<cfcomponent displayname="xml" output="no" implements="interface">
	<cfprocessingdirective pageEncoding="utf-8" />
	<cffunction name="init" output="no" returntype="struct" access="public">
		<cfargument name="settings" type="struct" />
		<cfset this.dsn = arguments.settings.dsn />
		<cfset this.settings = arguments.settings />
		<cfset this.config_path = arguments.settings.root & "/app/conf/config.cfm" />
		<cfset var result = this />
		<cfreturn result />
	</cffunction>
	
	
	<!--- View queries --->
	<cffunction name="getViewByName" output="no" returntype="query" access="public">
		<cfargument name="viewName" type="string" />
		<cfscript>
			var myxml = this.readXML();
			var view = XMLSearch(myxml, "//view[@name = '#arguments.viewName#']");
			var lis = this.getViewFieldsList();
			var result = QueryNew(lis);
		</cfscript>
		<cfif ArrayLen(view) >
			<cfset QueryAddRow(result) />
			<cfloop list="#lis#" index="arg">
				<cfset QuerySetCell(result, arg, view[1].XmlAttributes[arg]) />
			</cfloop>
		</cfif>
		<cfreturn result />
	</cffunction>
	<cffunction name="getViewByID" output="no" returntype="query" access="public">
		<cfargument name="id" type="numeric" />
		<cfscript>
			var myxml = this.readXML();
			var view = XMLSearch(myxml, "//view[@id='#arguments.id#']");
			var lis = this.getViewFieldsList();
			var result = QueryNew(lis);
		</cfscript>
		<cfif ArrayLen(view) >
			<cfset QueryAddRow(result) />
			<cfloop list="#lis#" index="arg">
				<cfset QuerySetCell(result, arg, view[1].XmlAttributes[arg]) />
			</cfloop>
		</cfif>
		<cfreturn result />
	</cffunction>
	<cffunction name="fetchAllViews" output="no" returntype="query" access="public">
		<cfscript>
			var myxml = this.readXML();
			var views = XMLSearch(myxml, "//view");
			var result = QueryNew("id,id_view,name");
		</cfscript>
		<cfloop array="#views#" index="inx">
			<cfset QueryAddRow(result) />
			<cfset QuerySetCell(result,"id",inx.XmlAttributes.id) />
			<cfset QuerySetCell(result,"id_view",inx.XmlAttributes.id_view) />
			<cfset QuerySetCell(result,"name",inx.XmlAttributes.name) />
		</cfloop>
		<cfreturn result />
	</cffunction>
	<cffunction name="fetchChildViews" output="no" returntype="query" access="public">
		<cfargument name="id_view" type="numeric" />
		<cfargument name="visibility" type="string" default="visible" />
		<cfscript>
			var own_state = ListValuecountnocase("visible,hidden,locked", arguments.visibility);
			var myxml = this.readXML();
			var views = XMLSearch(myxml, "//view[@id_view='#arguments.id_view#']");
			var lis = this.getViewFieldsList();
			var result = QueryNew(lis);
		</cfscript>
		<cfif ArrayLen(views) >
			<cfloop array="#views#" index="view">
				<cfif NOT own_state OR (lCase(view.XmlAttributes.visibility) EQ lCase(arguments.visibility))>
					<cfset QueryAddRow(result) />
					<cfloop list="#lis#" index="arg">
						<cfset QuerySetCell(result, arg, view.XmlAttributes[arg]) />
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn result />
	</cffunction>
	<cffunction name="insertView" output="no" returntype="numeric" access="public">
		<cfargument name="data" type="struct"/>
		
		<cfparam name="arguments.data.id" type="numeric" default="0"/>
		<cfparam name="arguments.data.id_view" type="numeric" default="0"/>
		<cfparam name="arguments.data.priority" type="numeric" default="0"/>
		<cfparam name="arguments.data.visibility" type="string" default=""/>
		<cfparam name="arguments.data.name" type="string" default=""/>
		<cfparam name="arguments.data.alias" type="string" default=""/>
		<cfparam name="arguments.data.label" type="string" default=""/>
		<cfparam name="arguments.data.title" type="string" default=""/>
		<cfparam name="arguments.data.layout" type="string" default=""/>
		<cfparam name="arguments.data.controller" type="string" default=""/>
		<cfparam name="arguments.data.view" type="string" default=""/>
			<cflock name="spiritXMLLock" timeout="300">
				<cfscript>
					var myxml = this.readXML();
					var child_count = ArrayLen(myxml.config.views.xmlchildren) + 1;
					myxml.config.views.xmlchildren[child_count] = XmlElemNew(myxml,"view");
					var xml_attr = myxml.config.views.xmlchildren[child_count].xmlattributes;
					var lis = this.getViewFieldsList();
				</cfscript>
					<cfloop list="#lis#" index="inx">
						<cfset myxml.config.views.xmlchildren[child_count].xmlattributes[inx] = arguments.data[inx] />
					</cfloop>
				<cfscript>
					var nid = this.Free_ID(myxml,"view");
					myxml.config.views.xmlchildren[child_count].xmlattributes.id = nid;
					this.writeXML(myxml,"views");
				</cfscript>
			</cflock>
		<cfreturn nid/>
	</cffunction>
	<cffunction name="updateView" output="no" returntype="void" access="public">
		<cfargument name="data" type="query" />
		<cfargument name="id" type="numeric" />
		<cflock name="insert_update_delete_view" timeout="300">
			<cfif arguments.data.recordcount>
				<cfscript>
					var myxml = this.readXML();
					var view = XMLSearch(myxml, "//view[@id='#arguments.id#']");
				</cfscript>
				<cfif ArrayLen(view)>
					<cfloop query="arguments.data">
						<cfset view[1].XmlAttributes[lcase(field)] = #fieldvalue# />
					</cfloop>
				</cfif>
			</cfif>
			<cfset this.writeXML(myxml,"views")>
		</cflock>
	</cffunction>
	<cffunction name="deleteView" output="no" returntype="void" access="public">
		<cfargument name="idView" type="string" />
			<cflock name="insert_update_delete_view" timeout="300">
			<cfscript>
				var myxml = this.readXML();
				for (i=1; i LTE ArrayLen(myxml.config.views.XmlChildren); i=i+1) 
					if (myxml.config.views.XmlChildren[i].XmlAttributes.id EQ val(arguments.idView)) ArrayDeleteAt(myxml.config.views.XmlChildren,i);
				
				var states = XMLSearch(myxml, "//state[@id_view='#arguments.idView#']");
				for(var k=1;k LTE ArrayLen(states);k++)
					for (var i=1;i LTE ArrayLen(myxml.config.states.XmlChildren);i++)
						if (myxml.config.states.XmlChildren[i].XmlAttributes.id EQ states[k].XmlAttributes.id)
							ArrayDeleteAt(myxml.config.states.XmlChildren,i);
				this.writeXML(myxml);
			</cfscript>
			</cflock>
	</cffunction>
	
	
	<!--- State queries --->
	<cffunction name="fetchStatesByViewID" output="no" returntype="query" access="public">
		<cfargument name="id_view" type="numeric" />
		<cfargument name="visibility" type="string" default="visible" />
		<cfscript>
			var own_state = ListFindNoCase("visible,hidden,locked", arguments.visibility);
			var myxml = this.readXML();
			var states = XMLSearch(myxml, "//state[@id_view='#arguments.id_view#'"&IIF(own_state,'" and @visibility=''"&arguments.visibility&"'']"','"]"'));
			var lis = this.getStateFieldsList();
			var result = QueryNew(lis);
		</cfscript>
		<cfloop array="#states#" index="myStateItem">
			<cfset QueryAddRow(result)/>
			<cfloop list="#lis#" index="arg">
				<cfset QuerySetCell(result, arg, myStateItem.XmlAttributes[arg])/>
			</cfloop>
		</cfloop>
		<cfreturn result />
	</cffunction>
	<cffunction name="getStateByID" output="no" returntype="query" access="public">
		<cfargument name="id" type="numeric" />
		<cfscript>
			var myxml = this.readXML();
			var states = XMLSearch(myxml, "//state[@id='#arguments.id#']");
			var lis = this.getStateFieldsList();
			var result = QueryNew(lis);
		</cfscript>
		<cfloop array="#states#" index="myStateItem">
			<cfset QueryAddRow(result)/>
			<cfloop list="#lis#" index="arg">
				<cfset QuerySetCell(result, arg, myStateItem.XmlAttributes[arg])/>
			</cfloop>
			<cfbreak>
		</cfloop>
		<cfreturn result />
		
	</cffunction>
	<cffunction name="insertState" output="no" returntype="numeric" access="public">
		<cfargument name="id_view" type="numeric"/>
		<cflock name="spiritXMLLock" timeout="300">
			<cfscript>
				var data = {id:0,
							id_view:arguments.id_view,
							priority:0,
							has_text:0,
							visibility:"visible",
							name:"default",
							label:"",
							title:"",
							state:"default_state.cfm",
							exit_state:""};

				var myxml = this.readXML();
				var child_count = ArrayLen(myxml.config.states.xmlchildren) + 1;
				myxml.config.states.xmlchildren[child_count] = XmlElemNew(myxml,"state");
				var xml_attr = myxml.config.states.xmlchildren[child_count].xmlattributes;
				var lis = this.getStateFieldsList();
			</cfscript>
			<cfloop list="#lis#" index="inx">
				<cfset myxml.config.states.xmlchildren[child_count].xmlattributes[inx] = data[inx]/>
			</cfloop>
			<cfset var nid = this.Free_ID(myxml,"state")/>
			<cfset myxml.config.states.xmlchildren[child_count].xmlattributes.id = nid/>
			<cfset this.writeXML(myxml,"states")/>
		</cflock>
		<cfreturn nid />
	</cffunction>
	<cffunction name="updateState" output="no" returntype="void" access="public">
		<cfargument name="data" type="query" />
		<cfargument name="id" type="numeric" />
		<cflock name="insert_update_state" timeout="300">
			<cfif arguments.data.recordcount>
				<cfscript>
					var myxml = this.readXML();
					var state = XMLSearch(myxml, "//state[@id='#arguments.id#']");
				</cfscript>
				<cfif ArrayLen(state)>
					<cfloop query="arguments.data">
						<cfset state[1].XmlAttributes[lcase(field)] = #fieldvalue# />
					</cfloop>
				</cfif>
			</cfif>
			<cfset this.writeXML(myxml,"states")>
		</cflock>
	</cffunction>
	<cffunction name="deleteState" output="no" returntype="void" access="public">
		<cfargument name="id" type="numeric" />
		<cflock name="insert_update_state" timeout="300">
				<cfscript>
					var myxml = this.readXML();
					for (var i=1; i LTE ArrayLen(myxml.config.states.XmlChildren); i=i+1)
						if (myxml.config.states.XmlChildren[i].XmlAttributes.id EQ arguments.id)
							{
								ArrayDeleteAt(myxml.config.states.XmlChildren,i);
								break;
							}
				</cfscript>
			<cfset this.writeXML(myxml)>
		</cflock>
	</cffunction>

	<!--- Sevrice function --->
	<cffunction name="Free_ID" output="no" returntype="numeric" access="private">
		<cfargument name="myxml" type="xml" required="true">
		<cfargument name="obj" type="String" required="true">
		<cflock name="New_ID_sync" timeout="300">
			<cfscript>
				var ids = [];
				var objs = XMLSearch(arguments.myxml, "//"&arguments.obj);
				for(var inx=1;inx LTE ArrayLen(objs);inx++) ArrayAppend(ids,objs[inx].XmlAttributes.id);
			</cfscript>
			<cfreturn ArrayMax(ids)+1>
		</cflock>
	</cffunction>
	<cffunction name="readXML" access="private" returntype="xml">
			<cflock name="spiritXMLLock" timeout="300">
				<cflock scope="application" type="exclusive" timeout="300">
					<cfif StructKeyExists(application,this.settings.appKey) AND StructKeyExists(application[this.settings.appKey],"xml_config") AND isXMLDoc(application[this.settings.appKey].xml_config)>
						<cfset var myxml = application[this.settings.appKey].xml_config/>
					<cfelse>
						<cftry>
							<cffile action="read" file="#ExpandPath(this.config_path)#" variable="arguments.temp" charset="utf-8" />
							<cfset var myxml = XMLParse(Trim(arguments.temp)) /> 
							<cfcatch type = "any">
								<cfthrow message="cant open file #this.config_path#"/>
							</cfcatch>
						</cftry>
						<cfset application[this.settings.appKey].xml_config = myxml/>
					</cfif>
				</cflock>
			</cflock>
		<cfreturn myxml>
	</cffunction>
	<cffunction name="writeXML" access="private" returntype="void">
		<cfargument name="myxml" type="XML">
		<cfargument name="sort_type" type="string" default="">
		<cflock name="spiritXMLLock" timeout="300">
			<cfif Len(arguments.sort_type)>
				<cfset myxmlar = arguments.myxml.config[arguments.sort_type].XmlChildren/>
				<cfset 	var len_ar = ArrayLen(myxmlar)/>
				<cfif len_ar GT 1>
					<cfset var view = XmlElemNew(arguments.myxml,myxmlar[1].XmlName)>
					<cfloop list="name,priority" index="parr">
						<cfscript>
	 						do{
								var flips = 0;
								for(var i=1;i LTE (len_ar - 1);i++)
									if (myxmlar[i].Xmlattributes[parr] GT myxmlar[i+1].Xmlattributes[parr])
										{
											view.Xmlattributes = Structcopy(myxmlar[i].Xmlattributes);
											myxmlar[i].Xmlattributes = StructCopy(myxmlar[i+1].Xmlattributes);
											myxmlar[i+1].Xmlattributes = StructCopy(view.Xmlattributes);
											flips++;
										}
							}while (flips); 
						</cfscript>
					</cfloop>
				</cfif>
			</cfif>
			<cffile action="write" file="#ExpandPath(this.config_path)#" output = "#arguments.myxml#" charset = "utf8">
			<cflock scope="application" type="exclusive" timeout="300">
				<cfset application[this.settings.appKey].xml_config = arguments.myxml/>
			</cflock>
		</cflock>
	</cffunction>

	<cffunction name="getViewFieldsList" output="no" returntype="string" access="private">
		<cfreturn "id,id_view,alias,controller,label,layout,name,priority,title,view,visibility" />
	</cffunction>
	<cffunction name="getStateFieldsList" output="no" returntype="string" access="private">
		<cfreturn "id,id_view,priority,has_text,visibility,name,label,title,state,exit_state" />
	</cffunction>
</cfcomponent>
