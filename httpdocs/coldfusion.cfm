{	scopeName = 'text.html.cfm';
	firstLineMatch = '<!DOCTYPE|<(?i:html)';
	fileTypes = ( 'cfm', 'cfml', 'cfc' );
	foldingStartMarker = '(?x) 
		(<(?i:head|body|table|thead|tbody|tfoot|tr|div|select|fieldset|style|script|ul|ol|form|dl|cfloop|cfif|cfswitch|cfcomponent|cffunction|cfcase|cfdefaultcase|cfsavecontent|cfscript)\b.*?> 
		        |<!---(?!.*---\s*>)|\{\s*$
		        )';
	foldingStopMarker = '(?x) 
		(</(?i:head|body|table|thead|tbody|tfoot|tr|div|select|fieldset|style|script|ul|ol|form|dl|cfloop|cfif|cfswitch|cfcomponent|cffunction|cfcase|cfdefaultcase|cfsavecontent|cfscript)> 
		        |^(?!.*?<!---).*?---\s*>|^\s*\}
		        )';
	patterns = (
	    {	name = 'invalid.illegal.incomplete.cfml';
			match = '<(cf|CF)[\W]*>';
		},
		{	include = '#tag-finder'; },
		{	name = 'comment.block.cfml';
			begin = '/\*';
			end = '(\*/|(?=</script))';
			captures = { 0 = { name = 'punctuation.definition.comment.js'; }; };
		},
		{	name = 'meta.tag.preprocessor.xml.html';
			begin = '<\?(xml)';
			end = '\?>';
			captures = { 1 = { name = 'entity.name.tag.xml.html'; }; };
			patterns = (
				{	include = '#tag-generic-attribute'; },
				{	include = '#string-double-quoted'; },
				{	include = '#string-single-quoted'; },
			);
		},
		{	include = '#cfcomment'; },
		{	include = '#htmlcomment'; },
		{	name = 'meta.tag.sgml.html';
			begin = '<!';
			end = '>';
			patterns = (
				{	name = 'meta.tag.sgml.doctype.html';
					begin = '(DOCTYPE)';
					end = '(?=>)';
					captures = { 1 = { name = 'entity.name.tag.doctype.html'; }; };
					patterns = (
						{	name = 'string.quoted.double.doctype.identifiers-and-DTDs.html';
							match = '"[^">]*"';
						},
					);
				},
				{	name = 'constant.other.inline-data.html';
					begin = '\[CDATA\[';
					end = ']](?=>)';
				},
			);
		},
		{	include = '#coldfusion-script'; },
		{	include = '#cffunction'; },
		{	name = 'source.css.embedded.html';
			begin = '(?:^\s+)?<((?i:style))\b(?![^>]*/>)';
			end = '</((?i:style))>(?:\s*\n)?';
			captures = { 1 = { name = 'entity.name.tag.style.html'; }; };
			patterns = (
				{	include = '#tag-stuff'; },
				{	begin = '>';
					end = '(?=</(?i:style))';
					patterns = ( { include = 'source.css'; } );
				},
			);
		},
		{	name = 'source.sql.embedded.html';
			begin = '(?:^\s+)?<((?i:cfquery))\b(?![^>]*/>)';
			end = '</((?i:cfquery))>(?:\s*\n)?';
			captures = { 1 = { name = 'entity.name.tag.script.html'; }; };
			patterns = (
				{	include = '#tag-stuff'; },
				{	begin = '>';
					end = '(?=</(?i:cfquery))';
					patterns = ( { include = 'source.sql'; } );
				},
			);
		},
		{	name = 'source.js.embedded.html';
			begin = '(?:^\s+)?<((?i:script))\b(?![^>]*/>)';
			end = '(?<=</(script|SCRIPT))>(?:\s*\n)?';
			captures = { 1 = { name = 'entity.name.tag.script.html'; }; };
			patterns = (
				{	include = '#tag-stuff'; },
				{	begin = '(?<!</(?:script|SCRIPT))>';
					end = '</((?i:script))';
					patterns = (
						{	name = 'comment.line.double-slash.js';
							match = '//.*?((?=</script)|$\n?)';
						},
						{	name = 'comment.block.js';
							begin = '/\*';
							end = '\*/|(?=</script)';
						},
						{	include = 'source.js'; },
					);
				},
			);
		},
		
		
		{	name = 'source.cfscript';
			begin = '</?cfscript.+?';
			end = '>';
			beginCaptures = {
				1 = { name = 'punctuation.definition.tag.html'; };
				2 = { name = 'entity.name.tag.script.html'; };
			};
			endCaptures = { 2 = { name = 'punctuation.definition.tag.html'; }; };
			patterns = (
				{	include = '#cf-tag-stuff'; },
				{	name = 'comment.line.double-slash.js';
					match = '(//).*?((?=</script)|$\n?)';
					captures = { 1 = { name = 'punctuation.definition.comment.js'; }; };
				},
				{	name = 'comment.block.js';
					begin = '/\*';
					end = '\*/|(?=</cfscript)';
					captures = { 0 = { name = 'punctuation.definition.comment.js'; }; };
				},
				{	include = 'source.js'; },
			);
		},
		{	name = 'component.source.coldfusion.embedded.html';
			begin = 'component\b[^{]*{';
			end = '}$';
			patterns = ( { include = 'source.java'; } );
		},
		{	name = 'meta.tag.structure.any.html';
			begin = '</?((?i:body|head|html)\b)';
			end = '>';
			captures = { 1 = { name = 'entity.name.tag.structure.any.html'; }; };
			patterns = ( { include = '#tag-stuff'; } );
		},
		{	name = 'meta.tag.block.any.html';
			begin = '</?((?i:address|blockquote|dd|div|dl|dt|fieldset|form|frame|frameset|h1|h2 |h3|h4|h5|h6|iframe|noframes|object|ol|p|ul|applet|center|dir|hr|menu|pre)\ b)';
			end = '>';
			captures = { 1 = { name = 'entity.name.tag.block.any.html'; }; };
			patterns = ( { include = '#tag-stuff'; } );
		},
		{	name = 'meta.tag.any.cfm';
			begin = '</?cf.+?';
			end = '>';
			captures = { 1 = { name = 'entity.name.tag.block.any.html'; }; };
			patterns = (
			    { include = '#tag-stuff'; },
				{	include = '#cf-tag-stuff'; }
			);
		},
		{	name = 'meta.tag.inline.any.html';
			begin = '</?((?i:a|abbr|acronym|area|b|base|basefont|bdo|big|br|button|caption|cite |code|col|colgroup|del|dfn|em|font|head|html|i|img|input|ins|isindex|kbd|la bel|legend|li|link|map|meta|noscript|optgroup|option|param|q|s|samp|script| select|small|span|strike|strong|style|sub|sup|table|tbody|td|textarea|tfoot |th|thead|title|tr|tt|u|var)\b)';
			end = '>';
			captures = { 1 = { name = 'entity.name.tag.inline.any.html'; }; };
			patterns = ( { include = '#tag-stuff'; } );
		},
		{	name = 'meta.tag.other.html';
			begin = '</?([a-zA-Z0-9:]+)';
			end = '>';
			captures = { 1 = { name = 'entity.name.tag.other.html'; }; };
			patterns = ( { include = '#tag-stuff'; } );
		},
		{	include = '#entities'; },
		{	name = 'invalid.illegal.incomplete.html';
			match = '<>';
		},
		{	name = 'invalid.illegal.bad-angle-bracket.html';
			match = '<(?=\W)|>';
		},
		
	);
	bundleUUID = '1A09BE0B-E81A-4CB7-AF69-AFC845162D1g';
	repository = {
	    cf-tag-stuff = {
	        name = 'meta.tag.any.cfm';
			patterns = (
				{	include = '#tag-id-attribute'; },
				{	include = '#cf-string-double-quoted'; },
				{	include = '#string-single-quoted'; },
				{	include = '#embedded-code'; },
				{	include = '#coldfusion-script'; },
				{	include = '#cf-tag-generic-attribute'; },
			);
		};
		cfcomment = {
			name = 'comment.block.cfm';
			begin = '<!---';
			end = '---\s*>';
			patterns = (
				{	name = 'invalid.illegal.bad-comments-or-CDATA.html';
					match = '---';
				},
			);
		};
		cffunction = {
			name = 'meta.tag.other.cfm';
			begin = '</?cffunc.+?';
			end = '>';
			captures = { 1 = { name = 'entity.name.tag.other.html'; }; };
			patterns = (
				{	match = '\b([nN][aA][mM][Ee])\b\s*(=)\s*(["''])([A-Za-z$_0-9]+)(["''])';
					captures = {
						0 = { name = 'entity.other.attribute-name.html'; };
						3 = { name = 'punctuation.definition.string.begin'; };
						4 = { name = 'entity.name.function.cfml'; };
						5 = { name = 'punctuation.definition.string.end'; };
					};
				},
				{	include = 'source.cfml'; },
				{	include = '#tag-stuff'; },
			);
		};
		coldfusion-script = {
			name = 'source.coldfusion.embedded.html';
			begin = '#';
			end = '\#';
			patterns = (
				{	include = '#inline-function-stuff'; },
				{	include = '#embedded-code'; },
			);
		};
		embedded-code = { patterns = ( { include = '#javascript'; } ); };
		entities = {
			patterns = (
				{	name = 'constant.character.entity.html';
					match = '&([a-zA-Z0-9]+|#[0-9]+|#x[0-9a-fA-F]+);';
				},
				{	name = 'invalid.illegal.bad-ampersand.html';
					match = '&';
				},
			);
		};
		htmlcomment = {
			name = 'comment.block.html';
			begin = '<!--';
			end = '-->';
			patterns = (
				{	name = 'invalid.illegal.bad-comments-or-CDATA.html';
					match = '--';
				},
			);
		};
		inline-function-stuff = {
			name = 'support.function';
			contentName = 'support.function.parameters';
			begin = '[a-zA-Z0-9_\.]+\(';
			end = '\)';
			patterns = (
				{	include = '#inline-function-stuff'; },
				{	include = '#string-double-quoted'; },
				{	include = '#string-single-quoted'; },
			);
		};
		string-double-quoted = {
			name = 'string.quoted.double.html';
			begin = '"';
			end = '"';
			patterns = (
				{	include = '#embedded-code'; },
				{	include = '#entities'; },
			);
		};
		string-single-quoted = {
			name = 'string.quoted.single.html';
			begin = "'";
			end = "'";
			patterns = (
				{	include = '#embedded-code'; },
				{	include = '#entities'; },
			);
		};
		tag-finder = {
			name = 'meta.tag.any.html';
			begin = '<([a-zA-Z0-9:]+)(?=[^>]*></\1>)';
			end = '>(<)/(\1)>';
			beginCaptures = { 1 = { name = 'entity.name.tag.html'; }; };
			endCaptures = {
				1 = { name = 'meta.scope.between-tag-pair.html'; };
				2 = { name = 'entity.name.tag.html'; };
			};
			patterns = ( { include = '#tag-stuff'; } );
		};
		tag-generic-attribute = {
			patterns = (
				{	name = 'entity.other.attribute-name.html';
					match = '\b([a-zA-Z0-9_\-:]+)';
				},
			);
		};
		tag-id-attribute = {
			name = 'meta.attribute-with-value.id.html';
			begin = '[^\.]\b(id)\b\s*=';
			end = '(?<=''|")';
			captures = { 1 = { name = 'entity.other.attribute-name.id.html'; }; };
			patterns = (
				{	name = 'string.quoted.double.html';
					contentName = 'meta.toc-list.id.html';
					begin = '"';
					end = '"';
					patterns = (
						{	include = '#embedded-code'; },
						{	include = '#entities'; },
					);
				},
				{	name = 'string.quoted.single.html';
					contentName = 'meta.toc-list.id.html';
					begin = "'";
					end = "'";
					patterns = (
						{	include = '#embedded-code'; },
						{	include = '#entities'; },
					);
				},
			);
		};
		tag-stuff = {
			patterns = (
				{	include = '#tag-id-attribute'; },
				{	include = '#inline-function-stuff'; },
				{	include = '#tag-generic-attribute'; },
				{	include = '#string-double-quoted'; },
				{	include = '#string-single-quoted'; },
				{	include = '#coldfusion-script'; },
				{	include = '#embedded-code'; },
				{	name = 'variable.other';
					match = '.var\s';
				},
				{	name = 'meta.tag.other';
					contentName = 'entity.name.function';
					begin = '.<cffunction\sname=(''|")1';
					end = '''|"1';
				},
			);
		};
	};
}