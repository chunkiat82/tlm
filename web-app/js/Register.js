/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

// NOTE: REQUIRES ext-helper.js TO BE INCLUDED FIRST

/**
 * @author Raymond.Ho
 */

// fields returned in Json object
var jobFunctionFields = ['class', 'id', 'users', 'title'];
var jobPositionFields = ['class', 'id', 'users', 'title'];
var countryFields = ['class', 'id', 'code', 'image', 'title'];
var publicationFields = ['class','id','pubShortName','adSchedules','subscriptions', 'documents', 'events', 'digitals', 'suppliers', 'htmlWriteUp', 'editor', 'pubId', 'fileName', 'pubLongName', 'advertiser', 'fileData'];
var honorificFields = ['class', 'id', 'users', 'type'];

// JsonStores
var jobFunctions = null;
var jobPositions = null;
var countries = null;
var publications = null;
var honorifics = null;

// jsonloadprogress (all 5 stores)
var jsonloadprogress = 0.0;

function updateProgress(increment, message) {
  jsonloadprogress += increment;
  Ext.MessageBox.updateProgress(jsonloadprogress, message);
  
  if (jsonloadprogress >= 1.0) {	  
	  Ext.MessageBox.hide();
	  getRegistrationWindow();
  }
}

function generatePublicationCheckboxes()
{
	var checkboxes = new Array();
	
	publications.each
	(
		function(record) 
		{
			checkboxes.push(checkBox(record.get('pubLongName'), 'publication.ids', record.id, true));
			return true;
		}
	);
	
	return checkboxes;
}

function prepareRegistration() {
  jsonloadprogress = 0.0;
  
  // display a dialog first	
  Ext.MessageBox.show(
	{
	  title: 'Please wait',
	  msg: 'Loading registration form...',
	  width: 300,
	  closeable: false,
	  progress: true,
	  progressTest: 'Downloading...'
	}
  );
  
  // pre-load all JsonStores used in the form
  // Job Function, Job Position, Country and Publication
  var sortInfo = {field: 'title',direction: 'ASC'}; 
  jobPositions = getJsonStore('lookup/jobPositions', 'items', 'id', jobPositionFields,sortInfo);  
  jobPositions.load({callback: function() {updateProgress(0.2, "Job Positions loaded.")}});
  
  jobFunctions = getJsonStore('lookup/jobFunctions','items', 'id', jobFunctionFields,sortInfo);  
  jobFunctions.load({callback: function() {updateProgress(0.2, "Job Functions loaded.")}});
  
  countries = getJsonStore('lookup/countries', 'items', 'id', countryFields,sortInfo);  
  countries.load({callback: function() { updateProgress(0.2, "Countries loaded.")}});
  
  //publications = getJsonStore('lookup/publications', 'items', 'id', publicationFields);
  //publications.load({callback: function() {updateProgress(0.2, "Publications loaded.")}});
  publications = PublicationsPers.getPublicationStore();
  updateProgress(0.2, "Publications loaded.");
  
  honorifics = getJsonStore('lookup/honorifics', 'items', 'id', honorificFields);
  honorifics.load({callback: function() {updateProgress(0.2, "Honorifics loaded.")} });
  
}

