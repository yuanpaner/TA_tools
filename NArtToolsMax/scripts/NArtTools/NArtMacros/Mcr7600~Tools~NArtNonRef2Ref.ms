	-- function:
	-- turn non reference objs to ref objs
	-- problem! : not record error files (map_workflow.ms)
	-- Version:1.0   panyuan @PWD 2015.6.12

macroScript NArtNonRef2Ref
category:"_NArtTools"
ButtonText:"nonRef2Ref objs"
toolTip:"nonRef2Ref objs"
(
	on execute do(

		--worldEntities workflow
		--panyuan @pwd 2015/6/3
		clearListener()

		struct geo(name,trans,mat,diffBip)
		struct ref (name,trans,file)
-- 		nonStaName = #()
-- 		nonStaMat = #()
		refObj=#()
		nonRefObj=#()
		geos=#()
			
		_prjPath = NArtPreferenceSetting()
		_prjPath.loadValue()
		_fbxFilePath = _prjPath.m_ExportTargetPath  
		_maxFilePath = _prjPath.m_ArtSourcePath  
		if(_fbxFilePath[_fbxFilePath.count]!=@"\")then  _fbxFilePath += @"\"
		if(_maxFilePath[_maxFilePath.count]!=@"\")then  _maxFilePath += @"\"
				

		----------------------------------------
		-- check ref obj
		-- change all to ref
		-- store in refObj#()
		-- modified 2015/6/11 by PY @pwd
		----------------------------------------
		if (selection.count!=0) then geos = selection
		else geos = geometry
		

		existFile = "已经存在的文件：\n"
		newRefObj=#()
		newRefObjName=#()
		refFile = #()
			
		for i in geos do i.name = NArtName.standardName i.name "G"
		for i in geos where (classof i != XRefObject) do
			(
				filename = "X" + (substring i.name 2 -1)
				filename = _maxFilePath + (NArtName.splitname filename "_" "_001") + ".max"
				if(doesFileExist filename) then append refFile filename --existFile = existFile + filename + "\n"
				obj = ref (i.name) (copy i.transform) filename
				append nonRefObj obj	--store nonRefObj
				print i.name
				print filename
				)
		refFile = makeUniqueArray refFile
		for i in refFile do existFile += i + "\n"
		print existFile
		free refFile
		print "-----------------------------\n"

		if (nonRefObj.count>0) then
		(
			format "there are % non reference objs\n" nonRefObj.count
			for i=1 to nonRefObj.count do
			(
				if(not (doesFileExist nonRefObj[i].file)) then
					(
						format "%\t has not existed and start to save node\n" nonRefObj[i].file
						obj = getnodebyname nonRefObj[i].name
						newObjName = NArtName.splitname nonRefObj[i].name "_" "_001"
						obj.name = newObjName
						obj.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
						saveNodes obj nonRefObj[i].file
						delete obj
						_obj = xrefs.addNewXRefObject nonRefObj[i].file (getMAXFileObjectNames nonRefObj[i].file)[1] dupMtlNameAction: #useScene modifiers: #xref  manipulators: #xref
						_obj.transform = nonRefObj[i].trans
						append newRefObj _obj
						)
					else
						(
							format "%\t has existed and start to ref node\n" nonRefObj[i].file
							obj = getnodebyname nonRefObj[i].name
							print obj.name
							delete obj
							_obj = xrefs.addNewXRefObject nonRefObj[i].file (getMAXFileObjectNames nonRefObj[i].file)[1]dupMtlNameAction: #useScene modifiers: #xref  manipulators: #xref
							_obj.transform = nonRefObj[i].trans
							_obj.name = uniqueName(NArtName.splitname nonRefObj[i].name "_" "_")
							append newRefObj _obj
							)
					

				)
			format "\nThere are % objs turned to ref objs" newRefObj.count
			)
		else messagebox "没有非镜像物体"
		-- print newRefObj
-- 		newRefObjName = for i in newRefObj collect  (NArtName.splitname i.name "_" "") 
-- 		makeUniqueArray newRefObjName
-- 		for n in newRefObjName do print n
	)
)
