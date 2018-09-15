	-- function:
	-- export geo to unity asset folder as FBX type 
	-- 2.0: using dummy.fbx to locate geo
	-- 3.0 using pyFunc.method + XRef for export FBX files
	-- 4.0 using NArtTools.method and preference setting
	-- 5.0 using NArtTools , export the max in the same folder and dummyGroup as transform reference
	-- Actor: panyuan @PWD 2015.4.10
	-- Version:5.0  

macroScript NArtFFMapWorkFlow
category:"_NArtTools"
ButtonText:"FF_Map Work Flow"
toolTip:"FF_Map Work Flow"
(
	on execute do(

	clearListener()
	global files=#()
	global exfiles=#()
	global filesName=#()
	global errorfiles=#()
	global exfiles=#()
		
	try(destroydialog mergeMaxFiles)catch()
	rollout mergeMaxFiles "Merge Max �ļ�"
	(
		edittext filePath "�ļ�·��:" width:450 pos:[5,5]
		button loadFiles "��ȡ" width:50 height:18 pos:[455,5]
		listbox fileList "Ҫ�������ļ�:" width:500 height:30 pos:[5,30]
		button delFile "ȥ��" width:50 pos:[105,25]
	-- 	spinner oldSize "ԭʼ�߶��Ǽ���:" range:[0.1,10,1.8] width:100 pos:[5,450] align:#left
	-- 	spinner newSize "��Ҫ����������:" range:[0.1,10,2.3] width:100 pos:[205,450] align:#left
		button doIt "����" width:100 pos:[295,450]
		button expIt "����" width:100 pos:[405,450]
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
			if (filePath.text == "") then messagebox "��ѡ��·��"
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
			try(deletefile (filePath.text+"\���󱨸�.txt"))catch()
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
					errorReport="�в����ļ�������:\n�ļ������ļ��а���������塢�������������淶\n��ԭ��û�е���\n����Ŀ¼�µ�txt�ļ��в鿴\n\n"
					if errorfiles.count!=0
					then
					(
						messagebox  errorReport
						for a in errorfiles do errorReport += a+"\n"					
						errorfile = createfile (filePath.text+"\���󱨸�.txt")
						format errorReport to:errorfile
						close errorfile
						ShellLaunch (filePath.text+"\���󱨸�.txt") ""
					)
			
		)
		
		on expIt pressed do 
		(
			progress.value = 0.0
			errorfiles=#()
			if (queryBox "�������Ḳ��ԭʼ�ļ���ԭʼ�ļ��Ƿ��Ѿ��������ݣ�" title:"ע�⣡" )
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
				else messagebox "û�е�����ļ�"
				if errorfiles.count!=0  then
					(
						errorReport="ģ�Ͷ�Ӧ��Դ�ļ�����������\n\n���ܵ��º��������⣬����\n\n"
						messagebox  errorReport
						for a in errorfiles do errorReport += a+"\n"
						errorfileName = createfile (filePath.text+"\���󱨸�.txt")
						if (doesFileExist errorfileName) then
						(
							errorfile = openFile filename
							format errorReport to:errorfile
							close errorfile
							)
						else
							(
								errorfile = createfile (filePath.text+"\���󱨸�.txt")
								format errorReport to:errorfile
								close errorfile
								)

						ShellLaunch (filePath.text+"\���󱨸�.txt") ""
					)
				)			

			)-- end button

	)
	createdialog mergeMaxFiles 510 490 style:#(#style_border,#style_titlebar,#style_sysmenu,#style_minimizebox)

	)-- end execute
)