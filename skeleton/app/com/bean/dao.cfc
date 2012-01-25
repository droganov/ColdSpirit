<cfcomponent output="no" hint="Dao is not supposed to be used directly, use it as a SuperClass for your beans">
	<!--- Class is not tested yet --->
	<cffunction name="init" output="no" returntype="any" access="public">
		<cfargument name="id" type="numeric" default="0" />
		<cfset this.read(arguments.id) />
		<cfreturn this />
	</cffunction>
	
	<!--- Dao --->
	<cffunction name="read" output="no" returntype="void" access="public">
		<cfargument name="id" type="numeric" default="#this.get('id')#" />
		<cfargument name="fieldNames" type="string" default="*" />
		<cfargument name="where" type="string" default="" />
		<cfquery name="local.data" datasource="#this.getDSN()#">
			SELECT
				#arguments.fieldNames#
			FROM
				#this.getTableName()#
			WHERE
				id = <cfqueryparam value="#arguments.id#" CFSQLType="cf_sql_integer" />
			<cfif Len(arguments.where)>
			AND
				#PreserveSingleQuotes(arguments.where)#
			</cfif>
			LIMIT
				1
		</cfquery>
		<cfset variables.data = data />
	</cffunction>
	<cffunction name="delete" output="no" returntype="void" access="public" hint="Deletes single or multiple database records">
		<cfargument name="id" type="string" default="#this.get('id')#" />
		<cfquery name="delete" datasource="#this.getDSN()#">
			DELETE FROM #this.getTableName()#
			WHERE
			id IN (<cfqueryparam value="#arguments.id#" CFSQLType="cf_sql_integer" list="yes" />)
		</cfquery>
		<cfset this.clearCache() />
	</cffunction>
	<cffunction name="create" output="no" returntype="numeric" access="public" hint="Creates new record and returns last ID. To add validation override this method in your bean, perform validation and then call super.create method">
		<cfargument name="data" type="struct" default="#form#" />
		<cfset var tableName = this.getTableName() />
		<cfset var fieldNames = ListToArray(this.filterFields(arguments.data, this.getColumnNames(tableName))) />
		<cfscript>
			var fn = [];
			for (local.i=1; i LTE ArrayLen(fieldNames); i=i+1) {
				ArrayAppend(fn, "`" & fieldNames[i] & "`");
			}
		</cfscript>
		<cflock timeout="100" name="insertLock">
			<cfquery name="insert" datasource="#this.getDSN()#">
				INSERT INTO #tableName# (#ArrayToList(fn)#)
				VALUES(
					<cfloop index="i" from="1" to="#ArrayLen(fn)#">
						<cfset var fieldName = fn[i] />
						<cfset var fieldValue = arguments.data[fieldNames[i]] />
						<cfqueryparam value="#fieldValue#" CFSQLType="#this.CFSQLTypeOf(fieldValue)#" />#IIF(i LT ArrayLen(fn), DE(", "), DE(""))#
					</cfloop>
				)
			</cfquery>
			<cfset this.clearCache() />
			<cfset var result = this.getLastID() />
		</cflock>
		<cfreturn result />
	</cffunction>
	<cffunction name="update" output="no" returntype="void" access="public">
		<cfargument name="data" type="struct" default="#form#" />
		<cfparam name="arguments.data.id" type="numeric" default="#this.get('id')#" />
		<cfset arguments.fieldNames = ListToArray(getColumnNames(this.getTableName())) />
		<cfquery name="update" datasource="#this.getDSN()#">
			UPDATE
				#this.getTableName()#
			SET
				id = #arguments.data.id#
				<cfloop index="i" from="1" to="#ArrayLen(arguments.fieldNames)#">
					<cfif StructKeyExists(arguments.data, arguments.fieldNames[i])>,
						<cfset var fieldName = arguments.fieldNames[i] />
						<cfset var fieldValue = arguments.data[fieldName] />
						`#fieldName#` = <cfqueryparam value="#fieldValue#" CFSQLType="#this.CFSQLTypeOf(fieldValue)#" />
					</cfif>
				</cfloop>
			WHERE
				id = <cfqueryparam value="#arguments.data.id#" CFSQLType="cf_sql_integer" />
		</cfquery>
		<cfset this.clearCache() />
	</cffunction>
	
	<!--- Extensibility --->
	<cffunction name="clearCache" output="no" returntype="void" access="public" hint="Clears table cache">
		<cftry>
			<cflock timeout="300" name="cacheClear">
				<cfobjectcache action="clear" filter="#this.setCacheFilter#" />
			</cflock>
			<cfcatch type="any">
				<!--- Catch is added to fix concurent modification errors for busy websites --->
			</cfcatch>
		</cftry>
	</cffunction>
	<cffunction name="get" output="no" returntype="string" access="public" hint="Returns value of the single field">
		<cfargument name="key" type="string" />
		<cfreturn variables.data[arguments.key] />
	</cffunction>
	<cffunction name="getLastID" output="no" returntype="numeric" access="public" hint="Returns last inserted ID">
		<cfquery name="getId" dataSource="#this.getDSN()#">
			SELECT LAST_INSERT_ID() AS `id`
		</cfquery>
		<cfreturn Val(getId.id) />
	</cffunction>
	<cffunction name="getResult" output="no" returntype="query" access="public" hint="Returns query result">
		<cfreturn variables.data />
	</cffunction>
	<cffunction name="hide" output="no" returntype="void" access="public">
		<cfargument name="id" type="string" default="#this.get('id')#" />
		<cfquery name="update" datasource="#this.getDSN()#">
			UPDATE
				#this.getTableName()#
			SET
				visibility = 'hidden'
			WHERE
			id IN (<cfqueryparam value="#arguments.id#" CFSQLType="cf_sql_integer" list="yes" />)
		</cfquery>
		<cfset this.clearCache() />
	</cffunction>
	<cffunction name="show" output="no" returntype="void" access="public">
		<cfargument name="id" type="string" default="#this.get('id')#" />
		<cfquery name="update" datasource="#this.getDSN()#">
			UPDATE
				#this.getTableName()#
			SET
				visibility = 'visible'
			WHERE
			id IN (<cfqueryparam value="#arguments.id#" CFSQLType="cf_sql_integer" list="yes" />)
		</cfquery>
		<cfset this.clearCache() />
	</cffunction>
	
	<!--- Private --->
	<cffunction name="CFSQLTypeOf" output="no" returntype="string" access="private">
		<cfargument name="field" type="string" />
		<cfscript>
			if(IsNumeric(arguments.field))
				return "CF_SQL_INTEGER";
			if(IsBoolean(arguments.field))
				return "CF_SQL_BIT";
			if(IsDate(arguments.field) AND Len(arguments.field) GT 9)
				return "CF_SQL_TIMESTAMP";
			return "CF_SQL_VARCHAR";
		</cfscript>
	</cffunction>
	<cffunction name="filterFields" output="no" returntype="string" access="private">
		<cfargument name="data" type="struct" />
		<cfargument name="fieldNames" type="string" />
		<cfset arguments.fieldNames = ListToArray(arguments.fieldNames) />
		<cfscript>
			var result = "";
			for (local.i=1; i LTE ArrayLen(arguments.fieldNames); i=i+1) {
				if(StructKeyExists(arguments.data, arguments.fieldNames[i]) AND arguments.fieldNames[i] NEQ "id") {
					result = ListAppend(result, arguments.fieldNames[i]);
				}
			}
			return result;
		</cfscript>
	</cffunction>
	<cffunction name="getColumnNames" output="no" returntype="string" access="private">
		<cfargument name="tableName" type="string" />
		<cfdbinfo datasource="#this.getDSN()#" name="local.result" type="columns" table="#arguments.tableName#" />
		<cfreturn ValueList(result.column_name) />
	</cffunction>
	<cffunction name="getDSN" output="no" returntype="string" access="private" hint="DSN is injected by the bean factory">
		<cfreturn this.dsn />
	</cffunction>
	<cffunction name="getTableName" output="no" returntype="string" access="private" hint="Make sure that your bean has the same name as the table">
		<cfscript>
			return getComponentMetaData(this).displayname;
		</cfscript>
	</cffunction>
	
	<cffunction name="setCacheFilter" output="no" returntype="boolean" access="private" hint="Your can override this filter in the subclass, to add some extra accurance.">
		<cfargument name="sql" type="string" />
		<cfreturn FindNoCase(this.getTableName(), arguments.sql) />
	</cffunction>
</cfcomponent>