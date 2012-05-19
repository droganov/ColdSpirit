<cfprocessingdirective pageEncoding="utf-8" /><!DOCTYPE HTML>
<cfparam name="url.tag" type="string" default="all" />
<cfparam name="url.page" type="numeric" default="1" />
<cfparam name="form.criteria" type="string" default="" />
<cfsilent>
	<cffunction name="countErrors" output="no" returntype="numeric" access="public">
		<cfquery name = "local.result" datasource = "errorDSN">
			SELECT COUNT(id) cnt
			FROM log
			WHERE host = <cfqueryparam value="#cgi.http_host#" cfsqltype="cf_sql_varchar" />
			<cfif url.tag NEQ "all">
				AND tag = <cfqueryparam value="#url.tag#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(form.criteria)>
				#search()#
			</cfif>
		</cfquery>
		<cfreturn Val(result.cnt) />
	</cffunction>
	<cffunction name="fetchErrors" output="no" returntype="query" access="public">
		<cfargument name="limit" type="string" />
		<cfquery name = "local.result" datasource = "errorDSN">
			SELECT *
			FROM log
			WHERE host = <cfqueryparam value="#cgi.http_host#" cfsqltype="cf_sql_varchar" />
			<cfif url.tag NEQ "all">
				AND tag = <cfqueryparam value="#url.tag#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(form.criteria)>
				#search()#
			</cfif>
			ORDER BY id DESC
			LIMIT #arguments.limit#
		</cfquery>
		<cfreturn result />
	</cffunction>
	<cffunction name="search" output="no" returntype="string" access="public">
		<cfsavecontent variable="local.result">
			<cfoutput>
				AND (
					host				LIKE <cfqueryparam value="%#form.criteria#%" CFSQLType="cf_sql_varchar" /> OR
					ip					LIKE <cfqueryparam value="%#form.criteria#%" CFSQLType="cf_sql_varchar" /> OR
					location		LIKE <cfqueryparam value="%#form.criteria#%" CFSQLType="cf_sql_varchar" /> OR
					errorcode 	LIKE <cfqueryparam value="%#form.criteria#%" CFSQLType="cf_sql_varchar" /> OR
					errortype		LIKE <cfqueryparam value="%#form.criteria#%" CFSQLType="cf_sql_varchar" /> OR
					message			LIKE <cfqueryparam value="%#form.criteria#%" CFSQLType="cf_sql_varchar" /> OR
					scopes			LIKE <cfqueryparam value="%#form.criteria#%" CFSQLType="cf_sql_varchar" /> OR
					catchData		LIKE <cfqueryparam value="%#form.criteria#%" CFSQLType="cf_sql_varchar" /> OR
					description	LIKE <cfqueryparam value="%#form.criteria#%" CFSQLType="cf_sql_varchar" />
				)
			</cfoutput>
		</cfsavecontent>
		<cfreturn result />
	</cffunction>
	<cffunction name="fetchTags" output="no" returntype="query" access="public">
		<cfquery name = "local.result" datasource = "errorDSN">
			SELECT tag
			FROM log
			WHERE host = <cfqueryparam value="#cgi.http_host#" cfsqltype="cf_sql_varchar" />
			GROUP BY tag
			ORDER BY tag
		</cfquery>
		<cfreturn result />
	</cffunction>

	<cffunction name="cleanUp" output="no" returntype="void" access="public">
		<cfquery name = "delete" datasource = "errorDSN">
			DELETE FROM log
			WHERE
				host = <cfqueryparam value="#cgi.http_host#" cfsqltype="cf_sql_varchar" />
		</cfquery>
	</cffunction>

	<cffunction name="paginate" output="no" returntype="struct" access="public">
		<cfargument name="records" type="numeric" />
		<cfargument name="current" type="numeric" />
		<cfargument name="rpp" type="numeric" />
		<cfscript>
			var result = {};
			result.totalPages = Ceiling(arguments.records / arguments.rpp);
			result.currentPage = arguments.current LTE result.totalPages
				? arguments.current
				: result.totalPages;
			result.currentPage = result.currentPage GTE 1
				? result.currentPage
				: 1;
			result.limit = result.currentPage * arguments.rpp - arguments.rpp & "," & arguments.rpp;
		</cfscript>
		<cfif result.totalPages GT 1>
			<cfsavecontent variable="result.result">
				<cfoutput>
					<div class="pages">
						<cfloop index="local.i" from="#1#" to="#result.totalPages#">
							<a href="#cgi.script_name#?page=#i#&amp;tag=#urlEncodedFormat(url.tag)#" class="#i EQ result.currentPage#">#i#</a>
						</cfloop>
						<div class="clear"></div>
					</div>
				</cfoutput>
			</cfsavecontent>
		<cfelse>
			<cfset result.result = "" />
		</cfif>
		<cfreturn result />
	</cffunction>
	<cfscript>
		rpp = 30;
		total = countErrors();
		pages = paginate(total, url.page, rpp);

		if (structKeyExists(url, "cleanUp")	) {
			cleanUp();
			location url=cgi.script_name addtoken=false;
		}
		list = fetchErrors(pages.limit);
		tags = fetchTags();
	</cfscript>
