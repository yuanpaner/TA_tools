-- 2015/6/3 @pwd by Panyuan
-- help for NartTools
macroscript NArtHelp
	category:"_NArtTools"
	buttontext:"Help Document"
	tooltip:"Help Document"
(
	on execute do
	(
		try(
			filepath = (GetDir #userScripts )+@"\NArtTools\*"
			files = getfiles filepath
			ShellLaunch files[1] ""
		)catch(
			messagebox "请检查svn是否跟新了帮助文件"
			)
		)
	
	)
