--prj：ShengDouShi
--panyuan 2015/5/25 @pwd
--1.change plugin files in the folder
--2.restart max
--version2 use ini file, plug can not be removed when using 

macroScript NArtPlugExchange
category:"_NArtTools"
toolTip:"更改手游/端游插件"
buttontext:"更改手游/端游插件"
(
	on isEnabled return ((maxVersion())[1]/1000==11 or is64bitApplication()!=true)
	on execute do
	(
		rollout plugEx "插件切换" width:176 height:184 
		(
			local rootPath =getDir #maxroot
			local clientPath = @"D:\art_ta\Public\ToolsAndPlug-ins\NArtToolsMax\plugins2009\s_client\"
			local mobilePath = @"D:\art_ta\Public\ToolsAndPlug-ins\NArtToolsMax\plugins2009\s_mobile\"
			global piniFile = (getDir #maxroot) + "plugin.ini"
			
			button btn1 "手游->端游" pos:[40,66] width:109 height:32
			button btn2 "端游->手游" pos:[40,118] width:109 height:32
			label lbl1 "当前插件状态：" pos:[16,8] width:144 height:24
			groupBox grp1 "切换插件" pos:[16,40] width:144 height:128
			on btn1 pressed  do
			(
				delIniSetting piniFile "Directories" "mobile"
				setINISetting piniFile "Directories" "client" clientPath
				quitMax #noPrompt
				)
			on btn2 pressed  do
			(
				delIniSetting piniFile "Directories" "client"
				setINISetting piniFile "Directories" "mobile" mobilePath
				quitMax #noPrompt
				)
		)

		if (doesFileExist piniFile)then createDialog plugEx pos:[20,20]
		else messagebox "只能手动改了！"
	)
)