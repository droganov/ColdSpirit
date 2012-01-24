<cfprocessingdirective pageEncoding="utf-8" /><!DOCTYPE HTML>
<cfscript>
	cacheKey = "error_*";
	cacheName = "errorLog";
	
	if(StructKeyExists(url, "clear")) cacheClear(cacheKey, cacheName);
	
	list = cacheGetAllIds(cacheKey, cacheName);
	if(NOT StructKeyExists(url, "page"))
		url.page = 1;
	url.page = Val(url.page);
	
	recordsPerPage = 25;
	totalPages = Ceiling(ArrayLen(list) / recordsPerPage);
	currentPage = url.page;
	
	url.page = url.page GT 0 ? url.page : 1;
	url.page = url.page LTE totalPages ? url.page : totalPages;
	
	loopFrom = url.page * recordsPerPage - recordsPerPage + 1;
	loopTo = loopFrom + recordsPerPage LTE ArrayLen(list) ? loopFrom + recordsPerPage : ArrayLen(list);
</cfscript>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>Ошибки</title>
	<style type="text/css" media="screen">
		body{padding:2em 6em; font-family:arial; font-size:.85em;}
		.header {font-size:2em; margin-bottom:1em;}
		
		.pages{margin-bottom:.5em;}
		.errors .row {position:relative;}
		.errors .i {position:absolute; left:-7em; text-align:right; width:6em;}
		.errors .item {background:#F2F2F2; margin-bottom:1px;}
		.errors .item:hover{background:#DEDEDE;}
		.errors .item, .errors .i{ padding:.2em;}
		.errors .item .data{background:#fff; padding:10px; display:none;}
		.errors .open .data {display:block;}
		.errors .item .summary {cursor:pointer;}
		
		.errors .scopes div.scope{display:none;}
		.errors .scopes div.open{display:block;}
		.errors .scopes a.true{text-decoration:none; color:#000; font-weight:bold;}
		
		.codeBlock {background:beige; padding:10px;}
	</style>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8">//<![CDATA[
		var j = jQuery.noConflict();
		j(function(){
			j("div.row div.summary").click(function(e){
				j(this).parent().parent().toggleClass("open")
			});
			
			j("div.scopes > a").click(function(e){
				var t = j(this);
				var p = t.parent();
				var href = t.attr("href");
				
				p.find("a").removeClass("true");
				p.find("div.scope").removeClass("open");
				
				t.addClass("true");
				p.find("div." + href).addClass("open");
				
				e.preventDefault();
			});
		});
	//]]></script>
</head>
<cfoutput>
<body>
	<div class="header">
		Всего ошибок: #ArrayLen(list)# <sup><a href="?clear">Очистить</a></sup>
	</div>
	<cfif ArrayLen(list)>
		<div class="pages">
			Страницы: 
			<cfloop index="page" from="1" to="#totalPages#">
				<a href="?page=#page#" class="#page EQ url.page#">#page#</a>#iif(page LT totalPages, DE(','), DE(''))#
			</cfloop>
		</div>
		<div class="errors">
			<cfloop index="i" from="#loopFrom#" to="#loopTo#">
				<cfset k = list[i] />
				<cfset e = cacheGet(k, cacheName) />
				<div id="#k#" class="row">
					<div class="i">#i#</div>
					<div class="item">
						<div class="summary">
							<cftry>
								<strong>#e.catch.message#</strong>
								<cfcatch type="any">
									<cfset myMessage = cfcatch.message />
								</cfcatch>
							</cftry>
							#e.url#
							<cftry>
								#e.scopes.cgi.remote_addr#
								<cfcatch type="any">
									<cfset myMessage = cfcatch.message />
								</cfcatch>
							</cftry>
							
							#DateFormat(e.ts, 'DD.MM.YYYY')# #TimeFormat(e.ts, 'HH:MM')#
						</div>
						<div class="data">
							<cftry>
								<cfif StructKeyExists(e, "catch")>
									<cfif len(e.catch.detail)>
										<h3>Детали</h3>
										<p class="codeBlock">#e.catch.detail#</p>
									</cfif>
									<cfif arrayLen(e.catch.tagcontext)>
										<h3>Шаблон</h3>
										<p class="codeBlock">
										<cfloop index="idx" from="1" to="#arraylen(e.catch.tagcontext)#">
											<cfif idx EQ 1>
												<b>#e.catch.tagcontext[idx].template#:&nbsp;line #e.catch.tagcontext[idx].line#</b><br />
											<cfelse>
												<b>Called from</b> #e.catch.tagcontext[idx].template#:&nbsp;line #e.catch.tagcontext[idx].line#<br />
											</cfif>
										</cfloop>
										</p>
										<h3>Исходный код</h3>
										<p style="font-family:'Courier New', Courier, monospace;font-size:9pt;" class="codeBlock">#replace(e.catch.tagcontext[1].codeprinthtml,' ','&nbsp;','all')#</p>
								    </cfif>
								</cfif>
								<cfcatch type="any">
									<cfset myMessage = cfcatch.message />
								</cfcatch>
							</cftry>
							<h3>Переменные</h3>
							<div class="scopes">
								<cfloop collection="#e.scopes#" item="s">
									<a href="#s#">#s#</a>
								</cfloop>
									<a href="sizeof">sizeOf</a>
								<cfloop collection="#e.scopes#" item="s">
									<div class="#s# scope">
										<cfdump var="#e.scopes[s]#" />
									</div>
								</cfloop>
								<div class="sizeof scope">
									<cfdump var="#e.sizeof#" />
								</div>
							</div>
						</div>
					</div>
				</div>
			</cfloop>
		</div>
	<cfelse>
		<p>ошибок нет</p>
	</cfif>
	
	
	<!--- <cfdump var="#list#" /> --->
</body>
</html></cfoutput>