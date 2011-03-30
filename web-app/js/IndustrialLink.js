/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
var industrialLinkPanel;
var industrialLinkDataStore;

Ext.onReady(function()
{
	
	//due to timing issue preload supplier database
	industrialLinkDataStore = new Ext.ux.JsonStore({
        url:urls.industrialLinkList,            
        idProperty: 'id',
        totalProperty: 'totalCount',
        root: 'items',
        fields: industrialLinkFields,
        sortInfo:{field: "organization", direction: "asc"}
    });
	industrialLinkDataStore.load();

});

MyDesktop.IndustrialLinkWindow = Ext.extend(Ext.app.Module, {
    id:'industrialLink-win',
    init : function(){
        this.launcher = {
            text: 'Industrial Link',
            iconCls:'icon-grid',
            handler : this.createWindow,
            scope: this
        }
    },

    createWindow : function(){      
        var desktop = this.app.getDesktop();
        var win = desktop.getWindow('industrialLink-win');

        var result  = createIndustrialLinkPanel();
                
        if(!win){
            win = desktop.createWindow({
                id: 'supplier-win',
                title:'Industrial Links',
                width:'70%',
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
        }
        win.show();
        Ext.MessageBox.hide();
    }
});

function createIndustrialLinkPanel(){

        function toggleDetails(btn, pressed){
            var view = grid.getView();
            view.showPreview = pressed;
            view.refresh();
        } 
        
        var cm = new Ext.grid.ColumnModel([
            {dataIndex: 'organization', header: 'Organization', id: 'organization',sortable: true,
            	filter: {
            		test: 
            			function(filterValue, rowValue) {
			            	if (filterValue.trim()=='')
			            		return 1;
			            	var filterArray = filterValue.split(",");	
			            	for (var j=0;j<filterArray.length;j++)
			            	{
			            		if ((rowValue.toLowerCase()).indexOf(filterArray[j].toLowerCase())>=0)
			            			return 1;
			            	}	
			            	return 0;	
            			}
            	},renderer:renderOrganization
        	},
            {dataIndex: 'abbreivation', header: 'Abbreivation',sortable: false, id: 'abbreivation'},
            {dataIndex: 'website', header: 'Website',sortable: false, id: 'website',renderer:renderOrganization},
            {id: 'publications',header:'Magazines Involved', dataIndex: 'publications',renderer:publicationRenderer}
        ]);
        cm.defaultSortable = true;
        var toggleBtn = new Ext.Button({
            pressed: true,
            enableToggle:true,
            text: 'Show Details',
            cls: 'x-btn-text-icon details',
            iconCls:'newsicon',
            toggleHandler: toggleDetails
        });
 		var grid = new Ext.grid.GridPanel({
            width : 1,            
            title:'Industrial Links (Searching is available)',
            iconCls: 'supplierIcon',
            ds: industrialLinkDataStore,
            layout:'fit',           
            cm:cm,
            border:false,
            trackMouseOver:true,            
            loadMask: true,
            plugins: ["filterrow"],
            stripeRows: true,
            viewConfig: {
                forceFit:true,
                enableRowBody:false,
                showPreview:false,
                getRowClass : function(record, rowIndex, p, store){
//                    if(this.showPreview){
//                        p.body =                             
//                            '<br><p class=""><b>Description:</b> '+record.data.description+'</p>';
//                        return 'x-grid3-row-expanded';
//                    }
                    return 'x-grid3-row-collapsed';
                }

                    
            },
            listeners:{
//	        	rowdblclick:function(g,n,e){
//	                    //alert('1');
//	                    toggleBtn.toggle();                                                             
//	                    toggleDetails(toggleBtn,toggleBtn.pressed);
//	        	}
            }
       
        });
       // grid.
        
        var temp = new Ext.Panel({                        
            items:grid,
            closable:true,
            layout:'fit',
            listeners:{
                'destroy':function(a){
        			industrialLinkPanel=null;
                }
            }
        });         
      //  supplierDataStore.load({params:{start:0, limit:pageSize}});       
        return temp;
        
}


