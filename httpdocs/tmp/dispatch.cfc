<cfcomponent>
	<cffunction name="init" output="no" returntype="dispatch" access="public">
		<cfscript>
			variables.messages = [];
			variables.dspatcher = {};
			this.ku = "dispatcher";
			return this;
		</cfscript>
	</cffunction>
	<cffunction name="event" output="no" returntype="void" access="public">
		<cfargument name="eventName" type="string" />
		<cfparam name="request.result" type="Array" default="#[]#" />
		<cfscript>
			try {
				StructDelete(variables.dispatcher, "controllerObj");
				StructDelete(variables.dispatcher, "method");
				StructClear(variables.dspatcher);
			}
			catch(Any e) {}
			variables.dspatcher.controllerObj = CreateObject("component", "controller").init();
			variables.dspatcher.method = variables.dspatcher.controllerObj[arguments.eventName];
			variables.dspatcher.method(this);
		</cfscript>
	</cffunction>
	<cffunction name="sendMessage" output="no" returntype="void" access="public">
		<cfargument name="message" type="string" />
		<cfscript>
			ArrayAppend(variables.messages, arguments.message);
		</cfscript>
	</cffunction>
	<cffunction name="getMessages" output="no" returntype="array" access="public">
		<cfreturn variables.messages />
	</cffunction>
</cfcomponent>