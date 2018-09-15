--删除宏命令文件
_dir = (getDir #userScripts) + @"\NArtTools\"

_mcrDir = getDir #userMacros
_mcrFilesName = _mcrDir + "\_NArtTools*.mcr"
_mcrFiles = getFiles _mcrFilesName
for i in _mcrFiles do(
	DeleteFile i
)

--加载公用函数
_functionFilePath = getFiles (_dir+@"NArtFunctions\*.ms")

for i in _functionFilePath do(
	print i
	filein i
	
)

--加载宏命令
_mcrfiles = getFiles (_dir+@"NArtMacros\*.ms")
_nartFiles = #()
m_NArtToolNames = #()

for i in _mcrfiles do(
	
	_toolName = NArtMenu.GetMenuToolName i
	
	if _toolName != undefined do(
		
		filein i
		append m_NArtToolNames _toolName
		
	)
)

--卸载之前的NArtTools菜单
m_mainMenuBar = menuMan.getMainMenuBar()
NArtMenu.UnRegisterMenuBarMenu m_mainMenuBar "NArtTools"

--创建新的NArtTools菜单
m_NArtMenu = menuMan.createMenu "NArtTools"

m_subMenuItem = menuMan.createSubMenuItem "NArtTools" m_NArtMenu

m_subMenuIndex = m_mainMenuBar.numItems() - 1

m_mainMenuBar.addItem m_subMenuItem m_subMenuIndex


--清除shift右键菜单
m_NArtQuadMenu = NArtMenu.ClearShiftQuad()

--遍历所有工具并加入相应菜单
for i = 1 to m_NArtToolNames.count do(
		
	try(
		--把工具加入主菜单
		NArtMenu.CreateMenuItem m_NArtMenu m_NArtToolNames[i] 
		
		--把工具加入shift右键菜单
		NArtMenu.CreateMenuItem m_NArtQuadMenu m_NArtToolNames[i] 
		
	)catch(
		
		_msg = "NArt工具 " + m_NArtToolNames[i].toolName + " 意外加载失败。"
		print _msg
	)
	
)




menuMan.updateMenuBar()







