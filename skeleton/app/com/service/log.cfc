<cfcomponent displayname="log" output="no">
	<cffunction name="exception" output="no" returntype="void" access="public">
		<cfargument name="exception" type="struct" />
		<cfargument name="description" type="any" default="" />
		<cfargument name="tag" type="string" default="error" />
		<cfscript>
			var data = {
				tag:		arguments.tag,
				message: 	Trim(arguments.exception.message),
				errorcode:	Val(arguments.exception.errorcode),
				errortype:	arguments.exception.type
			};
			
			if(IsSimpleValue(arguments.description))
				data.description = arguments.description;
			else
				data.description = serializeJSON(arguments.description);
			
			var scopes = {
				form:		form,
				url:		url,
				headers:	GetHttpRequestData().headers
			};
			
			var size = {
				server: sizeOf(server),
				request: sizeOf(request)
			};
			
			try { size.session = sizeOf(session); }
			catch(Any error) { size.session = 0; };
			
			try { size.application = sizeOf(application); }
			catch(Any error) { size.application = 0; };
			
			try {
				var catchData = {
					detail:		Trim(arguments.exception.detail),
					extended:	arguments.exception.extendedinfo,
					stacktrace:	arguments.exception.stacktrace,
					tagcontext:	structKeyExists(arguments.exception,'tagcontext') ? arguments.exception.tagcontext : []
				};
			}
			catch(Any e) {
				var catchData = {};
			}
			
			data.scopes = serializeJSON(scopes);
			data.sizeOf = serializeJSON(size);
			data.catchData = serializeJSON(catchData);
			
			this.write(data);
		</cfscript>
	</cffunction>
	<cffunction name="throw" output="no" returntype="void" access="public">
		<cfargument name="message" type="string" />
		<cfargument name="description" type="any" default="" />
		<cftry>
			<cfthrow message="#arguments.message#" />
			<cfcatch type="any">
				<cfset this.exception(cfcatch, arguments.description) />
			</cfcatch>
		</cftry>
	</cffunction>
	<cffunction name="message" output="no" returntype="void" access="public">
		<cfargument name="tag" type="string" />
		<cfargument name="message" type="string" />
		<cfargument name="description" type="any" default="" />
		<cfscript>
			if(NOT IsSimpleValue(arguments.description))
				arguments.description = serializeJSON(arguments.description);
				
			this.write(arguments);
		</cfscript>
	</cffunction>
	
	<cffunction name="warning" output="no" returntype="void" access="public">
		<cfargument name="exception" type="struct" />
		<cfargument name="description" default="#{}#" />
		<cfset this.exception(arguments.exception, arguments.description, "warning") />
	</cffunction>
	<cffunction name="write" output="no" returntype="void" access="private">
		<cfargument name="data" type="struct" />
		
		<cfparam name="arguments.data.tag" type="string" />
		<cfparam name="arguments.data.message" type="string" />
		<cfparam name="arguments.data.description" type="string" default="" />
		
		<cfparam name="arguments.data.scopes" type="string" default="" />
		<cfparam name="arguments.data.sizeOf" type="string" default="" />
		<cfparam name="arguments.data.catchData" type="string" default="" />
		
		<cfparam name="arguments.data.errorcode" type="numeric" default="0" />
		<cfparam name="arguments.data.errortype" type="string" default="" />
		
		<cftry>
			<cfquery name = "insert" datasource = "#this.parent.getSetting('logDSN')#">
				INSERT INTO log (tag, errorcode, errortype, ip, host, location, message, scopes, sizeOf, catchData, description)
				VALUES(
					<cfqueryparam value="#arguments.data.tag#" CFSQLType="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.data.errorcode#" CFSQLType="cf_sql_integer" />,
					<cfqueryparam value="#arguments.data.errortype#" CFSQLType="cf_sql_varchar" />,
					<cfqueryparam value="#this.ip()#" CFSQLType="cf_sql_varchar" />,
					<cfqueryparam value="#cgi.http_host#" CFSQLType="cf_sql_varchar" />,
					<cfqueryparam value="#this.uri()#" CFSQLType="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.data.message#" CFSQLType="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.data.scopes#" CFSQLType="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.data.sizeOf#" CFSQLType="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.data.catchData#" CFSQLType="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.data.description#" CFSQLType="cf_sql_varchar" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfscript>
					switch(arguments.tag) {
						case "Warning": case "Error":{
							var type = arguments.tag;
							break;
						}
						default: {
							var type = "Information";
							break;
						}
					}
				</cfscript>
				<cflog text = "#arguments.message#" file="ColdSpirit" type="#type#" application = "yes" />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="uri" output="no" returntype="string" access="private">
		<cfscript>
			var theURL = (cgi.https EQ "on" ) ? "https" : "http";
			var headers = GetHttpRequestData().headers;
			
			if(StructKeyExists(headers, "x-forwarded-host"))
				theURL = theURL & "://" & headers["x-forwarded-host"];
			else
				theURL = theURL & "://" & cgi.server_name;
			
			if(StructKeyExists(url, "vars")) {
				theURL = theURL & url.vars;
			}
			else {
				if(cgi.server_port neq 80) theURL = theURL & ":#cgi.server_port#";
				theURL = theURL & "#cgi.script_name#" & "?";
				if(len(cgi.query_string)) theURL = Replace(theURL, "?", "") & "?#cgi.query_string#";
				IF(ListContainsNoCase(theURL, ";jsessionid")){
					theURL = ReReplaceNoCase(theURL, "\?+", "&", "All");
					theURL = ReplaceNoCase(theURL, ";jsessionid", "?jsessionid");
				}
			}
			return theURL;
		</cfscript>
	</cffunction>
	<cffunction name="ip" output="no" returntype="string" access="private">
		<cfreturn Len(CGI.HTTP_X_Forwarded_For)
						? CGI.HTTP_X_Forwarded_For
						: CGI.Remote_Addr />
	</cffunction>
</cfcomponent>