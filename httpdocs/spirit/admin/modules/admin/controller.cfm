<cfprocessingdirective pageencoding="utf-8"><cfsilent>
	<cfscript>
/*		spirit.css("modules/admin/css/admin.css.cfm");
				
		spirit.js("js/jquery/jquery.easing.1.2.packed.js.cfm");
		spirit.js("js/jquery/suggest.js.cfm");
		spirit.js("js/jquery/ui.js.cfm");
		
		spirit.js("js/spry/xpath.js.cfm");
		spirit.js("js/spry/SpryData.js.cfm");
		spirit.js("js/spry/SpryNestedXMLDataSet.js.cfm");
		
		spirit.css("js/spry/css/SpryValidationTextField.css.cfm");
		spirit.js("js/spry/SpryValidationTextField.js.cfm");
		spirit.js("js/spry/SpryUtils.js.cfm");
		
		spirit.$js("js/spry/SpryAutoSuggest.js.cfm");
		spirit.$js("js/spry/SpryDataExtensions.js.cfm");
		spirit.$css("js/spry/css/SpryAutoSuggest.css.cfm");
		
		spirit.js("modules/admin/js/admin.js.cfm");*/
	</cfscript>
</cfsilent>
<div id="canvas" class="none">
	<div id="views" spry:region="dsMyData dsViews dsViewStates dsFiles dsState">
		<table border="0" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td spry:repeat="dsMyData" spry:choose="spry:choose">

				<!---
					TODO сделать подсветку статуса кнопок
				--->
				<!--- Begin: View Children --->
				<div spry:when="'{dsMyData::@type}' == 'views'" class="views">
					<div class="openView hand dropView rc6" spry:hover="hover" onClick="loadData('{dsMyData::view}', 'edit');">
						<span>{dsMyData::view}</span>
						<div class="dropLine"></div>
					</div>
					<div spry:repeat="dsViews">
						<div class="{dsViews::@selected} {dsViews::@visibility}View childView dropView hand rc6" spry:hover="hover" onClick="loadData('{dsViews::view}', 'edit');">
							<div spry:if="'{dsViews::@visibility}' == 'locked'" class="locked"><img src="f.cfm?f=modules/admin/images/icons/locked.png.cfm" width="9" height="13" alt="" /></div>
							<span>{dsViews::view}</span>
							<div class="dropLine"></div>
						</div>
					</div>
					<div class="center p10">
						<div class="addView rc6 hand" onclick="loadData('{dsMyData::view}', 'newView');" title="Add View"><span class="addIcon">+</span>&nbsp;Add</div>
						<div class="deleteView dropView">
							<div class="bgDeleteView rc6">&rarr; Delete &larr;</div>
						</div>
					</div>
				</div>
				<!--- End: View Children --->
				

				<!--- Begin: New View --->
				<div spry:when="'{dsMyData::@type}' == 'newView'" class="panel noDropView rc6">
					<table cellpadding="0" cellspacing="5" class="w100">
					<tr>
						<td class="center">{dsMyData::@name}</td>
					</tr>
					<tr>
						<td class="p5">
							<form method="post" accept-charset="utf-8" action="modules/admin/form/save.cfm?a=createView" onsubmit="return createView(this);">
								<input type="hidden" name="parentView" value="{dsMyData::name}"/>
								<div class="blueDisplay rc6">
									<div class="labels">
										<div class="options rc6">Options</div>
									</div>
									<div class="p5">
										<table cellpadding="0" cellspacing="10" class="w100">
										<tr id="r1">
											<td class="label">Name</td>
											<td>
												<div class="relative">
													<input type="text" name="name" id="name" class="w100" />
													<span class="textfieldRequiredMsg">The value is required.</span>
													<span class="textfieldInvalidFormatMsg">Invalid format.</span>
													<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
													<span class="textfieldCustomMsg"></span>
												</div>
											</td>
										</tr>
										<tr id="r2">
											<td class="label">Label</td>
											<td>
												<div class="relative">
													<input type="text" name="label" class="w100" />
													<span class="textfieldRequiredMsg">The value is required.</span>
													<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
												</div>
											</td>
										</tr>
										<tr id="r3">
											<td class="label grey">Title</td>
											<td>
												<div class="relative">
													<input type="text" name="title" class="w100" />
													<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
												</div>
											</td>
										</tr>
										<tr>
											<td class="label">Visibility</td>
											<td>
												<div id="routeVisibility" class="visibility">
													<div spry:hover="hover" onclick="setVisibility('Visible')" class="v_visible rc6"><span>Visible</span></div>
													<div spry:hover="hover" onclick="setVisibility('Hidden')" class=" rc6"><span>Hidden</span></div>
													<div spry:hover="hover" onclick="setVisibility('Locked')" class=" rc6"><span>Locked</span></div>
													<input type="hidden" name="visibility" value="Visible"/>
												</div>
											</td>
										</tr>
										</table>
									</div>
								</div>
								<div class="butonPlaceholder">
									<input type="submit" name="addView" value="Add View" class="rc6 hand" />
								</div>
							</form>
						</td>
					</tr>
					</table>
					<script type="text/javascript" charset="utf-8">
						var r1 = new Spry.Widget.ValidationTextField("r1", "none", {
							validateOn:['blur','change'],
							isRequired:true,
							maxChars: 25,
							validation: function (v){
								j("#r1").removeClass("textfieldCustomState");
								return isValidViewName(v);
							}
						});
						var r2 = new Spry.Widget.ValidationTextField("r2", "none", {
							validateOn:['blur','change'],
							isRequired:true,
							maxChars: 100
						});
						var r3 = new Spry.Widget.ValidationTextField("r3", "none", {
							validateOn:['blur','change'],
							isRequired:false,
							maxChars: 500
						});
						j("#name").focus();
					</script>
				</div>
				<!--- End: New View --->

				<!--- Begin: Edit View --->
				<div spry:when="'{dsMyData::@type}' == 'edit'" class="panel noDropView rc6" id="editView">
					<table cellpadding="0" cellspacing="5" class="w100">
					<tr>
						<td class="center">View: {dsMyData::name}</td>
					</tr>
					<tr>
						<td class="p5">
							<form id="fUpdateView" method="post" accept-charset="utf-8" action="modules/admin/form/save.cfm?a=updateView" onsubmit="return updateView();">
								<input type="hidden" name="viewName" id="oldViewName" value="{dsMyData::name}" />
								<div class="blueDisplay rc6">
									<div class="tl"></div><div class="tr"></div><div class="bl"></div><div class="br"></div>
									<div class="labels">
										<div class="options rc6">Options</div>
									</div>
									<div class="p5">
										<table cellpadding="0" cellspacing="10" class="w100">
										<tr id="r1">
											<td class="label">Name</td>
											<td>
												<div class="relative">
													<span spry:if="'{dsMyData::name}' == '{dsMyData::defaultView}'">
														<input type="text" disabled="disabled" name="name" value="{dsMyData::name}" id="name" class="w100" />
													</span>
													<span spry:if="'{dsMyData::name}' != 'root'">
														<input type="text" name="name" value="{dsMyData::name}" id="name" class="w100" />
													</span>
													<span class="textfieldRequiredMsg">The value is required.</span>
													<span class="textfieldInvalidFormatMsg">Invalid format.</span>
													<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
													<span class="textfieldCustomMsg"></span>
												</div>
											</td>
										</tr>
										<tr id="r2">
											<td class="label">Label</td>
											<td>
												<div class="relative">
													<input type="text" id="label" name="label" value="{dsMyData::label}" class="w100" />
													<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
												</div>
											</td>
										</tr>
										<tr id="r3">
											<td class="label grey">Title</td>
											<td>
												<div class="relative">
													<input type="text" id="title" name="title" value="{dsMyData::title}" class="w100" />
													<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
												</div>
											</td>
										</tr>
										<tr>
											<td class="label">Visibility</td>
											<td>
												<div id="routeVisibility" class="visibility">
													<div spry:hover="hover" onclick="setVisibility('Visible');updateView();" class="v_{dsMyData::visibility} rc6"><span>Visible</span></div>
													<div spry:hover="hover" onclick="setVisibility('Hidden');updateView();" class="h_{dsMyData::visibility} rc6"><span>Hidden</span></div>
													<span spry:if="'{dsMyData::name}' != '{dsMyData::defaultView}'">
													<div spry:hover="hover" onclick="setVisibility('Locked');updateView();" class="l_{dsMyData::visibility} rc6"><span>Locked</span></div>
													</span>
													<input type="hidden" name="visibility" value="{dsMyData::visibility}"/>
												</div>
											</td>
										</tr>
										<tr>
											<td class="label">Layout</td>
											<td><div spry:hover="hover" class="p6_3 hand {dsMyData::@layout} rc6" onclick="loadData('{dsMyData::name}', 'edit', 'layout');">{dsMyData::layout}</div></td>
										</tr>
										<tr>
											<td class="label">Controller</td>
											<td><div spry:hover="hover" class="p6_3 hand {dsMyData::@controller} rc6"  onclick="loadData('{dsMyData::name}', 'edit', 'controller');">{dsMyData::controller}</div></td>
										</tr>
										<tr>
											<td class="label">View</td>
											<td><div spry:hover="hover" class="p6_3 hand {dsMyData::@view} rc6"  onclick="loadData('{dsMyData::name}', 'edit', 'view');">{dsMyData::view}</div></td>
										</tr>
										<tr>
											<td class="label grey">Alias</td>
											<td>
												<div spry:hover="hover" class="p6_3 hand {dsMyData::@alias} rc6"  onclick="loadData('{dsMyData::name}', 'edit', 'alias');">
													<span spry:if="'{dsMyData::alias}' == ''">Set Alias</span>
													<span spry:if="'{dsMyData::alias}' != ''">{dsMyData::alias}</span>
												</div>
											</td>
										</tr>
										</table>
									</div>
								</div>
								<input type="hidden" name="id" value="{dsMyData::id}" />
							</form>
						</td>
					</tr>
					<tr>
						<td class="p5">
							<div class="blueDisplay rc6">
								<div class="labels">
									<div class="states rc6">States</div>
									<div class="add hand rc6" onclick="loadData('{dsMyData::name}', 'edit', 'newState');"><span class="addIcon">+</span>&nbsp;Add</div>
								</div>
								<div class="p5">
									<table cellpadding="0" cellspacing="10" class="w100">
									<tr valign="top">
										<td class="label grey" style="padding-top:.8em;">Default &rarr;</td>
										<td>
											<div spry:repeat="dsViewStates">
												<div spry:hover="hover" class="p6_3 hand {dsViewStates::@selected} {dsViewStates::@visibility} rc6" onclick="loadData('{dsMyData::name}', 'edit', 'state', '{dsViewStates::@name}');">
													<span>{dsViewStates::@name}&nbsp;</span>
													<span class="small relative">
														<sup spry:if="'{dsViewStates::@state}'.length" class="absolute ot grey">
															&larr;&nbsp;{dsViewStates::@state}
														</sup>
														<sub spry:if="'{dsViewStates::@exit_state}' != ''" class="relative ob green">
															&rarr;&nbsp;&nbsp;{dsViewStates::@exit_state}
														</sub>
													</span>
													<div spry:if="'{dsViewStates::@visibility}' == 'locked'" class="locked"><img src="f.cfm?f=modules/admin/images/icons/locked.png.cfm" width="9" height="13" alt="" /></div>
											</div>
										</td>
									</tr>
									</table>
								</div>
							</div>
						</td>
					</tr>
					</table>
					<script type="text/javascript" charset="utf-8">
						var r1 = new Spry.Widget.ValidationTextField("r1", "none", {
							validateOn:['blur','change'],
							isRequired:true,
							maxChars: 25,
							validation: function (v){
								j("#r1").removeClass("textfieldCustomState");
								return isValidViewName(v);
							}
						});
						var r2 = new Spry.Widget.ValidationTextField("r2", "none", {
							validateOn:['blur','change'],
							isRequired:true,
							maxChars: 100
						});
						var r3 = new Spry.Widget.ValidationTextField("r3", "none", {
							validateOn:['blur','change'],
							isRequired:false,
							maxChars: 500
						});
						if(!lastId.length)
							j("#name").focus();

						j("#editView input").change(
							function(){
								updateView();
							}
						).focus(function(){
							lastId = j(this).attr("id");
						});
					</script>
				</div>
				<!--- End: Edit View --->

				<!--- Begin: New State --->
				<div spry:when="'{dsMyData::@type}' == 'newState'" class="pl5 relative noDropView">
					<div class="yellowBar"></div>
					<div class="panel rc6">
						<table cellpadding="0" cellspacing="5" class="w100">
						<tr>
							<td class="center">{dsMyData::@label}</td>
						</tr>
						<tr>
							<td class="p5">
								<form id="fAddState" method="post" accept-charset="utf-8" action="modules/admin/form/save.cfm?a=addState" onsubmit="return addState(this);">
									<input type="hidden" name="viewName" value="{dsMyData::@viewName}" />
									<div class="yellowDisplay rc6">
										<div class="labels">
											<div><img src="f.cfm?f=modules/admin/images/icons/options_y.png.cfm" width="77" height="21" alt="" /></div>
										</div>
										<div class="p5">
											<table cellpadding="0" cellspacing="10" class="w100">
											<tr id="r1">
												<td class="label">Name</td>
												<td>
													<div id="a1" class="relative">
														<input type="text" name="name" id="stateName" class="w100" />
														<span class="textfieldRequiredMsg">The value is required.</span>
														<span class="textfieldInvalidFormatMsg">Invalid format.</span>
														<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
														<span class="textfieldCustomMsg"></span>
													</div>
												</td>
											</tr>
											<tr id="r2">
												<td class="label grey">Label</td>
												<td>
													<div id="a2" class="relative">
														<input type="text" name="label" class="w100" />
														<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
													</div>
												</td>
											</tr>
											<tr id="r3">
												<td class="label grey">Title</td>
												<td>
													<div id="a3" class="relative">
														<input type="text" name="title" class="w100" />
														<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
													</div>
												</td>
											</tr>
											<tr>
												<td class="label">Visibility</td>
												<td>
													<!---
														TODO пофиксить подсветку видимости
													--->
													<div id="stateVisibility" class="visibility">
														<div spry:hover="hover" onclick="setVisibility('Visible', 'state')" class="v_visible rc6"><span>Visible</span></div>
														<div spry:hover="hover" onclick="setVisibility('Hidden', 'state')" class="rc6"><span>Hidden</span></div>
														<div spry:hover="hover" onclick="setVisibility('Locked', 'state')" class="rc6"><span>Locked</span></div>
														<input type="hidden" name="visibility" value="visible"/>
													</div>
												</td>
											</tr>
											</table>
										</div>
									</div>
									<div class="butonPlaceholder">
										<input type="image" name="addState" src="f.cfm?f=modules/admin/images/icons/add_action.png.cfm" width="77" height="21" />
									</div>
								</form>
							</td>
						</tr>
						</table>
					</div>
					<script type="text/javascript" charset="utf-8">
						var a1 = new Spry.Widget.ValidationTextField("a1", "none", {
							validateOn:['blur','change'],
							isRequired:true,
							maxChars: 25,
							validation: function (v){
								j("#a1").removeClass("textfieldCustomState");
								return isValidViewName(v);
							}
						});
						var a2 = new Spry.Widget.ValidationTextField("a2", "none", {
							validateOn:['blur','change'],
							isRequired:false,
							maxChars: 100
						});
						var a3 = new Spry.Widget.ValidationTextField("a3", "none", {
							validateOn:['blur','change'],
							isRequired:false,
							maxChars: 250
						});

						if(!lastId.length)
							j("#stateName").focus();
					</script>
				</div>
				<!--- End: New State --->

				<!--- Begin: Edit State --->
				<div spry:when="'{dsMyData::@type}' == 'state'" class="pl5 relative noDropView">
					<div class="yellowBar"></div>
					<div class="panel rc6">
						<table cellpadding="0" cellspacing="5" class="w100">
							<tr>
								<td class="center">State: {dsState::name}</td>
							</tr>
							<tr>
								<td class="p5">
									<form id="fUpdateState" method="post" action="modules/admin/form/save.cfm?a=updateState" accept-charset="utf-8" onsubmit="return updateState();">
										<input type="hidden" name="viewName" value="{dsMyData::viewName}" />
										<input type="hidden" name="oldName" value="{dsState::name}" id="stateOldName" />
										<div class="yellowDisplay rc6">
											<div class="tl"></div><div class="tr"></div><div class="bl"></div><div class="br"></div>
											<div class="labels">
												<div><img src="f.cfm?f=modules/admin/images/icons/options_y.png.cfm" width="77" height="21" alt="" /></div>
											</div>
											<div class="p5">
												<table cellpadding="0" cellspacing="10" class="w100">
												<tr>
													<td class="label">Name</td>
													<td>
														<div id="a1" class="relative">
															<input type="text" name="name" value="{dsState::name}" id="stateName" class="w100" />
															<span class="textfieldRequiredMsg">The value is required.</span>
															<span class="textfieldInvalidFormatMsg">Invalid format.</span>
															<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
															<span class="textfieldCustomMsg"></span>
														</div>
													</td>
												</tr>
												<tr>
													<td class="label grey">Label</td>
													<td>
														<div id="a2" class="relative">
															<input type="text" name="label" value="{dsState::label}" id="stateLabel" class="w100" />
															<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
														</div>
													</td>
												</tr>
												<tr>
													<td class="label grey">Title</td>
													<td>
														<div id="a3" class="relative">
															<input type="text" id="stateTitle" name="title" value="{dsState::title}" class="w100" />
															<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
														</div>
													</td>
												</tr>
												<tr>
													<td class="label"></td>
													<td>
														<span spry:if="'{dsState::has_text}' == '1'">
															<input type="checkbox" name="has_text" value="1" id="stateHasText" checked="checked" />
															<label for="stateHasText">Has text</label>
														</span>
														<span spry:if="'{dsState::has_text}' == '0'">
															<input type="checkbox" name="has_text" value="1" id="stateHasText" />
															<label for="stateHasText">Has text</label>
														</span>
													</td>
												</tr>
												<tr>
													<td class="label">Visibility</td>
													<td>
														<div id="stateVisibility" class="visibility">
															<div spry:hover="hover" onclick="setVisibility('visible', 'state');updateState();" class="v_{dsState::visibility} rc6"><span>Visible</span></div>
															<div spry:hover="hover" onclick="setVisibility('hidden', 'state');updateState();" class="h_{dsState::visibility} rc6"><span>Hidden</span></div>
															<div spry:hover="hover" onclick="setVisibility('locked', 'state');updateState();" class="l_{dsState::visibility} rc6"><span>Locked</span></div>
															<input type="hidden" name="visibility" value="{dsState::visibility}"/>
														</div>
													</td>
												</tr>
												</table>
											</div>
										</div>
									</form>
								</td>
							</tr>
							<tr>
								<td class="p5">
									<div class="yellowDisplay rc6">
										<div class="tl"></div><div class="tr"></div><div class="bl"></div><div class="br"></div>
										<div class="labels">
											<div><img src="f.cfm?f=modules/admin/images/icons/states.png.cfm" width="77" height="21" alt="" /></div>
										</div>
										<div class="p5">
											<table cellpadding="0" cellspacing="10" class="w100">
											<tr>
												<td class="label">State &rarr;</td>
												<td>
													<div spry:hover="hover" class="p6_3 hand rc6"  onclick="loadData('{dsMyData::viewName}', 'edit', 'state', '{dsState::name}', 'stateTemplates');">
														<span>{dsState::name}</span>
														<span class="sup grey">&nbsp;{dsState::state}</span>
													</div>
												</td>
											</tr>
											<tr>
												<td class="label grey">Exit &rarr;</td>
												<td>
													<div spry:hover="hover" class="p6_3 hand rc6"  onclick="loadData('{dsMyData::viewName}', 'edit', 'state', '{dsState::name}', 'exit_state');">
														<span spry:if="'{dsState::exit_state}' == ''">Set Exit State</span>{dsState::exit_state}
													</div>
												</td>
											</tr>
											</table>
										</div>
									</div>
								</td>
							</tr>
						</table>
					</div>
					<script type="text/javascript" charset="utf-8">
					var a1 = new Spry.Widget.ValidationTextField("a1", "none", {
						validateOn:['blur','change'],
						isRequired:true,
						maxChars: 25,
						validation: function (v){
							j("#a1").removeClass("textfieldCustomState");
							return isValidViewName(v);
						}
					});
					var a2 = new Spry.Widget.ValidationTextField("a2", "none", {
						validateOn:['blur','change'],
						isRequired:false,
						maxChars: 100
					});
					var a3 = new Spry.Widget.ValidationTextField("a3", "none", {
						validateOn:['blur','change'],
						isRequired:false,
						maxChars: 250
					});
					j("#fUpdateState input").change(
						function(){
							updateState();
						}
					).blur(function(){
						lastId = j(this).attr("id");
					});
					if(!lastId.length)
						j("#stateName").focus();
					</script>
				</div>
				<!--- End: Edit State --->

				<!--- Begin: Set State Panel --->
				<div spry:when="'{dsMyData::@type}' == 'stateTemplates'" class="pl5 relative noDropView">
					<div class="yellowBar"></div>
					<div class="panel rc6">
						<table cellpadding="0" cellspacing="5" class="w100">
							<tr>
								<td class="center titlecase">{dsMyData::@name}</td>
							</tr>
							<tr>
								<td class="p5">
									<div class="yellowDisplay rc6">
										<div class="tl"></div><div class="tr"></div><div class="bl"></div><div class="br"></div>
										<div class="labels">
											<div><img src="f.cfm?f=modules/admin/images/icons/existing_yellow.png.cfm" width="77" height="21" alt="" /></div>
										</div>
										<form id="suggestState"method="post" action="modules/admin/form/save.cfm?a=setStateTemplate" accept-charset="utf-8" onsubmit="return false;">
											<input type="hidden" name="viewName" value="{dsMyData::viewName}" />
											<input type="hidden" name="stateName" value="{dsMyData::stateName}" />
											<table cellpadding="0" cellspacing="10" class="w100" border="0">
											<tr>
												<td class="w100">
													<div class="relative pr5 pt5">
														<input type="text" name="state" id="search" class="w100 search" placeholder="search" results="10" />
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div spry:repeatchildren="dsFiles" id="files">
														<div class="p6_3 hand rc6" spry:hover="hover">{dsFiles::file}</div>
													</div>
												</td>
											</tr>
											</table>
										</form>
									</div>
								</td>
							</tr>
							<tr>
								<td class="p5">
									<div class="blueDisplay rc6">
										<div class="tl"></div><div class="tr"></div><div class="bl"></div><div class="br"></div>
										<div class="labels">
											<div><img src="f.cfm?f=modules/admin/images/icons/new.png.cfm" width="77" height="21" alt="" /></div>
										</div>
										<form method="post" action="modules/admin/form/save.cfm?a=createStateTemplate" accept-charset="utf-8" onsubmit="return createStateTemplate(this);" id="createStateTemplate" style="padding-top:5px">
											<input type="hidden" name="viewName" value="{dsMyData::viewName}" />
											<input type="hidden" name="stateName" value="{dsMyData::stateName}" />
											<table cellpadding="0" cellspacing="10" class="w100">
												<tr>
													<td  id="f1"class="w100">
														<div class="relative pr5 below">
															<input type="text" name="state" value="{dsMyData::viewName}_{dsMyData::stateName}.cfm" id="newState" class="w100" />
															<span class="textfieldRequiredMsg">The value is required.</span>
															<span class="textfieldInvalidFormatMsg">Invalid format.</span>
															<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
															<span class="textfieldCustomMsg"></span>
														</div>
													</td>
													<td>
														<input type="image" name="submit" src="f.cfm?f=modules/admin/images/icons/add.png.cfm" width="34" height="21" alt="" class="hand" tabindex="0" /></td>
												</tr>
											</table>
										</form>
									</div>
								</td>
							</tr>
						</table>
					</div>
					<script type="text/javascript" charset="utf-8">
					var f1 = new Spry.Widget.ValidationTextField("f1", "none", {
						validateOn:['blur','change'],
						isRequired:true,
						maxChars: 100,
						validation: function (v){
							j("#f1").removeClass("textfieldCustomState");
							return isValidTemplateName(v);
						}
					});
					j("#suggestState").suggest("#files", {callBack: function(v){
						setStateTemplate(v);
					}});
					if(!lastId.length)
						j("#search").focus();
					</script>
				</div>
				<!--- End: Set State Panel --->

				<!--- Begin: Set Exit State Panel --->
				<div spry:when="'{dsMyData::@type}' == 'exit_state'" class="pl5 relative noDropView">
					<div class="yellowBar"></div>
					<div class="panel rc6">
						<table cellpadding="0" cellspacing="5" class="w100">
							<tr>
								<td class="center titlecase">{dsMyData::@name}</td>
							</tr>
							<tr>
								<td class="p5">
									<div class="yellowDisplay rc6">
										<div class="labels">
											<div><img src="f.cfm?f=modules/admin/images/icons/states.png.cfm" width="77" height="21" alt="" /></div>
											<div spry:if="'{dsMyData::exit_state}' != ''"><img class="hand" onclick="j('#exit_state').val('');setExitState();" src="f.cfm?f=modules/admin/images/icons/remove_exit_action.png.cfm" width="116" height="21" alt="" /></div>
											<div spry:if="'{dsMyData::exit_state}' == ''" class="disabled"><img src="f.cfm?f=modules/admin/images/icons/remove_exit_action.png.cfm" width="116" height="21" alt="" /></div>
										</div>
										<form id="fSuggestExitState" method="post" action="modules/admin/form/save.cfm?a=setExitState" onsubmit="return false;" accept-charset="utf-8">
											<input type="hidden" name="viewName" value="{dsMyData::viewName}" />
											<input type="hidden" name="stateName" value="{dsMyData::stateName}" />
											<table cellpadding="0" cellspacing="10" class="w100" border="0">
												<tr>
													<td style="padding-top:5px;" class="w100">
														<div class="pr5"><input type="text" name="exit_state" id="exit_state" class="w100 search" placeholder="search" results="10" /></div>
													</td>
												</tr>
												<tr>
													<td>
														<div spry:repeatchildren="dsViewStates" id="exitStateCanddates">
															<div class="p6_3 hand">
																<span class="label">{dsViewStates::state}</span>
																<span class="sup grey">{dsViewStates::@handler}</span>
															</div>
														</div>
													</td>
												</tr>
											</table>
										</form>
									</div>
								</td>
							</tr>
						</table>
					</div>
					<script type="text/javascript" charset="utf-8">
					j("#fSuggestExitState").suggest("#exitStateCanddates", {callBack: function(v, e){
						j("#exit_state").val(j("span.label", e).text());
						setExitState();
					}});
					if(!lastId.length)
						j("#exit_state").focus();
					</script>
				</div>
				<!--- End: Set Exit State Panel --->

				<!--- Begin: Alias Panel --->
				<div spry:when="'{dsMyData::@type}' == 'alias'" class="pl5 relative noDropView">
					<div class="bar"></div>
					<div class="panel rc6">
						<table cellpadding="0" cellspacing="5" class="w100">
							<tr>
								<td class="center titlecase">Set Alias</td>
							</tr>
							<tr>
								<td class="p5">
									<div class="blueDisplay rc6">
										<div class="tl"></div><div class="tr"></div><div class="bl"></div><div class="br"></div>
										<div class="labels">
											<div><img src="f.cfm?f=modules/admin/images/icons/routes.png.cfm" width="77" height="21" alt="" /></div>
											<div spry:if="'{dsMyData::@alias}'.length"><img src="f.cfm?f=modules/admin/images/icons/remove_current_alias.png.cfm" width="120" height="21" alt="" onclick="j('#iAlias').val('');setViewAlias();" class="hand" /></div>
											<div spry:if="!'{dsMyData::@alias}'.length" class="disabled"><img src="f.cfm?f=modules/admin/images/icons/remove_current_alias.png.cfm" width="120" height="21" alt="" /></div>
										</div>
										<form id="fSuggestAlias" method="post" action="modules/admin/form/save.cfm?a=setViewAlias" onsubmit="return false;" accept-charset="utf-8">
											<input type="hidden" name="viewName" value="{dsMyData::viewName}" />
											<table cellpadding="0" cellspacing="10" class="w100">
												<tr>
													<td style="padding-top:5px;" class="w100">
														<input id="iAlias" id="search" type="text" name="alias" class="w100 search" placeholder="search" results="10" /><br />
													</td>
												</tr>
												<tr>
													<td>
														<div spry:repeatchildren="dsViews" id="redirectViews">
															<div class="p6_3 hand rc6">{dsViews::view}</div>
														</div>
													</td>
												</tr>
											</table>
										</form>
									</div>
								</td>
							</tr>
						</table>
					</div>
					<script type="text/javascript" charset="utf-8">
					if(!lastId.length)
						j("#search").focus();
					j("#fSuggestAlias").suggest("#redirectViews", {callBack: function(v){
						setViewAlias();
					}});
					</script>
				</div>
				<!--- End: Alias Panel --->

				<!--- Begin: Files Panel --->
				<div spry:when="'{dsMyData::@type}' == 'layout' | '{dsMyData::@type}' == 'controller' | '{dsMyData::@type}' == 'view'" class="pl5 relative noDropView">
					<div class="bar"></div>
					<div class="panel rc6">
						<table cellpadding="0" cellspacing="5" class="w100">
							<tr>
								<td class="center titlecase">Set {dsMyData::@type}</td>
							</tr>
							<tr>
								<td class="p5">
									<!---
										TODO write jquery suggest
									--->
									<div class="blueDisplay rc6">
										<div class="tl"></div><div class="tr"></div><div class="bl"></div><div class="br"></div>
										<div class="labels">
											<div><img src="f.cfm?f=modules/admin/images/icons/existing.png.cfm" width="77" height="21" alt="" /></div>
										</div>
										<form method="post" id="fSuggestTemplate" accept-charset="utf-8" action="modules/admin/form/save.cfm?a=setViewTemplate" onsubmit="return false;">
											<input type="hidden" name="type" value="{dsMyData::@type}" />
											<input type="hidden" name="viewName" value="{dsMyData::viewName}" />
											<table cellpadding="0" cellspacing="10" class="w100" border="0">
												<tr>
													<td style="padding-top:5px;" class="w100">
														<input type="text" name="file" class="w100 search" placeholder="search" results="10" id="search" /><br />
													</td>
												</tr>
												<tr>
													<td>
														<div spry:repeatchildren="dsFiles" id="files">
															<div class="p6_3 hand viewTemplateFile rc6">{dsFiles::@name}</div>
														</div>
													</td>
												</tr>
											</table>
										</form>
									</div>
								</td>
							</tr>
							<tr>
								<td class="p5">
									<div class="blueDisplay rc6">
										<div class="labels">
											<div><img src="f.cfm?f=modules/admin/images/icons/new.png.cfm" width="77" height="21" alt="" /></div>
										</div>
										<form method="post" action="modules/admin/form/save.cfm?a=addViewTemplate" accept-charset="utf-8" onsubmit="return addViewTemplate(this);" id="fFile" style="padding-top:5px">
											<input type="hidden" name="type" value="{dsMyData::@type}" />
											<input type="hidden" name="viewName" value="{dsMyData::viewName}" />
											<table cellpadding="0" cellspacing="10" class="w100">
												<tr>
													<td class="w100" id="newViewTemplate">
														<div class="relative below pr5">
															<input type="text" name="file" value="{dsMyData::template}" id="file" class="w100" />
															<span class="textfieldRequiredMsg">The value is required.</span>
															<span class="textfieldInvalidFormatMsg">Invalid format.</span>
															<span class="textfieldMaxCharsMsg">The maximum number of characters exceeded.</span>
														</div>
													</td>
													<td>
														<input type="image" name="submit" src="f.cfm?f=modules/admin/images/icons/add.png.cfm" width="34" height="21" alt="" class="hand" tabindex="0" /></td>
												</tr>
											</table>
										</form>
									</div>
								</td>
							</tr>
						</table>
					</div>
					<script type="text/javascript" charset="utf-8">
					if(!lastId.length)
						j("#search").focus();
					j("#fSuggestTemplate").suggest("#files", {callBack: function(v){
						setViewTemplate();
					}});

					var newViewTemplate = new Spry.Widget.ValidationTextField("newViewTemplate", "none", {
						validateOn:['blur','change'],
						isRequired:true,
						maxChars: 100
					});
					</script>
				</div>
				<!--- End: Files Panel --->
			</td>
		</tr>
		</table>
		<script type="text/javascript">
			j("#" + lastId).focus();
			j(".childView").draggable({
				helper: 'clone',
				revert: true,
				revertDuration: 150,
				zIndex:3,
				appendTo: "body",
				opacity: 1,
				delay: 20,
				start: function (ev, ui){
					j("body").addClass("startDrag");
					j("body > div.childView").removeClass("dropable");
					j(this).addClass("noDropView");
					disableChildren(j(this).text());
					j(".dropView:not(.noDropView)").droppable({
						accept: ".dropView",
						activeClass: 'dropable',
						hoverClass: "dragOver",
						drop: function (ev, ui){
							var target = j(this);
							var viewName = ui.draggable.text().trim();
							if (j(this).is(".deleteView")){
								deleteView(viewName);
							}
							else{
								if (target.is(".openView")) {
									var targetViewName = target.text().trim();
									placeAfter = "";
								}
								else {
									var targetViewName = getParentView(target.text().trim()).text().trim();
									var placeAfter = target.text().trim();
								}
								moveView(viewName, targetViewName, placeAfter);
							}
						}
					});
				},
				stop: function(ev, ui) {
					j("div").droppable("destroy");
					j("body").removeClass("startDrag");
					j(this).removeClass("noDropView");
					enableChildren();
				}
			});
		</script>
	</div>
</div>
<cfoutput>
</cfoutput>