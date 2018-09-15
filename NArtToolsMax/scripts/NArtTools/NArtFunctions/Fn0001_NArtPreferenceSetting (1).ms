
struct NArtPreferenceSetting(
	m_ProjectName =  "WebFF",
	
	m_ArtSourcePath = @"D:\FF_Type0_Prj\webff_artsource",
	
	m_ExportTargetPath = @"D:\FF_Type0_Prj\webff_artres\ArtProject\Assets\_ArtResources",
	
	--����Ĭ�ϲ���
	fn SetDefaultValue = (
		
		m_ProjectName =  "WebFF"
	
		m_ArtSourcePath = @"D:\FF_Type0_Prj\webff_artsource"
	
		m_ExportTargetPath = @"D:\FF_Type0_Prj\webff_artres\ArtProject\Assets\_ArtResources"
	),
	

	--��ȡ�����ļ�·��
	fn GetSettingFile =(

		_fileName = "Preference.xml"
		_fullPath = GetDir #userScripts
		_fullPath += @"\NArtTools\NArtSettings\Local\"
		
		makeDir _fullPath
		 
		_fullPath += _fileName
		
		return _fullPath

	),
	

	--���Զ�ȡ�����ļ������
	fn LoadSettingFile =(
		_SettingFile = NArtPreferenceSetting.GetSettingFile()
		if (GetFiles _SettingFile)[1] == null do(
			_nps = NArtPreferenceSetting()
			_nps.SaveValue()
		)
		return _SettingFile
	),
	
	--��ȡ����
	fn LoadValue = (
		dotNet.loadAssembly "system.xml"
		_xmlDoc = dotNetObject "System.Xml.XmlDocument"
	
		_SettingFile = NArtPreferenceSetting.LoadSettingFile()
		
		_xmlDoc.Load(_SettingFile)
		
		_root = _xmlDoc.SelectSingleNode("NArtPreferenceSetting")
		
		_subRoot = _root.SelectSingleNode("PreferenceSetting")
		
		--m_ProjectName
		try(
			_ChildElement = _subRoot.SelectSingleNode("ProjectName")
			m_ProjectName = _ChildElement.InnerText
		)Catch()
		
		--m_ArtSourcePath
		try(
			_ChildElement = _subRoot.SelectSingleNode("ArtSourcePath")
			m_ArtSourcePath = _ChildElement.InnerText
		)Catch()
			
		--m_ExportTargetPath
		try(
			_ChildElement = _subRoot.SelectSingleNode("ExportTargetPath")
			m_ExportTargetPath = _ChildElement.InnerText
		)Catch()
	),
	
	fn SaveValue = (
		dotNet.loadAssembly "system.xml"
		_xmlDoc = dotNetObject "System.Xml.XmlDocument"
		
		_SettingFile = NArtPreferenceSetting.GetSettingFile()
		
		_rootName = "NArtPreferenceSetting"

		_root = _xmlDoc.createElement _rootName

		_xmlDoc.appendChild _root
		
		_PreferencSetting = _xmlDoc.createElement "PreferenceSetting"
		_root.appendChild _PreferencSetting
		
		--m_ProjectName
		_ChildElement = _xmlDoc.createElement "ProjectName"
		_ChildElement.InnerText = m_ProjectName
		_PreferencSetting.appendChild _ChildElement
		
		--m_ArtSourcePath
		_ChildElement = _xmlDoc.createElement "ArtSourcePath"
		_ChildElement.InnerText = m_ArtSourcePath
		_PreferencSetting.appendChild _ChildElement
		
		--m_ExportTargetPath
		_ChildElement = _xmlDoc.createElement "ExportTargetPath"
		_ChildElement.InnerText = m_ExportTargetPath
		_PreferencSetting.appendChild _ChildElement
		
		print "SaveValueToXML"
		return _xmlDoc.Save(_SettingFile)
	)

)

print "Load NArtPreferenceSetting"







