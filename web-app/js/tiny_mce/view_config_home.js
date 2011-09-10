tinyMCE.init({
      mode : "none",
     theme : "advanced",
     height: 200,
     readonly : true,
     setup: function (ed) {
    	 ed.onInit.add(function (ed, e) {
    		 $(ed.getDoc()).children().find('head').append('<style type="text/css">html { overflow:hidden;}.defaultSkin table.mceLayout tr.mceLast td { border:none;}.defaultSkin table.mceLayout tr.mceFirst td { border:none;}</style>');
    	 });
     }
});