<cfcomponent output="false" mixin="controller">	
	<cffunction name="init">
		<cfset this.version = "1.1">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="$mail" returntype="void" access="public" output="false">
		<cfset var loc = {}>
		

		<cfif StructKeyExists(arguments, "mailparts")>
			<cfset loc.mailparts = arguments.mailparts>
			<cfset StructDelete(arguments, "mailparts")>
		</cfif>
		<cfif StructKeyExists(arguments, "mailparams")>
			<cfset loc.mailparams = arguments.mailparams>
			<cfset StructDelete(arguments, "mailparams")>
		</cfif>
		<cfif StructKeyExists(arguments, "tagContent")>
			<cfset loc.tagContent = arguments.tagContent>
			<cfset StructDelete(arguments, "tagContent")>
		</cfif>
		
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
			
			<cfif StructKeyExists(loc, "mailparts")>
				<cfloop array="#loc.mailparts#" index="loc.i">
					<cfif loc.i.type EQ "HTML">
						<cfset loc.i.tagcontent = loc.i.tagcontent & "<br><br><hr>" & loc.appendBody>
					<cfelse>
						<cfset loc.i.tagcontent = loc.i.tagcontent & Chr(10) & Chr(13) & Chr(10) & Chr(13) &"==========" & Chr(10) & Chr(13) & loc.appendBody>
					</cfif>
				</cfloop>
			<cfelse>
				<cfif arguments.type EQ "HTML">
					<cfset loc.tagcontent = loc.tagcontent & "<br><br><hr>" & loc.appendBody>
				<cfelse>
					<cfset loc.tagcontent = loc.tagcontent & Chr(10) & Chr(13) & Chr(10) & Chr(13) &"==========" & Chr(10) & Chr(13) & loc.appendBody>
				</cfif>	
			</cfif>
			
		</cfif>
		
		
		
		<cfmail attributeCollection="#arguments#">
			<cfif StructKeyExists(loc, "mailparams")>
				<cfloop array="#loc.mailparams#" index="loc.i">
					<cfmailparam attributeCollection="#loc.i#">
				</cfloop>
			</cfif>
			<cfif StructKeyExists(loc, "mailparts")>
				<cfloop array="#loc.mailparts#" index="loc.i">
					<cfset loc.innerTagContent = loc.i.tagContent>
					<cfset StructDelete(loc.i, "tagContent")>
					<cfmailpart attributeCollection="#loc.i#">
						#loc.innerTagContent#
					</cfmailpart>
				</cfloop>
			</cfif>
			<cfif StructKeyExists(loc, "tagContent")>
				#loc.tagContent#
			</cfif>
		</cfmail>
	</cffunction>
	
</cfcomponent>
