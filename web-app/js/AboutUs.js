/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
var aboutUsPanel;

MyDesktop.AboutUsWindow = Ext.extend(Ext.app.Module, {
    id:'about-win',
    init : function(){
        this.launcher = {
            text: 'About Trade Link Media',
            iconCls:'icon-grid',
            handler : this.createWindow,
            scope: this
        }
    },

    createWindow : function(){      
        var desktop = this.app.getDesktop();
        var win = desktop.getWindow('about-win');

        var result  = createAboutUsPanel();
     
        if(!win){
            win = desktop.createWindow({
                id: 'about-win',
                title:'More Information',
                width:'80%',
                height:480,
                iconCls: 'icon-grid',
                shim:false,
                animCollapse:false,
                constrainHeader:true,
                maximizable:false,
                draggable: false,
                layout: 'fit',
                modal:true,
                items:result
            });
        }
        win.show();
    }
});


function createAboutUsPanel(){
    
	var temp = new Ext.ux.AjaxPanel({
        iconCls: '',            
        closable:true,
        width:1,
        layout:'fit',
        autoLoad: {url: 'aboutUs.html'}
    }); 
    return temp;
        
}


