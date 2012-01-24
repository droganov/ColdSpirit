jQuery.fn.extend({
	hint: function(hintClass) {
		if (!hintClass) hintClass = 'hint';
	    return this.each(function () {
	        var input = jQuery(this);
			var title = input.attr('title');
	        var form = jQuery(this.form);
	        var win = jQuery(window);
	
			if(!title.length) title = "Search";
			
			var init = function(){
				
			}
	        var remove = function() {
	            if (this.value === title && input.hasClass(hintClass)) {
	                input.val('').removeClass(hintClass);
	            }
	        }
	        if (title) {
	            input.blur(function () {
	                if (this.value === '') {
	                    input.val(title).addClass(hintClass);
	                }
	            }).focus(remove);
	
				// if(!input.is(":focus")){
				// 	
				// }
				// alert(input.is(":focus"));
	            form.submit(remove);
	            win.unload(remove);
	        }
	    });
	}
});