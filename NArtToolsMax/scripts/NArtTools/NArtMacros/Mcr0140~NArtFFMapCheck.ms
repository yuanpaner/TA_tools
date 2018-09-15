	-- function:
	-- check scene data for FF project
	-- Version:1.0   panyuan @PWD 2015.6.18

macroScript NArtFFMapCheck
category:"_NArtTools"
ButtonText:"FF_Map Name Check"
toolTip:"FF_Map Name Check"
(
	on execute do(
	
		clearListener()

		NamedSelectionSetManager.RemoveNamedSelSetByName "û�й淶��������"
		NamedSelectionSetManager.RemoveNamedSelSetByName "û�й淶������ͼ������"
		
		rollout sceneCheck "�������" width:192 height:392
		(
			local nonStaName = #()
			local nonStaMat = #()
			local refObj=#()
			local nonRefObj=#()
			local geos = #()
-- 			global _prjPath = NArtPreferenceSetting()
-- 			_prjPath.loadValue()
-- 			local _maxFilePath = _prjPath.m_ArtSourcePath --+ @"\WorldEntities\" + _sceneName + @"\"
-- 			if(_maxFilePath[_maxFilePath.count]!=@"\")then  _maxFilePath += @"\"
-- 			local _sceneName = getFilenameFile maxFilename  -- maxfile.max to maxfile
-- 			_sceneName = NArtName.standardName (getfilenamefile maxfilename) "delFirstLetter"
			
			
			button btn_geoName "ģ���������" pos:[24,24] width:112 height:32
			button btn_matCheckNR "������ͼ�������" pos:[38,120] width:108 height:32
			groupBox grp1 "��ԷǾ�������" pos:[24,88] width:144 height:78
			button btn_matNameR "������ͼ�������" pos:[40,224] width:104 height:32 enabled:false
			groupBox grp2 "��Ծ�������" pos:[24,184] width:144 height:120 enabled:false	
			on sceneCheck open  do
			(
				
				)
			on sceneCheck close  do
			(
				
				)
			on sceneCheck okToClose  do
			(
				
				)
			on btn_geoName pressed  do
			(
				nonStaName=#()

				nonStaName = for i in geometry where (i.name[1]!="G") collect i
-- 				actionMan.executeAction 0 "40472"
-- 				clearListener()
-- 				for i in nonStaName do print i.name
				NamedSelectionSetManager.RemoveNamedSelSetByName "û�й淶��������"
				if nonStaName.count> 0 then NamedSelectionSetManager.AddNewNamedSelSet nonStaName "û�й淶��������"
				macros.run "Edit" "namedSelSets" --selectionSets Editor
				)
			on btn_matCheckNR pressed  do
			(
				nonStaMat=#()
				for i in geometry where (classof i != XRefObject) do
				(
					if (i.material ==undefined or (classof i.material == Multimaterial)) then (append nonStaMat i)
					else if(i.material.name[1]!="M" or (matchPattern i.material.name pattern:"Material*") or (matchPattern i.material.name pattern:"*Default*")) then  ( append nonStaMat i)
						else if(i.material.diffusemap==undefined ) then  ( append nonStaMat i)
							else if ((filenamefrompath i.material.diffusemap.filename)[1]!="T") then  ( append nonStaMat i)
					)
				-- for i in nonStaMat do print i
-- 				NamedSelectionSetManager.RemoveNamedSelSetByName "û�й淶��������"
				NamedSelectionSetManager.RemoveNamedSelSetByName "û�й淶������ͼ������"
				if (nonStaMat.count>0)  then
				(
					NamedSelectionSetManager.AddNewNamedSelSet nonStaMat "û�й淶������ͼ������"
					macros.run "Edit" "namedSelSets" --selectionSets Editor
					)

				)

			on btn_matNameR pressed  do
			(
				
				)

		)
		
		createDialog sceneCheck 

	
	)
)