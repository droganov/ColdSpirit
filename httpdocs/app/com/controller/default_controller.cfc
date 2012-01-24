<cfcomponent output="no">
	<cfprocessingdirective pageEncoding="utf-8" />
	<cffunction name="onBeforeEvent" output="no" returntype="any" access="public">
		<cfargument name="event" type="struct" />
		<cfscript>
			var result = StructNew();
			event.target.css("/rc/css/blueprint/screen.css", "screen, projection");
			event.target.css("/rc/css/blueprint/print.css", "print");
		//	event.target.css("/rc/css/appearance.css", "all");
		//	event.target.css("/rc/css/layout.css", "all");
			event.target.js("/rc/js/jquery.js");
			event.target.js("/rc/js/global.js");
			result.menu = event.target.getView("root").fetchViews();
			result.breadCrumbs = event.currentView.getAncestorOrSelf();

		</cfscript>
		<cfreturn result />
	</cffunction>
	<cffunction name="rootDefault" output="no" returntype="struct" access="public">
		<cfargument name="event" type="struct" />
		<cfscript>
			var result = {};
			return result;
		</cfscript>
	</cffunction>
	<cffunction name="onAfterEvent" output="no" returntype="any" access="public">
		<cfargument name="event" type="struct" />
		<cfreturn "onAfterEvent result" />
	</cffunction>
	<cffunction name="onDefaultEvent" output="no" returntype="any" access="public">
		<cfargument name="event" type="struct" />
		<cfreturn "onDefaultEventResult" />
	</cffunction>
</cfcomponent>