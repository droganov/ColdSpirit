<cfcomponent displayname="Application" output="false" extends="spirit.framework.spirit">
	<cfscript>
		this.Name				= cgi.server_name;
		this.ApplicationTimeout = CreateTimeSpan( 1, 0, 0, 0);
		this.SessionManagement	= true;
		this.SetClientCookies	= false;

		//this.sessionStorage = "cacheName";
		//this.clientStorage = "cacheName";

		// spirit settings (optional)
		variables.spiritSettings = {
			interface: 		"xml", // currently xml and MySQL are supported
			appKey:			"spirit" // You can run several Spirit instances within 1 Applications if you set different keys for each
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
		//	writeOutput("<!-- " & GetTickCount() - this.timer & " MS -->");
		}
		/*
		function onError(Exception, string EventName){
			super.getService("log").Exception(arguments.Exception, arguments.EventName);
		}*/
	</cfscript>
</cfcomponent>