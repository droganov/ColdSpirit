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
</cfcomponent>