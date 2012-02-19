// JavaScript Document
var lastId = "";
var r = "root";
var l1 = "edit";
var dsBaseURL = "modules/admin/ajax/data.cfm";
if(checkCookie("spiritDSLocation"))
	var ds = getCookie("spiritDSLocation");
else
	var ds = dsBaseURL;
var ds = dsBaseURL;

var canvas;
var preloader;
var arrange;
var routes;


// datasets
var	dsMyData			= new Spry.Data.XMLDataSet(ds, "/columns/column");
var	dsViews				= new Spry.Data.NestedXMLDataSet(dsMyData, "views/view");
var	dsViewStates		= new Spry.Data.NestedXMLDataSet(dsMyData, "states/state");
var	dsFiles				= new Spry.Data.NestedXMLDataSet(dsMyData, "files/file");
var	dsState			= new Spry.Data.NestedXMLDataSet(dsMyData, "state");
	
j().ready(function(){
	//containers
	canvas = j("#canvas");
	preloader = j("#pre").css({position:"absolute", top:0, left:0, background:"#517FC9", color:"#fff", padding:"5px", "z-index":3}).hide();
	routes = j("#views");
	
	dsMyData.addObserver(
		function myObserverFunc(notificationType, dataSet, data){
			if (notificationType == "onPreLoad"){
				preloader.show();
			}
			if (notificationType == "onDataChanged"){
				if(!canvas.is(':visible'))
					canvas.fadeIn();
				preloader.hide();
				arrange();
			}
		}
	);
	
	// events
	j(window).resize(function(){
		arrange();
	}).mousemove(function(e){
		preloader.css({left:e.pageX + 12 + "px", top:e.pageY + 12 + "px"});
	});
	arrange = function(){
		canvas.width(j(window).width() - 20); //.height(j(window).height() - 80)
		setTimeout(function(){
			var l = j("#views > table").width() - canvas.width();
			if (l < 0) l = 0;
		//	alert("rw: " + j("#views > table").width() + ", cw: " + canvas.width());
			canvas.scrollLeft(l);
		},10);
	}
	arrange();
});

function loadData(viewName, l1, l2, l3, l4){
	if(!l1) var l1 = "edit";
	if(!l2) var l2 = "";
	if(!l3) var l3 = "";
	if(!l4) var l4 = "";
	
	
	var dsUrl = dsBaseURL + "?v=" + viewName + "&l1=" + l1 + "&l2=" + l2 + "&l3=" + l3 + "&l4=" + l4 + "&rnd=" + uid();
	lastId = "";
	
	
	
	dsMyData.setURL(dsUrl);
	dsMyData.loadData();
	setCookie("spiritDSLocation", dsUrl);
}

function reLoadData(){
	var u = dsMyData.getURL().get();
	loadData(u.v, u.l1, u.l2, u.l3, u.l4);
}

function submitForm(form, callback, error){
	if(!callback)
		var callback = function(){};
	if(!error)
		var error = function(){};
	if(Spry.Widget.Form.validate(form)){
		Spry.Utils.submitForm(form, function(req){
			var r = req.xhRequest.responseText;
			if(parseInt(r)){
				callback(req);
			}
			else {
				error(r);
			}
		});
	}
	return false;
}

function createView(form){
	return submitForm(
		form,
		function(){
			loadData(j("input[@name='name']", j(form)).val(), 'edit');
		},
		function(r){
			j("#r1").addClass("textfieldCustomState");
			j("#r1 .textfieldCustomMsg").html(r);
		}
	);
}

function updateView(){
	j("#r1").removeClass("textfieldCustomState");
	return submitForm(
		document.getElementById('fUpdateView'),
		function(){
			var r = j("#r1 input[@name='name']").val();
			var o = j("#oldViewName").val();
			if(r != o){
				var l = lastId;
				var u = dsMyData.getURL().get();
				loadData(r, u.l1, u.l2, u.l3, u.l4);
				lastId = l;
			}
		},
		function(r){
			j("#r1").addClass("textfieldCustomState");
			j("#r1 .textfieldCustomMsg").html(r);
		}
	);
}

function moveView(viewName, targetViewName, placeAfter) {
	j.post("modules/admin/form/save.cfm?a=moveView", {
		viewName: viewName,
		targetViewName: targetViewName,
		placeAfter: placeAfter
		}, function(result){
			enableChildren();
			j(".dropView").droppable("destroy");
			if(parseInt(result)){
				reLoadData();
			}
			else{
				alert(result);
			}
	})
}

function disableChildren(viewName){
	var viewName = viewName.trim();
	var trigger = false;
	//j("#trace").html(j("#views div.openView").length + " sss");
	j("#views div.openView").each(function(){
		if(viewName == j(this).text().trim())
			trigger = true;
		if(trigger){
			j(this).removeClass("dropView").addClass("noDropView");
			j("div.childView", j(this).parent()).removeClass("dropView").addClass("noDropView");
		}
	});
}

function enableChildren(){
	j("#views div.openView").addClass("dropView").removeClass("noDropView");
	j("#views div.childView").addClass("dropView").removeClass("noDropView");
}


function getActiveViewName(){
	var o = dsMyData.getURL().get();
	return o.v;
}

function getViewByName(view) {
	var view = view.trim();
	var result;
	j("#views div.childView").each(function(){
		var cr = j(this);
		if (view == cr.text().trim()){
			result = cr;
			return false;
		}
	});
	return result;
}

