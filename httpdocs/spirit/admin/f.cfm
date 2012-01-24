<cfsetting showDebugOutput="no" /><cfsilent>
	<cfparam name="url.f" type="string" default="liquid.vacuum" /><!--- relative path to the file --->
	<cfset e = ListGetAt(url.f, 2, ".") />
	<cfswitch expression="#e#">
		<cfcase value="png">
			<cfset t = "image/png" />
		</cfcase>
		<cfcase value="gif">
			<cfset t = "image/gif" />
		</cfcase>
		<cfcase value="jpg">
			<cfset t = "image/jpeg" />
		</cfcase>
		<cfdefaultcase>
			<cfabort /><!--- don't let them read other files or they may steal something --->
		</cfdefaultcase>
	</cfswitch>
	<cfcontent type="#t#" file="#ExpandPath('.')#/#url.f#" />
</cfsilent>