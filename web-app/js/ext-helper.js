// helper method to generate a textfield object
Ext.namespace('Ext.ux');
function textField(label, name, required)
{
	return new Ext.form.TextField( {
		fieldLabel : label,
		name: name,		
		allowBlank: !required
	})
}

function passwordField(label, name, required)
{
	return new Ext.form.TextField( {
		fieldLabel : label,
		name: name,		
		inputType: 'password',
		allowBlank: !required
	})
}

// helper method to generate a textArea map
function textArea(label, name, required)
{
	return {
		xtype: 'textarea',
		fieldLabel : label,
		name: name,		
		allowBlank: !required
	}
}

// helper method to generate a numeric field
function numberField(label, name, required)
{
	return {
		xtype: 'numberfield',
		fieldLabel : label,
		name: name,		
		allowBlank: !required
	}
}

// helper method to generate a group of radio buttons
// items is an array of map {label, value}
function radioGroup(label, name, items, defaultIndex)
{
	return {
		xtype: 'radiogroup',
		fieldLabel: label,
		items: radioButtonArray(name, items, defaultIndex)
	}
}

// used by function radioGroup()
function radioButtonArray(name, items, defaultIndex)
{
	var buttons = new Array();
	
	for (var i = 0; i < items.length; i++)
	{
		buttons.push(
			{
				name: name,
				boxLabel: items[i].label,
				inputValue: items[i].value,
				checked: (i == defaultIndex)
			}
		);
	}
	
	return buttons;
}

// helper method to generate a combo box
// comboValues should be a store of some sort - JsonStore has been tested
// valueField is the fieldname in the comboValues representing the value
// displayField is the fieldname in the comboValues representing the display label
// blankOptionLabel is the initial value of the combo box
function comboBox(label, name, comboValues, valueField, displayField, blankOptionLabel, required,edit)
{
	 if (!edit)
         edit=false;

	return new Ext.form.ComboBox(
		{
			store: comboValues,
			editable: edit,
			// name:name,
			fieldLabel:label,			
			allowBlank: !required,
			typeAhead: true,
			triggerAction: 'all',
			emptyText: blankOptionLabel,
			mode: 'local',
			selectOnFocus:true,
			valueField: valueField,
			displayField: displayField,
			hiddenName:name
		}
    )
}

// helper method to quickly retrieve a lookup object
// the fields must be populated e.g. ['id', 'title']
function getJsonStore(url, root, idProperty, fields,sorts)
{
	return new Ext.data.JsonStore({
	    autoDestroy: true,
	    url: url,
	    root: root,
	    idProperty: idProperty,
	    fields: fields,
	    sortInfo: sorts   
	})
}

// helper method to generate a checkbox map
function checkBox(label, name, value, checked)
{
	return {
      boxLabel:label,
      name: name,
      inputValue: value, 
      checked: checked
	}
}

Ext.ux.JsonStore= Ext.extend(Ext.data.JsonStore,
{
	listeners:{
	load:function(){
		Ext.MessageBox.hide();
	}
}
});
Ext.ux.BubblePanel = Ext.extend(Ext.Panel, {
    baseCls: 'x-bubble',
    frame: true
});

Ext.ux.AjaxPanel = Ext.extend(Ext.Panel,
{
	listeners:{
		afterrender:function(){
			Ext.MessageBox.hide();
		}
	}
});
