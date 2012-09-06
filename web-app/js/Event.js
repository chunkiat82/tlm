/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
var eventsPanel;
var sponsorsPanel;
var eventTask;

var eventDataStore;

Ext.onReady(function()
{

	var eventReader = new Ext.data.JsonReader({
	    // metadata configuration options:
	    idProperty: 'id',
	    root: 'items',
	    totalProperty: 'totalCount',
    	fields: [
    		        {name: 'id', mapping: 'id'},
    	            {name: 'eventName'},
    	            {name: 'eventLink'},
    	            {name: 'startDate', mapping: 'startDate', type: 'date'},
    	            {name: 'endDate', mapping: 'endDate', type: 'date'},
    	            {name: 'location'},
    	            {name: 'orgName'},
    	            {name: 'orgLink'},
    	            {name: 'publications'}

    		      ]
	});
	eventDataStore = new Ext.data.GroupingStore({
		 url:urls.eventList, 
		 reader: eventReader,
		 groupOnSort: true,
		 sortInfo:{field: 'startDate', direction: "ASC"},
		 groupField:'startDate'
		
	});
	
	

//	//due to timing issue preload supplier database
//	eventDataStore = new Ext.ux.JsonStore({
//        url:urls.eventList,       
//        idProperty: 'id',
//        totalProperty: 'totalCount',
//        root: '',
//        fields: [
//            {name: 'id', mapping: 'id'},
//            {name: 'eventName'},
//            {name: 'eventLink'},
//            {name: 'startDate', mapping: 'startDate', type: 'date'},
//            {name: 'endDate', mapping: 'endDate', type: 'date'},
//            {name: 'location'},
//            {name: 'orgName'},
//            {name: 'orgLink'},
//            {name: 'publications'}
//        ],            
//        sortInfo:{field: "startDate", direction: "ASC"}
//    });  
//	
	
	eventDataStore.load();

});

