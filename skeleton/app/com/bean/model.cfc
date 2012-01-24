<cfcomponent displayname="test" output="no">
	<cfscript>
		public string function init(){
			throw("init");
		}
		public void function ku(){
			//throw(dsn);
		}
	</cfscript>
</cfcomponent>