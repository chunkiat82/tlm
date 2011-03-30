MyDesktop.LoginWindow = Ext.extend(Ext.app.Module, {
    id:'login-win',
    init : function(){
        this.launcher = {
            text: 'Login',
            iconCls:'icon-grid',
            handler : this.createWindow,
            scope: this
        }
    },

    createWindow : function(){      
        var desktop = this.app.getDesktop();
        var win = desktop.getWindow('login-win');

        var result  = createLoginPanel();
     
        if(!win){
            win = desktop.createWindow({
                id: 'login-win',
                title:'Login Window',
                width:300,
                height:150,
                iconCls: 'icon-grid',
                shim:false,
                animCollapse:false,
                constrainHeader:true,
                maximizable:false,
                modal:true,
                layout: 'fit',
                items:result
            });
        }
        Ext.MessageBox.hide();
        win.show();
    }
});
function createLoginPanel()
{
	var loginHandler = {
			  method:'POST', 
			  waitTitle:'Connecting', 
			  waitMsg:'Sending data...',
			  success: function()
			  { 
				loggedIn=true;
				closeAllWindows();
				Ext.Msg.alert('Status', 'Login Successful!');	
				
			  },
			  failure: function(form, action) { 
			      if(action.failureType == 'server')
			      { 
			          obj = Ext.util.JSON.decode(action.response.responseText); 
			          Ext.Msg.alert('Login Failed!', obj.errors.reason); 
			      }
			      else
			      { 
			          Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText); 
			      } 
			      loginForm.getForm().reset(); 
			  } 
			}

			var loginForm = new Ext.FormPanel({ 
			  labelWidth:80,
			  // use acegi to validate instead
			  //url:'home/login', 
			  url: '/tlm/j_spring_security_check?spring-security-redirect=/login/ajaxSuccess',
			  frame:true, 
			  title:'', 
			  defaultType:'textfield',
			  monitorValid:true,
			  
			  items:[
			     textField('Username', 'j_username', true),
			     passwordField('Password', 'j_password', true)
			  ],
			 
				// All the magic happens after the user clicks the button     
			  buttons:[{ 
			    text:'Login',
			    formBind: true,	 
			    // Function that fires when user clicks the button 
			    handler:function()
			    { 
			      loginForm.getForm().submit(loginHandler); 
			    } 
			  }] // end of buttons 
			}); // end of new Ext.FormPanel
	return loginForm;
}

 
