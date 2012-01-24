// JavaScript Document



var menu;

j("#spiritMenu").ready(function(){
	menu = this;
	
	menu.posx = function () {
		var x = (j(window).width() / 2) - (j("#spiritMenu").width() / 2);
		if (x < 0)
			x = 0;
		j("#spiritMenu").css("left", x);
	}
	
	
	
	j("#spiritMenu td.mi_false").mouseover(function(){
		j(this).addClass("hover");
	});
	j("#spiritMenu td.mi_false").mouseout(function(){
		j(this).removeClass("hover");
	});
	
	menu.posx();
});

j(window).resize(function(){
	menu.posx();
});