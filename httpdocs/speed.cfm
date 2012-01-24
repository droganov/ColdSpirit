<cfscript>
	spirit = CreateObject("component", "/spirit.framework.spirit");
	spirit.bootStrap();
	spirit.dispatchEvent();
	
	files = "file2,File1,File 12";
	for (i=1; i LTE 5; i=i+1) {
		files = ListAppend(files, "file" & i);
	}
	files = ListToArray(files);
	
	iter = 500;
	
	t1 = GetTickCount();
	for (i=1; i LTE iter; i=i+1) {
		for (f=1; f LTE ArrayLen(files); f=f+1) {
			spirit.rss(files[f], "my rss");
		}
		rss = spirit.rss();
	}
	t1 = GetTickCount() - t1;
	
	t2 = GetTickCount();
	for (i=1; i LTE iter; i=i+1) {
		for (f=1; f LTE ArrayLen(files); f=f+1) {
			spirit.dispatchEvent();
		}
	}
	t2 = GetTickCount() - t2;
</cfscript>
<cfoutput>
	#rss#
	<strong>t1: #t1#</strong><br/>
	<hr>
	<strong>t2: #t2#</strong><br/>
	<hr>
	#t1/t2#
	<hr>
	#ArrayToList(files)#
</cfoutput>