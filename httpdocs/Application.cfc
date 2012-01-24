<cfcomponent displayname="Application" output="false" extends="spirit.framework.spirit">
	<cfscript>
		this.Name				= cgi.server_name;
		this.ApplicationTimeout = CreateTimeSpan( 1, 0, 0, 0);
		this.SessionManagement	= true;
		this.SetClientCookies	= false;
		
		// spirit settings (optional)
		variables.spiritSettings = {
			interface: 		"xml", // currently xml and MySQL are supported
			appKey:			"spirit", // You can run several Spirit instances within 1 Applications if you set different keys for each
			transients:		"controllers" // By default all components except "beans" are cached in app scope (singletones). It's recommentded to set controllers as transients during development process  
		};
		
		// initialize atFirstRequest
		function OnApplicationStart(Struct event){
			this.init(spiritSettings);
			return true;
		}
		function OnRequestStart(scriptName){
			this.timer = GetTickCount();
			this.bootStrap(spiritSettings);
			return true;
		}
		function onRequest(scriptName){
			this.dispatchEvent();
			this.render();
			//writeOutput();
		}
		function OnRequestEnd(){
			writeOutput("<!-- " & GetTickCount() - this.timer & " MS -->");
		}
	</cfscript>
	
	<!--- Application --->
	<!--- 
	<cffunction name="OnSessionStart" access="public" returntype="void" output="false" hint="Fires when the session is first created.">
		<cfreturn />
	</cffunction>
	
	<cffunction name="OnRequestEnd" access="public" returntype="void" output="true">
		<cfreturn />
	</cffunction>
	<cffunction name="OnSessionEnd" access="public" returntype="void" output="false">
		<cfargument name="SessionScope" type="struct" required="true" />
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
		<cfreturn />
	</cffunction>
	<cffunction name="OnApplicationEnd" access="public" returntype="void" output="false">
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
		<cfreturn />
	</cffunction>
	<cffunction name="OnError" access="public" returntype="void" output="true">
		<cfargument name="Exception" type="any" required="true" />
		<cfargument name="EventName" type="string" required="false" default="" />
		<cfreturn />
	</cffunction> --->
</cfcomponent>