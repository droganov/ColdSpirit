<cfcomponent accessors="true">
	<cfscript>
		public string function init(){
			//throw("file init");
		}
	</cfscript>
	<cffunction name="upload" access="public" returntype="struct">
		<cfargument name="fileField" type="string"/>
		<cfargument name="destination" type="string"/>
		<cfargument name="nameConflict" type="string" default="MakeUnique"/>
		<cfargument name="accept" type="string" default="image/jpg,image/jpeg,image/pjpg,image/pjpeg"/>
		<cfargument name="mode" type="numeric" default="644"/>
		
		<cfif NOT DirectoryExists(arguments.destination)>
			<cfset arguments.destination = ExpandPath(arguments.destination) />
		</cfif>
		<cfset var cffile = "">
		<cflock name="file" type="exclusive" timeout="10000">
			<cffile
				action="upload"
				filefield="#arguments.fileField#"
				destination="#arguments.destination#"
				nameconflict="#arguments.nameConflict#"
				accept="#arguments.accept#"
				mode="#arguments.mode#"
			/>
		</cflock>
		<cfscript>
			var r =		StructNew();
			r.local =	arguments.destination & "/" & cffile.serverFile;
			r.server =	cffile.serverdirectory & "/" & cffile.serverFile;
			r.cffile =	cffile;
			return r;
		</cfscript>
	</cffunction>
	<cffunction name="delete" output="no" returntype="void">
		<cfargument name="file" type="string">
		<cflock name="file" type="exclusive" timeout="10000">
			<cfif NOT FileExists(arguments.file)>
				<cfset arguments.file = ExpandPath(arguments.file) />
			</cfif>
			<cffile action="delete" file="#arguments.file#" />
		</cflock>
	</cffunction>
	<cffunction name="rename" output="no" returntype="void" access="public">
		<cfargument name="source" type="string"/>
		<cfargument name="destination" type="string"/>
		<cfargument name="mode" type="numeric" default="644"/>
		<cfargument name="attributes" type="string" default="readOnly" />
		<cflock name="file" type="exclusive" timeout="10000">
			<cffile action="rename" source="#arguments.source#" destination="#arguments.destination#"  mode="#arguments.mode#" attributes="#arguments.attributes#" />
		</cflock>
	</cffunction>
	
	<cffunction name="read" output="no" returntype="string" access="public">
		<cfargument name="path" type="string" />
		<cfargument name="charset" type="string" default="utf-8" />
		<cffile action="read" file="#arguments.path#" variable="arguments.myResult" charset="#arguments.charset#" />
		<cfreturn arguments.myResult />
	</cffunction>
	
	<cffunction name="write" output="no" returntype="void" access="public">
		<cfargument name="path" type="string" />
		<cfargument name="output" type="string" />
		<cfargument name="charset" type="string" default="utf-8" />
		<cfargument name="mode" type="numeric" default="644"/>
		<cfargument name="attributes" type="string" default="readOnly" />
		
		<cffile action="write" file="#arguments.path#" output="#arguments.output#" mode="#arguments.mode#" attributes="#arguments.attributes#" charset="#arguments.charset#" />
	</cffunction>
	
	<cffunction name="copy" output="no" returntype="void" access="public">
		<cfargument name="from" type="string" />
		<cfargument name="to" type="string" />
		<cfargument name="mode" type="numeric" default="644"/>
		<cfargument name="attributes" type="string" default="readOnly" />
		<cftry>
			<cfset this.delete(arguments.to)  />
			<cfcatch type="any">
				<cfset myMessage = cfcatch.message />
			</cfcatch>
		</cftry>
		<cffile action="copy" source="#arguments.from#" destination="#arguments.to#" mode="#arguments.mode#" attributes="#arguments.attributes#" />
	</cffunction>
</cfcomponent>