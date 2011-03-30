/*!
 * Ext JS Library 3.1.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.Desktop = function(app){
	
    var desktopEl = Ext.get('x-desktop');
    var shortcuts = Ext.get('x-shortcuts');

    var windows = new Ext.WindowGroup();
    var activeWindow;
		
    function minimizeWin(win){
        win.minimized = true;
        win.hide();
    }

    function markActive(win){
        if(activeWindow && activeWindow != win){
            markInactive(activeWindow);
        }       
        activeWindow = win;       
        win.minimized = false;
    }

    function markInactive(win){
        if(win == activeWindow){
            activeWindow = null;          
        }
    }

    function removeWin(win){  
    	//TODO RAY: Temp Fix to stop News Running Task
    	//Might not be good to stop all running task.
    	//Best to stop one specific task
    	//Ext.TaskMgr.stopAll();
    	layout();
        
    }

    function layout(){
        desktopEl.setHeight(Ext.lib.Dom.getViewHeight());
    }
    Ext.EventManager.onWindowResize(layout);

    this.layout = layout;

    this.createWindow = function(config, cls){
    	var win = new (cls||Ext.Window)(
            Ext.applyIf(config||{}, {
                manager: windows,
                minimizable: false,
                maximizable: true
            })
        );
        win.render(desktopEl);
        

        win.cmenu = new Ext.menu.Menu({
            items: [

            ]
        });

      
        
        win.on({
        	'activate': {
        		fn: markActive
        	},
        	'beforeshow': {
        		fn: markActive
        	},
        	'deactivate': {
        		fn: markInactive
        	},
        	'minimize': {
        		fn: minimizeWin
        	},
        	'close': {
        		fn: removeWin
        	}
        });
        
        layout();
        return win;
    };

    this.getManager = function(){
        return windows;
    };

    this.getWindow = function(id){
        return windows.get(id);
    }
    
    this.getWinWidth = function(){
		var width = Ext.lib.Dom.getViewWidth();
		return width < 200 ? 200 : width;
	}
		
	this.getWinHeight = function(){
		var height = (Ext.lib.Dom.getViewHeight());
		return height < 100 ? 100 : height;
	}
		
	this.getWinX = function(width){
		return (Ext.lib.Dom.getViewWidth() - width) / 2
	}
		
	this.getWinY = function(height){
		return (Ext.lib.Dom.getViewHeight()- height) / 2;
	}

    layout();

    if(shortcuts){
        shortcuts.on('click', function(e, t){
            if(t = e.getTarget('dt', shortcuts)){
                e.stopEvent();
                var module=null;
                if (t.id.match("pub-win"))
                {
                  module = app.getModule("pub-win");
                  if(module){
                    module.createWindow(t.id.substr(8,1));
                  }
                }
                else
                {
                   module= app.getModule(t.id.replace('-shortcut', ''));
                   if(module){
                    module.createWindow();
                   }
                }                                
            }
        });
    }
};
