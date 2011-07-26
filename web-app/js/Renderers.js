var localOffset = (new Date()).getTimezoneOffset()* 60000;
function defaultMonthFormat(value,p,record) 
{ 
 	value = new Date((value.getTime()) -localOffset);
	return value.format("M Y"); 
}
function defaultDateFormat(value,p,record) 
{ 
	value = new Date((value.getTime()) -localOffset);
	return value.format("d M Y"); 
}


function renderWebsite(value, p, record){            
    return String.format('<a target="_blank" href="{0}">{1}</a>',record.data.website,value);
}
function renderOrganization(value, p, record){            
    return String.format('<a target="_blank" href="{0}">{1}</a>',record.data.orgLink,value);
}
function renderEvent(value, p, record){            
          return String.format('<a target="_blank" href="{0}">{1}</a>',record.data.eventLink,value);
}

function countryRenderer(value, p, record){
    return String.format(            	
    '<img style="vertical-align:middle;width:50px;border:1px solid #DDD;" src="images/flags/{0}"/> {1}',record.get("imageUrl"),value);
};
function publicationRenderer(value, p, record){
	var tempString="";
	
	for (i=0;i<value.length;i++)
	{
		if (i==value.length-1)
			//only one item
			if ((value.length-1)==0)
				return value[i].pubShortName;
			else
				return tempString+value[i].pubShortName;
		else
			tempString+=value[i].pubShortName+', ';
	}
    return "";
};

function publicationFilter(filterValue, value){  
	if (filterValue.trim()=='')
		return 1;
	for (var i=0;i<value.length;i++){
		var filterArray = filterValue.split(",");		
		for (var j=0;j<filterArray.length;j++)
		{
			if ((value[i].pubShortName).toUpperCase()==filterArray[j].toUpperCase()){
				return 1;
			}
		}
	}
	return 0;
		
}

function standardContainFilter(filterValue, value){
	if (filterValue.trim()=='')
		return 1;
	var filterArray = filterValue.split(",");	
	for (var j=0;j<filterArray.length;j++)
	{
		if ((value.toLowerCase()).indexOf(filterArray[j].toLowerCase())>=0)
			return 1;
	}	
	return 0;	
}
