macroScript NArtTest
category:"_NArtTools"
buttontext:"tempory test"
toolTip:"tempory test"
(
	on execute do
	(
-- 		ShellLaunch @"D:\art_ta\Public\ToolsAndPlug-ins\NArtToolsMax\scripts\NArtTools" "" 
-- 		ShellLaunch maxfilepath ""	
		
		
		Global FF_tools
		 
-- 		Global _refPath
-- 		Global prjPath
-- 		struct geoData(name,trans,mat,diffBip)
-- 		struct xrefData (name,trans,file,layer)
			
					
		rollout Check_scene "检查场景" width:145 height:263
		(
			checkbox chk_geoName "模型名称" pos:[19,100] width:104 height:16 checked:true
			checkbox chk_mat "材质球、贴图" pos:[17,120] width:105 height:16 checked:true
			button btn_check "开始检查" pos:[10,155] width:125 height:20
			button btn_rename "规整场景物体命名" pos:[10,181] width:125 height:20
			checkbox chk_ref "检查镜像物体" pos:[16,27] width:104 height:16 checked:true
			checkbox chk_nonRef "检查非镜像物体" pos:[17,49] width:105 height:16 checked:true
			groupBox grp1 "检查范围" pos:[10,10] width:125 height:65
			groupBox grp2 "检查类型" pos:[10,80] width:125 height:66
			button btn_single "查找没有复用的物体" pos:[11,209] width:125 height:20
			button btn_chkScale "查找缩放不等比的物体" pos:[11,234] width:125 height:20
					
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
				print "有所缩放的物体：\n"
				for i in a_not100 do print i.name
				print "不等比缩放的物体:\n"
				for i in a_notSame do print i.name
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
					_exe = "$"+i+"*"+" as array"
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
				errorFile = maxfilepath + "错误报告.txt"
				nonSta = #()
				thisMax  = maxfilepath + maxfilename
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
	-- 					temp = geoData (copy i.name) (copy i.transform) mat diff
						append geosInfo temp
						)
					for i = 1 to  geosInfo.count where ((chkmat and ((geosInfo[i].mat[1]!="M") \
						or(matchPattern geosInfo[i].mat pattern:"Material*") \
						or (matchPattern geosInfo[i].mat pattern:"*Default*") \
						or (geosInfo[i].diffBip[1]!="T")) ) \
						or (chkgeo and (geosInfo[i].name[1]!="G"))) do append nonSta geosInfo[i].name --(getnodebyname geosInfo[i].name)				
							
-- 					try(NamedSelectionSetManager.RemoveNamedSelSetByName "没有规范命名贴图的物体")catch()
-- 					if nonSta.count> 0 then NamedSelectionSetManager.AddNewNamedSelSet nonSta "没有规范命名贴图的物体"
-- 					macros.run "Edit" "namedSelSets" --selectionSets Editor
					errorMsg = "存在问题的几何体（命名，材质球,贴图命名）：\n"
					for i in nonSta do (errorMsg+=i+"\n")
					)
					
				--ref
				nonSta=#()
				if (chkref and filesRef.count>0) then
				(
					filesRef = makeUniqueArray filesRef
					for i in filesRef do
					(
-- 						try(
							loadMaxFile i useFileUnits:true quiet:true
							if geometry.count>1 then append nonSta (filenamefrompath i)
							else 
							(
								obj = geometry[1]
								try
								(
								if (classof obj.material!=Multimaterial) then mat = copy (i.material.name) 
								else mat = "error"				
	 								)catch(mat= "error")
								try(diff = filenamefrompath (i.material.diffusemap.filename))catch(diff="error")
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
						errorMsg += "存在问题的外部镜像文件：\n"
						for i in nonSta do (errorMsg += i +"\n")
						)
					)
					
					
				actionMan.executeAction 0 "40472" --open listener
				clearListener()
				print errorMsg to:Listener
					
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
						NamedSelectionSetManager.RemoveNamedSelSetByName "没有复用的物体"
						NamedSelectionSetManager.AddNewNamedSelSet single "没有复用的物体"
						select single
						)catch()
					macros.run "Edit" "namedSelSets"
					)
				else print "没有只有一个的物体"
				)
		)
		

		
		
		rollout Xref_operate "镜像文件操作" width:145 height:137
		(
			button btn_setPath "单独选择导出路径" pos:[10,37] width:120 height:20
			button btn_non2Xref "开始导出" pos:[10,64] width:120 height:20
			checkbox chk_import "导入外部镜像" pos:[10,12] width:122 height:16 checked:true
			button btn_openWin "打开外部参照目录" pos:[10,91] width:120 height:20
			progressBar pb "ProgressBar" pos:[12,119] width:116 height:8 value:50 visible:false
			
			local refPath
			local geos=#()
			local nonRefObj=#()
			local chkRef = true
			
-- 			local _errorFile = maxFilePath + "错误报告.txt"
			local s_existFile = "已经存在的文件：\n"
			
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
				refPath = getSavePath caption:"输出路径" initialDir:maxfilepath
				)
			on btn_non2Xref pressed  do
			(
				if(refPath[refPath.count]!=@"\")then  refPath += @"\"
				
				if (selection.count!=0) then  geos = for i in selection where (classof i!=XRefObject) collect i
					else geos = for i in geometry where (classof i != XRefObject ) collect i
				if (queryBox "是否设置好镜像文件的路径\n\n是否检查好命名\n\n是否已规整场景物体命名\n\n" ) then
				(
-- 					try(deletefile _errorFile)catch()
					pb.visible = true
					--save information of these object:
					for i in geos do
					(
						filename = "X"+(substring i.name 2 -1)
						filename = refPath + (NArtName.splitname filename "_" "_001.max")
						if(doesFileExist filename) then s_existFile+=(filenamefrompath filename)+"\n"
						obj = xrefData (copy i.name) (copy i.transform) filename i.layer
						append nonRefObj obj
						)
					if s_existFile.count>0 then print s_existFile to:Listener
						
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
							else print ("no 001 : " + nonRefObj[i].name)
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
						errL = LayerManager.newLayerFromName "errorObjs"
						pb.value=0
						refFile = #()
						for i=1 to nonRefObj.count do
						(
							try(
-- 							_oriObj = getnodebyname nonRefObj[i].name
-- 							delete _oriObj
							namePre = NArtName.splitname nonRefObj[i].name  "_" "*"
							if ((finditem refFile namePre)==0)then 
							(								
								_obj = xrefs.addNewXRefObject nonRefObj[i].file (getMAXFileObjectNames nonRefObj[i].file)[1] dupMtlNameAction:#useScene modifiers:#xref manipulators:#xref
								_obj.transform = nonRefObj[i].trans
								_obj.name = nonRefObj[i].name
								nonRefObj[i].laye r.addNode _obj		
								append refFile namePre
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
								print ("import fail: " + nonRefObj[i].name)
								--errL.addNode _obj
								)
							pb.value = 100*i/nonRefObj.count
							)--end for
							
						)--end if chkRef
-- 						ilyr = layerManager.getLayerFromName "errorObjs"
-- 						ilyr.nodes &nodes
-- 						if nodes.count==0 then layerManager.deleteLayerByName "errorObjs"
						
						)--end if , whole operation
				)--end query
			)

		)	

		
		rollout Asset_Export "导出资源" width:144 height:205
		(
			button btn_crtDummy "生成+导出Dummy" pos:[11,134] width:120 height:20
			button btn_expModel "导出模型FBX" pos:[11,159] width:120 height:20
			checkbox chk_Xref "导出镜像文件" pos:[17,29] width:104 height:16 checked:true
			groupBox grp1 "导出文件类型" pos:[10,10] width:125 height:65
			button btn_resetPath "恢复默认路径" pos:[11,108] width:120 height:20
			button btn_setPath "单独设置导出路径" pos:[11,83] width:120 height:20
			progressBar pb "ProgressBar" pos:[13,189] width:119 height:8 color:(color 30 10 190)
			label lbl2 "只针对镜像物体" pos:[19,50] width:95 height:15

			
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
			local _filePath --for final fbx path
			
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
			on chk_Xref changed state do
			(
				chkref = chk_Xref.checked
				)
			on btn_crtDummy pressed  do
			(
				
				)
			
			on Asset_Export open  do
			(
				chkref = true
				_prjPath = NArtPreferenceSetting()
				_prjPath.loadValue()
				_fbxFilepath = _prjPath.m_ExportTargetPath
				_filePath=_fbxFilepath
				makeDir _fbxFilepath
				if(_fbxFilePath[_fbxFilePath.count]!=@"\")then  _fbxFilePath += @"\"
				
				--delete dummy
				ilyr = LayerManager.getLayerFromName "Dummy Layers"
				if ilyr!=undefined then 
				(
					ilyr.nodes &dumGrp
					delete dumGrp
					)
				)
			on btn_setPath pressed  do
			(
				_filePath = getSavePath caption:"输出路径" initialDir:maxfilepath
				if _filePath==undefined then _filePath=_fbxFilepath
				if(_filePath[_filePath.count]!=@"\")then  _filePath += @"\"
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
				if (queryBox "是否已单独设置镜像输出dummy的路径\n\n如不设置则按照Preference中的设置输出\n\n" ) then
				(
					ilyr = LayerManager.getLayerFromName "Dummy Layers"
					if ilyr!=undefined then 
					(
						ilyr.nodes &dumGrp
						delete dumGrp
						)
					dumGrp=#()
					for i =0 to layerManager.count-1 do
					(
						ilyr = layerManager.getLayer i
						ilyr.nodes &nodes
						if nodes.count>0 then
						(
							lyrDum = crtDummy _Dname:ilyr.name
							append dumGrp lyrDum
							for j in nodes where (classof j!=Dummy)do
							(
								geoDum = crtDummy _Dname:("D_"+j.name) _Dtrans:j.transform
								geoDum.parent = lyrDum
								append dumGrp geoDum							
								)
							)
						)
					LayerManager.deleteLayerByName "Dummy Layers"
					NL = LayerManager.newLayerFromName "Dummy Layers"
					for obj in dumGrp do NL.addNode obj
					select dumGrp 
					fname = "F"+(getFilenameFile maxFilename)+".FBX"
					NArtExport.fn_ExportFbx _filePath fname false false _selected:true
					print (_filePath+fname)
					
				
				)--end query
			)
			on btn_expModel pressed  do --export fbx
			(
				geos = #() --name trans mat diff
				filesRef = #() --name trans file layer : change the usage--> pathname 
				--delete layer
				ilyr = LayerManager.getLayerFromName "Dummy Layers"
				if ilyr!=undefined then 
				(
					ilyr.nodes &dumGrp
					delete dumGrp
					)
				
				--store geo
				if (selection.count==0) then 
				(
					for i in geometry do 
					(
						if (classof i ==XRefObject) then  (append filesRef i.filename)
						else (append geos i)
						)--end for
					
					)
				else 
					(
					for i in selection do
					(
						if (classof i ==XRefObject) then  (append filesRef i.filename)
						else (append geos i)
						)--end for
						
						)--end else
				filesRef = makeUniqueArray filesRef
						
-- 				if(chkref) then
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
				
				)

				
		)--Asset_Export End			

	
		rollout Else_operate "其他操作" width:144 height:96
		(
			button btn_openGrp "open" pos:[14,27] width:34 height:20
			button btn_add2Layer "新建层+添加选中物体" pos:[8,64] width:128 height:20
			button btn_closeGrp "close" pos:[56,27] width:34 height:20
			button btn_explodeGrp "expl" pos:[96,27] width:34 height:20
			groupBox grp2 "Group" pos:[8,8] width:128 height:48
 			
			fn crtDialog title: =
			(
				theObj = dotNetObject "MaxCustomControls.RenameInstanceDialog" "在这输入名字"
				if (title!=unsupplied )then theobj.text =title
					else theObj.text = "输入"
				DialogResult = theObj.Showmodal()

				--test if the ok button was pressed
				if (dotnet.compareenums TheObj.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK)) then 
				(
					NewStringEntered = theobj.InstanceName
					return NewStringEntered
					)
				else return undefined
				
				--get the new text string
				NewStringEntered = theobj.InstanceName
				return NewStringEntered

				)				
			
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
				
				lyrName = crtDialog title:"输入层的名字："
				if (lyrName!=undefined) then 
				(
					NL = LayerManager.newLayerFromName lyrName
					for i in selection do NL.addNode i
					macros.run "Layers" "LayerManager"
					)
				
			)
			on btn_closeGrp pressed  do
			(
				for i in objects where (isGroupHead i) do (setgroupopen i true;print i.name)
			)
		)--Else End
----------------主程序--------
	
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
				FF_tools=newrolloutfloater "FF 场景流程" 158 780 500 90
				addrollout Check_scene FF_tools
				addrollout Xref_operate FF_tools
				addrollout Asset_Export FF_tools
				addrollout Else_operate FF_tools					
-- 			)
		)
		else
		(
			FF_tools=newrolloutfloater "FF 场景流程" 158 780 500 90
			addrollout Check_scene FF_tools
			addrollout Xref_operate FF_tools
			addrollout Asset_Export FF_tools
			addrollout Else_operate FF_tools

		)
	)--on execute do

)