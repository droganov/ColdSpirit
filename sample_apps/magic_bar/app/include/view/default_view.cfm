<cfprocessingdirective pageEncoding="utf-8" /><cfoutput>
	<div id="header">
		<div class="homeLink span-4 prepend-1">
			&larr; <a href="/">На главную</a>
		</div>
		<div class="span-14">
			<h1>#e.t.title()#</h1>
		</div>
		<div class="clear"></div>
	</div>
	#render("state")#
</cfoutput>