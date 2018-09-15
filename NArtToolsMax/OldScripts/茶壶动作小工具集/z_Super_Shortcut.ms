macroScript tp_shortcut_mcr
category:"茶壶未完善工具"
buttontext:"Super Shortcut"
toolTip:"Super Shortcut"
(
	Global tp_shortcut_rol --主rollout
	
	

------------------------------以下为自定义函数-------------------------
	
	fn tp_inputVarFn tp_key=			
	(

		tp_inputkey=getKBChar prompt:""
		if tp_inputkey==" " then
		(
			DestroyDialog tp_shortcut_rol
			return tp_key
		)
		tp_key=tp_key+tp_inputkey
		tp_shortcut_rol.tp_shortcut_lbl.text=tp_key
		tp_inputVarfn tp_key
	)		--------------------------------------------输入函数--
	
	fn tp_GeoMode=
	(
		tp_geoArray=for i in objects where superclassof i==GeometryClass and classof i!=Biped_Object and classof i!=BoneGeometry collect i
		for i in objects do hide i
		for i in tp_geoArray do i.showFrozenInGray = off
		unhide tp_geoArray
		freeze tp_geoArray
		clearSelection()
	)	------------------------------------------------GeoMode-------
	
		
	fn tp_BipMode=
	(
		tp_bipArray=for i in objects where classof i==Biped_Object collect i
		tp_geoArray=for i in objects where superclassof i==GeometryClass and classof i!=Biped_Object and classof i!=BoneGeometry collect i
		for i in objects do hide i
		for i in tp_geoArray do i.showFrozenInGray = off
		unhide tp_bipArray
		unhide tp_geoArray
		freeze tp_geoArray
		clearSelection()
	)	------------------------------------------------bipMode-------
	
	fn tp_BoneMode=
	(
		tp_BoneArray=for i in objects where classof i==BoneGeometry collect i
		tp_geoArray=for i in objects where superclassof i==GeometryClass and classof i!=Biped_Object and classof i!=BoneGeometry collect i
		for i in objects do hide i
		for i in tp_geoArray do i.showFrozenInGray = off
		unhide tp_BoneArray
		unhide tp_geoArray
		freeze tp_geoArray
		clearSelection()
	)	------------------------------------------------BoneMode-------
	
		fn tp_HelperMode=
	(
		tp_bipNubArray=for i in objects where superclassof i==helper and classof i.controller==BipSlave_Control collect i
		tp_HelperArray=for i in objects where superclassof i==helper and classof i.controller!=BipSlave_Control collect i
		tp_geoArray=for i in objects where superclassof i==GeometryClass and classof i!=Biped_Object and classof i!=BoneGeometry collect i
		for i in objects do hide i
		for i in tp_geoArray do i.showFrozenInGray = off
		unhide tp_HelperArray
		unhide tp_geoArray
		freeze tp_geoArray
		clearSelection()
	)	------------------------------------------------BoneMode-------
	
	
	
	
	
	
	
	
		fn tp_shortcutToolsFn tp_X=
		(
		 	case tp_X of
			(
				"q":tp_geomode()
				"w":tp_BipMode()
				"e":tp_BoneMode()
				"r":tp_HelperMode()
				"box":box()
				default:try
						(execute tp_X
						)catch(messagebox "未识别")
			)
		) ----------------------------------------------执行命令函数--
	
	fn tp_creatRolloutFn =
	(
		rollout tp_shortcut_rol "Short Cut" width:50 height:18
		(
			label tp_shortcut_lbl "" pos:[5,2] width:40 height:14
		)
		tp_RolCreatePos=[mouse.screenpos.x+20,mouse.screenpos.y+10]
		createdialog tp_shortcut_rol pos:tp_RolCreatePos style:#(#style_border) bgcolor:[75,75,75] fgcolor:[255,204,0]
		tp_shortcut_rol.tp_shortcut_lbl.text="Input..."
		tp_shortcutToolsfn (tp_inputVarFn "")
		
	) 	-------------------------------------------------建立界面函数--
	

--------------------------------函数定义结束------------------------


------------------------------以下为主程序------------------------

	if tp_shortcut_rol==undefined then
	(
		tp_creatRolloutFn()
	)
	else
	(
		if tp_shortcut_rol.open==true then
		DestroyDialog tp_shortcut_rol
		else
		tp_creatRolloutFn()		
	)
)

	
