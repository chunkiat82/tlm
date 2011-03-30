/*!
 * Ext JS Library 3.1.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */

// Sample desktop configuration
MyDesktop = new Ext.app.App({
	init :function(){
		Ext.QuickTips.init();
	},

	getModules : function(){
		return [
                          new MyDesktop.PublicationWindow(),
                          new MyDesktop.SupplierWindow(),
                          new MyDesktop.EventWindow(),
                          new MyDesktop.DownloadWindow(),
                          new MyDesktop.LoginWindow(),
                          new MyDesktop.AboutUsWindow(),
                          new MyDesktop.IndustrialLinkWindow()
                          
		];
	}
});

