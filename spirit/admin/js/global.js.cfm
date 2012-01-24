// JavaScript Document

var j = jQuery.noConflict();

j(function(){
	
});

function safariSearch(){
	if(j.browser.safari){
		j("input.search").attr("type", "search").attr("placeholder", "Search").attr("results", 10);
	}
}

function go (u){
	document.location = u;
}

function refresh(){
    document.location.reload(false);
}

function uid() {
	return new Date().getTime();
}

function filter (input, container){
	var regExp = new RegExp(j(input).val(), "i");
	j(container).each(function(i){
		var t = j(this);
		var txt = t.text();
		if (txt.length && txt.search(regExp) != -1){
			t.fadeIn(200);
		}
		else {
			t.fadeOut(200);
		}
	});
}

function setCookie(c_name,value,expiredays){
	var exdate=new Date();
	exdate.setDate(exdate.getDate()+expiredays);
	document.cookie=c_name+ "=" +escape(value)+((expiredays==null) ? "" : ";  path=/; expires="+exdate.toGMTString());
}
function getCookie(c_name){
	if (document.cookie.length>0){
	c_start=document.cookie.indexOf(c_name + "=");
		if (c_start!=-1){
			c_start=c_start + c_name.length+1;
			c_end=document.cookie.indexOf(";",c_start);
			if (c_end==-1) c_end=document.cookie.length;
			return unescape(document.cookie.substring(c_start,c_end));
   		}
	}
	return "";
}
function checkCookie(c_name){
	var с = getCookie(c_name);
	if(getCookie(c_name).length)
		return true;
	else
		return false;
}