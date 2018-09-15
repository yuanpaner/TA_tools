	-- function:
	-- export geo to unity asset folder as FBX type 
	-- 2.0: using dummy.fbx to locate geo
	-- 3.0 using pyFunc.method + XRef for export FBX files
	-- 4.0 using NArtTools.method and preference setting
	-- 5.0 using NArtTools , export the max in the same folder and dummyGroup as transform reference
	-- Actor: panyuan @PWD 2015.4.10
	-- Version:5.0  
	-- Version: 6.0 Xfile name change 

macroScript NArtExportScene
category:"_NArtTools"
ButtonText:"Export FBX and Information"
toolTip:"Export FBX and Transform Info"
(
	on execute do(

		clearListener()
		
		if (queryBox "确认已经设置好源文件路径(WorldEntities)和目标文件路径(Models)！\n\n确认打开的是场景文件！\n\n与需要导出的元件max文件在同一文件夹中！") then
		(
			_sceneName = getFilenameFile maxFilename  -- maxfile.max to maxfile
			_sceneName = NArtName.standardName (getfilenamefile maxfilename) "delFirstLetter"

			_prjPath = NArtPreferenceSetting()
			_prjPath.loadValue()

			_fbxFilePath = _prjPath.m_ExportTargetPath
			_maxFilePath = _prjPath.m_ArtSourcePath
			if(_fbxFilePath[_fbxFilePath.count]!=@"\")then  _fbxFilePath += @"\"
			if(_maxFilePath[_maxFilePath.count]!=@"\")then  _maxFilePath += @"\"

			_xmlFile = _fbxFilePath + _sceneName  + ".xml"
			_matFilePath = _fbxFilePath + "Materials\\"
			_texFilePath = _fbxFilePath  + "Textures\\"


			makeDir _fbxFilePath --for export fbx file create folder
			makeDir _matFilePath
			makeDir _texFilePath
			if (queryBox "确认删除之前文件夹中的FBX、材质、贴图文件么？\n如果第一次导出请忽略。" )then
			(
				NArtElse.deleteOriFile _fbxFilePath true "*.FBX"--!add directory
				NArtElse.deleteOriFile _matFilePath true "*.mat"
				NArtElse.deleteOriFile _texFilePath true "*.*"
				
			) --querry del
			


			/* store the geometry information to geoInfo array */
			struct geo(
				id,
				name,
				pos,
				rot,
				eul,
				sca
				)
			geoInfo = #()
			i=1
			for x in geometry do 
			(
				rx = x.rotation.x_rotation
				ry = x.rotation.y_rotation
				rz = x.rotation.z_rotation
				eul = #(rx,ry,rz)
				tmp = geo i x.name x.pos x.rotation eul x.scale
				append geoInfo tmp
				i+=1
				)


			/* writing xml */
				
			NArtXml.AppendChild_simple _xmlFile 1 _sceneName	-- root node
-- 			for i =1 to geoInfo.count do 
-- 				(
					/* standrad name the geo */
-- 					xname = NArtName.standardName geoInfo[i].name "G"
-- 					xprename = NArtName.splitname (NArtName.standardName xname "P") "_" ".prefab"
					/* writing xml file */
					print "----------------------------" 
-- 					NArtXml.AppendChild_attr3 _xmlFile 2 "gameObjects" "name" xname "asset" xprename "none" "none" 
					
-- 					NArtXml.AppendChild_simple _xmlFile 3 "position"
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "x" geoInfo[i].pos.x
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "y" geoInfo[i].pos.y
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "z" geoInfo[i].pos.z
-- 					
-- 					NArtXml.AppendChild_simple _xmlFile 3 "quat"
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "x" geoInfo[i].rot.x
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "y" geoInfo[i].rot.y
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "z" geoInfo[i].rot.z
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "w" geoInfo[i].rot.w
-- 					
-- 					NArtXml.AppendChild_simple _xmlFile 3 "rotation"
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "x" geoInfo[i].eul[1]
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "y" geoInfo[i].eul[2]
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "z" geoInfo[i].eul[3]
-- 					
-- 					NArtXml.AppendChild_simple _xmlFile 3 "scale"
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "x" geoInfo[i].sca.x
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "y" geoInfo[i].sca.y
-- 					NArtXml.AppendChild_innerText _xmlFile 4 "z" geoInfo[i].sca.z
						
-- 				)


			/* export dummy */
			for i =1 to geoInfo.count do 
			(
				myD = Dummy name:("D_" + (NArtName.standardName geoInfo[i].name "P"))
				myD.scale = geoInfo[i].sca
				myD.rotation = geoInfo[i].rot
				myD.position = geoInfo[i].pos
				
				)
			group $D_* name:_sceneName --makes a group of all box*'s named "boxes".
			_exe = "select $"+_sceneName
			execute _exe
			fname = "F" + _sceneName + ".FBX"
			NArtExport.fn_ExportFbx _fbxFilePath  fname false false _selected:true
			delete selection


			/* export XRef file to FBX*/
			maxfiles = #()
			maxfiles = getfiles (_maxfilepath + "*.max")
			print maxfiles.count
			with redraw off
			(
				for i=1 to maxfiles.count do
				(
					_fn = filenamefrompath maxfiles[i]
					fname = NArtName.standardName (getFilenameFile maxfiles[i]) "F"
					fullname = _fbxFilePath + fname
					if ((filterString _fn "_").count == 4 and (NArtElse.noExistFile fullname)) then 
					(
-- 							obj= (getMAXFileObjectNames _fn)[1]
							loadMaxFile maxfiles[i] useFileUnits:true quiet:true
	-- 						fname = NArtName.standardName (getFilenameFile maxfiles[i]) "F"
	-- 						fullname = _fbxFilePath + fname
	-- 						if (NArtElse.noExistFile fullname) then
	-- 						(
							NArtExport.fn_ExportFbx _fbxFilePath  fname false true --fn exportFbx _exportPath  _fileName  _isAnim _isTextrue _selected:false
	-- 						)
							
					)
					

				)
			)			
		)--querry

	)
)
