<cfcomponent output="no">
	<cfprocessingdirective pageEncoding="utf-8" />
	<cfscript>
		public struct function onBeforeEvent(struct e){
			var result = {};
			e.t.css("/rc/css/blueprint/screen.css", "screen, projection");
			e.t.css("/rc/css/blueprint/print.css", "print");
			e.t.css("/rc/css/layout.css", "all");
			e.t.js("/rc/js/jquery.js");
			e.t.js("/rc/js/js.js");
			
			result.menu = e.t.getView("root").fetchViews();
			
			return result;
		}
		
		public struct function rootDefault(struct e){
			var result = {};
			return result;
		}
		
		public struct function connectForm(struct e){
			var result = {};
			e.t.css("/rc/js/spry/css/SpryValidationTextField.css");
			e.t.js("/rc/js/spry/SpryValidationTextField.js");
			
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