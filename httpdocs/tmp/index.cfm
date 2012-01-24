<cfscript>
	dispatch = CreateObject("component", "dispatch").init();
	dispatch.event("event_1");
	trace = dispatch.getMessages();
</cfscript>
<cfdump var="#trace#" />