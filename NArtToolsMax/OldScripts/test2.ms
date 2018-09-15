messagebox "Start"

if menuMan.registerMenuContext 0x1ee76d83 then(
	local mainMenuBar = menuMan.getMainMenuBar()
	local subMenu = menuMan.createMenu "NArtTools"
	local test1Item = menuMan.createActionItem "Test" "NartScript"
	subMenu.addItem test1Item -1
	local subMenuItem = menuMan.createSubMenuItem "NArtTools" subMenu
	local subMenuIndex = mainMenuBar.numItems() -1
	mainMenuBar.addItem subMenuItem subMenuIndex
	menuMan.upadateMenuBar()
)

messagebox "end"