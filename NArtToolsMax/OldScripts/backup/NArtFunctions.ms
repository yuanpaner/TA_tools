
struct NArtFn(
	
	--输出FBX
	fn ExportFbx _exportPath  _CopyTextures= (
		
		NArtFn.DelParticleView()
		
		_NArtIDName = NArtName.GetParentFloderName()
		
		if _NArtIDName == "" do(
			messageBox "输出失败，请先储存文件。" title:"NArtExport"
			return undefined
		)
		
		
		_exportFilePath		= _exportPath + "\\" + _NArtIDName
		_exportFileFullName = _exportFilePath + "\\F" + _NArtIDName + ".fbx"
		
		makeDir _exportFilePath

		if _CopyTextures do(
			
			_oldTexturePath = maxfilepath + "\\Textures\\"
			_exportTexturePath = _exportFilePath + "\\Textures\\"
			makeDir _exportTexturePath
			DOSCommand("copy " + _oldTexturePath + " "+ _exportTexturePath)
			
		)

		exportFile _exportFileFullName #noprompt
		
		_log = "NArtLog: ExportFbx "+ _exportFileFullName
		print _log
	),
	
	--清除ParticleView
	fn DelParticleView = (
		_particleViews = for i in objects where classof i==Particle_View collect i
		
		if _particleViews.count != 0 do(
			_log = "NArtLog: 删除ParticleViews:"+ (_particleViews.count as string) + "个"
			print _log
		)
		delete _particleViews
		
	)
	
)

struct NArtName(
	
	fn GetParentFloder _num= (
		
		if maxfilepath == "" do return ""
		
		_num -= 1
		
		filterNameArray = filterString maxfilepath "\\"
		
		if (_num < 0) or (_num > filterNameArray.count-1) do(
			return filterNameArray[filterNameArray.count]
		)
		
		_result = filterNameArray[filterNameArray.count - _num]
		
		return _result
	),
	
	--根据NArt命名规范获取ID名称
	fn GetParentFloderName = (
		return NArtName.GetParentFloder 0
	),
	
	--获取分类名称
	fn GetCategoryName =(
		return NArtName.GetParentFloder 1
	),
	
	--获取项目名称
	fn GetProjectName =(
		return NArtName.GetParentFloder 2
	),
	
	--根据传入名称排除前缀获取名称
	fn GetRealName _str = (
		
		if _str == "" do return ""
			
		_nameFile = getFileNameFile _str
		
		return subString _nameFile 1 -1
		
	),
	
	--根据MAX文件名称排除前缀获取名称
	fn GetMaxRealName = (
		
		if maxfilename == "" do return ""
			
		_nameFile = getFileNameFile maxfilename	
		
		_firstName = subString _nameFile 1 1
		if _firstName == "X" do(
			return subString _nameFile 1 -1
		)
		return _nameFile
	)
)
