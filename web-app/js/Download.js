function getDownloadPanel(pubId)
{		
	var view = new Ext.DataView({
		
		// an item is the div with the class "thumb-wrap"
        itemSelector: 'div.thumb-wrap',
	autoScroll: true,
        
        multiSelect: true,    
        
        // the data is from the action issue of the Publication controller
        // JSON return is all issues for the given publication.
        store: 
        new Ext.ux.JsonStore({
        	url: urls.issueListByPubId+"/"+pubId,
            autoLoad: true,
            root: 'items',
            id:'id',
            fields: issueFields
        }),        
        // the template represents each item that is returned via the JsonStore
        tpl: 
        new Ext.XTemplate(
            '<tpl for=".">',
            '<div  class="thumb-wrap" id="{name}">',
            '<div class="thumb"><img src="/tlm/response/issueThumbnail/{id}" class="thumb-img" /></div>',
            '<span>{name}</span>',
            '<span><tpl for="documents"><div style="float:left;clear:both;" onclick="openDownloadAttachment({id})"><a href="/tlm/response/download/{id}">{name}<a/></div></tpl></span>',
            '</div>',
            '</tpl>'
        )
    });
	
	var images = new Ext.Panel({
        id:'images',
        title:'PDFs',
        region:'center',
        margins: '5 5 5 0',
        layout:'fit',        
        items: view
    });
	
	return images;
}
function openDownloadAttachment(id){
 window.location.href=urlPath+"response/download/"+id;
}
MyDesktop.DownloadWindow = Ext.extend(Ext.app.Module, {
    id:'download-win',
    init : function(){
        this.launcher = {
            text: 'Download Publications',
            iconCls:'icon-grid',
            handler : this.createWindow,
            scope: this
        }
    },

    createWindow : function(pubId){
        var desktop = this.app.getDesktop();
        var win = desktop.getWindow('download-win');

        var result  = getDownloadPanel(pubId);
     
        if(win){
        	win.close();
        }
        win = desktop.createWindow({
            id: 'pub-win',                
            title:'Download Publications',
            width:'60%',
            height:480,
            iconCls: 'icon-grid',
            shim:false,
            animCollapse:false,
            constrainHeader:true,
            maximizable:false,
            draggable:false,
            layout: 'fit',
            modal:true,
            items:result
        });       
        win.show();
    }
});
