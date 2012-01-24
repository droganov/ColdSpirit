<cfoutput>#render("layout")#</cfoutput>
<!--- <cfscript>
	var tt = GetTickCount();
	var loops = 1000;
	for (i=1; i LTE loops; i=i+1) {
		this.render("state");
	}
	writeOutput(GetTickCount() - tt & "ms <br>");
	
	var tt = GetTickCount();
	var loops = 1000;
	for (i=1; i LTE loops; i=i+1) {
		this.renderState();
	}
	writeOutput(GetTickCount() - tt & "ms <br>");
</cfscript> --->
