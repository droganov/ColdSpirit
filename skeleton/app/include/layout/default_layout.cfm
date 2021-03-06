<cfprocessingdirective pageEncoding="utf-8" /><!doctype html>
<!--[if lt IE 9]><html class="ie"><![endif]-->
<!--[if gte IE 9]><!--><html><!--<![endif]-->
<cfoutput>
	
<head>
	<meta charset="utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>#title()#</title>
	#event.target.css()#
	#event.target.js()#
	<!--[if lt IE 8]><link rel="stylesheet" href="/rc/css/ie.css" type="text/css" /><![endif]-->
	<!---
		This script enables structural HTML5 elements in old IE.
		http://code.google.com/p/html5shim/
	--->
	<!--[if lt IE 9]>
		<script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
</head>
<body>
	<div class="container">
		<header>
			<h1>Layout #template#</h1>
		</header>
		<nav>
			navigation
		</nav>
		<section>
			#render("view")#
		</section>
		<footer>
			footer
		</footer>
	</div>
</body>
</html></cfoutput>