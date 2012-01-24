<cfcomponent>
	<cffunction name="init" output="no" returntype="controller" access="public">
		<cfscript>
			this.ku = "controller";
			return this;
		</cfscript>
	</cffunction>
	<cffunction name="event_1" output="no" returntype="void" access="public">
		<cfargument name="parent" type="dispatch" />
		<cfscript>
			arguments.parent.sendMessage("Event 1 fired");
			arguments.parent.event("event_2");
			arguments.parent.sendMessage("Hi that's me, event 1, again. You're not supposed to see me here cuz I should be dead already.");
		</cfscript>
	</cffunction>
	<cffunction name="event_2" output="no" returntype="void" access="public">
		<cfargument name="parent" type="dispatch" />
		<cfscript>
			arguments.parent.sendMessage("Event 2 fired");
		</cfscript>
	</cffunction>
</cfcomponent>