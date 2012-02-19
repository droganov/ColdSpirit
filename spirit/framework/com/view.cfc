<cfcomponent>
	<cfscript>
		public view function init(required string name, required struct settings){
			this.name					= arguments.name;
			variables.settings			= arguments.settings;
			variables.data				= this.getData();
			variables.states			= {};
			variables.stateStack		= {};
			variables.locked			= this.get("visibility") EQ "locked";
			variables.visible			= this.get("visibility") EQ "visible";
			variables.views				= {};
			variables.hasAlias			= YesNoFormat(Len(this.get("alias")));
			variables.hasParent			= YesNoFormat(this.get("name") NEQ this.getSetting("defaultViewName"));
			
			var states					= fetchStates("all");
			variables.defaultStateName	= states.name;
			
			
			for (local.i=1; i LTE states.recordcount; i=i+1) {
				variables.stateStack[states.name[i]] = CreateObject("component", "state").init(
					states.id[i],
					this,
					variables.settings
				);
			}
			
			return this;
		}
		
		// Actions
		
		// Desision
		public boolean function locked(){
			return variables.locked;
		}
		public boolean function visible(){
			return variables.visible;
		}
		public boolean function hasAlias(){
			return variables.hasAlias;
		}
		public boolean function hasAncestor(required string name){
			try {
				var result = StructKeyExists(variables.breadcrumbs, arguments.name);
			}
			catch(Any e) {
				variables.breadcrumbs = {};
				var arr = this.getAncestorArray();
				for (local.i=1; i LTE (ArrayLen(arr)); i=i+1) {
					variables.breadcrumbs[arr[i]] = "";
				}
				var result = StructKeyExists(variables.breadcrumbs, arguments.name);
			}
			return result;
		}
		public boolean function isDefaultView(){
			return !variables.hasParent;
		}
		public boolean function hasState(required string name){
			return StructKeyExists(variables.stateStack, arguments.name);
		}
		
		
		// Getters
		public string function get(required string key){
			return variables.data[arguments.key];
		}
		public query function getAncestor(visibility:"visible"){
			try {
				var result = variables.ancestor[arguments.visibility];
			}
			catch(Any e) {
				if(NOT ListFindNoCase("visible,hidden,locked,all", arguments.visibility))
					arguments.visibility = "visible";
				var result = this.makeAncestors(arguments.visibility, 1);
				variables.ancestor[arguments.visibility] = result;
			}
			return result;
		}		
		public array function getAncestorArray(result:[]){
			try {
				var result = variables.ancestorArray;
			}
			catch(Any e) {
				var result = [];
				for (local.i=1; i LTE ArrayLen(arguments.result); i=i+1) {
					result[i] = arguments.result[i]
				}
				if(!this.isDefaultView()) {
					var id_view = this.get("id_view");
					var parentView = this.getViewByID(id_view);
					var parentAncestor = parentView.getAncestorArray(result);
					
					for (local.i=1; i LTE ArrayLen(parentAncestor); i=i+1) {
						ArrayAppend(result, parentAncestor[i]);
					}
				}
				ArrayAppend(result, this.get("name"));
				variables.ancestorArray = result;
			}
			return result;
		}
		public query function getAncestorOrSelf(visibility:"visible"){
			try {
				var result = variables.ancestorOrSelf[arguments.visibility];
			}
			catch(Any e) {
				if(NOT ListFindNoCase("visible,hidden,locked,all", arguments.visibility))
					arguments.visibility = "visible";
				var result = this.makeAncestors(arguments.visibility, 0);
				variables.ancestorOrSelf[arguments.visibility] = result;
			}
			return result;
		}
		public string function getDefaultStateName(){
			return variables.defaultStateName;
		}
		public state function getState(stateName:this.getDefaultStateName()){
			var result = variables.stateStack[arguments.stateName];
			return result;
		}
		public query function fetchStates(visibility:"visible"){
			try{
				var states = variables.states[arguments.visibility];
			}
			catch (Any e){
				var states = this.loadStates(arguments.visibility);
			}
			return states;
		}
		public query function fetchViews(visibility:"visible"){
			try{
				return variables.views[arguments.visibility];
			}
			catch (Any e){
				var interfaceObj = this.getInterface();
				var views = interfaceObj.fetchChildViews(this.get("id"), arguments.visibility);
				variables.views[arguments.visibility] = views;
				return views;
			}
		}
		
		// Setters
		public void function delete(){
			var interfaceObj = this.getInterface();
			var childViews = this.fetchViews("all");
			var viewName = this.get("name");
			var viewID = this.get("id");
			var i = 1;
			for (i=1; i LTE childViews.recordcount; i=i+1) {
				var childView = this.getViewByName(childViews.name[i]);
				childView.delete();
			}
			interfaceObj.deleteView(viewID);
			this.reset();
		}
		public numeric function insert(required struct data){
			if(NOT StructKeyExists(arguments.data, "priority"))
				arguments.data.priority = this.getNextPriority();
			if(NOT StructKeyExists(arguments.data, "label"))
				arguments.data.label = "New View";
			if(NOT StructKeyExists(arguments.data, "title"))
				arguments.data.title = "";
			if(NOT StructKeyExists(arguments.data, "visibility"))
				arguments.data.visibility = "visible";
			if(NOT StructKeyExists(arguments.data, "layout"))
				arguments.data.layout = this.getSetting("defaultLayoutTemplate");
			if(NOT StructKeyExists(arguments.data, "view"))
				arguments.data.view = this.getSetting("defaultViewTemplate");
			if(NOT StructKeyExists(arguments.data, "controller"))
				arguments.data.controller = this.getSetting("defaultControllerName");
				
			if(this.viewExists(arguments.data.name))
				throw('View "' & arguments.data.name & '" already exists.');
				
			arguments.data.id_view = this.get("id");
			var interfaceObj = this.getInterface();
			
			
			var idView = interfaceObj.insertView(arguments.data);
			var stateArguments = StructNew();
			stateArguments.id_view = idView;
			this.insertState(stateArguments);
			return idView;
		}
		public numeric function insertState(required struct data){
			var state = this.getState();
			return state.insert(arguments.data);
		}
		public void function deleteState(required string stateName){
			var states = fetchStates("all");
			if(states.recordCount LTE 1) throw("You can not delete the last state.");
			if(NOT Len(arguments.stateName)) throw("Name of the state is not set.");
			if(NOT this.hasState(arguments.stateName)) throw("There is no such state.");
			var interfaceObj = this.getInterface();
			var state = this.getState(arguments.stateName);
			interfaceObj.deleteState(state.id);
			this.reset();
		}
		public void function moveState(required string stateName1, required string stateName2) {
			if(NOT this.hasState(arguments.stateName1)) throw("There is no such state "&arguments.stateName1);
			if(NOT this.hasState(arguments.stateName2)) throw("There is no such state "&arguments.stateName2);
			var states = this.fetchStates("all");
			var priority = 1;
			for(var k=1;k LTE states.recordCount;k++) {
				if(states.name[k] EQ arguments.stateName1) continue;
				this.getState(states.name[k]).update({priority:priority});
				priority++;
				if(states.name[k] EQ arguments.stateName2) {
					this.getState(arguments.stateName1).update({priority:priority});
					priority++;
				}
			}
			this.reset();
		}
		public void function move(required string targetViewName, required string placeAfter){
			var targetObj = this.getViewByName(arguments.targetViewName);
//			if(NOT targetObj.hasAncestor(this.get("name"))) {
				var mySublings = targetObj.fetchViews("all");
				if(Len(arguments.placeAfter)) {
					var myPriority = CreateObject("component", "view").init(arguments.placeAfter, variables.settings).get("priority") + 1;
					var i = 1;
					var beginSublingOffset = false;
					for (i=1; i LTE mySublings.recordcount; i=i+1) {
						if(beginSublingOffset) {
							var f = StructNew();
							f.priority = mySublings.priority[i] + 2;
							var currentView = this.getViewByName(mySublings.name[i]);
							currentView.update(f);
						}
						if(mySublings.name[i] EQ arguments.placeAfter)
							beginSublingOffset = true;
					}
				}
				else {
					var myPriority = 0;
					for (i=1; i LTE mySublings.recordcount; i=i+1) {
						var f = StructNew();
						f.priority = i;
						var currentView = this.getViewByName(mySublings.name[i]);
						currentView.update(f);
					}
				}
				var f = StructNew();
				f.priority = myPriority;
				f.id_view = targetObj.get("id");
				this.update(f);
//			}
		}
		public void function reset(){
			var spirit = CreateObject("component", "boot").init(variables.settings);
		}
		public void function update(required struct data){
			if(
				StructKeyExists(arguments.data, "name")
			AND
				this.viewExists(arguments.data.name)
			AND
				this.get("name") NEQ arguments.data.name
			)
				throw('View "' & arguments.data.name & '" already exists.');
				
				
			var fields = QueryNew("field,fieldValue");
			var attributes = variables.data;
			for (local.key IN attributes) {
				if(StructKeyExists(arguments.data, key) AND key NEQ "id"){
					var field = key;
					var fieldValue = arguments.data[key];
					QueryAddRow(fields);
					QuerySetCell(fields, "field", field);
					QuerySetCell(fields, "fieldValue", fieldValue);
				}
			}
			var interfaceObj = this.getInterface();
			interfaceObj.updateView(fields, this.get("id"));
			this.reset();
		}
		
		// Service
		private struct function getViewByID(required numeric id){
			lock scope="application" type="exclusive" timeout="300" {
				var viewStack = application[variables.settings.appKey].viewStack;
			}
			for (local.key IN viewStack) {
				var view = viewStack[key];
				if(view.get("id") EQ arguments.id)
					return view;
			}
			throw("Your application doesn't have view with id " & arguments.id);
		}
		private view function getViewByName(required string name){
			lock scope="application" type="exclusive" timeout="300" {
				var result = application[variables.settings.appKey].viewStack[arguments.name];
			}
			return result;
		}
		private string function getSetting(required  string key){
			return variables.settings[arguments.key];
		}
		private query function getData(){
			var interfaceObj = this.getInterface();
			return interfaceObj.getViewByName(this.name);
		}
		private function getInterface(){
			var interface = "interface." & this.getSetting("interface");
			return CreateObject("component", interface).init(variables.settings);
		}
		private numeric function getNextPriority(){
			var result = this.fetchViews();
			result = ValueList(result.priority);
			result = ListToArray(result);
			result = ArrayMax(result) + 1;
			return  result;
		}
		private query function makeAncestors(visibility:"visible", offset:0){
			var arr = this.getAncestorArray();
			var result = QueryNew("id,id_view,name,label,visibility");
			for (local.i=1; i LTE (ArrayLen(arr)-arguments.offset); i=i+1) {
				var viewObj = this.getViewByName(arr[i]);
				if(
						viewObj.get("visibility") EQ arguments.visibility
					OR
						arguments.visibility EQ "all"){
					QueryAddRow(result);
					QuerySetCell(result, "id", viewObj.get("id"));
					QuerySetCell(result, "id_view", viewObj.get("id_view"));
					QuerySetCell(result, "name", viewObj.get("name"));
					QuerySetCell(result, "label", viewObj.get("label"));
					QuerySetCell(result, "visibility", viewObj.get("visibility"));
				}
			}
			return result;
		}
		private query function loadStates(visibility:"all"){
			var interfaceObj = this.getInterface();
			var states = interfaceObj.fetchStatesByViewID(this.get("id"), arguments.visibility);
			variables.states[arguments.visibility] = states;
			return states;
		}
		private boolean function viewExists(required string name){
			lock scope="application" type="exclusive" timeout="300" {
				var result = StructKeyExists(application[variables.settings.appKey].viewStack, arguments.name);
			}
			return result;
		}
	</cfscript>
</cfcomponent>