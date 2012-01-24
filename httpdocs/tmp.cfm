<style type="text/css" media="screen">
	.bg {position:relative; margin:auto; width:65%; height:100px; overflow:hidden;}
	.bg div.item {position:absolute;  width:100%; height:100px; text-align:center; left:0; display:none;
		-webkit-transition: left 250ms cubic-bezier(0.390, 0.015, 0, 1);
		-moz-transition: left 250ms cubic-bezier(0.390, 0.015, 0, 1);
		-o-transition: left 250ms cubic-bezier(0.390, 0.015, 0, 1);
		-ms-transition: left 250ms cubic-bezier(0.390, 0.015, 0, 1);
		transition: left 250ms cubic-bezier(0.390, 0.015, 0, 1);
	}
	.bg div.label{background:#fff; position:relative; top:2em; width:1.3em; margin:auto; padding:10px; 
		-khtml-border-radius:20px; -moz-border-radius: 20px; -webkit-border-radius: 20px; border-radius: 20px;}
	.ready div.item{display:block;}
	.ctrl {text-align:center; margin-top:1em;}
	.bg div.before {left:-100%;}
	.bg div.after {left:100%;}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8">//<![CDATA[
	var j = jQuery.noConflict();
	j(function(){
		var gallery = j("#bg > div").data("currentItem", 0);
		var defaultItem = 0;
		init(defaultItem);
		
		var moveMe = function(e) {  
		  e.preventDefault();  
		  var orig = e.originalEvent;  
		  j(this).css({
		    left: orig.changedTouches[0].pageX - j(this).offset().left
		  });  
		};
		
		gallery.bind("touchstart touchmove", moveMe);  
		/*
		gallery.bind('touchstart',function(e){
			var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
			var elm = j(this).offset();
			var x = touch.pageX - elm.left;
			if(x < j(this).width() && x > 0){
				j(this).data("xStrart", x);
			}
			e.preventDefault();
		});
		
		gallery.bind('touchmove',function(e){
			e.preventDefault();
			var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
			var elm = j(this).offset();
			var x = touch.pageX - elm.left;
			if(x < j(this).width() && x > 0){
				var t = j(this);
				var offset = x - t.data("xStrart");
				t.css("left", x + "px");
				t.find("div.label").text(offset);
			}
		});
		*/
		
		function init(i){
			j(gallery[i]).css('zIndex', gallery.length);
			j("#bg > div:gt(" + i + ")").removeClass("before").addClass("after");
			j("#bg > div:lt(" + i + ")").removeClass("after").addClass("before");
			j("#bg").addClass("ready");
		}
		
		function openItem(i){
			var item = i > 0 ? i : 0;
			var item = item < gallery.length ? item : gallery.length - 1;
			
			for (var i=0; i < gallery.length; i++) {
				var currentItem = j(gallery[i]);
				if(i < item){
					currentItem.removeClass("after").addClass("before");
				}
				else if (i > item){
					currentItem.removeClass("before").addClass("after");
				}
				else{
					currentItem.removeClass("before").removeClass("after").css('zIndex', 1);
				}
			};
			gallery.data("currentItem", item);
		}
		function prev(){
			openItem(gallery.data("currentItem")-1);
		}
		function next(){
			openItem(gallery.data("currentItem")+1);
		}
		
		j("div.ctrl > a:first").click(function(e){
			prev();
			e.preventDefault();
		});
		j("div.ctrl > a:last").click(function(e){
			next();
			e.preventDefault();
		});
		
		j("#bg").click(function(e){
			next();
			e.preventDefault();
		});
	});
//]]></script>
<body id="tmp">
	<cfoutput>
	<div id="bg" class="bg">
		<cfloop index="o" from="1" to="100">
			<div class="item" style="background:###returnRandomHEXColors()#"><div class="label">#o#</div></div>
		</cfloop>
	</div>
	</cfoutput>
	<div class="ctrl">
		<a href="tuda">Туда</a> | <a href="suda">Сюда</a>
	</div>
	
</body>
<cfscript>
    function returnRandomHEXColors(numToReturn:1){

        var returnList = ""; // define a clear var to return in the end with a list of colors
        var colorTable = "A,B,C,D,E,F,0,1,2,3,4,5,6,7,8,9"; // define all possible characters in hex colors

        // loop through and generate as many colors as defined by the request
        for (i=1; i LTE val(numToReturn); i=i+1){
            // clear the color list
            tRandomColor = "";
            for(c=1; c lte 6; c=c+1){
            // generate a random (6) character hex code
            tRandomColor = tRandomColor & listGetAt(colorTable, randRange(1, listLen(colorTable)));
        }    

        // append it to the list to return in the end
        returnList = listAppend(returnList, tRandomColor);
    
        }    
        // return the list of random colors
        return returnList;

    }
</cfscript>