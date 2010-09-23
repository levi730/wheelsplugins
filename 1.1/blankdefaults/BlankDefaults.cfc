<cfcomponent output="false" mixin="model">
	<cffunction name="init">
		<cfset this.version = "1.1">
		<cfreturn this>
	</cffunction>
	

	<cffunction name="$initModelClass" returntype="any" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfargument name="path" type="string" required="true">
		<cfscript>
			var loc = {};
			variables.wheels = {};
			variables.wheels.errors = [];
			variables.wheels.class = {};
			variables.wheels.class.modelName = arguments.name;
			variables.wheels.class.path = arguments.path;
			
			// if our name has pathing in it, remove it and add it to the end of of the $class.path variable
			if (Find("/", arguments.name))
			{
				variables.wheels.class.modelName = ListLast(arguments.name, "/");
				variables.wheels.class.path = ListAppend(arguments.path, ListDeleteAt(arguments.name, ListLen(arguments.name, "/"), "/"), "/");
			}
			
			variables.wheels.class.RESQLAs = "[[:space:]]AS[[:space:]][A-Za-z1-9]+";
			variables.wheels.class.RESQLOperators = "((?: (?:NOT )?LIKE)|(?: (?:NOT )?IN)|(?: IS(?: NOT)?)|(?:<>)|(?:<=)|(?:>=)|(?:!=)|(?:!<)|(?:!>)|=|<|>)";
			variables.wheels.class.RESQLWhere = "(#variables.wheels.class.RESQLOperators# ?)(\('.+?'\)|\((-?[0-9\.],?)+\)|'.+?'()|''|(-?[0-9\.]+)()|NULL)(($|\)| (AND|OR)))";
			variables.wheels.class.mapping = {};
			variables.wheels.class.properties = {};
			variables.wheels.class.accessibleProperties = {};
			variables.wheels.class.calculatedProperties = {};
			variables.wheels.class.associations = {};
			variables.wheels.class.callbacks = {};
			variables.wheels.class.keys = "";
			variables.wheels.class.connection = {datasource=application.wheels.dataSourceName, username=application.wheels.dataSourceUserName, password=application.wheels.dataSourcePassword};
			variables.wheels.class.automaticValidations = application.wheels.automaticValidations;
	
			setTableNamePrefix(get("tableNamePrefix"));
			table(LCase(pluralize(variables.wheels.class.modelName)));
	
			loc.callbacks = "afterNew,afterFind,afterInitialization,beforeDelete,afterDelete,beforeSave,afterSave,beforeCreate,afterCreate,beforeUpdate,afterUpdate,beforeValidation,afterValidation,beforeValidationOnCreate,afterValidationOnCreate,beforeValidationOnUpdate,afterValidationOnUpdate";
			loc.iEnd = ListLen(loc.callbacks);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				variables.wheels.class.callbacks[ListGetAt(loc.callbacks, loc.i)] = ArrayNew(1);
			loc.validations = "onSave,onCreate,onUpdate";
			loc.iEnd = ListLen(loc.validations);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				variables.wheels.class.validations[ListGetAt(loc.validations, loc.i)] = ArrayNew(1);
	
			// run developer's init method if it exists
			if (StructKeyExists(variables, "init"))
				init();
	
			// load the database adapter
			variables.wheels.class.adapter = $createObjectFromRoot(path="#application.wheels.wheelsComponentPath#", fileName="Connection", method="init", datasource="#variables.wheels.class.connection.datasource#", username="#variables.wheels.class.connection.username#", password="#variables.wheels.class.connection.password#");
	
			// get columns for the table
			loc.columns = variables.wheels.class.adapter.$getColumns(tableName());
	
			variables.wheels.class.propertyList = "";
			variables.wheels.class.columnList = "";
			loc.processedColumns = "";
			loc.iEnd = loc.columns.recordCount;
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				// set up properties and column mapping
				if (!ListFind(loc.processedColumns, loc.columns["column_name"][loc.i]))
				{
					loc.property = loc.columns["column_name"][loc.i]; // default the column to map to a property with the same name
					for (loc.key in variables.wheels.class.mapping)
					{
						if (StructKeyExists(variables.wheels.class.mapping[loc.key], "type") and variables.wheels.class.mapping[loc.key].type == "column" && variables.wheels.class.mapping[loc.key].value == loc.property)
						{
							// developer has chosen to map this column to a property with a different name so set that here
							loc.property = loc.key;
							break;
						}
					}
					loc.type = SpanExcluding(loc.columns["type_name"][loc.i], "( ");
	
					// set the info we need for each property
					variables.wheels.class.properties[loc.property] = {};
					variables.wheels.class.properties[loc.property].dataType = loc.type;
					variables.wheels.class.properties[loc.property].type = variables.wheels.class.adapter.$getType(loc.type);
					variables.wheels.class.properties[loc.property].column = loc.columns["column_name"][loc.i];
					variables.wheels.class.properties[loc.property].scale = loc.columns["decimal_digits"][loc.i];
	
					// get a boolean value for whether this column can be set to null or not
					// if we don't get a boolean back we try to translate y/n to proper boolean values in cfml (yes/no)
					variables.wheels.class.properties[loc.property].nullable = Trim(loc.columns["is_nullable"][loc.i]);
					if (!IsBoolean(variables.wheels.class.properties[loc.property].nullable))
						variables.wheels.class.properties[loc.property].nullable = ReplaceList(variables.wheels.class.properties[loc.property].nullable, "N,Y", "No,Yes");			
	
					variables.wheels.class.properties[loc.property].size = loc.columns["column_size"][loc.i];
					variables.wheels.class.properties[loc.property].label = Humanize(loc.property);
					variables.wheels.class.properties[loc.property].validationtype = variables.wheels.class.adapter.$getValidationType(variables.wheels.class.properties[loc.property].type);
	
					if (StructKeyExists(variables.wheels.class.mapping, loc.property)) {
						if (StructKeyExists(variables.wheels.class.mapping[loc.property], "label"))
							variables.wheels.class.properties[loc.property].label = variables.wheels.class.mapping[loc.property].label;
						if (StructKeyExists(variables.wheels.class.mapping[loc.property], "defaultValue"))
							variables.wheels.class.properties[loc.property].defaultValue = variables.wheels.class.mapping[loc.property].defaultValue;
					}
	
					if (loc.columns["is_primarykey"][loc.i])
					{
						setPrimaryKey(loc.property);
					}
					else if (variables.wheels.class.automaticValidations and not ListFindNoCase("#application.wheels.timeStampOnCreateProperty#,#application.wheels.timeStampOnUpdateProperty#,#application.wheels.softDeleteProperty#", loc.property))
					{
						// set nullable validations if the developer has not
						loc.defaultValidationsAllowBlank = variables.wheels.class.properties[loc.property].nullable;
						if (!variables.wheels.class.properties[loc.property].nullable and !Len(loc.columns["column_default_value"][loc.i]) and !$validationExists(property=loc.property, validation="validatesPresenceOf"))
						{
							validatesPresenceOf(properties=loc.property);
						}
						// always allowblank if a database default or validatesPresenceOf() has been set
						if (Len(loc.columns["column_default_value"][loc.i]) or $validationExists(property=loc.property, validation="validatesPresenceOf"))
							loc.defaultValidationsAllowBlank = true;
						// set length validations if the developer has not
						if (variables.wheels.class.properties[loc.property].validationtype eq "string" and !$validationExists(property=loc.property, validation="validatesLengthOf"))
							validatesLengthOf(properties=loc.property, allowBlank=loc.defaultValidationsAllowBlank, maximum=variables.wheels.class.properties[loc.property].size);
						// set numericality validations if the developer has not
						if (ListFindNoCase("integer,float", variables.wheels.class.properties[loc.property].validationtype) and !$validationExists(property=loc.property, validation="validatesNumericalityOf"))
							validatesNumericalityOf(properties=loc.property, allowBlank=loc.defaultValidationsAllowBlank, onlyInteger=(variables.wheels.class.properties[loc.property].validationtype eq "integer"));
						// set date validations if the developer has not (checks both dates or times as per the IsDate() function)
						if (variables.wheels.class.properties[loc.property].validationtype eq "datetime" and !$validationExists(property=loc.property, validation="validatesFormatOf"))
							validatesFormatOf(properties=loc.property, allowBlank=loc.defaultValidationsAllowBlank, type="date");
					}
	
					variables.wheels.class.propertyList = ListAppend(variables.wheels.class.propertyList, loc.property);
					variables.wheels.class.columnList = ListAppend(variables.wheels.class.columnList, variables.wheels.class.properties[loc.property].column);
					loc.processedColumns = ListAppend(loc.processedColumns, loc.columns["column_name"][loc.i]);
				}
			}
	
			// raise error when no primary key has been defined for the table
			if (!Len(primaryKeys()))
			{
				$throw(type="Wheels.NoPrimaryKey", message="No primary key exists on the `#tableName()#` table.", extendedInfo="Set an appropriate primary key on the `#tableName()#` table.");
			}
	
			// add calculated properties
			variables.wheels.class.calculatedPropertyList = "";
			for (loc.key in variables.wheels.class.mapping)
			{
				if (StructKeyExists(variables.wheels.class.mapping[loc.key], "type") and variables.wheels.class.mapping[loc.key].type != "column")
				{
					variables.wheels.class.calculatedPropertyList = ListAppend(variables.wheels.class.calculatedPropertyList, loc.key);
					variables.wheels.class.calculatedProperties[loc.key] = {};
					variables.wheels.class.calculatedProperties[loc.key][variables.wheels.class.mapping[loc.key].type] = variables.wheels.class.mapping[loc.key].value;
				}
			}
	
			// set up soft deletion and time stamping if the necessary columns in the table exist
			if (Len(application.wheels.softDeleteProperty) && StructKeyExists(variables.wheels.class.properties, application.wheels.softDeleteProperty))
			{
				variables.wheels.class.softDeletion = true;
				variables.wheels.class.softDeleteColumn = variables.wheels.class.properties[application.wheels.softDeleteProperty].column;
			}
			else
			{
				variables.wheels.class.softDeletion = false;
			}
	
			if (Len(application.wheels.timeStampOnCreateProperty) && StructKeyExists(variables.wheels.class.properties, application.wheels.timeStampOnCreateProperty))
			{
				variables.wheels.class.timeStampingOnCreate = true;
				variables.wheels.class.timeStampOnCreateProperty = application.wheels.timeStampOnCreateProperty;
			}
			else
			{
				variables.wheels.class.timeStampingOnCreate = false;
			}
	
			if (Len(application.wheels.timeStampOnUpdateProperty) && StructKeyExists(variables.wheels.class.properties, application.wheels.timeStampOnUpdateProperty))
			{
				variables.wheels.class.timeStampingOnUpdate = true;
				variables.wheels.class.timeStampOnUpdateProperty = application.wheels.timeStampOnUpdateProperty;
			}
			else
			{
				variables.wheels.class.timeStampingOnUpdate = false;
			}
			
		</cfscript>
		
		<cfdbinfo name="loc.dbinfo" datasource="#get('dataSourceName')#" table="#variables.wheels.class.tablename#" type="columns">
		<cfscript>
			loc.dbdefaults = {};
			
			for(loc.intRow = 1; loc.intRow LTE loc.dbinfo.recordcount; loc.intRow = (loc.intRow + 1) )
			{
				loc.defaultValue = loc.dbinfo["COLUMN_DEFAULT_VALUE"][loc.intRow];
				
				if ((Left(loc.defaultValue,2) == "((" && Right(loc.defaultValue,2) == "))") || (Left(loc.defaultValue,2) == "('" && Right(loc.defaultValue,2) == "')"))
				{
					loc.defaultValue = Mid(loc.defaultValue, 3, Len(loc.defaultValue)-4);
				}
				
				loc.dbdefaults[loc.dbinfo["COLUMN_NAME"][loc.intRow]] = loc.defaultValue;
				
				
			}
			
			
			for(loc.key in variables.wheels.class.properties)
			{
				if(StructKeyExists(loc.dbdefaults, loc.key))
				{
					loc.setDefault = true;
				
					
					if(ListContains(variables.wheels.class.keys, loc.key))
					{
						loc.setDefault = false;
					}
					
					//Don't bother if this property is the timeStamp update target
					if (variables.wheels.class.timeStampingOnUpdate)
					{
						if(variables.wheels.class.timeStampOnUpdateProperty == loc.key)
						{
							loc.setDefault = false;
						}
					}
					
					//Don't bother if this property is the timeStamp create target
					if (variables.wheels.class.timeStampingOnCreate)
					{
						if(variables.wheels.class.timeStampOnCreateProperty == loc.key)
						{
							loc.setDefault = false;
						}
					}
					
					
					if(loc.setDefault)
					{
						variables.wheels.class.properties[loc.key].defaultValue = loc.dbdefaults[loc.key];
					}
					
				}
				
			}

		</cfscript>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>