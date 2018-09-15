print "NArt工具：FF合并多个max文件"

-- function:
-- imerge the files into one max for UV; then export as an signle file
-- Actor: panyuan @PWD 2015.6
-- Version:1.0  

clearListener()
global files=#()
global exfiles=#()
global filesName=#()
global errorfiles=#()
global exfiles=#()
	
try(destroydialog mergeMaxFiles)catch()
rollout mergeMaxFiles "Merge Max 文件"
(
	edittext filePath "文件路径:" width:450 pos:[5,5]
	button loadFiles "读取" width:50 height:18 pos:[455,5]
	listbox fileList "要处理的文件:" width:500 height:30 pos:[5,30]
	button delFile "去掉" width:50 pos:[105,25]
-- 	spinner oldSize "原始高度是几米:" range:[0.1,10,1.8] width:100 pos:[5,450] align:#left
-- 	spinner newSize "需要缩放至几米:" range:[0.1,10,2.3] width:100 pos:[205,450] align:#left
	button doIt "导入" width:100 pos:[295,450]
	button expIt "导出" width:100 pos:[405,450]
	progressbar progress width:500 height:10 pos:[5,475]
	
	fn GetFilesName =
	(
		filesName = #()
		for i in files do append filesName (filenameFromPath i)
		fileList.items = filesName
	)	
	
	on loadFiles pressed do
	(
		_prjPath = NArtPreferenceSetting()
		_prjPath.loadValue() 
		scenePath = _prjPath.m_ArtSourcePath
		try(filePath.text = getSavePath caption:"my title" initialDir:scenePath)catch()
		print filePath.text
		if (filePath.text == "") then messagebox "请选择路径"
		else
			files = getfiles (filePath.text + "\*.max")
		GetFilesName()
	)
	
	on delFile pressed do
	(
		if fileList.selection != 0 then	deleteitem files fileList.selection 
		GetFilesName()
	)
	
	on doIt pressed do with undo label:"Merge Files" on 
	(
		try(deletefile (filePath.text+"\错误报告.txt"))catch()
		errorfiles=#()
		exfiles=#()
		for a=1 to files.count do
			(
				--merge	
				progress.value = 100.0 * a / files.count
				if (getFileSize files[a]) > 21000000 then (append errorfiles (filenamefrompath files[a]);continue)
				else
					(						
						mobj_names = (getmaxfileobjectnames files[a])
						mobj1 =  mobj_names[1]
						mobj2 = "G" + (substring (getfilenamefile (filenamefrompath files[a])) 2 -1)
						if (mobj_names.count>1 or mobj1!=mobj2) then	(append errorfiles files[a];continue)
						try (mergeMAXFile files[a] mobj_names #noRedraw #deleteOldDups #mergeDups #useMergedMtlDups #neverReparent #renameMtlDups)catch(append errorfiles files[a];continue)
						append exfiles files[a]
					)
					
				)
				--error file
				errorReport="有部分文件可能因:\n文件过大、文件中包含多个物体、物体命名不够规范\n等原因没有导入\n可在目录下的txt文件中查看\n\n"
				if errorfiles.count!=0
				then
				(
					messagebox  errorReport
					for a in errorfiles do errorReport += a+"\n"					
					errorfile = createfile (filePath.text+"\错误报告.txt")
					format errorReport to:errorfile
					close errorfile
					ShellLaunch (filePath.text+"\错误报告.txt") ""
				)
		
	)
	
	on expIt pressed do 
	(
		progress.value = 0.0
		errorfiles=#()
		if (queryBox "本操作会覆盖原始文件，原始文件是否已经做过备份？" title:"注意！" )
		then  
		(
			if(exfiles.count>0) then
			(
				for b=1 to exfiles.count do
				(
					progress.value = 100.0 * b / exfiles.count
					if(not (doesFileExist exfiles[b])) then append errorfiles (filenamefrompath exfiles[b])
					mobjN = "G" + (substring (getfilenamefile (filenamefrompath exfiles[b])) 2 -1)
					mobj = getNodeByName mobjN
					mobj.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
					saveNodes mobj exfiles[b]
					
					)
				
				)
			else messagebox "没有导入的文件"
			if errorfiles.count!=0  then
				(
					errorReport="模型对应的源文件本来不存在\n\n可能导致后续的问题，请检查\n\n"
					messagebox  errorReport
					for a in errorfiles do errorReport += a+"\n"
					errorfileName = createfile (filePath.text+"\错误报告.txt")
					if (doesFileExist errorfileName) then
					(
						errorfile = openFile filename
						format errorReport to:errorfile
						close errorfile
						)
					else
						(
							errorfile = createfile (filePath.text+"\错误报告.txt")
							format errorReport to:errorfile
							close errorfile
							)

					ShellLaunch (filePath.text+"\错误报告.txt") ""
				)
			)			

		)-- end button

)
createdialog mergeMaxFiles 510 490 style:#(#style_border,#style_titlebar,#style_sysmenu,#style_minimizebox)