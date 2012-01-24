<cfinterface
	displayName="interface">
	<cffunction name="init" output="no" returntype="struct" access="public">
		<cfargument name="settings" type="struct" />
	</cffunction>
	<cffunction name="getViewByName" output="no" returntype="query" access="public">
		<cfargument name="viewName" type="string" />
	</cffunction>
	<cffunction name="getViewByID" output="no" returntype="query" access="public">
		<cfargument name="id" type="numeric" />
	</cffunction>
	<cffunction name="fetchAllViews" output="no" returntype="query" access="public">
	</cffunction>
	<cffunction name="fetchChildViews" output="no" returntype="query" access="public">
		<cfargument name="id_view" type="numeric" />
		<cfargument name="visibility" type="string" default="visible" />
	</cffunction>
	<cffunction name="insertView" output="no" returntype="numeric" access="public">
		<cfargument name="data" type="struct" />
	</cffunction>
	<cffunction name="updateView" output="no" returntype="void" access="public">
		<cfargument name="data" type="query" />
		<cfargument name="id" type="numeric" />
	</cffunction>
	<cffunction name="deleteView" output="no" returntype="void" access="public">
		<cfargument name="idView" type="string" />
	</cffunction>

	<!--- State queries --->
	<cffunction name="fetchStatesByViewID" output="no" returntype="query" access="public">
		<cfargument name="id_view" type="numeric" />
		<cfargument name="visibility" type="string" default="visible" />
	</cffunction>
	<cffunction name="getStateByID" output="no" returntype="query" access="public">
		<cfargument name="id" type="numeric" />
	</cffunction>
	<cffunction name="insertState" output="no" returntype="numeric" access="public">
		<cfargument name="id_view" type="numeric" />
	</cffunction>
	<cffunction name="updateState" output="no" returntype="void" access="public">
		<cfargument name="data" type="query" />
		<cfargument name="id" type="numeric" />
	</cffunction>
</cfinterface>