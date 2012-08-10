<cfcomponent output="no">
	<cfscript>
		// initialisation
		public void function init(struct settings:{}) {
			variables.spirit = CreateObject("component", "com.boot").init(arguments.settings);
		}
		private void function bootStrap(struct settings:{}) output=false {
			lock scope="Application" type="readOnly" timeout="30" {
				variables.spirit = Application[arguments.settings.appKey];
			}
			if(StructKeyExists(url, "reload") AND url.reload EQ variables.spirit.settings.reloadKey)
				this.init(arguments.settings);
			if(NOT StructKeyExists(url, "vars"))
				url.vars = "";
		}
		public void function dispatchEvent(string eventName:"") output=false{
			var e = variables.event = {};
			e.get 							= {};
			e.get.keys	 					= {};
			e.get.key 						= ListToArray(url.vars, "/");
			
			variables.event.target = variables.event.t = this;
			
			if(Len(arguments.eventName)) {
				var newLocation = "/" & arguments.eventName;
				if(ArrayLen(e.get.key) GT 2){
					var newEvent = ListToArray(arguments.eventName, "/");
					e.get.key[this.getSetting("viewUrlPosition")] = newEvent[1];
					e.get.key[this.getSetting("stateUrlPosition")] = newEvent[2];
					newLocation = "/" & ArrayToList(e.get.key, "/");
				}
				this.location(newLocation, 307);
			}
			
			
			// Declare css, js, rss
			e.css							= structNew("linked");
			e.js							= structNew("linked");
			e.rss							= structNew("linked");
			
			e.title			= "";
			
			// Setting up event name
			/*
				TODO Сделать задание view/state как параметра, чтобы можно было менять их распложение
			*/
			var viewName					= this.get(
												this.getSetting("viewUrlPosition"),
											 	this.getSetting("defaultViewName")
											 );
			try{
				var view = e.currentView	= this.getView(viewName);
			}
			catch (Any e){
				this.throwHttpCode(404);
			}
			// Protecting locked views
			if(view.locked()) this.throwHttpCode(404);
			
			// Managing alias (one pre request, no recusion)
			if(view.hasAlias()){
				var viewUrlPosition = this.getSetting("viewUrlPosition");
				var aliasName = view.get("alias");
				e.get.key[viewUrlPosition] = aliasName;
				
				ListLen(url.vars, "/")
					? ListSetAt(url.vars, viewUrlPosition, aliasName, "/")
					: url.vars = aliasName;
				try{
					view = e.currentView	= this.getView(aliasName);
				}
				catch (Any e){
					this.throwHttpCode(404);
				}
			}
			
			e.title = Len(view.get("title")) ? view.get("title") : view.get("label");
			
			var stateName					= this.get(this.getSetting("stateUrlPosition"), "");

			if(view.isDefaultView() AND NOT Len(stateName))
				stateName = view.getDefaultStateName();


			if(NOT Len(stateName))
				this.throwHttpCode(404);



			try {
				var state = e.currentState	= view.getState(stateName);
			}
			catch(Any e) {
				this.throwHttpCode(404);
			}
			
			if(Len(state.get("title")))
				e.title = state.get("title");
			
			// Protecting locked states
			if(state.locked()) this.throwHttpCode(404);
			
			e.viewState = viewName & "/" & stateName;
			e.name = viewName & stateName;
			
			// Dispatching an Event
			controller = CreateObject("component", this.getSetting("controller") & view.get("controller"));
			
			e.b = e.before = StructKeyExists(controller, "onBeforeEvent")
				? controller["onBeforeEvent"](e)
				: {};
				
			e.v = e.view = StructKeyExists(controller, viewName)
				? controller[viewName](e)
				: {};
			
			if(StructKeyExists(controller, e.name)){
				e.s = e.state = controller[e.name](e);
			}
			else{
				e.s = e.state = StructKeyExists(controller, "onDefaultEvent")
					? controller["onDefaultEvent"](e)
					: {};
			}
			
			e.a = e.after = StructKeyExists(controller, "onAfterEvent")
				? controller["onAfterEvent"](e)
				: {};
			
			// fixing unvanted variables in url
			if(ArrayLen(e.get.key) GT StructCount(e.get.keys))
				this.throwHttpCode(404);
		}
		
		// Actions
		public void function abort(){
			abort;
		}
		public void function ajaxOnly(){
			if(NOT this.isAjaxRequest())
				this.abort();
		}
		
		public void function noCache(){
			header name="expires" value=now();
			header name="pragma" value="no-cache";
			header name="cache-control" value="no-cache, no-store, must-revalidate";
		}
		public string function location(string target:"", numeric statuscode:301){
			if(Len(arguments.target)) {
				this.noCache();
				location url=arguments.target statusCode=arguments.statusCode addtoken=false;
			}
			var theURL = "";
			theURL = theURL & cgi.path_info & url.vars;
			return Replace(theURL, "//", "/");
		}
		
		// Decision
		public boolean function isAjaxRequest(){
			return
				StructKeyExists(GetHttpRequestData().headers,"x-requested-with")
			AND
				GetHttpRequestData().headers["x-requested-with"] EQ "XMLHttpRequest";
		}
		function typeOf (any obj) {
			return createObject('java','railo.runtime.op.Caster').toTypeName(arguments.obj);
		}

		// Getters
		public string function get(required string key, string default:"f"){
			variables.event.get.keys[arguments.key] = "";
			try {
				var myResult = variables.event.get.key[arguments.key];
				if(IsNumeric(arguments.default)) myResult = Val(myResult);
			}
			catch(Any e) {
				var myResult = arguments.default;
			}
			return myResult;
		}
		public any function getBean(required string beanName, string dsn:this.getSetting("dsn")){
			var bean = CreateObject("component", this.getSetting("bean") & arguments.beanName);
			var data = {};
			data.dsn = arguments.dsn;
			data.e = data.event = variables.event;
			bean["extend"] = this["extend"];
			return bean.extend(data);
		}
		public string function getBlock(required string blockName, dataProvider, numeric chachedWithin:0, string blockPrefix:"block"){
			arguments.blockName = this.getSetting("block") & arguments.blockName & ".cfm";
			if(arguments.chachedWithin) {
				var cacheKey = arguments.blockPrefix & "_" & arguments.blockName;

				try {
					cacheGet(cacheKey, true);
				}
				catch (e) {
					if (this.typeOf(arguments.dataProvider) EQ "railo.runtime.type.UDFImpl")
						var data = arguments.dataProvider();
					else
						var data = arguments.dataProvider;
					arguments.blockName = this.include(arguments.blockName);
					CachePut(cacheKey, arguments.blockName, arguments.chachedWithin);
					return arguments.blockName;
				}
			}
			return this.include(arguments.blockName);
		}
		public any function getCached(string key, callback, numeric timeSpan:0, string cacheName){
			try {
				return cacheGet(arguments.key, true, arguments.cacheName);
				throw(123);
			}
			catch(Any e) {
				var result = arguments.callback(variables.event);
				if(timeSpan NEQ 0)
					cachePut(arguments.key, result, arguments.timeSpan, arguments.timeSpan, arguments.cacheName);
			}
			return result;
		}
		public string function getIP(){
			if(Len(CGI.HTTP_X_Forwarded_For))
				var result = CGI.HTTP_X_Forwarded_For;
			else
				var result = CGI.Remote_Addr;
			return trim(ListFirst(result));
		}

		public any function getService(required string serviceName, struct data:{}){
			try {
				return variables.spirit.services[arguments.serviceName];
			}
			catch(Any e) {
				arguments.data.dsn = this.getSetting("dsn");
				var service = CreateObject("component", this.getSetting("service") & arguments.serviceName);
				service["extend"] = this["extend"];
				service = service.extend(arguments.data);
				StructDelete(service, "extend");
				lock scope="application" type="exclusive" timeout="300" {
					application[this.getSetting("appKey")].services[arguments.serviceName] = service;
				}
				return service;
			}
		}
		public string function getSetting(required string key){
			return variables.spirit.settings[arguments.key];
		}
		public string function post(required string key, string default:""){
			try {
				var result = form[arguments.key];
				if(IsNumeric(arguments.default))
					result = Val(result);
			}
			catch(Any e) {
				form[arguments.key] = arguments.default;
				return arguments.default;
			}
			return result;
		}
		public view function getView(string viewName:variables.event.currentView.get("name")){
			return variables.SPIRIT.viewStack[arguments.viewName];
		}
		public string function getViewState(e){ return variables.event.viewState; }
		public string function include(string template){
			var e = var event = variables.event;
			savecontent variable="local.result" {
				include arguments.template;
			}
			return result;
		}
		
		// Setters
		public string function css(string file, string media:"all"){
			if(StructKeyExists(arguments, "file")){
				StructInsert(variables.event.css, arguments.file, arguments.media, true);
				return;
			}
			
			if(this.getSetting("suppressStyles")) {
				var cssKey = Hash(StructKeyList(variables.event.css));
				var appKey = this.getSetting("appKey");
				lock scope="application" type="readOnly" timeout="300" {
					var app = application[appKey];
				}
				
				if(NOT StructKeyExists(app.styles, cssKey))
					this.suppressStyles();
				
				lock scope="application" type="readOnly" timeout="300" {
					return app.styles[cssKey];
				}
			}
			var result = "";
			for (local.file IN variables.event.css) {
				result = result & '<link type="text/css" href="' & file & '" rel="stylesheet" media="' & variables.event.css[file] & '" />';
			}
			return result;
		}
		public any function extend(required struct data){
			for (local.key IN arguments.data) {
				variables[key] = this[key] = arguments.data[key];
			}
			return this;
		}
		public string function js(string file){
			if(StructKeyExists(arguments, "file")) {
				StructInsert(variables.event.js, arguments.file, "", true);
				return;
			}
			
			if(this.getSetting("suppressScripts")) {
				var jsKey = Hash(StructKeyList(variables.event.js));
				var appKey = this.getSetting("appKey");
				lock scope="application" type="readOnly" timeout="300" {
					var app = application[appKey];
				}
				
				if(NOT StructKeyExists(app.scripts, jsKey))
					this.suppressScripts();
				
				lock scope="application" type="readOnly" timeout="300" {
					return app.scripts[jsKey];
				}
			}
			
			var result = "";
			for (local.file IN variables.event.js) {
				result = result & '<script type="text/javascript" src="' & file & '"></script>';
			}
			return result;
		}
		public string function rss(string file, string title){
			if(StructKeyExists(arguments, "file")) {
				StructInsert(variables.event.rss, arguments.file, arguments.title, true);
				return;
			}
			var result = "";
			for (local.file IN variables.event.rss) {
				result = result & '<link rel="alternate" type="application/rss+xml" title="' & XMLFormat(variables.event.rss[file])  & '" href="' & file & '" />';
			}
			return result;
		}

		public void function throwHttpCode(numeric statusCode:404){
			header statusCode = arguments.statusCode;
			this.abort();
		}

		public string function title(string title){
			if(Len(arguments.title))
				variables.event.title = arguments.title;
			else
				return variables.event.title;
		}

		

		// Renderers
		public string function render(string mode:""){
			switch(arguments.mode) {
				case "layout":{
					var template = this.getSetting("layout") & event.currentView.get("layout");
					break;
				}
				case "view":{
					var template = this.getSetting("view") & event.currentView.get("view");
					break;
				}
				case "state":{
					var template = this.getSetting("state") & event.currentState.get("state");
					break;
				}
				default: {
					var template = cgi.script_name;
					break;
				}
			}
			return this.include(template);
		}
		public void function rest(message, string contentType){
			var c = getPageContext();
			if(isSimpleValue(arguments.message)){
				param name="arguments.contentType" type="string" default="text/html";
			}
			else{
				param name="arguments.contentType" type="string" default="application/json";
				arguments.message = serializeJson(arguments.message);
			}
			c.getOut().clearBuffer();
			c.getResponse().setcontenttype(arguments.contentType);
			WriteOutput(arguments.message);
			this.abort();
		}
	</cfscript>
</cfcomponent>