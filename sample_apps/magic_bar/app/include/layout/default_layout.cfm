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
		<div class="span-12">
			<div id="logo">
				<a href="/"><img src="/rc/img/logo.png" width="241" height="62" alt="Logo" /></a><br/>
			</div>
		</div>
		<div class="span-12 last">
			<div id="menu" class="grey">
				<cfloop query="e.b.menu">
					<a href="/#name#" class="#e.t.getView().hasAncestor(name)#">#label#</a>#iif(currentRow LT recordcount, DE(' | '), DE(''))#
				</cfloop>
			</div>
		</div>
		<div class="clear"></div>
	</div>
	<div class="contentBorder">
		<div class="content container">
			#this.render("view")#
			<div class="clear"></div>
		</div>
	</div>
	<div class="container">
		<div id="footer" class="grey">
			&copy; #Year(Now())# «<a href="http://supremedesign.ru/">Сьюприм</a>»
		</div>
	</div>
</body>
</html></cfoutput>