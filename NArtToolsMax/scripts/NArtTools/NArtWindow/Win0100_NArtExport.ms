try(DestroyDialog Rollout_exportFBX)catch()
_doOver = false
rollout Rollout_exportFBX "ExportFBX" width:536 height:223
(
	edittext str_path "" pos:[17,37] width:439 height:22
	button btn_getPath "path" pos:[461,36] width:52 height:24
	button btn_export "Export" pos:[172,190] width:183 height:24
	checkbox chk_anim "Export Animation" pos:[349,73] width:132 height:19 checked:true
	checkbox chk_tex "Export texture" pos:[34,68] width:132 height:19 checked:true
	checkbox chk_skin "New skin" pos:[350,105] width:70 height:19 checked:true
	GroupBox grp1 "  Export FBX  " pos:[10,15] width:516 height:158	

	
	checkbox chk_select "Select" pos:[177,94] width:110 height:18
	
	checkbox chk_solo "Solo" pos:[177,70] width:110 height:18
	
	checkbox chk_zeroPos "Zero Pos" pos:[177,120] width:110 height:18
	checkbox chk_NameToF "G to F" pos:[177,145] width:118 height:15 checked:true
	
	fn GetSets = (
		
	)
	
	fn SaveSets = (
			
	)			

	on Rollout_exportFBX open do
	(	
		_nps = NArtPreferenceSetting()
		_nps.LoadValue()
		str_path.text = _nps.m_ExportTargetPath
		
		GetSets()
	)
	on btn_getPath pressed do
	(
		try(
			str_path.text = getSavePath caption:"输出路径" initialDir:(@"D:\FF_Type0_Prj\webff_artres\ArtProject\")
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
						
			DestroyDialog Rollout_exportFBX
		)else(
			messageBox "请选择输出路径！！"
		)
		SaveSets()
	)
)

createDialog Rollout_exportFBX