function getRegistrationWindow()
{
  Ext.QuickTips.init();  
  var registrationWindow;
  
  // define the button handler for the submit button in registrationForm
  var submitHandler = function(button, event) {
    registrationForm.form.submit( {
      url :'/tlm/userRegistration/ajaxSave',
      waitMsg :'Sending data...',
      failure : function(form, action) {
    	
        switch (action.failureType) {
          case Ext.form.Action.CLIENT_INVALID:
            Ext.Msg.alert('Failure', 'Some fields are still invalid/empty'); break;
          case Ext.form.Action.CONNECT_FAILURE:
            Ext.Msg.alert('Failure', 'Problem trying to connect to the database');  break;
          case Ext.form.Action.SERVER_INVALID:
            Ext.Msg.alert('Failure', 'A subscriber with the same email address already exist'); break;
          default:
        	Ext.Msg.alert('Failure', 'An unknown problem has occurred.'); break;
        }
    	
      },
      success : function(form, action) {
    	Ext.MessageBox.alert('Success', 'The registration will be processed. Please check your e-mail');
        registrationWindow.hide();
      }
    });
  };

  // define the registrationForm
  var registrationForm = new Ext.FormPanel( {
    labelWidth :80, // label settings here cascade unless overridden
    url :'success.txt',
    frame :true,
    width :800,
    xtype :'fieldset',
    autoHeight :true,

    // items on the form    
    items : [
       
      // top part of form
      {
        layout: 'column',
        border: false,
        defaults: { columnWidth: '.33', border: false },
        items:  [
          
          // first column, combination of user account details and work details
          {
            items: [
              // "User Account Details"               
              {
              	border: false,        	              	  
                xtype:'fieldset',
                bodyStyle: 'padding-right:0px;',
                title: ' User Account Details',
                autoHeight: true,
                defaultType :'textfield',
                defaults : { width :150 },
          
                // input elements
                items:[ 
                  // label, name, required
                  //textField('User name', 'user.userName', true ),
                  textField('E-mail', 'user.email', true)//,
                  //passwordField('Password', 'user.password', true),
                  //passwordField('Confirm Password', 'user.confirmPassword', true)                  
                  ]

              },
              
              // "Work Details"
              {
              	border: false,        	              	  
                xtype:'fieldset',
                bodyStyle: 'padding-right:0px;',
                title: ' Work Details',
                defaultType :'textfield',
                autoHeight: true,
                defaults : { width :150 },
            
                // input elements
                items:[
                  // label, name, required
                  textField('Company', 'user.company', true),
                  
                  // label, name, comboValues, valueField, displayField, blankOptionLabel, required
                  comboBox('Job Function', 'user.jobFunction.id', jobFunctions, 'id', 'title', 'Job Function...', true),
                  comboBox('Job Position', 'user.jobPosition.id', jobPositions, 'id', 'title', 'Job Position...', true)

                ]
              }
            ]
          }, // end of first column
          
          // start of second column
          {
            items: [
              // "Personal Particulars"
              {
              	border: false,        	              	  
                xtype: 'fieldset',
                bodyStyle: 'padding-right: 0px;',
                title: 'Personal Particulars',
                autoHeight: true,
                defaults: { width: 150 },
        	
                // input elements
                items: [
                  // label, name, comboValues, valueField, displayField, blankOptionLabel, required
                  comboBox('Honorific', 'user.honorific.id', honorifics, 'id', 'type', 'Honorific...', true),
                  textField('First Name', 'user.firstName', true ),
                  textField('Last Name', 'user.lastName', true ),
                  
                  // label, name, items, defaultIndex
                  radioGroup('Gender', 'user.gender', [{label: 'Male', value: 0}, {label: 'Female', value: 1}], 0)
                  ]
              },
          
              // "Contact Information"
              {
              	border: false,        	              	  
                xtype: 'fieldset',
                bodyStyle: 'padding-right: 0px;',
                title: 'Contact Information',
                autoHeight: true,
                defaults: { width: 150 },
          	
                // input elements
                items: [
                  // label, name, required
                  textField('Telephone', 'user.telephone', true),
                  textField('Fax', 'user.fax', false),
                  textField('Mobile', 'user.mobile',false )              
                  ]
              }
            ]
          }, // end of second column
          
          // start of third column
          {        	  
            items: [
              // "Location"
              {
              	border: false,            	  
        	    xtype: 'fieldset',
        	    bodyStyle: 'padding-right: 0px;',
        	    title: 'Location',
        	    autoHeight: true,
        	    defaults: { width: 150 },
        	
        	    // input elements
        	    items: [
                  // label, name, comboValues, valueField, displayField, blankOptionLabel, required
                  comboBox('Country', 'user.country.id', countries, 'id', 'title', 'Country...', true,true),
                  textArea('Address', 'user.address', false),
                  textField('City', 'user.city', false),
                  textField('State', 'user.state', false),
                  numberField('Postal Code', 'user.postal', false)
        	    ]
              }
            ]
          } // end of third column
        ] // end items on top part of form
    },
    
    // bottom part of form
    {
      xtype:'fieldset',
      checkboxToggle:false, // displayed when checkbox is checked
      title: 'Change Subscription Selections',
      autoHeight:true,
      defaults: { width: 600 },
      defaultType: 'textfield',
      collapsed: false, // initial state is collapsed
      
      // items on bottom part of form
      items: [{
        xtype: 'checkboxgroup',
        fieldLabel: 'Subscriptions',
        itemCls: 'x-check-group-alt',
        columns: 3,
        
        // checkbox items
        items: generatePublicationCheckboxes()

      }] // end items at bottom part of form
    } // end bottom part of form
    ], // end items on form

    // buttons for the form
    buttons : [ {
      text :'Submit',
      handler :submitHandler
    } ]
    
  }); // end Ext.FormPanel definition
  
  // define the registrationWindow which uses registrationForm
  registrationWindow = new Ext.Window( {
    title :'Free Digit Copy Registration',
    width :800,
    autoHeight :true,
    modal :true,
    border :false,
    resizable :false,
    items :registrationForm
  });
  
  registrationWindow.show();
}
