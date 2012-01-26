<cfcomponent displayname="xml" output="no" implements="interface">
	<cfprocessingdirective pageEncoding="utf-8" />
	<cffunction name="init" output="no" returntype="struct" access="public">
		<cfargument name="settings" type="struct" />
		<cfset this.dsn = arguments.settings.dsn />
		<cfset this.config_path = arguments.settings.root & "/app/conf/config.cfm" />
		<cfset var result = this />
		<cfreturn result />
	</cffunction>
	
	
	<!--- View queries --->
	<cffunction name="getViewByName" output="no" returntype="query" access="public">
		<cfargument name="viewName" type="string" />
		<cfscript>
			var myxml = this.readXML();
			var view = XMLSearch(myxml, "//view[@name=#arguments.viewName#]");
			
			var lis = "id,id_view,alias,controller,fieldnames,label,layout,name,priority,title,view,visibility";
			var result = QueryNew(lis);
		</cfscript>
		<cfif ArrayLen(view) >
			<cfset QueryAddRow(result) />
			<cfloop list="#lis#" index="arg">
				<cfset QuerySetCell(result, arg, view.XmlAttributes[arg]) />
			</cfloop>
			<cfbreak />
		</cfif>
		<cfreturn result />
	</cffunction>
	<cffunction name="getViewByID" output="no" returntype="query" access="public">
		<cfargument name="id" type="numeric" />
		<cfscript>
			var myxml = this.readXML();
			var views = XMLSearch(myxml, "//view");
			var lis = StructKeyList(views[1].xmlattributes);
			var result = QueryNew(lis);
		</cfscript>
		<cfloop array="#views#" index="inx">
			<cfset var myViewItem = inx.xmlattributes />
			<cfif (val(myViewItem.id) EQ val(arguments.id)) >
				<cfset QueryAddRow(result) />
				<cfloop list="#lis#" index="arg">
					<cfset QuerySetCell(result, arg, myViewItem[arg]) />
				</cfloop>
				<cfbreak />
			</cfif>
		</cfloop>
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
			var own_state = ListFindNoCase("visible,hidden,locked", arguments.visibility);
			var myxml = this.readXML();
			var views = XMLSearch(myxml, "//view");
			var lis = StructKeyList(views[1].xmlattributes);
			var result = QueryNew(lis);
		</cfscript>
		<cfloop array="#views#" index="inx">
			<cfset var myViewItem = inx.xmlattributes />
			<cfif ((NOT own_state) OR (own_state AND (myViewItem.visibility EQ arguments.visibility)))>
			<cfif (myViewItem.id_view EQ #arguments.id_view#)>
				<cfset QueryAddRow(result) />
				<cfloop list="#lis#" index="arg">
					<cfset QuerySetCell(result, arg, myViewItem[arg]) />
				</cfloop>
			</cfif>
			</cfif>					
		</cfloop>
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
			<cflock name="insert_update_delete_view" timeout="300">
			<cfscript>
				var myxml = this.readXML();
				var child_count = ArrayLen(myxml.config.views.xmlchildren) + 1;
				myxml.config.views.xmlchildren[child_count] = XmlElemNew(myxml,"view");
				var xml_attr = myxml.config.views.xmlchildren[child_count].xmlattributes;
			</cfscript>
 			<cfset var lis = lcase(StructKeyList(arguments.data)) />
			<cfloop list="#lis#" index="inx">
				<cfset xml_attr[inx] = arguments.data[inx] />
			</cfloop> 
			<cfset xml_attr.id = this.Free_ID(myxml,"views") />
			<cfset this.writeXML(myxml) />
			<cfset this.Sort_by_priority_name("views") />
			</cflock>
		<cfreturn xml_attr.id />
	</cffunction>
	<cffunction name="updateView" output="no" returntype="void" access="public">
		<cfargument name="data" type="query" />
		<cfargument name="id" type="numeric" />
		<cflock name="insert_update_delete_view" timeout="300">
		<cfif arguments.data.recordcount>
			<cfscript>
				var myxml = this.readXML();
				var it_him = 0;
				for(i=1;i LTE ArrayLen(myxml.config.views.xmlchildren);i=i+1)
				if (myxml.config.views.xmlchildren[i].xmlattributes.id EQ arguments.id)  var it_him = i;
			</cfscript>
			<cfif it_him>
				<cfloop query="arguments.data">
					<cfset myxml.config.views.XmlChildren[it_him].XmlAttributes[lcase(field)] = #fieldvalue# />
				</cfloop>
			</cfif>
		</cfif>
		<cfset this.writeXML(myxml)>
		<cfset Sort_by_priority_name("views")>
		</cflock>
	</cffunction>
	<cffunction name="deleteView" output="no" returntype="void" access="public">
		<cfargument name="idView" type="string" />
			<cflock name="insert_update_delete_view" timeout="300">
			<cfscript>
				var myxml = this.readXML();
				for (i=1; i LTE ArrayLen(myxml.config.views.XmlChildren); i=i+1) 
				if (myxml.config.views.XmlChildren[i].XmlAttributes.id EQ arguments.idView) ArrayDeleteAt(myxml.config.views.XmlChildren,i);
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
			var states = XMLSearch(myxml, "//state");
			var lis = StructKeyList(states[1].xmlattributes);
			var result = QueryNew(lis);
		</cfscript>
		<cfloop array="#states#" index="inx">	
			<cfset var myViewItem = inx.xmlattributes />
			<cfif ((NOT own_state) OR (own_state AND (myViewItem.visibility EQ arguments.visibility)))>
			<cfif (myViewItem.id_view EQ arguments.id_view) > <!--- AND ((myViewItem.visibility EQ arguments.visibility) OR (myViewItem.visibility EQ "all"))) > --->
				<cfset QueryAddRow(result) />
				<cfloop list="#lis#" index="arg">
					<cfset QuerySetCell(result, arg, myViewItem[arg]) />
				</cfloop>
			</cfif>
			</cfif>					
		</cfloop>
		<cfreturn result />
	</cffunction>
	<cffunction name="getStateByID" output="no" returntype="query" access="public">
		<cfargument name="id" type="numeric" />
		<cfscript>
			var myxml = this.readXML();
			var states = XMLSearch(myxml, "//state");
			var lis = StructKeyList(states[1].xmlattributes);
			var result = QueryNew(lis);
		</cfscript>
		<cfloop array="#states#" index="inx">	
			<cfset var myViewItem = inx.xmlattributes />
			<cfif (myViewItem.id EQ arguments.id) >
				<cfset QueryAddRow(result) />
				<cfloop list="#lis#" index="arg">
					<cfset QuerySetCell(result, arg, myViewItem[arg]) />
				</cfloop>
			</cfif>					
		</cfloop>
		<cfreturn result />
		
	</cffunction>
	<cffunction name="insertState" output="no" returntype="numeric" access="public">
		<cfargument name="id_view" type="numeric" />
		<cfparam name="id_view" type="numeric" default="0">
		<cflock name="insert_update_state" timeout="300">
			<cfscript>
				var data = {id=0,id_view=arguments.id_view,priority=0,has_text=0,visibility="visible",name="",label="",title="",state="default_state.cfm",exit_state=""};

				var myxml = this.readXML();
				var child_count = ArrayLen(myxml.config.states.xmlchildren) + 1;
				myxml.config.states.xmlchildren[child_count] = XmlElemNew(myxml,"state");
				var xml_attr = myxml.config.states.xmlchildren[child_count].xmlattributes;
			</cfscript>
 			<cfset var lis = lcase(StructKeyList(data)) />
			<cfloop list="#lis#" index="inx">
				<cfset xml_attr[inx] = data[inx] />
			</cfloop> 
			<cfset xml_attr.id = this.Free_ID(myxml,"states") />
			<cfset this.writeXML(myxml) />
			<cfset this.Sort_by_priority_name("states") />
		</cflock>				
		<cfreturn xml_attr.id />
	</cffunction>
	<cffunction name="updateState" output="no" returntype="void" access="public">
		<cfargument name="data" type="query" />
		<cfargument name="id" type="numeric" />
		<cflock name="insert_update_state" timeout="300">
			<cfif arguments.data.recordcount>
				<cfscript>
					var myxml = this.readXML();
					var it_him = 0;
					for(i=1;i LTE ArrayLen(myxml.config.states.xmlchildren);i=i+1)
					if (myxml.config.states.xmlchildren[i].xmlattributes.id EQ arguments.id)  var it_him = i;
				</cfscript>
				<cfif it_him>
					<cfloop query="arguments.data">
						<cfset myxml.config.states.XmlChildren[it_him].XmlAttributes[lcase(field)] = #fieldvalue# />
					</cfloop>
				</cfif>
			</cfif>
			<cfset this.writeXML(myxml)>
		</cflock>
		<cfset Sort_by_priority_name("states")>
	</cffunction>
	<cffunction name="deleteState" output="no" returntype="void" access="public">
		<cfargument name="id" type="numeric" />
		<cflock name="insert_update_state" timeout="300">
				<cfscript>
					var myxml = this.readXML();
					var it_him = 0;
					for(i=1;i LTE ArrayLen(myxml.config.states.xmlchildren);i=i+1)
					if (myxml.config.states.xmlchildren[i].xmlattributes.id EQ arguments.id)  var it_him = i;
				</cfscript>
				<cfif it_him>
					<cfset arrayDeleteAt(myxml.config.states.XmlChildren,it_him)/>
				</cfif>
			<cfset this.writeXML(myxml)>
		</cflock>
	</cffunction>

	<!--- Sevrice function --->
	<cffunction name="Free_ID" output="no" returntype="numeric" access="private">
		<cfargument name="myxml" type="xml" required="true">
		<cfargument name="obj" type="String" required="true">
		<cflock name="New_ID_sync" timeout="300">
		<cfscript>
			var ret_id = 1;
			var IDS = StructNew();
			for(i=1;i LTE ArrayLen(myxml.config[#obj#].XmlChildren);i=i+1) 
			{
				var tem = myxml.config[#obj#].XmlChildren[i].XmlAttributes.id;
				IDS["#tem#"] = true;
			}
				while(StructKeyExists(IDS,#ret_id#)) ret_id = ret_id +1;
			return ret_id;
		</cfscript>
		</cflock>
	</cffunction>
	<cffunction name="Sort_by_priority_name" output="no" returntype="void" access="private">
		<cfargument name="sort_obj" type="string" required="true" / >
		<cflock name="Sortlock" timeout="300">
			<cfset  var myxml = this.readXML() />
			<cfset  var myxmlar = myxml.config[#sort_obj#].XmlChildren />
			<cfif (ArrayLen(myxmlar) GT 1) >
					<cfset 	var len_ar = ArrayLen(myxmlar) />
					<cfset 	myxmlar[len_ar+1] = XmlElemNew(myxml,myxml.config[#sort_obj#].XmlChildren[1].XmlName) />
				<cfloop list="name,priority" index="parr">	
					<cfscript>
 						do 
						{ 
						var flips = 0;	
						for(i=1;i LTE (len_ar - 1); i=i+1) 
							if (myxmlar[i].Xmlattributes[#parr#] GT myxmlar[i+1].Xmlattributes[#parr#])
								{
									myxmlar[len_ar+1].XmlAttributes = StructCopy(myxmlar[i].Xmlattributes);
									myxmlar[i].Xmlattributes = StructCopy(myxmlar[i+1].Xmlattributes);
									myxmlar[i+1].Xmlattributes = StructCopy(myxmlar[len_ar+1].XmlAttributes) ; 
									flips = flips +1;
								}
						}
						while (flips GT 0); 
					</cfscript>
				</cfloop>
					<cfset ArrayDeleteAt(myxmlar,len_ar+1)/>
					<cfset this.writeXML(myxml) />
			</cfif>
		</cflock>
	</cffunction>
	<cffunction name="readXML" access="private" returntype="xml">
			<cflock name="spiritXMLLock" timeout="300">
				<cffile action="read" file="#ExpandPath(this.config_path)#" variable="arguments.temp" charset="utf-8" />
				<cfset var myxml = XMLParse(Trim(arguments.temp)) /> 
				<cftry>
					<cfcatch type = "any">
						<cfthrow message="cant open file #this.config_path#"/>
					</cfcatch>
				</cftry>
			</cflock>
		<cfreturn myxml>
	</cffunction>
	<cffunction name="writeXML" access="private" returntype="void">
		<cfargument name="myXML_to_w" type="XML">
			<cflock name="spiritXMLLock" timeout="300">
				<cftry>
					<cffile action="write" file="#ExpandPath(this.config_path)#" output = "#arguments.myXML_to_w#" charset = "utf8">
					<cfcatch type="any">
						<cfthrow message="cant write in file #this.config_path#"/>
					</cfcatch>
				</cftry>
			</cflock>
	</cffunction>
</cfcomponent>