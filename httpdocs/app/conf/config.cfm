<?xml version="1.0" encoding="UTF-8"?>
<config>
	<views>
		<view addview="Add View" alias="" controller="default_controller" fieldnames="parentView,visibility,label,title,addView,name" id="4" id_view="2" label="dfsdfsdf" layout="default_layout.cfm" name="dsfdsf" parentview="test2" priority="0" title="" view="default_view.cfm" visibility="Visible"/>
  <view addview="Add View" alias="" controller="default_controller" fieldnames="viewName,type,file" id="1" id_view="0" label="Home" layout="default_layout.cfm" name="root" parentview="root" priority="0" title="" view="default_view.cfm" visibility="Hidden"/>
  <view addview="Add View" alias="" controller="default_controller" fieldnames="viewName,type,file" id="2" id_view="1" label="test" layout="test_layout.cfm" name="test" parentview="root" priority="1" title="" view="default_view.cfm" visibility="Visible"/>
  <view addview="Add View" alias="" controller="default_controller" fieldnames="parentView,visibility,label,title,addView,name" id="3" id_view="1" label="test2" layout="default_layout.cfm" name="test2" parentview="test" priority="2" title="" view="default_view.cfm" visibility="Visible"/>
  </views>
	<states>
		<state exit_state="" has_text="0" id="1" id_view="1" label="test" name="default" priority="0" state="default_state.cfm" title="" visibility="visible"/>
  <state exit_state="" has_text="0" id="2" id_view="2" label="New State" name="default" priority="1" state="default_state.cfm" title="" visibility="visible"/>
  <state exit_state="" has_text="0" id="3" id_view="3" label="New State" name="default" priority="2" state="default_state.cfm" title="" visibility="visible"/>
  <state exit_state="" has_text="0" id="4" id_view="4" label="New State" name="default" priority="3" state="default_state.cfm" title="" visibility="visible"/>
  </states>
</config>

