-- 2015/6/3 @pwd by Panyuan
-- help for NartTools
macroscript NArtHelp
	category:"_NArtTools"
	buttontext:"NArt���߰����ĵ�"
	tooltip:"NArt���߰����ĵ�"
(
	on execute do
	(
		try(
			filepath = (GetDir #userScripts )+@"\NArtTools\*"
			files = getfiles filepath
			ShellLaunch files[1] ""
		)catch(
			messagebox "����svn�Ƿ�����˰����ļ�"
			)
		)
	
	)