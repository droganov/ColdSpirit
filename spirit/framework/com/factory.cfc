<cfcomponent displayname="factory" output="no" extends="ioc">
	<cfscript>
		private any function resolveBean( string beanName ) {
			var partialBean = resolveBeanCreate( beanName );
			return partialBean.bean;
		}
		
		private struct function resolveBeanCreate( string beanName) {
			var bean = 0;
			var accumulator = {};
			if ( structKeyExists( variables.beanInfo, beanName ) ) {
				var info = variables.beanInfo[ beanName ];
				if ( structKeyExists( info, 'cfc' ) ) {
					// use createObject so we have control over initialization:
					bean = createObject( 'component', info.cfc );
					accumulator.bean = bean;
				} else if ( structKeyExists( info, 'value' ) ) {
					accumulator.bean = info.value;
				} else {
					throw 'internal error: invalid metadata for #beanName#';
				}
			} else if ( structKeyExists( variables, 'parent' ) && variables.parent.containsBean( beanName ) ) {
				bean = variables.parent.getBean( beanName );
				accumulator.bean = bean;
			} else {
				missingBean( beanName );
			}
			return accumulator;
		}
	</cfscript>
</cfcomponent>