function getParentView(view){
	return j("div.openView", getViewByName(view).parent().parent());
}

function getParentViewName(view){
	var viewName = getParentView(view).text().trim();
	return(viewName);
}

function deleteView(view){
	var view = view.trim();
	if(confirm("Delete view? You can not undo this action.")){
		j.post("modules/admin/form/save.cfm?a=deleteView", {
			viewName: view
			}, function(result){
				j("div").droppable("destroy");
				if(result == "ok"){
					if(getViewByName(view).is(".selected"))
						loadData(getParentViewName(view));
					else	
						reLoadData();
				}
				else{
					alert(result);
				}
		})
	}
}
function deleteState(viewName, stateName){
	var viewName = viewName.trim();
	var stateName = stateName.trim();
	if(confirm("Delete state? You can not undo this action.")){
		j.post("modules/admin/form/save.cfm?a=deleteState", {
			viewName: viewName,
			stateName: stateName
			}, function(result){
				j("div").droppable("destroy");
				if(parseInt(result)) {
					if(j("#editStateName").text().trim() == stateName) loadData(viewName);
					else reLoadData();
				}
				else alert(result);
		})
	}
}
function moveState(viewName, stateName1, stateName2){
	var viewName = viewName.trim();
	var stateName1 = stateName1.trim();
	var stateName2 = stateName2.trim();
	j.post("modules/admin/form/save.cfm?a=moveState", {
		viewName: viewName,
		stateName1: stateName1,
		stateName2: stateName2
		}, function(result){
			j("div").droppable("destroy");
			if(parseInt(result)) {
				reLoadData();
			}
			else alert(result);
	})
}

function setViewTemplate(){
	return submitForm(
		document.getElementById('fSuggestTemplate'),
		function(){
			var u = dsMyData.getURL().get();
			loadData(u.v);
		},
		function(r){
			alert(r);
		}
	);
}

function addViewTemplate(form){
	return submitForm(
		form,
		function(){
			var u = dsMyData.getURL().get();
			loadData(u.v);
		},
		function(r){
			alert(r);
		}
	);
}

function setViewAlias(form){
	return submitForm(
		document.getElementById('fSuggestAlias'),
		function(){
			var u = dsMyData.getURL().get();
			loadData(u.v);
		},
		function(r){
			alert(r);
		}
	);
}

function setVisibility (visibility, type){
	if(!type)
		var target = "#routeVisibility";
	if (type == "state")
		var target = "#stateVisibility";
	j(target + " div").attr("class", "rc6");
	j(target + " input").val(visibility);
	j(target + " div span").each(function(i){
		if (j(this).text() == visibility){
			j(this).parent().addClass("active");
		}
	})
}

function addState(form){
	return submitForm(
		form,
		function(req){
			var u = dsMyData.getURL().get();
			loadData(u.v, 'edit', 'state', j("#stateName").val());
		},
		function(r){
			j("#a1").addClass("textfieldCustomState");
			j("#a1 .textfieldCustomMsg").html(r);
		}
	);
}

function updateState(){
	var name = j("#stateName").val();
	var oldName = j("#stateOldName").val();
	//alert(name + " _ " + oldName);
	return submitForm(
		document.getElementById('fUpdateState'),
		function(){
			var u = dsMyData.getURL().get();
			loadData(u.v, 'edit', 'state', name, u.v4);
		},
		function(r){
			j("#stateOldName").val(oldName);
			j("#a1").addClass("textfieldCustomState");
			j("#a1 .textfieldCustomMsg").html(r);
		}
	);
}

function setStateTemplate(v){
	return submitForm(
		document.getElementById('suggestState'),
		function(){
			var u = dsMyData.getURL().get();
			var chromeTimeoout = setTimeout(function(){loadData(u.v, 'edit', 'state', u.l3)}, 100);
		},
		function(r){
			alert(r);
		}
	);
}

function createStateTemplate(){
	return submitForm(
		document.getElementById('createStateTemplate'),
		function(r){
			var u = dsMyData.getURL().get();
			loadData(u.v, 'edit', 'state', j("#stateName").val(), u.v4);
		},
		function(r){
			alert(r);
		}
	);
}



function setExitState(form){
	return submitForm(
		document.getElementById('fSuggestExitState'),
		function(e){
			var u = dsMyData.getURL().get();
			loadData(u.v, 'edit', 'state', u.l3);
		},
		function(r){
			alert(r);
		}
	);
}

function isValidViewName(v){
	var regExp = new RegExp("^[a-zA-Z0-9_|-]+$", "i");
	return regExp.test(v);
}
function isValidTemplateName(v){
	var regExp = new RegExp("^[a-zA-Z0-9_-]+\.{1}(cfm|cfml|cfc)$", "i");
	return regExp.test(v);
}

String.prototype.get = function() {
	var r = {};
	var s = this;
	var q = s.substring(s.indexOf('?') + 1); // remove everything up to the ?
	q = q.replace(/\&$/, ''); // remove the trailing &
	jQuery.each(q.split('&'), function() {
		var splitted = this.split('=');
		var key = splitted[0];
		if(splitted.length > 1)
			var val = splitted[1];
		else
			var val = "";
		if (/^[0-9.]+$/.test(val)) val = parseFloat(val); 	// convert floats
		if (typeof val == 'number' || val.length > 0) r[key] = val; // ignore empty values
	});
	return r;
};
String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g,"");
}
