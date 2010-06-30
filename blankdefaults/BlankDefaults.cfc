<cfcomponent output="false" mixin="model">	
	<cffunction name="init">
		<cfset this.version = "1.0.2,1.0.3,1.0.4,1.0.5">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="$setDefaultValues" returntype="any" access="public" output="false">
		<cfscript>
			var loc = {};
			loc.iEnd = ListLen(variables.wheels.class.propertyList);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ListGetAt(variables.wheels.class.propertyList, loc.i);
				if ((!StructKeyExists(this, loc.iItem) || !Len(this[loc.iItem])))
				{
					//Don't bother if this property is a key
					if(!ListContains(variables.wheels.class.keys, loc.iItem))
					{
						if(StructKeyExists(variables.wheels.class.properties[loc.iItem], "defaultValue"))
						{
							if(Len(variables.wheels.class.properties[loc.iItem].defaultValue))
							{
								// set the default value from the db
								this[loc.iItem] = variables.wheels.class.properties[loc.iItem].defaultValue;
							}
							else
							{
								this[loc.iItem] = "";
							}
						}
						else
						{
							this[loc.iItem] = "";
						}
					}					
				}
			}
		</cfscript>
	</cffunction>

</cfcomponent>
