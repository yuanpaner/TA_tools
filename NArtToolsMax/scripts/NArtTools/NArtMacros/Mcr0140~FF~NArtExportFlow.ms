macroScript NArtExportFlow
category:"_NArtTools"
buttontext:"FF_Export Flow"
toolTip:"FF_Export Flow"
(
	on isEnabled return ((maxVersion())[1]/1000==14)
	on execute do
	(
-- 		ShellLaunch @"D:\art_ta\Public\ToolsAndPlug-ins\NArtToolsMax\scripts\NArtTools" "" 
-- 		ShellLaunch maxfilepath ""	
		
		
		Global FF_tools
		 
-- 		Global _refPath
-- 		Global prjPath
-- 		struct geoData(name,trans,mat,diffBip)
-- 		struct xrefData (name,trans,file,layer)
			
					
		rollout Check_scene "��鳡��" width:145 height:263
		(
			checkbox chk_geoName "ģ������" pos:[19,100] width:104 height:16 checked:true
			checkbox chk_mat "��������ͼ" pos:[17,120] width:105 height:16 checked:true
			button btn_check "��ʼ���" pos:[10,155] width:125 height:20
			button btn_rename "����������������" pos:[10,181] width:125 height:20
			checkbox chk_ref "��龵������" pos:[16,27] width:104 height:16 checked:false
			checkbox chk_nonRef "���Ǿ�������" pos:[17,49] width:105 height:16 checked:true
			groupBox grp1 "��鷶Χ" pos:[10,10] width:125 height:65
			groupBox grp2 "�������" pos:[10,80] width:125 height:66
			button btn_single "����û�и��õ�����" pos:[11,209] width:125 height:20
			button btn_chkScale "�������Ų��ȱȵ�����" pos:[11,234] width:125 height:20
					
			local chknon,chkref
			local chkgeo,chkmat
			local geos = #()
			local filesRef = #() --xref file name
			local geosInfo = #() --geo data struct name trans file layer
			local nonSta = #() --not standard 
			local temp			
			local errorFile --txt file
			local thisMax  = maxfilepath + maxfilename
			local errorMsg
			
			fn f_check obj &arr type: = 
			(
				flag = 0
				if (type==unsupplied) then flag  = 0
				else
				(
					if (type=="G") then flag =1
					else
					(
						if(type = "M") then flag =2
						)					
					)
				case flag of
				(
					0:(if(obj.name[1]!="G" or obj.mat[1]!="M" or (matchPattern obj.mat pattern:"Material*") or(matchPattern obj.mat pattern:"*Default*") or (geosInfo[i].diffBip[1]!="T"))then append arr obj.name)
					1:(if(obj.name[1]!="G")then append arr obj.name)
					2:(try(if(obj.mat[1]!="M" or (matchPattern obj.mat pattern:"Material*") or(matchPattern obj.mat pattern:"*Default*") or (geosInfo[i].diffBip[1]!="T")) then  append arr obj.name)catch(append arr obj.name) )
					default:(print (obj.name + "check OK"))
					
					)				
				
				)

			on Check_scene open  do
			(
				chkgeo = chk_geoName.checked
				chkmat = chk_mat.checked
				chkref = chk_ref.checked
				chknon = chk_nonRef.checked
				)
			on chk_geoName changed state do
			(
				chkgeo = chk_geoName.checked
				)
			on chk_mat changed state do
			(
				chkmat = chk_mat.checked
				)
			on chk_ref changed state do
			(
				chkref = chk_ref.checked
				)
			on chk_nonRef changed state do
			(
				chknon = chk_nonRef.checked
				)
			on btn_chkScale pressed do
			(
				a_not100=#()
				a_notSame = #()
				if selection.count==0 then geos = geometry else geos = selection
				NArtCheck.checkScale geos &a_not100 &a_notSame
				print "�������ŵ����壺\n"
				for i in a_not100 do print i.name
				print "���ȱ����ŵ�����:\n"
				for i in a_notSame do print i.name
				try(
						NamedSelectionSetManager.RemoveNamedSelSetByName "�ǵȱ����ŵ�����"
						NamedSelectionSetManager.AddNewNamedSelSet a_notSame "�ǵȱ����ŵ�����"
						select a_notSame
						macros.run "Edit" "namedSelSets"
						)catch()
					
				)
				
			on btn_rename pressed do with undo label:"undo rename" on 
			(
				file_exp = #() --temp
				arr = #() --temp
				if selection.count==0 then geos = geometry else geos = selection
				for i in geos do (fname = NArtName.splitname i.name "_" "";append file_exp fname)
				file_exp = makeUniqueArray file_exp
				for i in file_exp do
				(
					_exe = "$"+i+"_*"+" as array" --"_*" not "*", or else xxx170, xxx171 wrong
					arr = execute _exe
					for j in arr do j.name = ""
					for j in arr do j.name = uniqueName(i+"_")
					print ("Done!" + i)
					)
				)

			on btn_check pressed  do
			(
				
				--collect geometry :ref and non ref
				geos=#()
				filesRef = #()
				errorFile = maxfilepath + "���󱨸�.txt"
				nonSta = #()
				thisMax  = maxfilepath + maxfilename
				
				
				chkgeo = chk_geoName.checked
				chkmat = chk_mat.checked
				chkref = chk_ref.checked
				chknon = chk_nonRef.checked
				
				if (selection.count!=0) then (
					for i in selection do
					(
						if (classof i ==XRefObject) then append filesRef i.filename
						else append geos i
						)
					)
					else 
						(
						for i in geometry do
							(
								if (classof i ==XRefObject) then append filesRef i.filename
								else append geos i
								)
							)
							
				-- non ref
				if (chknon) then
				(
					for i in geos do
					(
						try
						(
							if (classof i.material!=Multimaterial) then mat = copy (i.material.name) 
							else mat = "error"				
							)catch(mat= "error")
						try(diff = filenamefrompath (i.material.diffusemap.filename))catch(diff = "error")
						temp = geoData()
						temp.name = copy i.name
						temp.trans = copy i.transform
						temp.mat = mat
						temp.diffBip = diff
						append geosInfo temp
						)
					--version 1.0 seemingly wrong
-- 					for i = 1 to  geosInfo.count where ((chkmat and ((geosInfo[i].mat[1]!="M") \
-- 						or(matchPattern geosInfo[i].mat pattern:"Material*") \
-- 						or (matchPattern geosInfo[i].mat pattern:"*Default*") \
-- 						or (geosInfo[i].diffBip[1]!="T")) ) \
-- 						or (chkgeo and (geosInfo[i].name[1]!="G"))) do append nonSta geosInfo[i].name --(getnodebyname geosInfo[i].name)
					--version 2.0 					
					for i=1 to geosInfo.count do
					(
						if(chkgeo)then
						(
							if (geosInfo[i].name[1]!="G") then append nonSta geosInfo[i] --append nonSta geosInfo[i].name
							)
						if (chkmat) then
							(
								if(geosInfo[i].mat[1]!="M" or (matchPattern geosInfo[i].mat pattern:"Material*") or(matchPattern geosInfo[i].mat pattern:"*Default*") or (geosInfo[i].diffBip[1]!="T")) then  append nonSta geosInfo[i] --append nonSta geosInfo[i].name--append nonSta geosInfo[i].name
								)						
						)
							
					--version 3.0 fail
					/*
					for i in geos do
					(
						if (chkgeo and chkmat) then
						(
							f_check i &nonSta
							)
						else 
							(
								if(chkgeo) then f_check i &nonSta type:"G"
								if(chkgeo) then f_check i &nonSta type:"M"
								)
						)
						*/
-- 					try(NamedSelectionSetManager.RemoveNamedSelSetByName "û�й淶������ͼ������")catch()
-- 					if nonSta.count> 0 then NamedSelectionSetManager.AddNewNamedSelSet nonSta "û�й淶������ͼ������"
-- 					macros.run "Edit" "namedSelSets" --selectionSets Editor
					errorMsg = "��������ļ����壨������������,��ͼ��������\n"
					nonSta = makeUniqueArray nonSta
					for i in nonSta do (errorMsg+=i.name+"\t\t"+i.mat+"\n") --do (errorMsg+=i+"\n")
					if errorMsg.count>23 then 
					(
							actionMan.executeAction 0 "40472" --open listener
							clearListener()
							print errorMsg to:Listener
						)
					else (actionMan.executeAction 0 "40472";clearListener();print "�޲��淶����")
					)
					
				--ref
				
				nonSta=#()
				if (chkref and filesRef.count>0) then
				(
					filesRef = makeUniqueArray filesRef
					for i in filesRef do
					(
						--version 1.0
-- 						try(
							loadMaxFile i useFileUnits:true quiet:true
							if geometry.count>1 then append nonSta (filenamefrompath i)
							else 
							(
								obj = geometry[1]
								try
								(
								if (classof obj.material!=Multimaterial) then mat = copy (obj.material.name) 
								else mat = "error"				
	 								)catch(mat= "error")
								try(diff = filenamefrompath (obj.material.diffusemap.filename))catch(diff="error")
								try(na = obj.name)catch(na = "error")
								
								if ((chkmat and (mat[1]!="M" or (matchPattern mat pattern:"Material*") or (matchPattern mat pattern:"*Default*") \
								or (diff[1]!="T"))) \
								or(chkgeo and (na[1]!="G"))) then append nonSta (filenamefrompath i)						
								)
							
-- 							)catch(append nonSta (filenamefrompath i))
						)--end for
						
					loadMaxFile thisMax useFileUnits:true quiet:true
					if (nonSta.count>0) then
					(
						errorMsg="����������ⲿ�����ļ���\n"
						for i in nonSta do (errorMsg+=i+"\n")
						actionMan.executeAction 0 "40472" --open listener
						clearListener()
						print errorMsg to:Listener
						)
					)					
					
-- 				if (errorMsg.count>13) then 
-- 					(
-- 							actionMan.executeAction 0 "40472" --open listener
-- 							clearListener()
-- 							print errorMsg to:Listener
-- 						)
-- 				else (actionMan.executeAction 0 "40472";clearListener();print "�޲��淶����")
					
				)
			on btn_single pressed  do
			(
				file_exp = #()
				arr = #()
				single = #()
				if selection.count==0 then geos = geometry else geos = selection
				for i in geos do (fname = NArtName.splitname i.name "_" "";append file_exp fname)
				file_exp = makeUniqueArray file_exp
				for i in file_exp do
				(
					_exe = "$"+i+"*"+" as array"
					arr = execute _exe
					if arr.count==1 then (append single (getnodebyname (i+"_001")))
					)
				if single.count>0 then 
				(
					try(
						NamedSelectionSetManager.RemoveNamedSelSetByName "û�и��õ�����"
						NamedSelectionSetManager.AddNewNamedSelSet single "û�и��õ�����"
						select single
						macros.run "Edit" "namedSelSets"
						)catch()
					
					)
				else print "û��ֻ��һ��������"
				)
		)
		

		
		
		rollout Xref_operate "�����ļ�����" width:145 height:137
		(
			button btn_setPath "����ѡ�񵼳�·��" pos:[10,37] width:120 height:20
			button btn_non2Xref "��ʼ����" pos:[10,64] width:120 height:20
			checkbox chk_import "�����ⲿ����" pos:[10,12] width:122 height:16 checked:true
			button btn_openWin "���ⲿ����Ŀ¼" pos:[10,91] width:120 height:20
			progressBar pb "ProgressBar" pos:[12,119] width:116 height:8 value:50 visible:false
			
			local refPath
			local geos=#()
			local nonRefObj=#()
			local chkRef = true
			local flag = false
			
-- 			local _errorFile = maxFilePath + "���󱨸�.txt"
			local s_existFile = "�Ѿ����ڵ��ļ���\n"
			
			on chk_import changed state do
			(
				chkRef = chk_import.checked
				)
			on Xref_operate open  do
			(
-- 				prjPath.loadValue()
				refPath = copy maxfilepath
				)
			on btn_openWin pressed do 
			(
				actionMan.executeAction 0 "40876"  -- File: XRef Objects Visible
				)
			on btn_setPath pressed  do
			(
				refPath = getSavePath caption:"���·��" initialDir:maxfilepath
				)
			on btn_non2Xref pressed  do
			(
				if(refPath[refPath.count]!=@"\")then  refPath += @"\"
				
				if (selection.count!=0) then  geos = for i in selection where (classof i!=XRefObject) collect i
					else geos = for i in geometry where (classof i != XRefObject ) collect i
				if (queryBox "�Ƿ����úþ����ļ���·��\n\n�Ƿ��������\n\n�Ƿ��ѹ���������������,�������001\n\n" ) then
				(
-- 					try(deletefile _errorFile)catch()
					pb.visible = true
					nonRefObj=#() --this is the point why model increase double every operation
					--save information of these object:
					for i in geos do
					(
						filename = "X"+(substring i.name 2 -1)
						filename = refPath + (NArtName.splitname filename "_" "_001.max")
						if(doesFileExist filename) then s_existFile+=(filenamefrompath filename)+"\n"
						obj = xrefData (copy i.name) (copy i.transform) filename i.layer
						append nonRefObj obj
						)
					if s_existFile.count>9 then print s_existFile to:Listener
						
					--save node, delete objs, import objs
					if (nonRefObj.count >0 ) then
					(
						--1. save 
						print "start to save xref original files\n"
						pb.value = 0
						for i =1 to nonRefObj.count where (not (doesFileExist nonRefObj[i].file)) do
						(
							if (matchPattern nonRefObj[i].name pattern:"*_001") then
							(
								obj=getnodebyname nonRefObj[i].name
								obj.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
								saveNodes obj nonRefObj[i].file
								print nonRefObj[i].name to:Listener
								obj.transform = nonRefObj[i].trans								
								)
							--else print ("no 001 : " + nonRefObj[i].name;flag = true)
							else print ("û���ļ� 001 : " + nonRefObj[i].name;flag = true)
							pb.value = 100*i/nonRefObj.count
							)--end for
						
						if (chkRef) then
						(
						--2. delete add to import
						print "start to delete objs"
-- 						geos = #()
-- 						pb.value = 0
-- 						for i = 1 to nonRefObj.count do
-- 						(
-- 							obj = getnodebyname nonRefObj[i].name
-- 							if obj!=undefined then append geos obj
-- 								else print ("delete fail: "+nonRefObj[i].name)
-- 							pb.value = 100*i/nonRefObj.count
-- 							)
						delete geos 
							
						-- 3. import
						print "start to import xrefs"	
						--errL = LayerManager.newLayerFromName "errorObjs"
						pb.value=0
						refFile = #()
						print nonRefObj.count
							
						for i=1 to nonRefObj.count do
						(
							try(
							namePre = NArtName.splitname nonRefObj[i].name  "_" "_*" --old problem, 12and125!!!
							if ((finditem refFile namePre)==0)then 
							(								
								_obj = xrefs.addNewXRefObject nonRefObj[i].file (getMAXFileObjectNames nonRefObj[i].file)[1] dupMtlNameAction:#useScene modifiers:#xref manipulators:#xref
								append refFile namePre
								_obj.transform = nonRefObj[i].trans
								_obj.name = nonRefObj[i].name
								nonRefObj[i].layer.addNode _obj		
								)
							else 
								(								
									arr = execute ("$"+namePre+" as array")
									maxOps.CloneNodes arr[1]  expandHierarchy:false  cloneType: #copy newNodes:&objs
									_obj = objs[1]
									_obj.transform = nonRefObj[i].trans
									_obj.name = nonRefObj[i].name
									nonRefObj[i].layer.addNode _obj		
									)
								)
							catch(
								--print ("import fail: " + nonRefObj[i].name)
								print ("�ļ�����ʧ��: " + nonRefObj[i].name)
								flag = true
								)
							pb.value = 100*i/nonRefObj.count
							)--end for
						
						)--end if chkRef
-- 						ilyr = layerManager.getLayerFromName "errorObjs"
-- 						ilyr.nodes &nodes
-- 						if nodes.count==0 then layerManager.deleteLayerByName "errorObjs"
						
						)--end if , whole operation
				)--end query
				if flag then (messagebox "����û�������������ɹ������壬������������";flag = false)
			) -- end button btn_non2Xref
			

		)	

		
		rollout Asset_Export "������Դ" width:144 height:205
		(
			button btn_crtDummy "����+����Dummy" pos:[13,156] width:120 height:20
			button btn_expModel "����ģ��FBX" pos:[13,181] width:120 height:20
			button btn_resetPath "�ָ�Ĭ��·��" pos:[14,65] width:109 height:20
			button btn_setPath "�������õ���·��" pos:[14,41] width:109 height:20
			progressBar pb "" pos:[13,211] width:119 height:8 color:(color 30 10 190)
			label lbl1 "ֻ��Ծ�������ĵ���" pos:[13,13] width:121 height:16
			button btn_delFile "ɾ��Ŀ��·�����ļ�" pos:[13,121] width:120 height:20
			checkbox chk_fbx "FBX" pos:[14,100] width:41 height:18 checked:true
			checkbox chk_mat "Mat" pos:[55,100] width:41 height:18
			checkbox chk_tex "Tex" pos:[95,100] width:41 height:18
		
			local chknon 
			local chkref  
			local geos = #()
			local filesRef = #() --xref file name
			local geosInfo = #() --geo data struct name trans file layer
			local temp			
			local thisMax  = maxfilepath + maxfilename
			local errorMsg
			local _prjPath
			local _fbxFilePath 
			local dumGrp = #()
			local _filePath,_matFilePath,_texFilePath --for final fbx path
			
			--in:"D:\FF_Type0_Prj\webff_artsource\WorldEntities\maketayi\"
			--out;"\WorldEntities\maketayi"
			fn getPath s_path =
			(
				a_fn=filterString s_path ":\\/"
				index = finditem a_fn "WorldEntities"
				s_fnRet=""
				if (index==0) then (return undefined)
				else
				(
					for i=index to (a_fn.count-1) do s_fnRet +=@"\"+a_fn[i]
					return s_fnRet
					)
				)
			fn crtDummy _Dname: _Dtrans: = 
				(
					myDummy = Dummy transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
					if _Dname!=unsupplied then myDummy.name=_Dname
					if _Dtrans!=unsupplied then myDummy.transform = _Dtrans
					return myDummy
					)

			fn linkParChi Par ChiArray = 
				(	
					errors = for i in ChiArray where (i.parent != undefined ) collect i
					for i in ChiArray where (i.parent ==undefined) do i.parent  = Par
					return errors
					)
					
			fn compStr2StrArr str &strA = 
				(
					for i in strA do
					(
						if(str==i) do return true
						)
					return false	
				)
			on chk_Xref changed state do
			(
				chkref = chk_Xref.checked
				)
			
			on Asset_Export open  do
			(
				chkref = true
				_prjPath = NArtPreferenceSetting()
				_prjPath.loadValue()
				_fbxFilepath = _prjPath.m_ExportTargetPath
				_filePath=_fbxFilepath
				_matFilePath = _filePath+"Materials\\"
				_texFilePath = _filePath +"Textures\\"
				makeDir _fbxFilepath
				makeDir _matFilePath
				makeDir _texFilePath
				if(_fbxFilePath[_fbxFilePath.count]!=@"\")then  _fbxFilePath += @"\"
				
				--delete dummy
				ilyr = LayerManager.getLayerFromName "Dummy Layers"
				if ilyr!=undefined then 
				(
					ilyr.nodes &dumGrp
					delete dumGrp
					LayerManager.deleteLayerByName "Dummy Layers"
					)
				)
			on btn_delFile pressed do
			(
				if(queryBox "ȷ��Ҫɾ��ԭ������ͼ��������FBX�ļ�ô\n\n�����Ҫ������unity�е��ڹ���Ч����������ɾ��������\n\n") then
				(
					if chk_fbx.checked then NArtElse.deleteOriFile _filePath true "*.FBX"
					if chk_mat.checked then NArtElse.deleteOriFile _matFilePath true "*.mat"
					if chk_tex.checked then NArtElse.deleteOriFile _texFilePath true "*.*"
					)
				
				)
			on btn_setPath pressed  do
			(
				_filePath = getSavePath caption:"���·��" initialDir:_fbxFilepath
				if _filePath==undefined then _filePath=_fbxFilepath
				if(_filePath[_filePath.count]!=@"\")then  _filePath += @"\"
				_matFilePath = _filePath+"Materials\\"
				_texFilePath = _filePath +"Textures\\"
				print ("export path:\n"+_filepath)
				)
			on btn_resetPath pressed do
			(
				_filePath = _fbxFilepath
				if(_filePath[_filePath.count]!=@"\")then  _filePath += @"\"
				print ("export path:\n"+_filepath)
				)
			on btn_crtDummy pressed  do
			(
				--version1.0 using group : group affect the transform of XRef
				--using Layers
				if (queryBox "�Ƿ��ѵ������þ������dummy��·��\n\n�粻��������Preference�е��������\n\n" ) then
				(
					--delete dummy 
					ilyr = LayerManager.getLayerFromName "Dummy Layers"
					if ilyr!=undefined then 
					(
						ilyr.nodes &dumGrp
						delete dumGrp
						)
						
					--get the dummy Name
					--create dummy according layers ; export
					temp = NArtElse.crtDialog title:"����������Dummy������"
					if (temp!=undefined) then
						(
							dumGrp=#()
							for i =0 to layerManager.count-1 do
							(
								ilyr = layerManager.getLayer i
								ilyr.nodes &nodes
								s_lyrname = ilyr.name
								if nodes.count>0 then
								(
									if matchPattern s_lyrname pattern:"*~*" then 
									(
										i_index = findstring s_lyrname "~"
										s_par = substring s_lyrname 1 (i_index-1)
										s_chi = substring s_lyrname (i_index+1) -1
										o_par = getnodebyname s_par
										lyrDum = getnodebyname s_chi
										if o_par==undefined then o_par = crtDummy _Dname:s_par
										if lyrDum==undefined then lyrDum = crtDummy _Dname:s_chi
										lyrDum.parent = o_par
										)
									else --lyrDum = crtDummy _Dname:ilyr.name
										(
											lyrDum = getnodebyname ilyr.name
											if lyrDum==undefined then 
											(
												lyrDum = crtDummy _Dname:ilyr.name
											)
										)

									append dumGrp lyrDum
										
									for j in nodes where (classof j!=Dummy)do
									(
										geoDum = crtDummy _Dname:("D_"+j.name) _Dtrans:j.transform
										geoDum.parent = lyrDum
										append dumGrp geoDum							
										)
									)
							)
		-- 					LayerManager.deleteLayerByName "Dummy Layers"
		-- 					NL = LayerManager.newLayerFromName "Dummy Layers"
		-- 					for obj in dumGrp do NL.addNode obj
							select dumGrp 
		-- 					fname = "F"+(getFilenameFile maxFilename)+".FBX"
							fname = temp+".FBX"
							NArtExport.fn_ExportFbx _filePath fname false false _selected:true
							print (_filePath+fname)
							delete dumGrp
							)
						else Messagebox "����������"						

		
				)--end query
			)
			on btn_expModel pressed  do --export fbx
			(
				temp = NArtElse.crtDialog title:"��������Ҫ�����ģ�͵ĵ�һ���ֶΣ��ö��Ż�ո����"
				expArr = #()
				
				if temp!=undefined then
				(expArr = filterString temp ",�� ";print expArr.count)
				else expArr = #()
				
				geos = #() --name trans mat diff
				filesRef = #() --name trans file layer : change the usage--> pathname 
				--delete layer
				ilyr = LayerManager.getLayerFromName "Dummy Layers"
				if ilyr!=undefined then 
				(
					ilyr.nodes &dumGrp
					delete dumGrp
					LayerManager.deleteLayerByName "Dummy Layers"
					)
				
				--store geo
				if (selection.count==0) then 
				(
					for i in geometry do 
					(
						flag = false -- whether or not to export
						if expArr.count==0 then flag =true
						else 
						(
							index_ = findstring i.name "_"
							expGeoName = substring i.name 1 (index_-1)
							flag = compStr2StrArr expGeoName &expArr
							)
							
						if (classof i ==XRefObject and flag) then  (append filesRef i.filename)
						else if(flag) then (append geos i)
						)--end for					
					)
				else 
					(
					for i in selection do
					(
						flag = false
						if expArr.count==0 then flag =true
						else 
						(
							index_ = findstring i.name "_"
							expGeoName = substring i.name 1 (index_-1)
							flag = compStr2StrArr expGeoName &expArr
							)
							
						if (classof i ==XRefObject and flag) then  (append filesRef i.filename)
						else if(flag) then (append geos i)
						)--end for
						
						)--end else
				filesRef = makeUniqueArray filesRef
						
-- 				if(chkref) then --now only support the reference file to export
-- 					(
						--copy texture
						a_oriTexPath=#()
						for i in filesRef do
						(
							_ori = (pathConfig.removePathLeaf i)+@"\Textures\"
							print _ori
							append a_oriTexPath _ori
							)
						a_oriTexPath = makeUniqueArray a_oriTexPath
						for i in a_oriTexPath do
						(
							print i
							s_targetPath = _fbxFilepath+(getPath i)+@"\Textures\"
							makeDir s_targetPath
							DOSCommand("copy " + i + " "+ s_targetPath)
							)
						--export fbx
						for i=1 to filesRef.count do
						(
							_filePath = getPath filesRef[i]
							if (_filePath!=undefined) then (
								_filePath = _fbxFilepath+_filePath	
								_filename = getFilenameFile filesRef[i]
								_filename = "F"+(substring _filename 2 -1)+".FBX"
								loadMaxFile filesRef[i] useFileUnits:true quiet:true
								NArtExport.fn_ExportFbx _filePath  _filename false false _selected:false	
								)
								else
								(
									print ("\n!!!path:"+filesRef[i])
									)
							
							) -- end for
						loadMaxFile thisMax useFileUnits:true quiet:true
-- 						)						
				
				)--btn_expModel end

				
		)--Asset_Export End		
		
	rollout OutAsset_Export "���������ⲿ��Դ" width:144 height:140
	(
		button btn_exp "��ʼ����" pos:[8,112] width:116 height:19
		label lbl1 "���ָ���ļ��������е�max�ļ�" pos:[11,8] width:117 height:40
		button btn_maxPath "ѡ��max�ļ���" pos:[8,48] width:116 height:19
		button btn_fbxPath "ѡ�񵼳��ļ���" pos:[8,80] width:116 height:19
		
		local fbxFilePath = ""
		local _maxFilePath = ""
		local matMaxPath = ""
		local texMaxPath = ""	
		local matFbxPath = ""
		local texFbxPath = ""
		local ffPath = @"D:\FF_Type0_Prj\webff_artres\ArtProject\Assets\_ArtResources\WorldEntities\"
		on OutAsset_Export open do
		(
			fbxFilepath = maxfilepath
			_maxFilePath = ""
		)
		on btn_maxPath pressed  do
		(
			_maxFilePath = getSavePath caption:"max�ļ�·��" initialDir:_maxFilePath
			if _maxFilePath==undefined then messagebox "����ѡ��һ��max�ļ����ڵ��ļ���"
			else 
			(
				if(_maxFilePath[maxFilePath.count]!=@"\")then  _maxFilePath += @"\"
-- 				matMaxPath = _maxFilePath+"Materials\\"
				texMaxPath = _maxFilePath +"Textures\\"
				print ("export path:\n"+_maxFilePath)	
			)
		)	
		on btn_fbxPath pressed  do
		(
			fbxFilePath = getSavePath caption:"max�ļ�·��" initialDir:ffPath
			if fbxFilePath==undefined then messagebox "����ѡ��һ��max�ļ����ڵ��ļ���"
			else 
			(
				if(fbxFilePath[fbxFilePath.count]!=@"\")then  fbxFilePath += @"\"
-- 				matFbxPath = fbxFilePath+"Materials\\"
				texFbxPath = fbxFilePath +"Textures\\"
				makeDir texFbxPath
				print ("export path:\n"+fbxFilePath)	
			)
		)	
		on btn_exp pressed do
		(
			--collect maxfiles
			files = #()
			files = getFiles(_maxFilePath+"*.max")
			--copy texture
			DOSCommand("copy " + texMaxPath + " "+ texFbxPath)
			--export fbxFiles
			for i in files do
			(
				fbxName = getFilenameFile i
				fbxName = "F"+(substring fbxName 2 -1) + ".FBX"
				loadMaxFile i useFileUnits:true quiet:true
				NArtExport.fn_ExportFbx fbxFilePath fbxName false false _selected:false	
			)
		)

	) --end rollout OutAsset_Export

	rollout Else_operate "��������" width:144 height:160
	(
		button btn_openGrp "open" pos:[14,29] width:35 height:20
		button btn_add2Layer "�½���+����ѡ������" pos:[9,64] width:125 height:20
		button btn_closeGrp "close" pos:[56,29] width:32 height:20
		button btn_explodeGrp "expl" pos:[96,29] width:32 height:20
		groupBox grp1 "��" pos:[8,8] width:128 height:48
		button btn_attach "Attach" pos:[80,112] width:48 height:20
		button btn_xform "XForm" pos:[18,111] width:46 height:20
		groupBox grp2 "ģ��" pos:[8,88] width:128 height:53
 			
			--set NArtElse.crtDialog
-- 			fn crtDialog title: =
-- 			(
-- 				theObj = dotNetObject "MaxCustomControls.RenameInstanceDialog" "������������"
-- 				if (title!=unsupplied )then theobj.text =title
-- 					else theObj.text = "����"
-- 				DialogResult = theObj.Showmodal()

-- 				--test if the ok button was pressed
-- 				if (dotnet.compareenums TheObj.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK)) then 
-- 				(
-- 					NewStringEntered = theobj.InstanceName
-- 					return NewStringEntered
-- 					)
-- 				else return undefined

-- 				)				
			
			on Else_operate open  do
			(
			
			)
			on btn_openGrp pressed  do
			(
				for i in objects where (isGroupHead i) do (setgroupopen i true;print i.name)
			)
			on btn_explodeGrp pressed  do
			(
				for i in objects where (isGroupHead i) do
				(
						if (isOpenGroupHead i) then
							(
								setgroupopen i false
								explodegroup i
								)
							else explodeGroup i
							
						)
			)
			on btn_add2Layer pressed  do
			(
				
				lyrName = NArtElse.crtDialog title:"���������֣�"
				if (lyrName!=undefined) then 
				(
					NL=LayerManager.getLayerFromName lyrName
					if NL==undefined then 	NL = LayerManager.newLayerFromName lyrName
					for i in selection do NL.addNode i
					macros.run "Layers" "LayerManager"
					)
				
			)
			on btn_closeGrp pressed  do
			(
				for i in objects where (isGroupHead i) do (setgroupopen i true;print i.name)
			)
			
			on btn_attach pressed do
			(
				if selection.count!=1 then (messagebox "��ѡ����ֻѡ��һ��������в���";break)
				o_target = $
				s_name = $.name
				o_box = box()
				converttopoly o_box
				o_box.transform = o_target.transform
				polyop.deleteFaces o_box #(1,2,3,4,5,6) delIsoVerts:true
				o_box.attach o_target o_box
				o_box.name = s_name
				select o_box
				
				)
			on btn_xform pressed do with undo label:"undo xform" on 
			(
				if selection==1 then (messagebox "��ѡ��������в���";break)
				for i in selection do
				(
					resetxform i
					maxOps.CollapseNode i on
					)
				)
		)--Else End
----------------������--------
	
		----RolloutFloater-----
-- 		
		if FF_tools!=undefined then 
		(
			if FF_tools.open==true then 
			(	
				closeRolloutFloater FF_tools 
			)
-- 			else 
-- 			(
				FF_tools=newrolloutfloater "FF ��������" 158 850 500 90
				addrollout Check_scene FF_tools
				addrollout Xref_operate FF_tools
				addrollout Asset_Export FF_tools
				addrollout OutAsset_Export FF_tools
				addrollout Else_operate FF_tools rolledUp:true				
-- 			)
		)
		else
		(
			FF_tools=newrolloutfloater "FF ��������" 158 850 500 90
			addrollout Check_scene FF_tools
			addrollout Xref_operate FF_tools
			addrollout Asset_Export FF_tools
			addrollout OutAsset_Export FF_tools
			addrollout Else_operate FF_tools rolledUp:true	

		)
	)--on execute do

)