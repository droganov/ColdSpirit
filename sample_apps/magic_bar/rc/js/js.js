var j = jQuery.noConflict();

// partner
j(function(){
	var form = j("#partnerForm");
	var rules = j("#rules");
	var rulesVisible = form.find(".formShow");
	var rulesHidden = form.find(".formHide");
	
	rules.click(function(e){
		clickRules();
	});
	
	function clickRules(){
		var result = rules.is(":checked");
		result
			? rulesVisible.fadeOut("fast", function(){rulesHidden.fadeIn("fast")})
			: rulesHidden.fadeOut("fast", function(){rulesVisible.fadeIn("fast")});
	}
	
	j("#locationSuggest").click(function(e){
		var t = j(this);
		j("#locationLabel").val(t.text());
		j("#locationRoute").val(t.attr("href"));
		e.preventDefault();
	});
	clickRules();
});