/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function loadContactusForm() {

    var subjectList = [
        ['To subscribe a publication','To subscribe a publication'],
        ['To request for media kit of a publication','To request for media kit of a publication'],
        ['To submit an article / press release','To submit an article / press release'],
        ['Others','Others']

    ];

    var buttonHandler = function(button,event) {
    	contactUsBottom.form.submit({
            method:'POST',
            url:'response/contact',
            waitMsg:'Sending data...',
            failure:function(f,a){
                Ext.MessageBox.alert('Error', 'Error in sending enquiry');
            },
            success:function(f,a){
                Ext.MessageBox.alert('Information', 'Your enquiry details has been sent.');
                window.close();
            }
        });
    };
    var contactUsHtml="<h2>Trade Link Media Pte Ltd</h2><br/><a target='_blank' href='http://gothere.sg/maps#q:388399'>Find Us (Map)</a><br/><br/>Call: +65-6842 2580 &nbsp;Fax: +65-6842 2581<br/>Email: <a href='mailto:info@tradelinkmedia.com.sg'>info@tradelinkmedia.com.sg</a>"+
    				  "<br/><br/>101 Lorong 23 #06-04 Prosper House<br/>Singapore 388399";
    var contactUsTop = new Ext.Panel({      
        iconCls: 'monthIcon',        
        layout:'fit',
        region:'north',
        height:150,
        bodyStyle:'padding:5px 5px 5px 5px;text-align:center;background:url("images/tlm/logo.png") no-repeat scroll left top;',
        html:contactUsHtml
    });  
    var contactUsBottom = new Ext.FormPanel({
        labelWidth: 110, // label settings here cascade unless overridden
        url:'response/contact',
        layout:'form',
        region:'center',
        frame:true,
        title: 'On-line Form',
        bodyStyle:'padding:5px 5px 5px 5px;  z-index:300001;',
        width: 340,
        defaults:{ width: 340},
        defaultType: 'textfield',
        xtype:'form',
        items: [
            new Ext.form.ComboBox({
                store: subjectList ,
                name:'subject',
                fieldLabel: 'Subject',
                displayField:'Subject',
                allowBlank:false,
                typeAhead: true,
                triggerAction: 'all',
                emptyText:'Select a subject...',
                selectOnFocus:true,
                forceSelection :true
             }),
            {
                fieldLabel: 'Your Name',
                name: 'yourName',
                width:150,
                allowBlank:false

            },
            {
                fieldLabel: 'E-mail Address',
                name: 'emailAddress',
                width:200,
                vtype:'email',
                allowBlank:false
            },
            {
                fieldLabel: 'Company Name',
                name: 'companyName',
                width:200,
                allowBlank:false
            },
            new Ext.form.TextArea({
                fieldLabel: 'Message',
                allowBlank: false,
                name: 'message',
                height: 150,
                width:300
            })
        ],
        buttons: [{
                text: 'Email Us Now',
                handler:buttonHandler
            }]
    });

    var window = new Ext.Window({
        title: 'Email/Contact Us',
        modal :true,
        width:500,
        height:450,
        layout: 'border',
        plain:true, 
        bodyStyle:'padding:5px;',
        buttonAlign:'center',
        border:false,
        items: [contactUsTop,contactUsBottom]

    });

    window.show();
};