<cfprocessingdirective pageEncoding="utf-8" /><cfcomponent displayname = "directory" output = "no">
	
	<cffunction name="create" output="no" returntype="void">
		<cfargument name="directory" type="string" />
		<cfargument name="mode" type="numeric" default="644" />
		<cflock timeout="600" name="directory" type="exclusive">
			<cfdirectory action="create" directory="#arguments.directory#" mode="#arguments.mode#" />
		</cflock>
	</cffunction>
	
	<cffunction name="delete" output="no" returntype="void">
		<cfargument name="directory" type="string" />
		<cfargument name="recurse" type="boolean" default="false" />
		<cflock timeout="1000" name="directory" type="exclusive">
			<cfdirectory action="delete" directory="#arguments.directory#" recurse="#arguments.recurse#" />
		</cflock>
	</cffunction>

	<cffunction name="list" output="no" returntype="query">
		<cfargument name="path" type="string" />
		<cfargument name="filter" type="string" default="" />
		<cfargument name="sort" type="string" default="asc" />
		<cfargument name="recurse" type="boolean" default="false" />
		<cfif NOT DirectoryExists(arguments.path)>
			<cfset arguments.path = ExpandPath(arguments.path) />
		</cfif>
		<cflock timeout="600" name="directory" type="readOnly">
			<cfdirectory action="list" directory="#arguments.path#" name="arguments.myResult" filter="#arguments.filter#" sort="#arguments.sort#" recurse="#arguments.recurse#" />
		</cflock>
		<cfreturn arguments.myResult />
	</cffunction>
		
	<cffunction name="rename" output="no" returntype="void">
		<cfargument name="directory" type="string" />
		<cfargument name="newdirectory" type="string" />
		<cflock timeout="600" name="directory" type="exclusive">
			<cfdirectory action="rename" directory="#arguments.directory#" newDirectory="#arguments.newdirectory#" />
		</cflock>
	</cffunction>
</cfcomponent>