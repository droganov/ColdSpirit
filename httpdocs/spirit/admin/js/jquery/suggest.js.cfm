jQuery.fn.extend({
	suggest: function(r, o) {
		if(!o)
			var o = new Object();
		if(!o.hoverClass)
			o.hoverClass = "hover";
		if(!o.selectedClass)
			o.selectedClass = "selected";
		if(!o.callBack){
			o.callBack = function(){}
		}	
  		return this.each(
			function(i) {
				var t = jQuery(this);
				var input = jQuery("input:visible", t).attr("autocomplete", "off");
				var region = jQuery(r, t);
				var item = jQuery(r + " div");
				var highlightItem = function (i) {
					item.removeClass(o.hoverClass);
					jQuery(item[i]).addClass(o.hoverClass);
				}
				var selectItem = function (i) {
					var currentItem = jQuery(item[i]);
					var v = currentItem.text();
					item.removeClass(o.hoverClass).removeClass(o.selectedClass);
					currentItem.addClass(o.selectedClass);
					input.val(v);
					
					o.callBack(v, currentItem);
				}
				var filter = function (v){
					if(v.length){
						item.each(function(){
							var currentItem = jQuery(this);
							var regExp = new RegExp(v, "i");
							var myValue = currentItem.text();
							if(v == myValue){
								item.show();
								return false;
							}
							
							if(myValue.search(regExp) >= 0)
								currentItem.show();
							else
								currentItem.hide();
						});
					}
					else{
						item.show();
					}
				}
				var getHighlightedItem = function(){
					var myResult = -1;
					item.each(function(i){
						if(jQuery(this).is("." + o.hoverClass)){
							myResult = i;
							return false;
						}
					});
					return myResult;
				}
				var getPrevVisibleItem = function(n){
					var i;
					for (i = n; i >= 0; i--) {
						var currentItem = jQuery(item[i]);
						if(currentItem.is(":visible"))
							return i;
					}
					for (i = item.length - 1; i >= 0; i--) {
						var currentItem = jQuery(item[i]);
						if(currentItem.is(":visible"))
							return i;
					}
					return 0;
				}
				var getNextVisibleItem = function(n){
					var i;
					for(i = n + 1; i < item.length; i++){
						var currentItem = jQuery(item[i]);
						if(currentItem.is(":visible"))
							return i;
					}
					for(i = 0; i < n; i++){
						var currentItem = jQuery(item[i]);
						if(currentItem.is(":visible"))
							return i;
					}
					return 0;
				}
				
				input.keyup(function(event){
					filter(input.val());
					switch(event.keyCode){
					case 13:
						var i = getHighlightedItem();
						if(i >= 0)
							selectItem(getHighlightedItem());
						break;
					case 38:
						highlightItem(getPrevVisibleItem(getHighlightedItem() - 1));
						break;
					case 40:
						highlightItem(getNextVisibleItem(getHighlightedItem()));
						break;
					}
				}).change(function(){
					filter(input.val());
				});
				
				item.each(function(i){
					jQuery(this).click(function(){
						selectItem(i);
					}).hover(function(){
						highlightItem(i);
					},
						function(){
							jQuery(this).removeClass(o.hoverClass);
						}
					);
				});
			}
		);
	}
});