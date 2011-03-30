/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
var supplierPanel;
var supplierDataStore;

Ext.onReady(function()
{
	
	//due to timing issue preload supplier database
	supplierDataStore = new Ext.ux.JsonStore({
        url:urls.supplierList,            
        idProperty: 'id',
        totalProperty: 'totalCount',
        root: 'items',
        fields: [
            {name: 'id', mapping: 'id'},
           // {name: 'joined', mapping: 'joined', type: 'date', dateFormat: 'd/m/Y'},
            {name: 'company'},
            {name: 'description'},
            {name: 'telephone'},
            {name: 'fax'},
            {name: 'countryTitle',mapping:'country.title'},        
            {name: 'countryId',mapping:'country.id'},  
            {name: 'imageUrl',mapping:'country.image'},  
            {name: 'website'},
            {name: 'publications',mapping:'publications'}               
        ],
        sortInfo:{field: "company", direction: "asc"}
    });
    supplierDataStore.load();

});

MyDesktop.SupplierWindow = Ext.extend(Ext.app.Module, {
    id:'supplier-win',
    init : function(){
        this.launcher = {
            text: 'Supplier',
            iconCls:'icon-grid',
            handler : this.createWindow,
            scope: this
        }
    },

    createWindow : function(){      
        var desktop = this.app.getDesktop();
        var win = desktop.getWindow('supplier-win');

        var result  = createSupplierPanel();
                
        if(!win){
            win = desktop.createWindow({
                id: 'supplier-win',
                title:'Supplier List',
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

function createSupplierPanel(){
//        var innerWindowWidth = documentWindow.innerWidth*0.7;
//        var innerWindowHeight = documentWindow.innerHeight*0.8;
        function toggleDetails(btn, pressed){
            var view = grid.getView();
            view.showPreview = pressed;
            view.refresh();
        } 
        
        var cm = new Ext.grid.ColumnModel([
            //  checkboxModel,
            //Ext.util.Format.dateRenderer('d/m/Y')
            //{id:'joined', width:60,dataIndex: 'joined', header: 'Date Added',renderer:Ext.util.Format.dateRenderer('d/m/Y') },
            {dataIndex: 'company', header: 'Company', id: 'company',sortable: true,
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
            {dataIndex: 'description', header: 'Description',sortable: false, defaultWidth:'200',id: 'description',
        		filter: {
	        		test: 
	        			function(filterValue, rowValue) {
		        			if (filterValue.trim()=='')
		        				return 1;
		        			for (var i=0;i<rowValue.length;i++){
		        				var filterArray = filterValue.split(",");		
		        				for (var j=0;j<filterArray.length;j++)
		        				{
		        					if ((rowValue).toUpperCase().indexOf(filterArray[j].toUpperCase())>=0){
		        						return 1;
		        					}
		        				}
		        			}
		        			return 0;
	        			}
	        	}},
            {dataIndex: 'telephone', header: 'Telephone',sortable: false, id: 'telephone'},
            {dataIndex: 'fax', header: 'Fax',sortable: false, id: 'fax'},
            {dataIndex: 'countryTitle', header: 'Country', sortable: true,id: 'countryId', 
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
	        	},renderer:countryRenderer
        	}    
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
            title:'Supplier List (Searching is available)',
            iconCls: 'supplierIcon',
            ds: supplierDataStore,
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
                    if(this.showPreview){
                        p.body =                             
                            '<br><p class=""><b>Description:</b> '+record.data.description+'</p>';
                        return 'x-grid3-row-expanded';
                    }
                    return 'x-grid3-row-collapsed';
                }

                    
            },
            listeners:{
	        	rowdblclick:function(g,n,e){
	                    //alert('1');
	                    toggleBtn.toggle();                                                             
	                    toggleDetails(toggleBtn,toggleBtn.pressed);
	        	}
            }
       
        });
       // grid.
        
        var temp = new Ext.Panel({                        
            items:grid,
            closable:true,
            layout:'fit',
            listeners:{
                'destroy':function(a){
                    supplierPanel=null;
                }
            }
        });         
      //  supplierDataStore.load({params:{start:0, limit:pageSize}});       
        return temp;
        
}


