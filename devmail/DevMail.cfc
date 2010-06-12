<cfcomponent output="false" mixin="controller">
	<cffunction name="init">
		<cfset this.version = "1.0.2,1.0.3,1.0.4">
		<cfreturn this>
	</cffunction>

	<cffunction name="$mail" returntype="void" access="public" output="false">

		<cfset var loc = {}>
		<cfset loc.content = arguments.body>
		<cfset StructDelete(arguments, "body")>

		<cfset loc.appendBody = "">
		<cfif StructKeyExists(application.wheels, "emailOverride")>
			<cfif StructKeyExists(arguments, "to")>
				<cfset loc.appendBody = ListAppend(loc.appendBody, "To: " & arguments.to, "|")>
			</cfif>
			<cfif StructKeyExists(arguments, "cc")>
				<cfset loc.appendBody = ListAppend(loc.appendBody, "Cc: " & arguments.cc, "|")>
			</cfif>
			<cfif StructKeyExists(arguments, "Bcc")>
				<cfset loc.appendBody = ListAppend(loc.appendBody, "Bcc: " & arguments.bcc, "|")>
			</cfif>

			<cfset arguments.to = application.wheels.emailOverride>

			<cfif ArrayLen(loc.content) GT 1>
				<cfset loc.content[1] = loc.content[1] & "#Chr(10)##Chr(13)##Chr(10)##Chr(13)#==========#Chr(10)##Chr(13)##loc.appendBody#">
				<cfset loc.content[2] = loc.content[2] & "<br><br><hr>#loc.appendBody#">
			<cfelse>
				<cfif UCase(arguments.type) EQ "HTML">
					<cfset loc.content[1] = loc.content[1] & "<br><br><hr>#loc.appendBody#">
				<cfelse>
					<cfset loc.content[1] = loc.content[1] & "#Chr(10)##Chr(13)##Chr(10)##Chr(13)#==========#Chr(10)##Chr(13)##loc.appendBody#">
				</cfif>
			</cfif>

		</cfif>


		<cfmail attributeCollection="#arguments#"><cfif ArrayLen(loc.content) GT 1><cfmailpart type="text">#Trim(loc.content[1])#</cfmailpart><cfmailpart type="html">#Trim(loc.content[2])#</cfmailpart><cfelse>#Trim(loc.content[1])#</cfif></cfmail>
	</cffunction>


</cfcomponent>