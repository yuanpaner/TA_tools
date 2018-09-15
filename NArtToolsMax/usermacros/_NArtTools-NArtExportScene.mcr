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
-- 		 	_prjPath.m_ExportTargetPath = @"D:\FF_Type0_Prj\webff_artres\SandboxU3d5\Assets\_ArtResources"
-- 		 	_prjPath.m_ArtSourcePath = @"D:\FF_Type0_Prj\webff_artsource"
			_prjPath.loadValue()

-- 			_fbxFilePath = _prjPath.m_ExportTargetPath + @"\Maps\Models\" + _sceneName + @"\"
-- 			_maxFilePath = _prjPath.m_ArtSourcePath + @"\WorldEntities\" + _sceneName + @"\"
			--temp
			-- _fbxFilePath = @"D:\FF_Type0_Prj\webff_artres\SandboxU3d5\Assets\_ArtResources\Maps\Models\bhys\"
			-- _maxFilePath = @"D:\FF_Type0_Prj\webff_artsource\WorldEntities\bhys\"
			_fbxFilePath = _prjPath.m_ExportTargetPath + @"\"
			_maxFilePath = _prjPath.m_ArtSourcePath +  @"\"


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
			for i =1 to geoInfo.count do 
				(
					/* standrad name the geo */
					xname = NArtName.standardName geoInfo[i].name "G"
					xprename = NArtName.splitname (NArtName.standardName xname "P") "_" ".prefab"
					/* writing xml file */
					print "----------------------------" 
					NArtXml.AppendChild_attr3 _xmlFile 2 "gameObjects" "name" xname "asset" xprename "none" "none" 
					
					NArtXml.AppendChild_simple _xmlFile 3 "position"
					NArtXml.AppendChild_innerText _xmlFile 4 "x" geoInfo[i].pos.x
					NArtXml.AppendChild_innerText _xmlFile 4 "y" geoInfo[i].pos.y
					NArtXml.AppendChild_innerText _xmlFile 4 "z" geoInfo[i].pos.z
					
					NArtXml.AppendChild_simple _xmlFile 3 "quat"
					NArtXml.AppendChild_innerText _xmlFile 4 "x" geoInfo[i].rot.x
					NArtXml.AppendChild_innerText _xmlFile 4 "y" geoInfo[i].rot.y
					NArtXml.AppendChild_innerText _xmlFile 4 "z" geoInfo[i].rot.z
					NArtXml.AppendChild_innerText _xmlFile 4 "w" geoInfo[i].rot.w
					
					NArtXml.AppendChild_simple _xmlFile 3 "rotation"
					NArtXml.AppendChild_innerText _xmlFile 4 "x" geoInfo[i].eul[1]
					NArtXml.AppendChild_innerText _xmlFile 4 "y" geoInfo[i].eul[2]
					NArtXml.AppendChild_innerText _xmlFile 4 "z" geoInfo[i].eul[3]
					
					NArtXml.AppendChild_simple _xmlFile 3 "scale"
					NArtXml.AppendChild_innerText _xmlFile 4 "x" geoInfo[i].sca.x
					NArtXml.AppendChild_innerText _xmlFile 4 "y" geoInfo[i].sca.y
					NArtXml.AppendChild_innerText _xmlFile 4 "z" geoInfo[i].sca.z
					
					--modify: export the file in the folder	 
			-- 			fname=_fbxFilePath + (standardName (splitname x.name "_" ".FBX") "F")
			-- 			 exportSetting "Geometry"
			-- 			if((getfiles fname).count == 0) then --just need one prefab for copies
			-- 			(
			-- 				tmpPos = x.position
			-- 				tmpRot = x.rotation 
			-- 				tmpSca = x.scale
			-- 		
			-- 				  x.position = [0,0,0]
			-- 				  x.scale=[1,1,1]
			-- 				  deg = eulerAngles 0 0 0
			-- 				  x.rotation = (quat 0 0 0 1)
			-- 				 
			-- 				  select x
			-- 				  exportfile fname #noprompt selectedonly:true using:t_fbx
			-- 		 
			-- 				  x.rotation = tmpRot
			-- 				  x.position = tmpPos
			-- 				  x.scale = tmpSca
			-- 			)		
				)


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
			for i=1 to maxfiles.count do
			(
				_fn = filenamefrompath maxfiles[i]
				fname = NArtName.standardName (getFilenameFile maxfiles[i]) "F"
				fullname = _fbxFilePath + fname
				if ((filterString _fn "_").count > 2 and (NArtElse.noExistFile fullname)) then 
				(
						loadMaxFile maxfiles[i] useFileUnits:true quiet:true
-- 						fname = NArtName.standardName (getFilenameFile maxfiles[i]) "F"
-- 						fullname = _fbxFilePath + fname
-- 						if (NArtElse.noExistFile fullname) then
-- 						(
						NArtExport.fn_ExportFbx _fbxFilePath  fname false true --fn exportFbx _exportPath  _fileName  _isAnim _isTextrue _selected:false
-- 						)
						
				)
				

			)		
		)--querry

	)
)
