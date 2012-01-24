<cfcomponent displayname="boot" output="no">
	<cfscript>
		public struct function init(struct settings){
			var spirit = {};
			spirit.settings = this.initSettings(arguments.settings);
			spirit.viewStack = this.initViews(spirit.settings);
			spirit.styles = {};
			spirit.scripts = {};
			
			lock scope="Application" type="exclusive" timeout="300" {
				application[spirit.settings.appKey] = spirit;
			}
			return spirit;
		}
		private struct function initSettings(struct settings){
			if(NOT StructKeyExists(arguments.settings, "dsn"))
				arguments.settings.dsn = "global";
				
			if(NOT StructKeyExists(arguments.settings, "root"))
				arguments.settings.root = "/";
				
			if(NOT StructKeyExists(arguments.settings, "app"))
				arguments.settings.app = Replace(arguments.settings.root & "/app", "//", "/", "All");
				
			if(NOT StructKeyExists(arguments.settings, "spirit"))
				arguments.settings.spirit = "/spirit";
				
			if(NOT StructKeyExists(arguments.settings, "appKey"))
				arguments.settings.appKey = "spirit";
				
			if(NOT StructKeyExists(arguments.settings, "include"))
				arguments.settings.include = arguments.settings.app & "/include";
				
			if(NOT StructKeyExists(arguments.settings, "layout"))
				arguments.settings.layout = arguments.settings.include & "/layout/";
				
			if(NOT StructKeyExists(arguments.settings, "view"))
				arguments.settings.view = arguments.settings.include & "/view/";
				
			if(NOT StructKeyExists(arguments.settings, "state"))
				arguments.settings.state = arguments.settings.include & "/state/";
			
			if(NOT StructKeyExists(arguments.settings, "block"))
				arguments.settings.block = arguments.settings.include & "/block/";
				
			if(NOT StructKeyExists(arguments.settings, "resources"))
				arguments.settings.resources = Replace(arguments.settings.root & "/rc", "//", "/", "All");
			
			if(NOT StructKeyExists(arguments.settings, "defaultViewName"))
				arguments.settings.defaultViewName = "root";
				
			if(NOT StructKeyExists(arguments.settings, "interface"))
				arguments.settings.interface = "xml";
				
			if(NOT StructKeyExists(arguments.settings, "classPath"))
				arguments.settings.classPath = arguments.settings.app & ".com";
				
			if(NOT StructKeyExists(arguments.settings, "bean"))
				arguments.settings.bean = arguments.settings.classPath & ".bean.";
				
			if(NOT StructKeyExists(arguments.settings, "controller"))
				arguments.settings.controller = arguments.settings.classPath & ".controller.";
				
			if(NOT StructKeyExists(arguments.settings, "service"))
				arguments.settings.service = arguments.settings.classPath & ".service.";
				
			if(NOT StructKeyExists(arguments.settings, "viewUrlPosition"))
				arguments.settings.viewUrlPosition = 1;
				
			if(NOT StructKeyExists(arguments.settings, "stateUrlPosition"))
				arguments.settings.stateUrlPosition = 2;
				
			if(NOT StructKeyExists(arguments.settings, "reloadKey"))
				arguments.settings.reloadKey = "";
				
			// templates
			if(NOT StructKeyExists(arguments.settings, "defaultLayoutTemplate"))
				arguments.settings.defaultLayoutTemplate = "default_layout.cfm";
			if(NOT StructKeyExists(arguments.settings, "defaultViewTemplate"))
				arguments.settings.defaultViewTemplate = "default_view.cfm";
			if(NOT StructKeyExists(arguments.settings, "defaultStateTemplate"))
				arguments.settings.defaultStateTemplate = "default_state.cfm";
			if(NOT StructKeyExists(arguments.settings, "defaultControllerName"))
				arguments.settings.defaultControllerName = "default_controller";
			
			
			// resources
			if(NOT StructKeyExists(arguments.settings, "suppressScripts"))
				//arguments.settings.suppressScripts = true;
				arguments.settings.suppressScripts = NOT IsLocalHost(cgi.remote_addr);
			
			if(NOT StructKeyExists(arguments.settings, "suppressStyles"))
				//arguments.settings.suppressStyles = true;
				arguments.settings.suppressStyles = NOT IsLocalHost(cgi.remote_addr);
			
			if(NOT DirectoryExists(ExpandPath(arguments.settings.resources) & "/cache"))
				DirectoryCreate(ExpandPath(arguments.settings.resources) & "/cache");

			return arguments.settings;
		}
		private struct function initViews(struct settings){
			var interFacePath = "interface." & arguments.settings.interface;
			var interface = CreateObject("component", interFacePath)
				.init(arguments.settings);
			var views = interface.fetchAllViews();
			var viewStack = {};
			viewStack = {};
			for (local.i=1; i LTE views.recordcount; i=i+1) {
				var viewName = views.name[i];
				var viewObj = createObject("component", "view").init(viewName, arguments.settings);
				StructInsert(viewStack, viewName, viewObj);
			}
			return viewStack;
		}
	</cfscript>
</cfcomponent>