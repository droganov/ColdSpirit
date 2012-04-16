<cfprocessingdirective pageEncoding="utf-8" /><!DOCTYPE HTML>
<cffunction name="fetchErrors" output="no" returntype="query" access="public">
	<cfquery name = "local.result" datasource = "errorDSN">
		SELECT *
		FROM log
		WHERE host = <cfqueryparam value="#cgi.http_host#" cfsqltype="cf_sql_varchar" />
		ORDER BY id DESC
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
<cfscript>
	if (structKeyExists(url, "cleanUp")	) cleanUp();
	list = fetchErrors();
</cfscript>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>Ошибки</title>
	<style type="text/css" media="screen">
		body {font-family: sans-serif; margin:40px; font-size:14px; line-height:1.5; color:#333333;}
		a {color:#0071BC;}
		.header{font-size:32px;}
		.row {padding:5px 10px; margin:0 -10px; margin-bottom:1px;}
		.row:hover{background:#E6E6E6;}
		.row.open{background:#D4E8FC;}
		.s1 {background: #F2F2F2;}
		.small{font-size:11px;}
		.grey{color:#999999;}
		.info{margin:0 -5px; display:none;}
		.box{background-color: #fff; padding:5px; margin-bottom:5px;}
		.box.last{margin-bottom:0;}
		.pre{font-family:monospace; padding-bottom:1em; }
		.cleanUp{position: absolute; top:30px; right:30px;}
		.template{color:#F15A24;}

		table{margin-bottom:1em; width:100%;}
		table th{text-align:left; border-bottom:1px dotted #cfcfcf;}
		table td{vertical-align: top;}
		table td.grey{white-space: nowrap; text-align:right; width:12em;}
	</style>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8">//<![CDATA[
		var j = jQuery.noConflict();
		j(function(){
			j("div.small a, div.info").click(function(e) {
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
	<a href="?cleanUp" class="cleanUp">Прибрать говно</a>
	<div class="header">#cgi.http_host#</div>
	<cfif list.recordCount>
		<cfloop query="list">
			<div class="row s#currentRow MOD 2#">
				<div class="h">
					<strong>#message#</strong>
					— #errortype#, #errorcode#
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
					<cfset size = DeserializeJSON(sizeOf) />
					<cfset scopes = DeserializeJSON(scopes) />
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
					<div class="clear"></div>
				</div>
			</div>
		</cfloop>
	<cfelse>
		<p>ошибок нет</p>
	</cfif>
	
	
	<!--- <cfdump var="#list#" /> --->
</body>
</html></cfoutput>