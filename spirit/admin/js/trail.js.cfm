var trail = j('<div id="pre">Loading...</div>');
j(
	function(){
		trail.appendTo("body");
		hideTrail();
		
		jQuery().ajaxStart(function() {
			showTrail();
		}).ajaxStop(function() {
			hideTrail();
		});
		
		j(document).bind("mousemove", function(e) {
			trail.css("left", e.pageX + 12 + "px");
			trail.css("top", e.pageY + 12 + "px");
		});
	}
);
showTrail = function (){
	trail.show();	
}

hideTrail = function (){
	trail.hide();
}