--ɾ���������ļ�
_mcrDir = getDir #userMacros
_mcrFilesName = _mcrDir + "\_NArtTools*.mcr"
_mcrFiles = getFiles _mcrFilesName
for i in _mcrFiles do(
	DeleteFile i
)

--���ع��ú���
_functionFilePath = getFiles @"D:\art_ta\Public\ToolsAndPlug-ins\NArtToolsMax\scripts\NArtTools\NArtFunctions\*.ms"

for i in _functionFilePath do(
	print i
	filein i
	
)

--���غ�����
_mcrfiles = getFiles @"D:\art_ta\Public\ToolsAndPlug-ins\NArtToolsMax\scripts\NArtTools\NArtMacros\*.ms"
_nartFiles = #()
m_NArtToolNames = #()

for i in _mcrfiles do(
	
	_toolName = NArtMenu.GetMenuToolName i
	
	if _toolName != undefined do(
		
		filein i
		append m_NArtToolNames _toolName
		
	)
)

--ж��֮ǰ��NArtTools�˵�
m_mainMenuBar = menuMan.getMainMenuBar()
NArtMenu.UnRegisterMenuBarMenu m_mainMenuBar "NArtTools"

--�����µ�NArtTools�˵�
m_NArtMenu = menuMan.createMenu "NArtTools"

m_subMenuItem = menuMan.createSubMenuItem "NArtTools" m_NArtMenu

m_subMenuIndex = m_mainMenuBar.numItems() - 1

m_mainMenuBar.addItem m_subMenuItem m_subMenuIndex


--���shift�Ҽ��˵�
m_NArtQuadMenu = NArtMenu.ClearShiftQuad()

--�������й��߲�������Ӧ�˵�
for i = 1 to m_NArtToolNames.count do(
		
	try(
		--�ѹ��߼������˵�
		NArtMenu.CreateMenuItem m_NArtMenu m_NArtToolNames[i] 
		
		--�ѹ��߼���shift�Ҽ��˵�
		NArtMenu.CreateMenuItem m_NArtQuadMenu m_NArtToolNames[i] 
		
	)catch(
		
		_msg = "NArt���� " + m_NArtToolNames[i].toolName + " �������ʧ�ܡ�"
		print _msg
	)
	
)




menuMan.updateMenuBar()






