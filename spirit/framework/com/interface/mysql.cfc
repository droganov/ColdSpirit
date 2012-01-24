<cfcomponent displayname="mysql" output="no" implements="interface">
	<cfprocessingdirective pageEncoding="utf-8" />
	<cffunction name="init" output="no" returntype="struct" access="public">
		<cfargument name="settings" type="struct" />
		<cfset this.dsn = arguments.settings.dsn />
		<cfset var result = this />
		<cfreturn result />
	</cffunction>
	<cffunction name="lastID" output="no" returntype="numeric" access="private">
		<cfquery name="arguments.lastID" dataSource = "#this.dsn#">
			SELECT LAST_INSERT_ID() AS `id`
		</cfquery>
		<cfreturn arguments.lastID.id />
	</cffunction>
	
	
	<!--- View queries --->
	<cffunction name="getViewByName" output="no" returntype="query" access="public">
		<cfargument name="viewName" type="string" />
		<cfquery name = "arguments.myResult" datasource = "#this.dsn#">
			SELECT
				*
			FROM
				view
			WHERE
				name = <cfqueryparam value="#arguments.viewName#" CFSQLType="cf_sql_varchar"/>
			LIMIT
				1
		</cfquery>
		<cfreturn arguments.myResult />
	</cffunction>
	<cffunction name="getViewByID" output="no" returntype="query" access="public">
		<cfargument name="id" type="numeric" />
		<cfquery name = "arguments.myResult" datasource = "#this.dsn#">
			SELECT
				*
			FROM
				view
			WHERE
				id = <cfqueryparam value="#arguments.id#" CFSQLType="cf_sql_numeric"/>
			LIMIT
				1
		</cfquery>
		<cfreturn arguments.myResult />
	</cffunction>
	<cffunction name="fetchAllViews" output="no" returntype="query" access="public">
		<cfquery name = "arguments.myResult" datasource = "#this.dsn#">
			SELECT
				id,id_view,name
			FROM
				view
			ORDER BY
				priority, name
		</cfquery>
		<cfreturn arguments.myResult />
	</cffunction>
	<cffunction name="fetchChildViews" output="no" returntype="query" access="public">
		<cfargument name="id_view" type="numeric" />
		<cfargument name="visibility" type="string" default="visible" />
		<cfquery name = "arguments.myResult" datasource = "#this.dsn#">
			SELECT
				*
			FROM
				view
			WHERE
				id_view = #arguments.id_view#
			<cfif ListFindNoCase("visible,hidden,locked", arguments.visibility)>
			AND
				visibility = <cfqueryparam value="#arguments.visibility#" CFSQLType="cf_sql_varchar"/>
			</cfif>
			ORDER BY
				priority, name
		</cfquery>
		<cfreturn arguments.myResult />
	</cffunction>
	<cffunction name="insertView" output="no" returntype="numeric" access="public">
		<cfargument name="data" type="struct" />
		<cfquery name = "insert" datasource = "#this.dsn#">
			INSERT INTO view (id_view,priority,name,label,title,visibility,layout,controller,view)
			VALUES(
				<cfqueryparam value="#arguments.data.id_view#" CFSQLType="cf_sql_integer" />,
				<cfqueryparam value="#arguments.data.priority#" CFSQLType="cf_sql_integer" />,
				<cfqueryparam value="#arguments.data.name#" CFSQLType="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.data.label#" CFSQLType="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.data.title#" CFSQLType="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.data.visibility#" CFSQLType="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.data.layout#" CFSQLType="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.data.controller#" CFSQLType="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.data.view#" CFSQLType="cf_sql_varchar" />
			)
		</cfquery>
		<cfreturn lastID() />
	</cffunction>
	<cffunction name="updateView" output="no" returntype="void" access="public">
		<cfargument name="data" type="query" />
		<cfargument name="id" type="numeric" />
		<cfif arguments.data.recordcount>
			<cfquery name = "update" datasource = "#this.dsn#">
				UPDATE
					view
				SET
					<cfloop query="arguments.data">
						#LCase(field)# = <cfqueryparam
							value="#fieldvalue#"
							CFSQLType="#IIF(IsNumeric(fieldvalue), DE('cf_sql_integer'), DE('cf_sql_varchar'))#"/>#IIF(currentRow LT recordcount, DE(','), DE(''))#
					</cfloop>
				WHERE
					id = <cfqueryparam value="#arguments.id#" CFSQLType="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
	<cffunction name="deleteView" output="no" returntype="void" access="public">
		<cfargument name="idView" type="string" />
		<cfquery name = "delete" datasource = "#this.dsn#">
			DELETE FROM view
			WHERE
				id = <cfqueryparam value="#arguments.idView#" CFSQLType="cf_sql_integer" />
			LIMIT 1
		</cfquery>
	</cffunction>
	
	
	<!--- State queries --->
	<cffunction name="fetchStatesByViewID" output="no" returntype="query" access="public">
		<cfargument name="id_view" type="numeric" />
		<cfargument name="visibility" type="string" default="visible" />
		<cfquery name = "arguments.myResult" datasource = "#this.dsn#">
			SELECT
				*
			FROM
				state
			WHERE
				id_view = #arguments.id_view#
			<cfif ListFindNoCase("visible,hidden,locked", arguments.visibility)>
			AND
				visibility = <cfqueryparam value="#arguments.visibility#" CFSQLType="cf_sql_varchar"/>
			</cfif>
			ORDER BY
				priority, name
		</cfquery>
		<cfreturn arguments.myResult />
	</cffunction>
	<cffunction name="getStateByID" output="no" returntype="query" access="public">
		<cfargument name="id" type="numeric" />
		<cfquery name = "arguments.myResult" datasource = "#this.dsn#">
			SELECT
				*
			FROM
				state
			WHERE
				id = #arguments.id#
		</cfquery>
		<cfreturn arguments.myResult />
	</cffunction>
	<cffunction name="insertState" output="no" returntype="numeric" access="public">
		<cfargument name="id_view" type="numeric" />
		<cfquery name = "insert" datasource = "#this.dsn#">
			INSERT INTO state (id_view)
			VALUES(
				<cfqueryparam value="#arguments.id_view#" CFSQLType="cf_sql_integer"/>
			)
		</cfquery>
		<cfreturn lastID() />
	</cffunction>
	<cffunction name="updateState" output="no" returntype="void" access="public">
		<cfargument name="data" type="query" />
		<cfargument name="id" type="numeric" />
		<cfif arguments.data.recordcount>
			<cfquery name = "update" datasource = "#this.dsn#">
				UPDATE
					state
				SET
					<cfloop query="arguments.data">
						#LCase(field)# = <cfqueryparam
							value="#fieldvalue#"
							CFSQLType="#IIF(IsNumeric(fieldvalue), DE('cf_sql_integer'), DE('cf_sql_varchar'))#"/>#IIF(currentRow LT recordcount, DE(','), DE(''))#
					</cfloop>
				WHERE
					id = <cfqueryparam value="#arguments.id#" CFSQLType="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
</cfcomponent>