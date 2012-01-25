<?xml version="1.0" encoding="UTF-8"?>
<config>
	<views>
		<view addview="Add View" alias="" controller="default_controller" fieldnames="parentView,visibility,label,title,addView,name" id="4" id_view="2" label="dfsdfsdf" layout="default_layout.cfm" name="dsfdsf" parentview="test2" priority="0" title="" view="default_view.cfm" visibility="Visible"/>
  <view addview="Add View" alias="" controller="default_controller" fieldnames="viewName,file,type" id="1" id_view="0" label="Home" layout="default_layout.cfm" name="root" parentview="root" priority="0" title="" view="root_view.cfm" visibility="Hidden"/>
  <view addview="Add View" alias="" controller="default_controller" fieldnames="viewName,file,type" id="2" id_view="1" label="Вопросы и ответы" layout="default_layout.cfm" name="faq" parentview="root" priority="1" title="" view="default_view.cfm" visibility="visible"/>
  <view addview="Add View" alias="" controller="default_controller" fieldnames="id,viewName,title,visibility,name,label" id="3" id_view="1" label="Обратная связь" layout="default_layout.cfm" name="contact" parentview="test" priority="2" title="" view="default_view.cfm" visibility="visible"/>
  <view addview="Add View" alias="" controller="default_controller" fieldnames="viewName,visibility,label,id,title,name" id="5" id_view="1" label="Установить MagicBar" layout="default_layout.cfm" name="connect" parentview="root" priority="3" title="" view="default_view.cfm" visibility="Hidden"/>
  <view addview="Add View" alias="" controller="default_controller" fieldnames="viewName,visibility,label,id,title,name" id="6" id_view="1" label="Форма" layout="default_layout.cfm" name="form" parentview="root" priority="3" title="" view="default_view.cfm" visibility="Hidden"/>
  </views>
	<states>
		<state exit_state="" has_text="0" id="1" id_view="1" label="test" name="default" priority="0" state="default_state.cfm" title="" visibility="visible"/>
  <state exit_state="" has_text="0" id="2" id_view="2" label="New State" name="default" priority="1" state="default_state.cfm" title="" visibility="visible"/>
  <state exit_state="" has_text="0" id="5" id_view="5" label="New State" name="form" priority="1" state="connect_form.cfm" title="" visibility="visible"/>
  <state exit_state="" has_text="0" id="6" id_view="6" label="" name="partner" priority="1" state="default_state.cfm" title="" visibility="visible"/>
  <state exit_state="" has_text="0" id="3" id_view="3" label="New State" name="default" priority="2" state="default_state.cfm" title="" visibility="visible"/>
  <state exit_state="" has_text="0" id="7" id_view="5" label="" name="success" priority="2" state="connect_success.cfm" title="" visibility="visible"/>
  <state exit_state="" has_text="0" id="4" id_view="4" label="New State" name="default" priority="3" state="default_state.cfm" title="" visibility="visible"/>
  </states>
</config>

