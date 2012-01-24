<cfprocessingdirective pageencoding="UTF-8"><cfsilent>
	<cfscript>
		scriptName = ListGetAt(cgi.script_name, ListLen(cgi.SCRIPT_NAME,"/"),"/");
		menu = CreateObject("component", "com.menu").init();
	</cfscript>
	<cfsavecontent variable="controller"><cfinclude template="#menu.controller#" /></cfsavecontent>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--- [
     <!ENTITY % SPRY SYSTEM "http://www.adobe.com/dtd/spry.dtd">
     %SPRY;
]> --->
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:spry="http://ns.adobe.com/spry">


<cfoutput>
<head>
	<link type="text/css" href="css/appearance.css.cfm" rel="stylesheet" media="screen, print" />
	<link type="text/css" href="css/menu.css.cfm" rel="stylesheet" media="screen, print" />
	<link type="text/css" href="modules/admin/css/admin.css.cfm" rel="stylesheet" media="screen, print" />
	<link type="text/css" href="js/spry/css/SpryValidationTextField.css.cfm" rel="stylesheet" media="screen, print" />
	
	

	<script type="text/javascript" src="js/jquery/jquery.js.cfm"></script>
	<script type="text/javascript" src="js/jquery/jquery.dimensions.pack.js.cfm"></script>
	<script type="text/javascript" src="js/global.js.cfm"></script>
	<script type="text/javascript" src="js/menu.js.cfm"></script>
	<script type="text/javascript" src="js/trail.js.cfm"></script>
	<script type="text/javascript" src="js/jquery/jquery.easing.1.2.packed.js.cfm"></script>
	<script type="text/javascript" src="js/jquery/suggest.js.cfm"></script>
	<script type="text/javascript" src="js/jquery/ui.js.cfm"></script>
	<script type="text/javascript" src="js/spry/xpath.js.cfm"></script>
	<script type="text/javascript" src="js/spry/SpryData.js.cfm"></script>
	<script type="text/javascript" src="js/spry/SpryNestedXMLDataSet.js.cfm"></script>
	<script type="text/javascript" src="js/spry/SpryValidationTextField.js.cfm"></script>
	<script type="text/javascript" src="js/spry/SpryUtils.js.cfm"></script>
	<script type="text/javascript" src="modules/admin/js/admin.js.cfm"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>ColdSpirit</title>
</head>
<body>
	<div id="spiritMenu">
		<table>
		<tr>
			<td class="miLeft"><strong>ColdSpirit</strong></td>
			<cfloop from="1" to="#ArrayLen(menu.data)#" index="i">
			<td class="hand mi_#url.module EQ menu.data[i].name#" onclick="go('?module=#menu.data[i].name#')">
				<a class="label" href="?module=#menu.data[i].name#">#menu.data[i].label#</a>
			</td>
			</cfloop>
			<td class="miRight hand">Log Off</td>
		</tr>
		</table>
	</div>
	<div id="controller">
		#controller#
	</div>
</body>
</html>
</cfoutput>