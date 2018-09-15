
struct NArtExport(

	-- 输出fbx默认方法
	fn fn_ExportFbx _exportPath  _fileName  _isAnim _isTextrue _selected:false = (

		if _selected == false do(
			NArtCheck.DelParticleView()	
		)
		
		makeDir _exportPath
		if _isTextrue do(
			
			_oldTexturePath = maxfilepath + "\\Textures\\"
			_exportTexturePath = _exportPath + "\\Textures\\"
			makeDir _exportTexturePath
			DOSCommand("copy " + _oldTexturePath + " "+ _exportTexturePath)
			
		)
		_exportFileFullName = _exportPath + "\\" + _fileName
		
		FBXExporterSetParam "Animation" _isAnim
		FBXExporterSetParam "BakeAnimation" true
		FBXExporterSetParam "ConvertUnit" "cm"

		exportFile _exportFileFullName #noprompt selectedOnly:_selected
	),
	
	--获取输出路径
	fn fn_getExportPath _folderNum =
	(
		_filePath = maxfilePath
		_pathstrArray = filterString maxfilePath ":\\/"
		
		_nps = NArtPreferenceSetting()
		_nps.LoadValue()
		
		_postPath = _nps.m_ExportTargetPath
		
		_typePath = NArtExport.GetFileType()
		
		_postPath += "\\"
		_postPath += _typePath
		
		
		i = _folderNum
		while i >= 0 do(
			_index = _pathstrArray.count - i
			if _index >= 0 then(
				_postPath += "\\"
				_postPath += _pathstrArray[_index]
			)else(
				i = 0
			)
			i -= 1
		)
		return _postPath 
	),
	
	--获取文件类别
	fn GetFileType =(
		_pathArray = filterString maxfilePath ":\\/"
		for i in _pathArray do(
			if i == "Character" do
				return i
			
			if i == "CGAnimation" do
				return i
			
			if i == "Animation" do
				return i
			
			if i == "WorldEntities" do
				return i
		)
		return "Temp"
	),
	
	
	--获取输出名称
	fn fn_getExportFileName =
	(
		_fileName = maxfileName
		if _fileName[1] =="X" then
		(
			_filename = replace _filename 1 1 "F"
		)else(
			_filename = "F"+ _filename
		)
		_filename = substituteString _filename "@skin" ""
		_filename = substituteString _filename ".max" ".fbx"
		return _fileName 
	),
	
	--输出相关贴图
	fn fn_copyDenpendTextrue _obj _newPath =(
		_newPath= _newpath +"Textures\\"
		
		if classof _Obj.Material == Standardmaterial do(
			if _Obj.material.diffusemap != undefined do(
				
				oldFilestr = _Obj.material.diffusemap.filename
				_typestr =  getfilenameType oldFilestr
				_filename = getfilenamefile oldFilestr
				
				makedir _newPath 
				newTextureName=_newPath + _filename + _typestr	

				_Dostr = "copy " + oldFilestr + " "+ newTextureName
				DOSCommand _Dostr
			)
		)	
		if classof _Obj.Material == Multimaterial do(
			
			for i=1 to _Obj.material.count do (
				if _obj.material[i].diffusemap != undefined do(
					oldFilestr = _Obj.material[i].diffusemap.filename
					_typestr =  getfilenameType oldFilestr

					_filename = getfilenamefile oldFilestr
					
					makedir _newPath 
					newTextureName=_newPath + _filename + _typestr
					_Dostr = "copy " + oldFilestr + " "+ newTextureName
					DOSCommand _Dostr
				)
			)
		)
		
	),
	
	--角色输出方法	
	fn CharacterExport = 
	(
		_fileName  = NArtExport.fn_getExportFileName() 
		
		--多输出一级菜单
		_filePath = NArtExport.fn_getExportPath 1
		
		_exbipNubArray = #()
		for i in objects do(
			if classof i.controller == BipSlave_Control and classof i == Dummy then(
				
			)else(
				append _exbipNubArray i
			)
		)
		select _exbipNubArray
			
		undo on(
			if (matchpattern maxfilename pattern: "*@*") then
			(	
				if(matchpattern maxfilename pattern: "*@skin*") then(

-- 					NArtNewSkin.fn_createBoneAndSkin()				
					NArtExport.fn_ExportFbx _filePath _fileName false true _selected:true
					
				)else(	
-- 					NArtNewSkin.fn_createBoneAndSkin()			
					NArtExport.fn_ExportFbx _filePath _fileName true false _selected:true
				)
				
			)else(
				if(matchpattern maxfilename pattern: "*_rig*") then(
-- 					NArtNewSkin.fn_createBoneAndSkin()	
					NArtExport.fn_ExportFbx _filePath _fileName false true _selected:true
					
				)else(	
					NArtExport.fn_ExportFbx _filePath _fileName false true	_selected:true
				)
			)
		)

		max undo 
		unhide objects
		unfreeze objects
	),
	
	--动作输出
	fn ExportAnimation = (
	
	),

	
	--场景输出方法
	fn WorldEntitiesExport = 
	(
-- 		NArtCheck.fn_checkSceneFile()
		for i=1 to objects.count do (
			clearSelection()
			select objects[i]
			_filePath = NArtExport.fn_getExportPath 0
			_objName = replace objects[i].name 1 1 "F" 
			_fileName = _objName +".fbx"
			print _fileName
			_copyTexture = (i==1)
			NArtExport.fn_ExportFbx _filePath _fileName false _copyTexture	_selected:true
-- 			NArtExport.fn_copyDenpendTextrue objects[i] _filePath
		)
	)
	
)

print "Load NArtExport"
