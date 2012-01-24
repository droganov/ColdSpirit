<cfcomponent>
	<cffunction name="init">
		<cfargument name="conf" type="string" />
		<cfsavecontent variable="arguments.file"><cfinclude template="../conf/modules.cfm" /></cfsavecontent>
		<cfscript>
			x = XMLSearch(arguments.file, "//module");
			d = ArrayNew(1);
		</cfscript>
		<cfparam name="url.module" default="#x[1].XmlAttributes.name#">
		<cfloop from="1" to="#ArrayLen(x)#" index="i">
			<cfset ArrayAppend(d, x[i].XmlAttributes) />
			<cfset this.controller = x[i].XmlAttributes.controller />
			<cfif x[i].XmlAttributes.name EQ url.module>
				<cfset this.controller = x[i].XmlAttributes.controller />
			</cfif>
		</cfloop>
		<cfset this.data = d />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getData">
		<cfreturn this.data />
	</cffunction>
</cfcomponent>