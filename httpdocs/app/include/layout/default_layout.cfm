<cfprocessingdirective pageEncoding="utf-8" /><!DOCTYPE HTML>
<cfoutput>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>#title()#</title>
	#event.target.css()#
	<!--[if lt IE 8]><link rel="stylesheet" href="/base/css/blueprint/ie.css" type="text/css" media="screen, projection" /><![endif]-->
	#event.target.js()#
</head>
<body>
	<div class="container">
		<h1>Layout #template#</h1>
		<div>
			#render("view")#
		</div>
	</div>
</body>
</html></cfoutput>