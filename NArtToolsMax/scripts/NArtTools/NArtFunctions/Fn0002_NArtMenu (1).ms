
print "Load NArtMenu"

--���߲˵��ṹ��
struct MenuToolName(
	pMenuName, --�ϼ��˵���
	toolName	--������
)

struct NArtMenu(
	
	--�����ļ�����ȡ���߲˵�
	fn GetMenuToolName _fileName = (
		
		_result = MenuToolName()
		
		_realFileName = getFileNameFile _fileName
		
		_checkNArt = findString _realFileName "NArt"
	
		if _checkNArt == undefined do(
			msg = "�ļ�: " + _fileName + " �ļ�����û��NArt��������NArt���ߣ��������ء�"
			print msg
			return undefined
		)
		
		_nameArray = filterstring _realFileName "~"
		
		if _nameArray.count == 2 do (
			_result.pMenuName = undefined
			_result.toolName = _nameArray[2]
			return _result
		)
		
		if _nameArray.count == 3 do (
			_result.pMenuName = _nameArray[2]
			_result.toolName = _nameArray[3]
			return _result
		)
		
		msg = "�ļ�: " + _fileName + " �ļ��������Ϲ淶���������ء�"
		print msg
		
		return undefined
	),
	
	
	--��������ж�ز˵��е��ض��˵�
	fn UnRegisterMenuBarMenu _mainMenu _menuName = (
		
		m_unRegisterArray = NArtMenu.GetSubMenusByName _mainMenu _menuName

		for i in m_unRegisterArray do(
			menuMan.unRegisterMenu i
		)

	),
	
	--�������ƻ�ȡsubItem
	fn GetSubMenusByName _menu _name = (
		m_subMenus = #()
		m_maxNum = _menu.numItems()
		for i = 1 to m_maxNum do (
			m_menuSubItem = _menu.getItem i
			if m_menuSubItem != undefined do(
				m_itemName = m_menuSubItem.getTitle()
				if m_itemName == _name do (
					m_subMenu = m_menuSubItem.getSubMenu()
					append m_subMenus m_subMenu
				)
			)
		)
		return m_subMenus
	),
	

	--���������������˵�����
	fn CreateMenuItem _mainMenu _menuToolName = (
		
		_pMenuName = _menuToolName.pMenuName
		
		_toolName = _menuToolName.toolName
		
		if _pMenuName != undefined do(
		
			m_subMenus = NArtMenu.GetSubMenusByName _mainMenu _pMenuName
			
			if m_subMenus.count == 0 then(
				
				_newSubMenu = NArtMenu.CreateSubMenu _mainMenu _pMenuName
				_mainMenu = _newSubMenu
				
			)else(
				
				_mainMenu = m_subMenus[1]
				
			)
		)
		
		NArtMenu.CreateActionItem _mainMenu _toolName
	),
	
	--�����Ӳ˵�
	fn CreateSubMenu _mainMenu _subMenuName = (
		
		m_subMenu = menuMan.createMenu _subMenuName

		m_subMenuItem = menuMan.createSubMenuItem _subMenuName m_subMenu

		m_subMenuIndex = _mainMenu.numItems()+1

		_mainMenu.addItem m_subMenuItem m_subMenuIndex
		
		return m_subMenu
	),
	
	--������������
	fn CreateActionItem _mainMenu _name = (
		
		m_menuName = _mainMenu.getTitle()
		
		m_newItem = menuMan.createActionItem _name "_NArtTools" 

		_mainMenu.addItem m_newItem -1
	),
	
	
	--����˵�����
	fn ClearItem _menu = (
	
		_numItem = _menu.numItems()
		
		while _menu.numItems() > 0 do(
			_menu.removeItemByPosition 1
		)

		menuMan.updateMenuBar()
	),
	
	--���shift�Ҽ��˵�
	fn ClearShiftQuad = (
		--#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed
		--#shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed
		m_quadMenu = menuMan.getViewportRightClickMenu #shiftPressed
		 
		m_NArtQuadMenu = m_quadMenu.getMenu 4

		m_NArtQuadMenu.setTitle "NArtTools"

		NArtMenu.ClearItem m_NArtQuadMenu
		
		return m_NArtQuadMenu
	)

)









