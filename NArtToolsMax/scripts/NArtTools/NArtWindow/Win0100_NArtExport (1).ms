print "NArt执行：输出FBX对话框"

try(DestroyDialog Rollout_exportFBX)catch()
_doOver = false
rollout Rollout_exportFBX "ExportFBX" width:536 height:223
(
	edittext str_path "" pos:[17,37] width:439 height:22
	button btn_getPath "路径" pos:[461,36] width:52 height:24
	button btn_export "输出" pos:[172,190] width:183 height:24
	checkbox chk_anim "输出动画" pos:[349,73] width:132 height:19 checked:true
	checkbox chk_tex "输出贴图" pos:[34,68] width:132 height:19 checked:true
	checkbox chk_skin "打散骨架" pos:[350,105] width:70 height:19 checked:false
	GroupBox grp1 "  输出FBX  " pos:[10,15] width:516 height:158	

	
	checkbox chk_select "只输出选择物体" pos:[177,94] width:110 height:18
	
	checkbox chk_solo "单独物体" pos:[177,70] width:110 height:18
	
	checkbox chk_zeroPos "位置归零" pos:[177,120] width:110 height:18
	checkbox chk_NameToF "更改前缀G为F" pos:[177,145] width:118 height:15 checked:true
	
	fn GetSets = (
		
	)
	
	fn SaveSets = (
			
	)			

	on Rollout_exportFBX open do
	(	
		_nps = NArtPreferenceSetting()
		_nps.LoadValue()
		str_path.text = _nps.m_ExportTargetPath + @"\__ExportTemp__"
		
		GetSets()
	)
	on btn_getPath pressed do
	(
		try(
			_nps = NArtPreferenceSetting()
			_nps.LoadValue()
			str_path.text = getSavePath caption:"输出路径" initialDir:(_nps.m_ExportTargetPath)
		)catch()
	)
	on btn_export pressed do
	(
		if str_path.text != "" then
		(
			_filename = NArtExport.fn_getExportFileName()	
			_Path = str_path.text +@"\"
			_allObject = objects
			if chk_select.state then(
				_allObject = selection
			)
			if chk_solo.state then(
				for i=1 to _allObject.count do(
					_obj = _allObject[i]
					if _obj == undefined do print "!!!!!!!!!!!@@@@@@@@#@%@!#^#%@#%"
					_newFileName = _obj.name + ".fbx"
					if chk_zeropos.state do _obj.pos = [0,0,0]
					if chk_NameToF.state do (
						_newFileName = (NArtName.ReplacePrefix _obj.name) + ".fbx"
					)
					
					select _obj
					_copyTexture = chk_tex.state
					if _copyTexture then
						_copyTexture = (i==1)
					
					NArtExport.fn_ExportFbx (_Path) (_newFileName) (chk_anim.state) _copyTexture _selected:true
					print selection
				)
			)else(
						
				if  chk_skin.state then(
					undo on(					
						NArtNewSkin.fn_createBoneAndSkin()							
					)
					NArtExport.fn_ExportFbx (_Path) (_filename) (chk_anim.state) (chk_tex.state)					
					max undo 
					unhide objects
					unfreeze objects					
				)else(	
	
					NArtExport.fn_ExportFbx (_Path) (_filename) (chk_anim.state) (chk_tex.state)	
				)
			)
						
			Try(DestroyDialog Rollout_exportFBX)Catch()
		)else(
			messageBox "请选择输出路径！！"
		)
		SaveSets()
	)
)

createDialog Rollout_exportFBX