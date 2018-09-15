print "NArt工具：炸开每个面"

try(destroyDialog faceBreak)catch()
-- 	faceObjectsArray = #()
-- 	newName = ""
-- 	desObj = undefined 

	fn canConv obj = (canConvertTo obj Editable_Poly)

	--rollout
	rollout faceBreak "炸开每个面！" width:272 height:344
	(
		pickButton btnPick "选择物体" pos:[176,24] width:72 height:48 filter:canConv toolTip:""
		label lbl2 "detach后的新名称：" pos:[38,104] width:120 height:16
		editText edtNewName "" pos:[33,128] width:183 height:24
		button btnBreak "炸开每个面" pos:[24,272] width:224 height:48
		checkbox chkDelOri "删除原来的物体" pos:[38,176] width:160 height:16 checked:true
		checkbox chkPar2P "连接给point" pos:[38,204] width:160 height:16 checked:true
		checkbox chkSelFace "只detach选中的面" pos:[38,232] width:160 height:16 checked:false
		label lbl4 "detach的对象：" pos:[26,25] width:120 height:24 enabled:true
		label lblDetach "请选择需要detach的模型" pos:[27,52] width:133 height:20
		groupBox grp1 "" pos:[24,80] width:224 height:176
		
		local newName = ""
		local desObj = undefined 
		
-- 		local selTri = selectionSets["triagle"]
-- 		local selRec = selectionSets["Rectangle"]
-- 		local selN = selectionSets["otherPoly"]
		local faces=#()
		local tri=#()
		local rec = #()
		local non = #()
		
		on faceBreak open  do
		(
			sels = selection
			if (sels[1]!=undefined ) then 
			(
				desObj = sels[1]
				lblDetach.caption = desobj.name	
			)
			)
		on btnPick picked obj do
		(
			if obj!=undefined then lblDetach.caption = obj.name	
			desObj = obj
			)
		on edtNewName entered text do
		(
			newName = edtNewName.text
			)
		on btnBreak pressed do with undo label:"break faces" on
		(
			if (desObj == undefined) then (messagebox "请选择需要detach的物体")
			else
			(
	-- 			print edtNewName.text
				if (edtNewName.text != "") then newName = edtNewName.text + "_"
					else ( newName = desObj.name + "_face_")
				faces = NArtGeometry.faceBreakFunc desObj chkDelOri.state chkPar2P.state chkSelFace.state newName
-- 				print faces
				for i in faces do
				(
-- 					print i
					if i.numverts == 3 then append tri i
					else if i.numverts == 4 then append rec i
						else append non i
					)
				NamedSelectionSetManager.AddNewNamedSelSet tri "triagle"
				NamedSelectionSetManager.AddNewNamedSelSet rec "Rectangle"
				NamedSelectionSetManager.AddNewNamedSelSet non "otherPoly"
				free tri
				free rec
				free non
				free faces
				macros.run "Edit" "namedSelSets"
			)
		)
		on chkDelOri changed state do
		(
			
			)
		on chkPar2P changed state do
		(
			
			)
		on chkSelFace changed state do
		(
			
			)
	)


	createDialog faceBreak pos:[20,20]