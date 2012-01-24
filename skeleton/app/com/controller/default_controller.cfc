<cfcomponent output="no">
	<cfprocessingdirective pageEncoding="utf-8" />
	<cfscript>
		public struct function onBeforeEvent(struct e){
			var result = {};
			e.t.css("/rc/css/style.css");
			e.t.js("/rc/js/jquery.js");
			e.t.js("/rc/js/js.js");
			
			return result;
		}
		
		public struct function rootDefault(struct e){
			var result = {};
			return result;
		}
		
		public struct function onAfterEvent(struct e){
			var result = {};
			return result;
		}
		
		public struct function onDefaultEvent(struct e){
			var result = {};
			return result;
		}
	</cfscript>
</cfcomponent>