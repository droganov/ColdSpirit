<cfcomponent>
	<cfscript>
		public state function init(id, view, settings){
			this.id						= arguments.id;
			variables.settings			= arguments.settings;
			variables.view 				= arguments.view;
			variables.data				= this.getData();
			variables.locked			= this.get("visibility") EQ "locked";
			variables.visible			= this.get("visibility") EQ "visible";
			
			
			return this;
		}
		// Desision
		public boolean function locked(){
			return variables.locked;
		}
		public boolean function visible(){
			return variables.visible;
		}
		
		
		// Getters
		public string function get(key){
			return variables.data[key];
		}
		public Query function getAttributes(){
			return variables.data;
		}
		
		// Setters
		public numeric function insert(data){
			if(NOT StructKeyExists(arguments.data, "name"))
				arguments.data.name = "default";
			if(NOT StructKeyExists(arguments.data, "label"))
				arguments.data.label = "New State";
			if(NOT StructKeyExists(arguments.data, "id_view"))
				arguments.data.id_view = variables.view.get("id");
			if(NOT StructKeyExists(arguments.data, "priority"))
				arguments.data.priority = this.getNextPriority();
			if(NOT StructKeyExists(arguments.data, "state"))
				arguments.data.state = this.getSetting("defaultStateTemplate");
			
			var validatedData = validate(arguments.data);
			var interfaceObj = this.getInterface();
			var idState = interfaceObj.insertState(arguments.data.id_view);
			interfaceObj.updateState(validatedData, idState);
			variables.view.reset();
			return idState;
		}
		public void function update(data){
			if(NOT StructKeyExists(arguments.data, "name"))
				arguments.data.name = this.get("name");
			var validatedData = this.validate(arguments.data);
			var interfaceObj = this.getInterface();
			interfaceObj.updateState(validatedData, this.get("id"));
			variables.view.reset();
		}
		
		// Service
		private query function getData(){
			var interfaceObj = this.getInterface();
			return interfaceObj.getStateByID(this.id);
		}
		private function getInterface(){
			var interface = "interface." & this.getSetting("interface");
			return CreateObject("component", interface).init(variables.settings);
		}
		private numeric function getNextPriority(){
			var sublingStates = variables.view.fetchStates("all");
			return ArrayMax(ListToArray(ValueList(sublingStates.priority))) + 1;
		}
		private string function getSetting(key){
			return variables.settings[arguments.key];
		}
		private query function validate(data){
			if(NOT StructKeyExists(arguments.data, "id_view"))
				arguments.data.id_view = variables.view.get("id");
			if(NOT StructKeyExists(arguments.data, "title"))
				arguments.data.title = "";
			if(NOT StructKeyExists(arguments.data, "visibility"))
				arguments.data.visibility = "visible";
			if(NOT StructKeyExists(arguments.data, "has_text"))
				arguments.data.has_text = 0;
			if(variables.view.hasState(arguments.data.name) AND arguments.data.name NEQ this.get("name"))
				throw('State ' & '"' & arguments.data.name & '"' & ' already exists!');
			var fields = QueryNew("field,fieldValue");
			var validFields = "id_view,priority,has_text,visibility,name,label,title,state,exit_state";

			for (local.key IN arguments.data) {
				if(ListFindNoCase(validFields, key) AND key NEQ "id") {
					var field = key;
					var fieldValue = arguments.data[key];
					QueryAddRow(fields);
					QuerySetCell(fields, "field", field);
					QuerySetCell(fields, "fieldValue", fieldValue);
				}
			}
			return fields;
		}
	</cfscript>
</cfcomponent>