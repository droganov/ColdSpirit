<cfprocessingdirective pageEncoding="utf-8" /><!DOCTYPE HTML>
<cfscript>
	cacheName = "errorLog";
	
	public string function uri(){
		var theURL = "http";
		if (cgi.https EQ "on" ) theURL = "#TheURL#s";
		theURL = theURL & "://#cgi.server_name#";
		if(cgi.server_port neq 80) theURL = theURL & ":#cgi.server_port#";
		theURL = theURL & "#cgi.script_name#" & "?";
		if(len(cgi.query_string)) theURL = Replace(theURL, "?", "") & "?#cgi.query_string#";
		IF(ListContainsNoCase(theURL, ";jsessionid")){
			theURL = ReReplaceNoCase(theURL, "\?+", "&", "All");
			theURL = ReplaceNoCase(theURL, ";jsessionid", "?jsessionid");
		}	
		return theURL;
	}
	
	
	e = {};
	e.scopes.cgi = cgi;
	e.scopes.form = form;
	e.scopes.url = url;
	e.ts = Now();
	try {
		e.catch = catch;
	}
	catch(Any error) {}
	
	e.url = uri();
	e.sizeOf.application = sizeOf(application);
	e.sizeOf.server = sizeOf(server);
	e.sizeOf.request = sizeOf(request);
	try {
		e.sizeOf.session = sizeOf(session);
	}
	catch(Any error) {};
	cacheKey = "error_" & CreateUUID();
	CachePut(cacheKey, e, CreateTimeSpan(7,0,0,0), cacheName);
</cfscript>
<cfoutput>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>Произошла непредвиденная ошибка</title>
	<style type="text/css" media="screen">
		body{padding:5em;}
		.dance {width:950px; margin:0 auto;}
		.header{text-align:center;}
	</style>
</head>
<body>
	<div class="dance">
		<object width="950" height="483"><param name="movie" value="http://www.youtube.com/v/nRypewMyXbw?version=3&amp;hl=ru_RU&amp;rel=0&amp;autoplay=1&amp;loop=1&amp;disablekb=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/nRypewMyXbw?version=3&amp;hl=ru_RU&amp;rel=0&amp;autoplay=1&amp;loop=1&amp;disablekb=1" type="application/x-shockwave-flash" width="950" height="483" allowscriptaccess="always" allowfullscreen="true"></embed></object>
	</div>
	<div class="header">
		500
	</div>
</body>
</html></cfoutput>