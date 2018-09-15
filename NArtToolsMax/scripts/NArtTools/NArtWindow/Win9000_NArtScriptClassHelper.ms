print "NArt工具：MAXScript编写辅助工具"

global tp_scriptHelper_rol
global tp_refreshText_fn
fn tp_refreshText_fn =
(
	try
	(
		if selection.count==1 then
		(
			try(tp_scriptHelper_rol.tp_Name_edt.text=$.name)catch(tp_scriptHelper_rol.tp_Name_edt.text="")
			try(tp_scriptHelper_rol.tp_pos_edt.text=$.pos as string)catch(tp_scriptHelper_rol.tp_pos_edt.text="")
			try(tp_scriptHelper_rol.tp_Rotation_edt.text=$.rotation as string)catch(tp_scriptHelper_rol.tp_Rotation_edt.text="")
			try(tp_scriptHelper_rol.tp_Scale_edt.text=$.scale as string)catch(tp_scriptHelper_rol.tp_Scale_edt.text="")
			try(tp_scriptHelper_rol.tp_ClassOf_edt.text=classof $ as string)catch(tp_scriptHelper_rol.tp_ClassOf_edt.text="")
			try(tp_scriptHelper_rol.tp_superclassof_edt.text=superclassof $ as string)catch(tp_scriptHelper_rol.tp_superclassof_edt.text="")
			try(tp_scriptHelper_rol.tp_wirecolor_edt.text=$.wirecolor as string)catch(tp_scriptHelper_rol.tp_wirecolor_edt.text="")
			try(tp_scriptHelper_rol.tp_wirecolor_cp.color=$.wirecolor)catch(tp_scriptHelper_rol.tp_wirecolor_cp.color=(color 0 0 0))
			try(tp_scriptHelper_rol.TP_ControllerClass_edt.text=(classof $.controller) as string)catch(tp_scriptHelper_rol.TP_ControllerClass_edt.text="")
			try(tp_scriptHelper_rol.TP_MousePos_edt.text="["+(mouse.screenpos.x as integer) as string+" , "+(mouse.screenpos.y as integer) as string+" ]")catch()
		)
		else
		(
			tp_scriptHelper_rol.tp_Name_edt.text=""
			tp_scriptHelper_rol.tp_pos_edt.text=""
			tp_scriptHelper_rol.tp_Rotation_edt.text=""
			tp_scriptHelper_rol.tp_Scale_edt.text=""
			tp_scriptHelper_rol.tp_ClassOf_edt.text=""
			tp_scriptHelper_rol.tp_superclassof_edt.text=""
			tp_scriptHelper_rol.tp_wirecolor_edt.text=""
			tp_scriptHelper_rol.tp_wirecolor_cp.color=(color 0 0 0)
			tp_scriptHelper_rol.TP_ControllerClass_edt.text=""
			tp_scriptHelper_rol.TP_MousePos_edt.text="["+(mouse.screenpos.x as integer) as string+" , "+(mouse.screenpos.y as integer) as string+" ]"
		)
	)catch()
)


try(DestroyDialog tp_scriptHelper_rol)catch()
rollout tp_scriptHelper_rol "TP Script Helper" width:220 height:401
(
	button tp_refresh_btn "手动刷新" pos:[140,369] width:68 height:25 



	edittext tp_Name_edt "name：" pos:[10,5] width:200 height:18 labelOnTop:true 



	edittext tp_pos_edt "Pos：" pos:[10,43] width:200 height:18 labelOnTop:true 



	edittext tp_Rotation_edt "Rotation：" pos:[10,81] width:200 height:18 labelOnTop:true 



	edittext tp_Scale_edt "Scale：" pos:[10,119] width:200 height:18 labelOnTop:true 



	edittext tp_ClassOf_edt "ClassOf：" pos:[10,157] width:200 height:18 labelOnTop:true 



	edittext tp_SuperClassOf_edt "Super：" pos:[10,195] width:200 height:18 labelOnTop:true 



	edittext tp_wirecolor_edt "WireColor：" pos:[10,233] width:105 height:18 enabled:true labelOnTop:true 



	colorPicker tp_wirecolor_cp "" pos:[113,242] width:40 height:30 color:(color 0 0 0)
	
	button tp_setcolor_btn "Set Color" pos:[155,242] width:55 height:30
	
	edittext TP_ControllerClass_edt "Controller：" pos:[10,271] width:200 height:18 labelOnTop:true 



	edittext TP_MousePos_edt "MousePos：" pos:[10,309] width:200 height:18 labelOnTop:true 
	timer tmr1 "Timer" pos:[28,357] width:24 height:24



	on tp_refresh_btn pressed do
	(
		if selection.count==1 then
		(
			tp_Name_edt.text=$.name
			try
			(
				tp_pos_edt.text=$.pos as string
				tp_Rotation_edt.text=$.rotation as string
				tp_Scale_edt.text=$.scale as string
			)
			catch
			(
				tp_scriptHelper_rol.tp_pos_edt.text=""
				tp_scriptHelper_rol.tp_Rotation_edt.text=""
				tp_scriptHelper_rol.tp_Scale_edt.text=""
			)
			tp_ClassOf_edt.text=classof $ as string
			tp_superclassof_edt.text=superclassof $ as string
			tp_wirecolor_edt.text=$.wirecolor as string
			tp_wirecolor_cp.color=$.wirecolor
			TP_ControllerClass_edt.text=(classof $.controller) as string
			TP_MousePos_edt.text="["+(mouse.screenpos.x as integer) as string+" , "+(mouse.screenpos.y as integer) as string+" ]"
		)
	)--on pressed do
	on tp_wirecolor_cp changed col do
	(
		tp_wirecolor_edt.text=tp_wirecolor_cp.color as string
	)
	on tp_setcolor_btn pressed do
	(
		for i in selection do i.wirecolor=tp_wirecolor_cp.color
	)
	on tmr1 tick  do
	(
		tp_refreshText_fn()
	)
)
tp_scriptHelperX=mouse.screenpos.x-200
tp_scriptHelperY=mouse.screenpos.y-213
createdialog tp_scriptHelper_rol style:#(#style_toolwindow,#style_sysmenu) pos:[tp_scriptHelperX,tp_scriptHelperY]
callbacks.addscript #selectionsetchanged "tp_refreshText_fn()" 