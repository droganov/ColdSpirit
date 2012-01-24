<cfprocessingdirective pageEncoding="utf-8" /><cfsilent>
	<cfparam name="url.a" type="string" default="" />
	<cfsetting showdebugoutput="no" />
	<cfscript>
		var myResult = 1;
		switch(url.a) {
			case "createView" :{
				var viewObj = this.getView(form.parentView);
				try {
					viewObj.insert(form);
				}
				catch(Any e) {
					myResult = e.message;
				}
				break;
			}
			case "deleteView" :{
				var viewObj = this.getView(form.viewName);
				viewObj.delete();
				var myResult = "ok";
				break;
			}
			case "updateView": case "setViewAlias":{
				try {
					this.getView(form.viewName).update(form);
				}
				catch(Any e) {
					myResult = e.message;
				}
				
				break;
			}
			case "moveView":{
				this.getView(form.viewName).move(form.targetViewName, form.placeAfter);
				break;
			}
			case "setViewTemplate":{
				form.file = Replace(form.file, ".cfc", "", "All");
				form[form.type] = form.file;
				this.getView(form.viewName).update(form);
				break;
			}
			case "addViewTemplate" :{
				/*
					TODO fix this workaround when ExpandPath bug will be fixed
				*/
				var destinationPath = Replace(this.getSetting(form.type), "//", "/") & "/";
				destinationPath = ExpandPath(Replace(destinationPath, ".", "/", "ALL")) & form.file;
				var sourcePath = ExpandPath("../../../../framework/template/") & form.type;
				if(form.type EQ "controller"){
					sourcePath = sourcePath & ".cfc";
				}
				else{
					sourcePath = sourcePath & ".cfm";
				}
				//throw(destinationPath);
				try {
					FileCopy(sourcePath, destinationPath);
					form[form.type] = Replace(form.file, ".cfc", "", "All");
					this.getView(form.viewName).update(form);
				}
				catch(Any e) {
					var myResult = 'File "' & form.file & '" already exists!';
				}
				break;
			}
			case "addState" :{
				try {
					var myResult = this.getView(form.viewName).insertState(form);
				}
				catch(Any e) {
					var myResult = "View '" & form.viewName & "' already has child state named '" & form.name & "'.";
				}
				break;
			}
			case "updateState":{
				this.getView(form.viewName).getState(form.oldName).update(form);
				break;
			}
			case "setStateTemplate" :{
				this.getView(form.viewName).getState(form.stateName).update(form);
				break;
			}
			case "createStateTemplate" :{
				var sourcePath = ExpandPath("../../../../framework/template/state.cfm");
				var destinationPath = ExpandPath(this.getSetting("state")) & "/" & form.state;
				//throw(destinationPath);
				try {
					FileCopy(sourcePath, destinationPath);
					this.getView(form.viewName).getState(form.stateName).update(form);
				}
				catch(Any e) {
					var myResult = 'File "' & form.file & '" already exists!';
				}
				break;
			}
			case "setExitState":{
				this.getView(form.viewName).getState(form.stateName).update(form);
				break;
			}
		}
	</cfscript>
	<cffunction name="throw" output="no" returntype="void" access="public">
		<cfargument name="m" type="string" />
		<cfthrow message="#m#" />
	</cffunction>
</cfsilent><cfoutput>#myResult#</cfoutput>