MyDesktop.EventWindow = Ext.extend(Ext.app.Module, {
    id:'event-win',
    init : function(){
        this.launcher = {
            text: 'Events',
            iconCls:'icon-grid',
            handler : this.createWindow,
            scope: this
        }
    },

    createWindow : function(){      
        var desktop = this.app.getDesktop();
        var win = desktop.getWindow('event-win');

        var result  = createEventsPanel();
     
        if(!win){
            win = desktop.createWindow({
                id: 'event-win',
                title:'Calendar',
                width:'100%',
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
            win.on({
            	'close': {
            		fn: function(){Ext.TaskMgr.stop(eventTask);}
            	}
            });
        }
        win.show();
        Ext.MessageBox.hide();
    }
});


function createEventsPanel(){
    if (!eventsPanel){
    	pageSize=20;
        function toggleDetails(btn, pressed){
            var view = grid.getView();
            view.showPreview = pressed;
            view.refresh();
        } 
        var store = eventDataStore;
        
        var checkboxModel = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
        var  startDateColumn = new Ext.grid.Column({id: 'startDate', width:50,dataIndex: 'startDate', header: 'Start Date',groupable:true,sortable: true,renderer:defaultDateFormat});
        var  endDateColumn = new Ext.grid.Column({id: 'endDate', width:50,dataIndex: 'endDate', header: 'End Date',sortable: true,renderer:defaultDateFormat});
        var  monthColumn = new Ext.grid.Column({id: 'monthDate', hidden:true, width:50,dataIndex: 'startDate', header: 'Month',sortable: true,renderer:defaultMonthFormat});
        var cm = new Ext.grid.ColumnModel([
            monthColumn,
            startDateColumn,            
            endDateColumn,
            {id: 'eventName',dataIndex: 'eventName', header: 'Event Name', sortable: true, renderer:renderEvent},
            {id: 'location', header: 'Location',dataIndex: 'location',sortable: true},
            {id: 'orgName', header: 'Organization',dataIndex: 'orgName', sortable: true,renderer:renderOrganization},
            {id: 'publications',header:'Magazines Involved', dataIndex: 'publications',renderer:publicationRenderer}
        ]);
        cm.defaultSortable = true;
        
        
        var grid = new Ext.grid.GridPanel({
            width : 1,            
            title:'',
            ds: store ,            
            layout:'fit',
            region:'center',
            cm: cm,
            border:false,
            trackMouseOver:true,            
            loadMask: true,
            viewConfig: {
                forceFit:true,
                enableRowBody:true,
                showPreview:true,
                getRowClass : function(record, rowIndex, p, store){
                    var smodel = grid.getSelectionModel();
                    if (smodel. getCount()==0)
                        return 'x-grid3-row-collapsed';
                    if (record.data.id==smodel.getSelected().get('id')){                       
                        return 'x-grid3-row-expanded';
                    }
                    return 'x-grid3-row-collapsed';
                }
            },	 
            view: new Ext.grid.GroupingView({
                forceFit: true,
                // custom grouping text template to display the number of items per group
                groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Events" : "Event"]})'
            }),
            listeners:{
	        	rowclick:function(g,n,e){
	                    grid.getView().refresh();                   
	        	}
            }       
        });
        var view = new Ext.DataView({
            itemSelector: 'div.thumb-wrap-nomore',
            style:'overflow:auto',
            multiSelect: true,       
            store: 
            new Ext.data.JsonStore({
            	url: urls.adsEventsList,
                autoLoad: true,
                root: 'items',
                id:'id',
                fields: adsFields
            }),
            tpl: new Ext.XTemplate(
                '<tpl for=".">',
                '<div class="thumb-wrap" id="{name}">',
                '<div class="thumb"><tpl if="this.isImage(mimeType)">',
                '<a href="{url}" target="_blank" border="0"><img src="/tlm/response/adsImage/{id}" class="thumb-img" /></a>',
                '</tpl><tpl if="this.isImage(mimeType) == false">',
                '<object width="150" height="150" id="advertise3"',
				'codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"',
				'classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">',
				'<param value="/tlm/response/adsImage/{id}" name="movie">',
				'<param value="High" name="quality">',
				'<param value="#ffffff" name="bgcolor">',
				'<embed width="150" height="150" align=""',
				'pluginspage="http://www.macromedia.com/go/getflashplayer"',
				'type="application/x-shockwave-flash" name="advertise1"',
				'bgcolor="#ffffff" quality="High"',
				'src="/tlm/response/adsImage/{id}">',
				'</object>',
                '</tpl></div>',
                '<span>&nbsp;</span></div>',
                '</tpl>',
                {
                    isImage: function(mimeType){
	                	if (mimeType.indexOf("image")>=0)
	                    	return true;
	                    else
	                    	return false;                        	
                    }                
                }
            )
        });
        sponsorsPanel = new Ext.Panel({
            width:170,            
            frame:true,
            region:'west',
            pageY:1000,
            items: view
        });
        var temp = new Ext.Panel({
            title: 'Events',
            iconCls: 'monthIcon',
            closable:true,
            width:1,
            layout:'border',
            
            items:[grid,sponsorsPanel],
          
            listeners:{
                'destroy':function(a){
                    eventsPanel=null;
                    //Ext.TaskMgr.stopAll();
                }
            }
        });         
        var topSponsor=0;
        eventTask={
    	    run: function(){
	        	var tempTopSponsor= sponsorsPanel.body.getScroll().top;
	        	if (tempTopSponsor+100<topSponsor){
	        		sponsorsPanel.body.scrollTo('top',0,true);
	        		topSponsor=0;
	        	}
	        	else{
		        	topSponsor+=100;
		        	sponsorsPanel.body.scroll('b',100,true);
	        	}
	    	},
    	    interval: 2000
    	}
        Ext.TaskMgr.start(eventTask);
        return temp;
    }
    else
        return eventsPanel;
        
}


