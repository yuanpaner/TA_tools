
struct NArtFn(
	
	--���FBX
	fn ExportFbx _exportPath  _CopyTextures= (
		
		NArtFn.DelParticleView()
		
		_NArtIDName = NArtName.GetParentFloderName()
		
		if _NArtIDName == "" do(
			messageBox "���ʧ�ܣ����ȴ����ļ���" title:"NArtExport"
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
	
	--���ParticleView
	fn DelParticleView = (
		_particleViews = for i in objects where classof i==Particle_View collect i
		
		if _particleViews.count != 0 do(
			_log = "NArtLog: ɾ��ParticleViews:"+ (_particleViews.count as string) + "��"
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
	
	--����NArt�����淶��ȡID����
	fn GetParentFloderName = (
		return NArtName.GetParentFloder 0
	),
	
	--��ȡ��������
	fn GetCategoryName =(
		return NArtName.GetParentFloder 1
	),
	
	--��ȡ��Ŀ����
	fn GetProjectName =(
		return NArtName.GetParentFloder 2
	),
	
	--���ݴ��������ų�ǰ׺��ȡ����
	fn GetRealName _str = (
		
		if _str == "" do return ""
			
		_nameFile = getFileNameFile _str
		
		return subString _nameFile 1 -1
		
	),
	
	--����MAX�ļ������ų�ǰ׺��ȡ����
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