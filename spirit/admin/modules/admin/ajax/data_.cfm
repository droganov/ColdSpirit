<cfsilent>
	<cfprocessingdirective pageencoding="utf-8"/>
	<cfsetting showdebugoutput="no" />
	<cfcontent type="text/xml" reset="Yes"/>
	<cfparam name="url.l1" default="edit" />
	<cfparam name="url.l2" type="string" default="" />
	<cfparam name="url.l3" type="string" default="" />
	<cfparam name="url.l4" type="string" default="" />
	<cfscript>
		spirit = CreateObject("component", "spirit.framework.Spirit").init(request.spiritSettings);
		directory = CreateObject("component", "spirit.framework.com.util.directory");
		if(NOT StructKeyExists(url, "v"))
			url.v = spirit.getSetting("defaultViewName");
		viewObj = spirit.view(url.v);
		ancestor = viewObj.ancestorOrSelf("all");
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
						children = spirit.view(name).views("all");
					</cfscript>
				</cfsilent>
				<cfloop query="children">
				<view selected="#IIF(viewObj.hasAncestor(name), DE('selected'), DE(''))#" visibility="#visibility#">#XMLFormat(name)#</view></cfloop>
			</views>
		</column>
	</cfloop>
	<!--- Add/Edit Route --->
	<cfswitch expression="#url.l1#">
	<cfcase value = "newView">
		<column type="newView" name="Add View">
			<id>#viewObj.getAttribute("id")#</id>
			<name>#viewObj.getAttribute("name")#</name>
		</column>
	</cfcase>
	<cfcase value="edit">
		<cfsilent>
			<cfscript>
				states = viewObj.states("all");
				viewData = viewObj.getAttributes();
				layout = "";
					if(url.l2 EQ "layout") layout = "selected";
				controller = "";
					if(url.l2 EQ "controller") controller = "selected";
				view = "";
					if(url.l2 EQ "view") view = "selected";
				alias = "";
					if(url.l2 EQ "alias") alias = "selected";
			</cfscript>
		</cfsilent>
		<column type="edit" layout="#layout#" controller="#controller#" view="#view#" alias="#alias#">
			<name>#XMLFormat(viewData.name)#</name>
			<alias>#XMLFormat(viewData.alias)#</alias>
			<label>#XMLFormat(viewData.label)#</label>
			<title>#XMLFormat(viewData.title)#</title>
			<layout>#XMLFormat(viewData.layout)#</layout>
			<controller>#XMLFormat(viewData.controller)#.cfc</controller>
			<view>#XMLFormat(viewData.view)#</view>
			<visibility>#XMLFormat(viewData.visibility)#</visibility>
			<defaultView>#spirit.getSetting("defaultViewName")#</defaultView>
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
				d = ExpandPath("/") & spirit.getSetting(url.l2);
				files = directory.list(d, "*.cfm", "desc", false);
			</cfscript>
			<column type="#url.l2#">
				<viewName>#viewObj.getAttribute("name")#</viewName>
				<template>#viewObj.getAttribute("name")#.cfm</template>
				<files>
					<cfloop query="files"><file name="#name#" /></cfloop>
				</files>
			</column>
		</cfcase>
		<cfcase value="controller">
			<cfscript>
				d = ExpandPath("/") & ListChangeDelims(spirit.getSetting(url.l2), "/", ".");
				files = directory.list(d, "*.cfc", "desc", false);
			</cfscript>
			<column type="#url.l2#">
				<viewName>#viewObj.getAttribute("name")#</viewName>
				<template>#viewObj.getAttribute("name")#.cfc</template>
				<files>
					<cfloop query="files"><file name="#name#" /></cfloop>
				</files>
			</column>
		</cfcase>
		<!--- Alias --->
		<cfcase value="alias">
			<cfscript>
				viewData = viewObj.getAttributes();
				views = viewObj.viewStack.listAllViews();
			</cfscript>
			<column type="alias" name="#url.l3#" alias="#viewData.alias#">
				<viewName>#viewData.name#</viewName>
				<views>
					<cfloop query="views">
						<cfif name NEQ viewData.name>
							<id>#id#</id>
							<view>#name#</view>
						</cfif>
					</cfloop>
				</views>
			</column>
		</cfcase>
		<!--- States --->
		<cfcase value = "newState">
			<column type="newState" viewName="#viewObj.getAttribute('name')#" label="Add State" />
		</cfcase>
		<cfcase value = "state">
			
			<cfscript>
				stateData = viewObj.state(url.l3).getAttributes();
			</cfscript>
			<column type="state" name="#url.l3#">
				<viewName>#viewObj.getAttribute('name')#</viewName>
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
				stateData = viewObj.state(url.l3).getAttributes();
				d = ExpandPath("/") & spirit.getSetting("state");
				files = directory.list(d, "*.cfm", "desc", false);
			</cfscript>
			<column type="stateTemplates" name="Set State Handler">
				<viewName>#viewObj.getAttribute("name")#</viewName>
				<stateName>#stateData.name#</stateName>
				<files>
					<cfloop query="files"><file>#XMLFormat(name)#</file></cfloop>
				</files>
			</column>
		</cfcase>
		<cfcase value="exit_state">
			<cfsilent>
				<cfscript>
					stateData = viewObj.state(url.l3).getAttributes();
					states = viewObj.states("all");
				</cfscript>
			</cfsilent>
			<column type="exit_state" name="Set Exit State">
				<viewName>#viewObj.getAttribute("name")#</viewName>
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