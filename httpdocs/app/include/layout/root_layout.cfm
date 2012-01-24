<cfprocessingdirective pageEncoding="utf-8" /><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<cfoutput><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>#event.target.title()#</title>
	#event.target.css()#
	#event.target.js()#
</head>
<body>
	<h1>Hi I'm default layout</h1>
	#event.target.renderView()#
</body>
</html></cfoutput>