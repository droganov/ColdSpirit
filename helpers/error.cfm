<cfprocessingdirective pageEncoding="utf-8" /><!DOCTYPE HTML>
<cffunction name="insertError" output="no" returntype="void" access="public">
	<cfargument name="e" type="struct" />
	<cfscript>
		var scopes = serializeJSON(arguments.e.data.scopes);
		var sizeOf = serializeJSON(arguments.e.data.sizeOf);
		var catchData = serializeJSON(arguments.e.data.catch);
	</cfscript>
	<cfquery name = "insert" datasource = "errorDSN">
		INSERT INTO log (errorcode, errortype, ip, host, location, message, scopes, sizeOf, catchData)
		VALUES(
			<cfqueryparam value="#arguments.e.errorcode#" CFSQLType="cf_sql_integer" />,
			<cfqueryparam value="#arguments.e.errortype#" CFSQLType="cf_sql_varchar" />,
			<cfqueryparam value="#cgi.remote_addr#" CFSQLType="cf_sql_varchar" />,
			<cfqueryparam value="#cgi.http_host#" CFSQLType="cf_sql_varchar" />,
			<cfqueryparam value="#arguments.e.url#" CFSQLType="cf_sql_varchar" />,
			<cfqueryparam value="#arguments.e.message#" CFSQLType="cf_sql_varchar" />,
			<cfqueryparam value="#scopes#" CFSQLType="cf_sql_varchar" />,
			<cfqueryparam value="#sizeOf#" CFSQLType="cf_sql_varchar" />,
			<cfqueryparam value="#catchData#" CFSQLType="cf_sql_varchar" />
		)
	</cfquery>
</cffunction>
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
	e.url = uri();

	e.data.scopes.form = form;
	e.data.scopes.url = url;
	e.data.scopes.headers = GetHttpRequestData().headers;

	e.data.sizeOf.application = sizeOf(application);
	e.data.sizeOf.server = sizeOf(server);
	e.data.sizeOf.request = sizeOf(request);
	try {
		e.data.sizeOf.session = sizeOf(session);
	}
	catch(Any error) { e.data.sizeOf.session = 0;};

	

	try {
		e.errorcode = catch.errorcode;
		e.errortype = catch.type;
		e.message = trim(catch.message);
		e.data.catch.detail = trim(catch.detail);
		e.data.catch.extended = catch.extendedinfo;
		e.data.catch.stacktrace = catch.stacktrace;
		e.data.catch.tagcontext = structKeyExists(catch,'tagcontext') ? catch.tagcontext : [];

		insertError(e);
	}
	catch(Any error) {}
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
		Произошла непредвиденная ошибка 500
	</div>
</body>
</html></cfoutput>