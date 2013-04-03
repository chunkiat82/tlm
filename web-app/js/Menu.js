Ext.onReady(function() {
	Ext.QuickTips.init();

	var tb = new Ext.Toolbar();
	tb.render('toolbar');

	tb.add( {
		text : 'Home',
		iconCls : 'homeicon',
		listeners : {
			click : function() {
				home();
			}
		}
	});
	tb.addSeparator();
	tb.add( {
		text : 'RSS Feed',
		iconCls : 'rssIcon',
		listeners : {
			click : function() {
				openWindowLocation(urlPath + 'rss');
			}
		}
	});
	tb.addSeparator();
	tb.add( {
		iconCls : 'pubsicon',
		text : 'About Publications',
		menu : {
			items : [ {
				text : 'SEA Building',
				iconCls : 'seabIcon',
				listeners : {
					click : function() {
						openPublications(6);
					}
				}
			}, {
				text : 'SEA Construction',
				iconCls : 'seacIcon',
				listeners : {
					click : function() {
						openPublications(7);
					}
				}
			}, {
				text : 'Security Solutions Today',
				iconCls : 'sstIcon',
				listeners : {
					click : function() {
						openPublications(5);
					}
				}
			}, {
				text : 'Bathroom + Kitchen Today',
				iconCls : 'bktIcon',
				listeners : {
					click : function() {
						openPublications(1);
					}
				}
			}, {
				text : 'Lighting Today',
				iconCls : 'ltIcon',
				listeners : {
					click : function() {
						openPublications(4);
					}
				}
			}, {
				text : 'Light Audio-Visual Asia',
				iconCls : 'lstIcon',
				listeners : {
					click : function() {
						openPublications(8);
					}
				}
			} ]
		}

	});
	tb.addSeparator();
	tb.add( {
		iconCls : 'pdficon',
		text : 'Download Issues',
		menu : {
			items : [ {
				text : 'SEA Building',
				iconCls : 'seabIcon',
				listeners : {
					click : function() {
						openDownloads(6);
					}
				}
			}, {
				text : 'SEA Construction',
				iconCls : 'seacIcon',
				listeners : {
					click : function() {
						openDownloads(7);
					}
				}
			}, {
				text : 'Security Solutions Today',
				iconCls : 'sstIcon',
				listeners : {
					click : function() {
						openDownloads(5);
					}
				}
			}, {
				text : 'Bathroom + Kitchen Today',
				iconCls : 'bktIcon',
				listeners : {
					click : function() {
						openDownloads(1);
					}
				}
			}, {
				text : 'Concrete Technology Today',
				iconCls : 'cttIcon',
				listeners : {
					click : function() {
						openDownloads(2);
					}
				}
			}, {
				text : 'Lighting Today',
				iconCls : 'ltIcon',
				listeners : {
					click : function() {
						openDownloads(4);
					}
				}
			}, {
				text : 'Light Audio-Visual Asia',
				iconCls : 'lstIcon',
				listeners : {
					click : function() {
						openDownloads(8);
					}
				}
			} ]
		}
	});
	tb.addSeparator();
	tb.add( {
		text : 'Subscription Form',
		iconCls : 'pdficon',
		listeners : {
			click : function() {
				openWindowLocation('/images/subpdf.pdf');
			}
		}
	});
	tb.addSeparator();
	tb.add( {
		text : 'Terms of Use',
		iconCls : 'pubsicon',
		listeners : {
			click : function() {
				openWindowLocation(urlPath + 'terms.html');
			}
		}
	});
	tb.addSeparator();
	tb.add( {
		text : 'Privacy Policy',
		iconCls : 'pubsicon',
		listeners : {
			click : function() {
				openWindowLocation(urlPath + 'privacy.html');
			}
		}
	});
	tb.addFill();
	/*
	 * tb.add({ text:'Login', iconCls: 'loginicon', listeners:{ click:function() {
	 * openLogin(); } } });
	 */

	tb.doLayout();
});