</cfsilent>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>Ошибки</title>
	<style type="text/css" media="screen">
		body {font-family: sans-serif; margin:40px; font-size:14px; line-height:1.5; color:#333333;}
		a {color:#0071BC;}
		.header{font-size:32px;}
		.header a{text-decoration:none; color:#333333;}
		.row {padding:5px 10px; margin:0 -10px; margin-bottom:1px;}
		.row:hover{background:#E6E6E6;}
		.row.open{background:#D4E8FC;}
		.s1 {background: #F2F2F2;}
		.small{font-size:11px;}
		.grey{color:#999999;}
		.info{margin:0 -5px; display:none;}
		.box{background-color: #fff; padding:5px; margin-top:5px;}
		.pre{font-family:monospace; padding-bottom:1em; }
		.controls{position: absolute; top:30px; right:30px;}
		.template{color:#F15A24;}
		.error{color:#ff3c00;}
		.warning{color:#ff9000;}
		.message{color:#00a651;}
		.tag_false{color:#00a651;}
		.tabs {margin-bottom:1em;}
		.tabs a, .pages a {display: block; float: left; margin-right:10px;}
		.tabs a.tab_true, .pages a.true {background-color: #F2F2F2; color:#333333; text-decoration:none; margin:-.3em 0px; padding:.3em 10px; margin-right:10px;}
		.tabs a.tab_true.all, .pages a::first-child {margin-left:-10px;}
		.clear{clear:both;}

		.pages{margin-top:1em; margin-left:-10px;}

		table{margin-bottom:1em; width:100%;}
		table th{text-align:left; border-bottom:1px dotted #cfcfcf;}
		table td{vertical-align: top;}
		table td.grey{white-space: nowrap; text-align:right; width:12em;}
	</style>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8">//<![CDATA[
		var j = jQuery.noConflict();
		j(function(){
			j("div.small a, div.info, div.h a").click(function(e) {
				e.stopPropagation();
			});
			j("div.row").click(function(e) {
				e.preventDefault();
				j(this).toggleClass("open").find("div.info").slideToggle("fast");
			});
		});
	//]]></script>
</head>
<cfoutput>
<body>
	<div class="controls">
		<div class="aRight">
			<a href="?cleanUp" class="cleanUp">Очистить лог</a>
		</div>
		<div class="search">
			<form action="#cgi.script_name#?#cgi.query_string#" method="post" accept-charset="utf-8">
				<input type="search" name="criteria" value="#HTMLEditFormat(form.criteria)#" placeholder="Поиск" />
				<input type="submit" name="submit" value="Найти" />
			</form>
		</div>
	</div>
	
	<div class="header"><a href="#cgi.script_name#">#cgi.http_host#</a></div>
	<cfif tags.recordCount>
		<div class="tabs">
			<a href="#cgi.script_name#" class="tab_#url.tag EQ 'all'# all">Все записи</a>
		<cfloop query="tags">
			<a href="#cgi.script_name#?tag=#URLEncodedFormat(tag)#" class="tab_#url.tag EQ tag#">#tag#</a>
		</cfloop>
			<div class="clear"></div>
		</div>
	</cfif>
	<cfif Len(form.criteria)>
		<div class="searchResult">
			Найдено записей: #total#
		</div>
	</cfif>
 <cfif list.recordCount>
		<cfloop query="list">
			<div class="row s#currentRow MOD 2#">
				<div class="h">
					<a href="#cgi.script_name#?tag=#URLEncodedFormat(tag)#" class="#iif(tag EQ 'error', DE('error'), DE(iif(tag EQ 'warning', DE('warning'), DE('message'))))#">#tag#</a>
					<strong>#message#</strong>
					<cfif tag EQ "error">
						— #errortype#, #errorcode#
					</cfif>
				</div>
				<div class="small">
					<span class="grey">Время:</span>
					<span>#dateFormat(dt, "DD:MM:YYYY")# в #timeFormat(dt, "HH:MM")#</span>,
					<span class="grey">ip:</span>
					<span>#ip#</span>,
					<span class="grey">адрес:</span>
					<span><a href="#location#">#location#</a></span>
				</div>
				<div class="info">

					<cfif Len(catchData)>
						<cfif IsJSON(catchData)>
							<cfset catchData = DeserializeJSON(catchData) />
							<cftry>
								<div class="box">
									<div class="hh">Tag Context</div>
									<div class="small">
										<cfloop index="i" from="1" to="#ArrayLen(catchData.tagContext)#">
											<div class="pre">
												<span class="template">#catchData.tagContext[i].template#</span><br/>
												<span>#catchData.tagContext[i].codePrintHTML#</span>
											</div>
										</cfloop>
		 							</div>
								</div>
								<cfcatch type="any">
									<div class="box">
										<div class="hh">Stacktrace</div>
										<div class="small">
											<cfdump var="#catchData.stacktrace#" />
										</div>
									</div>
								</cfcatch>
							</cftry>
						<cfelse>
							<div class="box">
								<div class="hh">Catch Data</div>
								<div class="small">
									<pre>
										#catchData#
									</pre>
	 							</div>
							</div>
						</cfif>
					</cfif>
					
					
					<cfif Len(sizeOf) AND IsJSON(sizeOf)>
						<cfset size = DeserializeJSON(sizeOf) />
						<div class="box">
							<div class="hh">Ресурсы</div>
							<div class="small">
								<span class="grey">Server:</span>
								<span>#size.server / 1000#  KB</span>,
								<span class="grey">Application:</span>
								<span>#size.Application / 1000#  KB</span>,
								<span class="grey">Session:</span>
								<span>#size.Session / 1000#  KB</span>,
								<span class="grey">Request:</span>
								<span>#size.Request / 1000# KB</span>
							</div>
						</div>
					</cfif>

					
					<cfif Len(scopes) AND IsJSON(scopes)>
						<cfset scopes = DeserializeJSON(scopes) />
						<div class="box last">
							<div class="hh">Переменные</div>
							<div class="small">
								<cfset s = DeserializeJSON(scopes) />
								<cfif StructKeyExists(s, "form") AND StructCount(s.form)>
									<table>
										<thead>
											<tr>
												<th></th>
												<th>Post</th>
											</tr>
										</thead>
										<tbody>
											<cfloop collection="#s.form#" item="key">
											<tr>
												<td class="grey">#key#:</td>
												<td>#HTMLEditFormat(s.form[key])#</td>
											</tr>
											</cfloop>
										</tbody>
									</table>
								</cfif>
								<cfif StructKeyExists(s, "url") AND StructCount(s.url)>
									<table>
										<thead>
											<tr>
												<th></th>
												<th>Get</th>
											</tr>
										</thead>
										<tbody>
											<cfloop collection="#s.url#" item="key">
											<tr>
												<td class="grey">#key#:</td>
												<td>#HTMLEditFormat(s.url[key])#</td>
											</tr>
											</cfloop>
										</tbody>
									</table>
								</cfif>
								<cfif StructKeyExists(s, "headers") AND StructCount(s.headers)>
									<table>
										<thead>
											<tr>
												<th></th>
												<th>Headers</th>
											</tr>
										</thead>
										<tbody>
											<cfloop collection="#s.headers#" item="key">
											<tr>
												<td class="grey">#key#:</td>
												<td>#HTMLEditFormat(s.headers[key])#</td>
											</tr>
											</cfloop>
										</tbody>
									</table>
								</cfif>
							</div>
						</div>
					</cfif>

					<cfif Len(description)>
						<div class="box">
							<div class="hh">Description</div>
							<div class="small">
								<cfif IsJSON(description)>
									<cfset desc = DeserializeJSON(description) />
									<cfif IsSimpleValue(desc)>
										#desc#
									<cfelse>
										<table>
										<tbody>
											<cfloop collection="#desc#" item="key">
											<tr>
												<td class="grey">#key#:</td>
												<td>
													<cfif IsSimpleValue(desc[key])>
														#HTMLEditFormat(desc[key])#
													<cfelse>
														<cfdump var="#desc[key]#" />
													</cfif>
												</td>
											</tr>
											</cfloop>
										</tbody>
									</table>
									</cfif>

								<cfelse>
									#description#
								</cfif>
 							</div>
						</div>
						
					</cfif>

					<div class="clear"></div>
				</div>
			</div>
		</cfloop>
		#pages.result#
	<cfelse>
		<p>Нет записей</p>
	</cfif>
	
	
	<!--- <cfdump var="#pages#" /> --->
</body>
</html></cfoutput>