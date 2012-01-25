<cfcomponent displayname="util" output="no">
	<cfscript>
		private string function getUrlRegEx(){
			return '(?ix)(((https?|ftp|gopher)://([^:]+\:[^@]*@)?)?([\d\w\-]+\.)?[\w\d\-\.]+\.[\w\d]+((/[\w\d\-@%]+)*(/([\w\d\.\_\-@]+\.[\w\d]+)?(\?[\w\d\?%,\.\/\##!@:=\+~_\-&]*(?<![\.]))?)?)?)';
		//	return '(?ix)(((https?)://([^:]+\:[^@]*@)?)([\d\w\-]+\.)?[\w\d\-\.]+\.(com|net|org|info|biz|tv|co\.uk|de|ro|it)((/[\w\d\.\-@%\\\/:]* )+)?(\?[\w\d\?%,\.\/\##!@:=\+~_\-&]*(?<![\.]))?)';
		}
		private string function fixUrlChit(string string){
			arguments.string = ReplaceNoCase(arguments.string, "http://http://", "http://", "All");
			arguments.string = ReplaceNoCase(arguments.string, "http://https://", "https://", "All");
			arguments.string = ReplaceNoCase(arguments.string, "http://ftp://", "ftp://", "All");
			return arguments.string;
		}
		public string function formatUrl(string string){
			var result = arguments.string.Trim().ReplaceAll(
				this.getUrlRegEx(),
				"http://$1"
			);
			return this.fixUrlChit(result);
		}
		
		function ActivateURL(string string, string target:"_self") {
		    var result = arguments.string.Trim().ReplaceAll(
				this.getUrlRegEx(),
				"<a href=""http://$1"" target=" & arguments.target & ">$1</a>"
			);
			return this.fixUrlChit(result);
		}
		
		function isURL(stringToCheck){
			var URLRegEx = "(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'"".,<>?«»]))";
		//	var URLRegEx = "https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?";
			return isValid("regex", stringToCheck, URLRegex);
		}
		
		function activateLinks( string ){
		    var stringLen = len( string );
		    var currentPosition = 1;
		    var urlArray = [];

		    while( currentPosition < stringLen )
		    {
		        rezArray = REFindNoCase( "(?i)\b((?:https?://|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'"".,<>?«»]))", arguments.string, currentPosition, true );

		        if( rezArray.len[1] != 0 ){
		            arrayAppend( urlArray, mid( string, rezArray.pos[1]-2, rezArray.len[1]+2 ) );
		            currentPosition = rezArray.pos[1] + rezArray.len[1];
		        } else {
		            currentPosition = stringLen;
		        }
		    }

		    for( i = 1; i <= arrayLen( urlArray ); i++ )
		    {
		        if( left( urlArray[i], 2 ) != '="' )
		        {
		            link = right( urlArray[i], len( urlArray[i] )-2 );
		            string = replace( string, link, '<a href="'& link &'">'& link &'</a>', "all" );
		        } else {
		            i++;
		        }
		    }

		    return string;
		}
		
		
	

		function extractUrls(String input) {
			
	        var result = CreateObject("java", "java.util.ArrayList");

	        var pattern = CreateObject("java", "java.util.regex.Pattern").compile(
	            "\\b(((ht|f)tp(s?)\\:\\/\\/|~\\/|\\/)|www.)" &
	            "(\\w+:\\w+@)?(([-\\w]+\\.)+(com|org|net|gov" & 
	            "|mil|biz|info|mobi|name|aero|jobs|museum" & 
	            "|travel|[a-z]{2}))(:[\\d]{1,5})?" &
	            "(((\\/([-\\w~!$+|.,=]|%[a-f\\d]{2})+)+|\\/)+|\\?|##)?" &
	            "((\\?([-\\w~!$+|.,*:]|%[a-f\\d{2}])+=?" &
	            "([-\\w~!$+|.,*:=]|%[a-f\\d]{2})*)" & 
	            "(&(?:[-\\w~!$+|.,*:]|%[a-f\\d{2}])+=?" & 
	            "([-\\w~!$+|.,*:=]|%[a-f\\d]{2})*)*)*" &
	            "(##([-\\w~!$+|.,*:=]|%[a-f\\d]{2})*)?\\b");

	        var matcher = pattern.matcher(input);
	        while (matcher.find()) {
	            result.add(matcher.group());
	        }

	        return result;
	    }
		
	</cfscript>
</cfcomponent>