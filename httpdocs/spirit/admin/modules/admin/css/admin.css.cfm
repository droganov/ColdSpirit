<cfprocessingdirective pageEncoding="utf-8" /><cfcontent type="text/css" />@charset "UTF-8";
/* CSS Document */
#files {
	overflow: auto;
	max-height: 300px;
}
.absolute {
	position:absolute;
}

.bar, .yellowBar {
	position: absolute;
	width:5px;
	height:31px;
	top:5px;
	left:0;
	overflow:hidden;
	background:url(../../../f.cfm?f=modules/admin/images/bg/c_routes.png.cfm) repeat-x 0px 5px;
}
.blue{
	color:#517FC9;
}
.yellowBar {
	background:url(../../../f.cfm?f=modules/admin/images/bg/c_actions.png.cfm) repeat-x 0px 5px;
}
body{
}
.green {
	color:#409E7A;
}
#canvas {
	position:relative;
	overflow:hidden;
}
#views	{
	padding:1px;
	position:relative;
}
#trace{
	position:absolute;
	bottom:0;
	left:0;
	z-index:2;
}
.views {
	padding-right:5px;
	background:url(../../../f.cfm?f=modules/admin/images/bg/c_routes.png.cfm) no-repeat 177px 5px;
}
.rc6{
	-moz-border-radius: 6px;
	-webkit-border-radius: 6px;
	-khtml-border-radius: 6px;
	border-radius: 6px;
}
.views .openView, .childView {
	width:175px;
	padding:.5em 0;
	
	border:1px solid #d3d3d3;
	
	background:#cdcdcd;
	background: -webkit-gradient(linear, left top, left bottom, from(#999), to(#fdfdfd));
	background: -moz-linear-gradient(top,  #999,  #fdfdfd);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#999999', endColorstr='#fdfdfd');
	
	text-align:center;
	position:relative;
}

.views .openView {
	margin-bottom:10px;
}
.childView {
	margin-bottom:3px;
	position:relative;
}
.views .dragOver {
}

.addView {
	border:1px solid #c1c1c1;
	color:#fff;
	background:#4dab8d;
	width:4em;
	margin:0 auto;
	padding:.2em 0;
	font-size:80%;
}
span.addIcon {background:rgba(255, 255, 255, .3);color:#fff; padding:0 .3em;
	-moz-border-radius: 6px;
	-webkit-border-radius: 6px;
	-khtml-border-radius: 6px;
	border-radius: 6px;}
.addView:hover {border-color:#fff;}
.childView .dropLine, .startDrag .addView {
	display:none;
}


.startDrag div#menu, .startDrag div.noDropView, .startDragRouteTemplate .views, .startDragRouteTemplate #editView, .startDragRouteTemplate #menu {
	filter:alpha(opacity=10);
	-moz-opacity:.1;
	opacity:.1;
}

.deleteView{
	display:none;
	margin:0 2.7em;
}
.deleteView .bgDeleteView{
	border:1px solid #d3d3d3;
	background:#f37f7b;
	padding:2.7em 0;
	font-size:80%;
}
.dragOver .bgDeleteView{
	background:#f3463a;
}


.startDrag .deleteView{
	display:block;
}

.dropable{
//	outline: 1px dotted #409E7A;
}
.startDrag div.dropable {
/*	filter:alpha(opacity=100);
	-moz-opacity:1;
	opacity:1;
*/}
.dragOver .dropLine {
	width: 177px;
	height:5px;
	background:url(../../../f.cfm?f=modules/admin/images/bg/drop_me.gif.cfm) no-repeat;
	position:absolute;
	top:34px;
	display:block;
}

.views .hover {
	background:#b8b8b8;
	background: -webkit-gradient(linear, left top, left bottom, from(#686868), to(#fcfcfc));
	background: -moz-linear-gradient(top,  #686868,  #fcfcfc);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#686868', endColorstr='#fcfcfc');
}
.views .selected {
	background:#add6f5;
	background: -webkit-gradient(linear, left top, left bottom, from(#75a3c4), to(#fcfdff));
	background: -moz-linear-gradient(top,  #75a3c4,  #fcfdff);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#75a3c4', endColorstr='#fcfdff');
	border-color:#b3dcfb;
}


.hiddenView, .lockedView {
	filter:alpha(opacity=40);
	-moz-opacity:.40;
	opacity:.40;
}
.lockedView .locked {
	position:absolute;
	top:6px;
	left:6px;
}


.panel {width:357px; background:#c9c9c9; border:1px solid #d3d3d3;
	background:#cdcdcd;
	background: -webkit-gradient(
		linear,
		left top,
		left bottom,
		color-stop(0, rgb(153,153,153)),
		color-stop(0.12, rgb(201,201,201))
	);
	background: -moz-linear-gradient(top,  #999 0%,  #ececec 1.6em);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#999999', endColorstr='#ececec');
}
.panel .top{
	background:url(../../../f.cfm?f=modules/admin/images/bg/panel_top.png.cfm);
	height:6px;
}
.panel .bottom {
	height:6px;
	background:url(../../../f.cfm?f=modules/admin/images/bg/panel_bottom.png.cfm);
}

.panel .blueDisplay {
	background:#D6DEE6;
}
.panel .blueDisplay .labels, .panel .yellowDisplay .labels {
	position:relative;
	top:-.5em;
	margin-left:10px; margin-bottom:-10px;
}

.panel .blueDisplay .labels div, .panel .yellowDisplay .labels div {
	display:inline;
}
.panel .blueDisplay .labels .options, .panel .blueDisplay .labels .states, .panel .blueDisplay .labels .add{
	background:#6394d3; color:#fff; border:1px solid rgba(0,0,0,.15);font-size:80%; padding:.2em .3em;
}
.options, .panel .blueDisplay .labels .states{background:#f1e27b; color:#000;}
.options, .panel .blueDisplay .labels .add{background:#4dac8d; color:#fff;}
.options, .panel .blueDisplay .labels .add:hover{border:1px solid rgba(0,0,0,.45);}
.panel input[type=submit]{
	background:#4dab8c; color:#fff; border:1px solid rgba(0,0,0,.15);font-size:80%; padding:.1em 1.5em;
}
.panel input[type=submit]:hover{border:1px solid rgba(0,0,0,.45)}
.panel input[type=submit]:active{position:relative; top:1px; left:1px;background;#439479;}
.panel .blueDisplay .hover {
	background:#f5f5dc;
}
.panel .blueDisplay .selected {
	background:#B8BFC7;
}
.panel .blueDisplay .hidden, .panel .blueDisplay .locked {
	filter:alpha(opacity=70);
	-moz-opacity:.70;
	opacity:.70;
}
.panel .blueDisplay .locked div.locked {
	margin-top:-1.1em;
	margin-bottom:.2em;
	margin-left:-15px;
}
.panel .yellowDisplay {
	position:relative;
	background:#f5f5dc;
}
.panel .yellowDisplay .tl {
	top:0;
	left:0;
	background:url(../../../f.cfm?f=modules/admin/images/bg/yellowDisplay_tl.png.cfm);
} 
.panel .yellowDisplay .tr {
	top:0;
	right:0;
	background:url(../../../f.cfm?f=modules/admin/images/bg/yellowDisplay_tr.png.cfm);
} 
.panel .yellowDisplay .bl {
	bottom:0;
	left:0;
	background:url(../../../f.cfm?f=modules/admin/images/bg/yellowDisplay_bl.png.cfm);
} 
.panel .yellowDisplay .br {
	bottom:0;
	right:0;
	background:url(../../../f.cfm?f=modules/admin/images/bg/yellowDisplay_br.png.cfm);
}

.panel .label {
	font-size:70%;
	text-align:right;
	width:50px;
}
.ot {
	top:-1.3em;
}
.small{
	font-size:70%;
}

div.visibility div {
	display:inline;
	padding:4px 10px;
	cursor:pointer;
	cursor:hand;
}


.panel .yellowDisplay .hover {
	background:#EDDD68;
}


div.visibility div.v_visible, div.visibility div.h_hidden, div.visibility div.l_locked, div.visibility div.active {
	background:#eddd68;
}


.p6_3 {
	padding:3px 6px;
}
.yellow {
	color:#EDDD68;
}