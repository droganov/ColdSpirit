<cfsilent>
	<cfprocessingdirective pageencoding="utf-8"/>
	<cfsetting showdebugoutput="no" />
	<cfcontent type="text/xml" reset="Yes"/>
	<cfparam name="url.l1" default="edit" />
	<cfparam name="url.l2" type="string" default="" />
	<cfparam name="url.l3" type="string" default="" />
	<cfparam name="url.l4" type="string" default="" />
	<cfscript>
		var directory = CreateObject("component", "spirit.admin.com.directory");
		if(NOT StructKeyExists(url, "v")) url.v = "";
		if(NOT Len(url.v))
			url.v = this.getSetting("defaultViewName");
		var viewObj = this.getView(url.v);
		var ancestor = viewObj.getAncestorOrSelf("all");
	</cfscript>
</cfsilent><?xml version="1.0" encoding="UTF-8"?>
<cfoutput>
<columns>
	<!--- View Chain --->
	<cfloop query="ancestor">
		<column type="views">
			<view>#name#</view>
			<views>
				<cfsilent>
					<cfscript>
						var children = this.getView(name).getViews("all");
					</cfscript>
				</cfsilent>
				<cfloop query="children">
				<view selected="#IIF(viewObj.hasAncestor(name) OR viewObj.get('name') EQ name, DE('selected'), DE(''))#" visibility="#lcase(visibility)#">#XMLFormat(name)#</view></cfloop>
			</views>
		</column>
	</cfloop>
	<!--- Add/Edit Route --->
	<cfswitch expression="#url.l1#">
	<cfcase value = "newView">
		<column type="newView" name="Add View">
			<id>#viewObj.get("id")#</id>
			<name>#viewObj.get("name")#</name>
		</column>
	</cfcase>
	<cfcase value="edit">
		<cfsilent>
			<cfscript>
				var states = viewObj.fetchStates("all");
				var layout = "";
					if(url.l2 EQ "layout") layout = "selected";
				var controller = "";
					if(url.l2 EQ "controller") controller = "selected";
				var view = "";
					if(url.l2 EQ "view") view = "selected";
				var alias = "";
					if(url.l2 EQ "alias") alias = "selected";
			</cfscript>
		</cfsilent>
		<column type="edit" layout="#layout#" controller="#controller#" view="#view#" alias="#alias#">
			<name>#XMLFormat(viewObj.get("name"))#</name>
			<alias>#XMLFormat(viewObj.get("alias"))#</alias>
			<label>#XMLFormat(viewObj.get("label"))#</label>
			<title>#XMLFormat(viewObj.get("title"))#</title>
			<layout>#XMLFormat(viewObj.get("layout"))#</layout>
			<controller>#XMLFormat(viewObj.get("controller"))#.cfc</controller>
			<view>#XMLFormat(viewObj.get("view"))#</view>
			<visibility>#XMLFormat(lcase(viewObj.get("visibility")))#</visibility>
			<defaultView>#this.getSetting("defaultViewName")#</defaultView>
			<states>
				<cfloop query="states">
					<state name="#name#" state="#state#" exit_state="#exit_state#" selected="#iif(url.l3 EQ name, DE('selected'),DE('notselected'))#" visibility="#visibility#" />
				</cfloop>
			</states>
		</column>
	</cfcase>
	</cfswitch>
	<!--- Level 3 panels --->
	<cfswitch expression="#url.l2#">
		<cfcase value="layout,view">
			<cfscript>
				var d = ExpandPath("/") & this.getSetting(url.l2);
				var files = directory.list(d, "*.cfm", "desc", false);
			</cfscript>
			<column type="#url.l2#">
				<viewName>#viewObj.get("name")#</viewName>
				<template>#viewObj.get("name")#_#url.l2#.cfm</template>
				<files>
					<cfloop query="files"><file name="#name#" /></cfloop>
				</files>
			</column>
		</cfcase>
		<cfcase value="controller">
			<cfscript>
				var d = ExpandPath("/") & ListChangeDelims(this.getSetting(url.l2), "/", ".");
				var files = directory.list(d, "*.cfc", "desc", false);
			</cfscript>
			<column type="#url.l2#">
				<viewName>#viewObj.get("name")#</viewName>
				<template>#viewObj.get("name")#_controller.cfc</template>
				<files>
					<cfloop query="files"><file name="#name#" /></cfloop>
				</files>
			</column>
		</cfcase>
		<!--- Alias --->
		<cfcase value="alias">
			<cfscript>
				var interface = this.getSetting("interface");
				var interfaceObj = CreateObject("component", "/spirit.framework.com.interface." & interface).init(variables.spirit.settings);
				var views = interfaceObj.fetchAllViews();
			</cfscript>
			<column type="alias" name="#url.l3#" alias="#viewObj.get('alias')#">
				<viewName>#viewObj.get('name')#</viewName>
				<views>
					<cfloop query="views">
						<cfif name NEQ viewObj.get('name')>
							<id>#id#</id>
							<view>#name#</view>
						</cfif>
					</cfloop>
				</views>
			</column>
		</cfcase>
		<!--- States --->
		<cfcase value = "newState">
			<column type="newState" viewName="#viewObj.get('name')#" label="Add State" />
		</cfcase>
		<cfcase value = "state">
			
			<cfscript>
				var stateData = viewObj.getState(url.l3).getAttributes();
			</cfscript>
			<column type="state" name="#url.l3#">
				<viewName>#viewObj.get('name')#</viewName>
				<state>
					<cfloop collection="#stateData#" item="key">
						<cfset keyValue = stateData[key] />
						<#LCase(key)#>#XMLFormat(keyValue)#</#LCase(key)#>
					</cfloop>
				</state>
			</column>
		</cfcase>
	</cfswitch>
	<cfswitch expression="#url.l4#">
		<cfcase value="stateTemplates">
			<cfscript>
				var stateData = viewObj.getState(url.l3).getAttributes();
				var d = ExpandPath("/") & this.getSetting("state");
				var files = directory.list(d, "*.cfm", "desc", false);
			</cfscript>
			<column type="stateTemplates" name="Set State Handler">
				<viewName>#viewObj.get("name")#</viewName>
				<stateName>#stateData.name#</stateName>
				<files>
					<cfloop query="files"><file>#XMLFormat(name)#</file></cfloop>
				</files>
			</column>
		</cfcase>
		<cfcase value="exit_state">
			<cfsilent>
				<cfscript>
					var stateData = viewObj.getState(url.l3).getAttributes();
					var states = viewObj.fetchStates("all");
				</cfscript>
			</cfsilent>
			<column type="exit_state" name="Set Exit State">
				<viewName>#viewObj.get("name")#</viewName>
				<stateName>#stateData.name#</stateName>
				<exit_state>#stateData.exit_state#</exit_state>
				<states>
					<cfloop query="states">
						<cfif name NEQ stateData.name>
							<state handler="#XMLFormat(state)#">#XMLFormat(name)#</state>
						</cfif>
					</cfloop>
				</states>
			</column>
		</cfcase>
	</cfswitch>
</columns>
</cfoutput>