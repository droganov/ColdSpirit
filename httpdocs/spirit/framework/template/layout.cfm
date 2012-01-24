<cfprocessingdirective pageEncoding="utf-8" /><!DOCTYPE HTML>
<cfoutput>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>#event.target.title()#</title>
	#event.target.css()#
	#event.target.js()#
</head>
<body>
	<h1>Hi I'm default layout</h1>
	#event.target.render("view")#
</body>
</html></cfoutput>