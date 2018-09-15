macroScript breakableObj_BB
category:"BBTools"
tooltip:"breakableObj"
buttonText:"可破坏物件"
(
	global breakableObjFloater
	
	rollout rltFractureVoronoi "自动切割物体"
	(
		groupBox boxSetUp "" pos:[5,0] width:155 height:83
		fn geometryFilter obj = superClassOf obj == GeometryClass
		pickButton pbObject "拾取物体" pos:[30,11] width:106 height:25 filter:geometryFilter tooltip:"指定要切割的物体"
		spinner spnNbParts "基本碎片数: " pos:[35,41] width:106 height:16 range:[2,1000,10] type:#integer enabled:false
		spinner spnNbIter "重复次数:     " pos:[35,61] width:106 height:16 range:[1,10,1] type:#integer enabled:false
	
		groupBox boxMat "" pos:[5,81] width:155 height:89
		spinner spnNewID "新材质ID数:" pos:[35,93] width:91 height:16 range:[1,100,1] indeterminate:true type:#integer enabled:false
		checkBox cbKeepMat "保留材质" pos:[12,110] checked:true enabled:false
		spinner spnNewCh "新贴图通道数:" pos:[45,133] width:83 height:16 range:[1,10,3] type:#integer enabled:false
		checkBox cbRWMS "读写贴图尺寸" pos:[12,150] width:120 height:16 checked:true enabled:false
	
		groupBox boxHierarchy "" pos:[5,168] width:155 height:48
		checkBox cbKeepGen "保持重复次数" pos:[12,179]  checked:false enabled:false
		checkBox cbLinkGen "空心" pos:[12,196]  checked:false enabled:false
	
		groupBox boxCreate "" pos:[5,214] width:155 height:109
		button btnCreate "切割成10 个部分" pos:[30,225] width:106 height:25 tooltip:"请先拾取一个物体" enabled:false
		radiobuttons rdoColor "" pos:[12,253] width:150 height:32 labels:#("不同颜色","统一颜色") default:1 columns:1 enabled:false
		colorPicker cpParts "" pos:[90,270] fieldWidth:20 height:12 visible:false
		radiobuttons rdoCenter "" pos:[12,288] width:150 height:32 labels:#("以边界盒为中心","以体积为中心") default:1 columns:1 enabled:false
	
		groupBox boxProgress "" pos:[5,321] width:155 height:49 --pos:[17,140] width:128 height:10
		progressBar pbProgress "" pos:[17,335] width:128 height:10 value:0 color:[0,96,0]
		label lblProStatus "" pos:[10,351] width:100 height:17
	
		local theObject			-- holds the original object
	
	
		on pbObject picked obj do
		(
			pbObject.text = obj.name
			theObject = obj
			spnNbParts.enabled = true
			spnNbIter.enabled = true
			spnNewID.enabled = true
			cbKeepMat.enabled = true
			spnNewCh.enabled = true
			cbRWMS.enabled = true
			cbLinkGen.enabled = true
			btnCreate.enabled = true
			btnCreate.tooltip = "开始切割"
			rdoColor.enabled = true
			rdoCenter.enabled = true
			cpParts.color = obj.wireColor
			cpParts.visible = true
				
			when obj deleted do
			(
				btnCreate.enabled = false
				btnCreate.tooltip = pbObject.text + " 已经被删除！"
				pbObject.text = "拾取物体"
			)
			
			undo off
			(	-- gets new mat ID for new faces
				m = edit_mesh()
				addModifier obj m
				spnNewID.value = amax(for i = 1 to obj.numfaces collect getFaceMatID obj i) + 1
				deleteModifier obj m
			)
	
		)	-- end on btnMesh picked theMesh
	
	
		on btnCreate pressed do
		(
			undo off
			(
				disableSceneRedraw()
				clearSelection()
				start = timeStamp()
				
				local nbParts = spnNbParts.value
				local nbIter = spnNbIter.value
				local keepGen = cbKeepGen.checked
				local linkGen = cbLinkGen.checked
				local aPartsStart = #()
				local aPartsEnd = #()
				local aAllParts = #()
				local aAllCoords = #()
				local thePlane = plane width:1 length:1 widthSegs:1 lengthSegs:1	-- plane helper for slice plane
				local theMesh = editable_mesh()
				local abortBreaking = false
				local Group_obj = #()
				local iGroup_obj = #()
				
				lblProStatus.caption = " 切割中..."
				
				--	BREAKING UP
				---------------
				
				-- clean copy (no custom attributes, keyframes, weird transforms, etc
				theCopy = copy theObject
				theCopy.name = "toto"
				resetXForm theCopy
				convertToMesh theCopy
				theMesh.mesh = theCopy.mesh
				theMesh.transform = theCopy.transform
				theMesh.pivot = [0,0,0]
				resetXForm theMesh
				convertToMesh theMesh
				delete theCopy
				
				-- material and UVs
				if cbKeepMat.checked do theMesh.material = theObject.material
				addModifier theMesh (uvwMap mapChannel:spnNewCh.value realWorldMapSize:cbRWMS.checked)
				convertToMesh theMesh
				setFaceSelection theMesh #{}
				
				-- parts creation
				aPartsEnd = #(theMesh)
				for iter = 1 to nbIter while not abortBreaking do
				(
					aPartsStart = aPartsEnd
					aPartsEnd = #()
					
					for obj in aPartsStart while not abortBreaking do
					(	
						aPartsTemp = for i = 1 to nbParts collect copy obj
						pSys = pcloud emitter:obj formation:3 total_number:nbParts quantityMethod:1 viewPercent:100 seed:(random 0 100)
						aCoords = for i = 1 to nbParts collect particlePos pSys i	-- fill with random coordinates
						delete pSys
						for i = 1 to nbParts - 1 do for j = i + 1 to nbParts while not abortBreaking do	-- for each pair of coords
						(
							thePlane.pos = (aCoords[i] + aCoords[j]) / 2
							thePlane.dir = aCoords[j] - aCoords[i]
							
							addModifier aPartsTemp[i] (sliceModifier slice_type:2)
							addModifier aPartsTemp[j] (sliceModifier slice_type:3)
							aPartsTemp[i].slice.slice_plane.transform = thePlane.transform
							aPartsTemp[j].slice.slice_plane.transform = thePlane.transform
							if linkGen == off do 
							(
								addModifier aPartsTemp[i] (cap_holes())
								addModifier aPartsTemp[j] (cap_holes())
							)
							convertToMesh aPartsTemp[i]
							convertToMesh aPartsTemp[j]
							
							if keyboard.escPressed do abortBreaking = queryBox "你想要放弃并删除已经创建的碎片？"
						)	-- end i loop
						aPartsEnd += aPartsTemp
						aAllParts += aPartsTemp
						aAllCoords += aCoords
						
						total = nbParts * ((nbParts^nbIter - 1) / (nbParts - 1))
						prog = 100 * aAllParts.count / total
						pbProgress.value = prog
						pbProgress.color = [200 - prog * 2,prog * 2,0]
					)	-- end obj loop
				)	-- end iter loop
				
				if not abortBreaking then
				(
					lblProStatus.caption = " 完成中..."
					
					-- 	TIDYING UP
					--------------
					
					delete theMesh
					delete thePlane
					hide theObject
					
					-- intermediate generations
					if not keepGen and nbIter != 1 do
					(
						ind = 0
						for i = 1 to nbIter - 1 do for j = 1 to nbParts^i do
						(
						ind += 1
						delete aAllParts[ind]
						aAllCoords[ind] = undefined
						)
						aAllParts = for obj in aAllParts where not isDeleted obj collect obj
						aAllCoords = for c in aAllCoords where c != undefined collect c
					)
					
					-- coordinates
					if rdoCenter.state == 1 then centerPivot aAllParts
					else for i = 1 to aAllParts.count do aAllParts[i].pivot = aAllCoords[i]
					resetXForm aAllParts
					convertToMesh aAllParts
					
					-- new faces ID
					newID = spnNewID.value
					for obj in aAllParts do
					(
						for f in getFaceSelection obj do setFaceMatID obj f newID
						setFaceSelection obj #{}
					)
					
					-- names
					if not keepGen or nbIter == 1 then
						for i = 1 to aAllParts.count do aAllParts[i].name = theObject.name + "_" + i as string
					else
					(
						for i = 1 to nbParts do aAllParts[i].name = theObject.name + "_" + i as string 
						indP = 0
						indC = nbParts
						for i = 1 to nbIter - 1 do for j = 1 to nbParts^i do
						(
							indP += 1
							for k = 1 to nbParts do
							(
								indC += 1
								aAllParts[indC].name = aAllParts[indP].name + "_" + k as string
							)	-- end k loop
						)	-- end j loop
					)	-- end else
					
					-- layers
					-- (comment out this block if you don't want any layer, intermediate generations will not be hidden)
					-- (FROM HERE...)
					
					Group_obj = for obj in aAllParts collect obj
					if selectionSets["Group_Obj_刚体"] != undefined then
						iGroup_obj = for iObj in selectionSets["Group_Obj_刚体"] collect iObj 
					selectionSets["Group_Obj_刚体"] = iGroup_obj + Group_obj
					--else
					--selectionSets["Group_碎片"] = Group_obj

		
					-- hierarchy
					/*if linkGen do
					(
						if not KeepGen or nbIter == 1 then for obj in aAllParts do attachObjects theObject obj move:false
						else
						(
							for i = 1 to nbParts do attachObjects theObject aAllParts[i] move:false
							indP = 0
							indC = nbParts
							for i = 1 to nbIter - 1 do for j = 1 to nbParts^i do
							(
								indP += 1
								for k = 1 to nbParts do
								(
									indC += 1
									attachObjects aAllParts[indP] aAllParts[indC] move:false
								)	-- end k loop
							)	-- end j loop
						)	-- end else
					)	-- end if linkGen
					*/
					
					-- colors
					if rdoColor.state == 1 then for obj in aAllParts do obj.wireColor = random black white
					else aAllParts.wireColor = cpParts.color
					
					lblProStatus.caption = " 花费时间 " + (formattedPrint ((timeStamp() - start) / 1000.0) format:".1f") + "秒"
					
					enableSceneRedraw()
					completeRedraw()
				)
				else
				(
					delete thePlane
					delete theMesh
					delete aAllParts
					pbProgress.value = 0
					lblProStatus.caption = " 停止"
					enableSceneRedraw()
				)	-- end test abortBreaking
				
			)	-- end undo off
			
		)	-- end btnCreate pressed
	
	
		on spnNbParts changed val do
		(
			btnCreate.caption = "切割成 " + ((val ^ spnNbIter.value) as string) + " 个部分"
		)
	
	
		on spnNbIter changed val do
		(
			btnCreate.caption = "切割成 " + ((spnNbParts.value ^ val) as string) + " 个部分"
			cbKeepGen.enabled = val != 1
		)
		
	
		on rltFractureVoronoi close do
		(
			enableSceneRedraw()
			CompleteRedraw()
			callbacks.removeScripts id:#FVcbID01
		)
	
	)	-- end rollout rltFractureVor

	
	rollout autoSkin_Rollout "自动绑点" width:168 height:608
	(
		spinner width_spn "Width:" pos:[32,12] width:112 height:16 range:[0,100,10] type:#float 
		spinner Height_spn "Height:" pos:[25,36] width:120 height:16 range:[0,100,10] type:#float 
		spinner length_spn "Length:" pos:[25,60] width:120 height:16 range:[0,100,20] type:#float 
		button CreateBone_btn "创建骨骼" pos:[16,196] width:136 height:26 enabled:false toolTip:"建议Length = Width + Height"
		checkbox BoneOn_chk "Bone On" pos:[16,81] width:128 height:13 checked:false
		label createProStatus "" pos:[17,227] width:127 height:17
		GroupBox bonePro_grp "" pos:[5,0] width:155 height:101
		GroupBox Create_grp "" pos:[5,100] width:155 height:268
		button autoSkin_btn "自动绑点" pos:[16,473] width:136 height:32 enabled:false 
		--local SetList = (for x = 1 to selectionSets.count collect selectionSets[x].name ) 
		fn updateList = (for x = 1 to selectionSets.count collect selectionSets[x].name)
		local SetList = updateList()
		dropdownList boneSet_ddl "动力学骨骼选择集列表：" pos:[16,409] width:139 height:41 selection:0  items:SetList 
		dropdownList objSet_ddl "动力学物体选择集列表：" pos:[14,148] width:136 height:41 selection:0 items:SetList
		button autoMerge_btn "自动合并" pos:[16,250] width:136 height:32 enabled:false toolTip:"自动合并参与动力学计算的物体！"
		GroupBox grp3 "" pos:[8,368] width:155 height:91
		label infoProgress_lbl "" pos:[16,509] width:136 height:19
		fn geometryFilter obj = superClassOf obj == GeometryClass
		pickbutton addObj_btn "拾取物体" pos:[22,295] width:123 height:24 toolTip:"拾取不参与动力学模拟的物体！" filter:geometryFilter  
		GroupBox grp7 "" pos:[16,282] width:136 height:76
		button manualMerge_btn "手动合并" pos:[22,327] width:123 height:24 enabled:false toolTip:"手动合并不参与动力学计算的物体！"
		button selNullVertex_btn "选择空点" pos:[16,532] width:136 height:32 toolTip:"选择权重为0的点！"
		GroupBox grp11 "" pos:[8,459] width:155 height:134	
		label infoSelNullVertex_lbl "" pos:[16,569] width:136 height:16
		button refresh_btn "刷新列表" pos:[15,112] width:137 height:26 toolTip:"刷新动力学物体和骨骼选择集列表"
		button btn8 "刷新列表" pos:[16,380] width:136 height:25 toolTip:"刷新动力学物体和骨骼选择集列表"

		fn vID n =(
		$.EditablePoly.selectByMaterial n
		$.EditablePoly.ConvertSelection #Face #Vertex
		($.EditablePoly.GetSelection #Vertex)  as array
		)

		local theAddObj
	
		on CreateBone_btn pressed  do
		(
			undo on
			(
				start = timeStamp()
				createProStatus.caption = " 创建中..."	

				Group_rigidBone = #()
				Group_endBone = #()
				--根部骨骼及末端
				local rootBone,rootBoneTrans,rootBonePos,rootBoneEnd,objList,var
				var = objSet_ddl.selection
				objList = selectionsets[var]
				rootBone = BoneSys.createBone [0,0,0] [30,0,0] [0,0,1]
				rootBone.name = "Bone_根部0"
				rootBone.boneEnable = BoneOn_chk.state
				selectionSets["Group_Bone_根部"] = rootBone--append Group_rigidBone RootBone
				
				rootBoneTrans = rootBone.transform
				rootBonePos = rootBoneTrans.translation
				
				rootBoneEnd = BoneSys.createBone rootBonePos (rootBonePos + 10) rootBone.dir
				rootBoneEnd.transform =  rootBoneTrans
				in coordSys Local move rootBoneEnd [30,0,0]
				rootBoneEnd.parent = rootBone
				rootBoneEnd.width = rootBone.width
				rootBoneEnd.height = rootBone.height
				rootBone.taper = 90
				rootBoneEnd.length    = (rootBone.width+rootBone.height)/2
				rootBoneEnd.name	  = "Bone_根部0_末端"
				append Group_endBone rootBoneEnd
				--新骨骼
				for i = 1 to objList.count do
				(
					local rigidObj  = objList[i]
					local rigidObjTrans = rigidObj.transform
					local rigidObjPos   = rigidObjTrans.translation
					local newbone
				
					newBone= BoneSys.createBone rigidObjPos (rigidObjPos+10) rigidObj.dir
					newBone.transform = rigidObjTrans
				
					newBone.width     = width_spn.value
					newBone.height    = Height_spn.value
					newBone.taper     = 90
					newBone.length    = length_spn.value
					newBone.name	  = "Bone_"+ rigidObj.name
					newBone.parent	  =	rootBone
					newBone.boneEnable	   = BoneOn_chk.state
					
					append Group_rigidBone newBone
					selectionSets["Group_Bone_刚体"] = Group_rigidBone
				)
				--末端骨骼
				for j=1 to Group_rigidBone.count do
				(
					local endObj = Group_rigidBone[j]
					local endObjTrans = endObj.transform
					local endObjPos   = endObjTrans.translation
					local endBone
				
					endBone =	BoneSys.createBone endObjPos (endObjPos+10) endObj.dir
					endBone.transform = endObjTrans
					in coordSys Local move endBone [endObj.length,0,0]
					
					endBone.parent	  =	endObj
					
					endBone.width     = endObj.width
					endBone.height    = endObj.height
					endBone.taper     = 90
					endBone.length    = (endObj.width+endObj.height)/2
					endBone.name	  = "Bone_末端"+((j-1) as string)
					
					append Group_endBone endBone
					selectionSets["Group_Bone_末端"] = Group_endBone
					hide selectionSets["Group_Bone_末端"]
				)
					createProStatus.caption = "完成...花费时间 " + (formattedPrint ((timeStamp() - start) / 1000.0) format:".1f") + " 秒..."
					enableSceneRedraw()
					completeRedraw()
			)
		)
		on autoSkin_btn pressed  do
		(
			if (selection.count == 1 and selection[1].name == "v_body")  then
			(
				try
				(
					start = timeStamp()
					infoProgress_lbl.caption = " 自动绑点中..."
					local boneList,sel
					sel = boneSet_ddl.selection
					--为所选择的物体添加skin修改器，并限制影响骨骼为2，关掉为所有点设置权重
					addmodifier $ (skin bone_Limit:2 weightAllVertices:off showNoEnvelopes:on filter_vertices:on initialStaticEnvelope:on initialEnvelopeInner:0.5 initialEnvelopeOuter:1 )
					max modify mode
					boneList = selectionsets[sel]
					for k = 1 to boneList.count do 
					(
						skinOps.addBone $.modifiers[#Skin] boneList[k] 1
					)
					modPanel.setCurrentObject $.modifiers[#Skin]
					
					--为骨骼列表里头的骨骼添加权重,根据id号
					for j = 1 to boneList.count do --sBoneList = 1
					(
						for i = 1 to (vID j).count do 
						(
							skinOps.SetVertexWeights $.modifiers[#Skin] ((vID j)[i]) j 1
						)
					)
					infoProgress_lbl.caption =  "完成...花费时间 " + (formattedPrint ((timeStamp() - start) / 1000.0) format:".1f") + " 秒..."
				)
				catch()
			)
			else infoProgress_lbl.caption = "未选择v_body..."
		)
		on boneSet_ddl selected sel do
		(
			if boneSet_ddl.selection > 0 do autoSkin_btn.enabled = true
		)
		on objSet_ddl selected sel do
		(
			if objSet_ddl.selection > 0 do 
			(
				CreateBone_btn.enabled = true
				autoMerge_btn.enabled = true
			)
		)
		on autoMerge_btn pressed  do
		(
			try
			(
				local objList,sel,A
				sel = objSet_ddl.selection
				objList = selectionsets[sel]		
					--自动设置id
					o = 1
					while o <= objList.count do 
					(	
						convertTo objList[o] (Editable_Poly)
						allFaceNum = polyOp.getNumFaces objList[o]
						allFace = (for i = 1 to allFaceNum  collect i)
						polyOp.setFaceMatID objList[o] allFace o 
						o += 1
					)
					
					--自动合并
					p = 1
					A = copy objList[p]
					A.name = "v_body"
					A.wirecolor = black
					deleteKeys A
					resetXForm A
					A.pivot = [0,0,0]
					convertTo A (Editable_Poly)
					while p <= (objList.count-1) do
					(
						polyOp.attach A (copy objList[p+1])
						p += 1
					)
				)
				catch()
		)
		on addObj_btn picked obj do
		(
			addObj_btn.text = obj.name
			theAddObj = obj
			manualMerge_btn.enabled = true
		)
		on manualMerge_btn pressed  do
		(
			if (selection.count == 1 and selection[1].name == "v_body" ) then
			(
				try
				(
					local objList,sel,addObj
					sel = objSet_ddl.selection
					objList = selectionsets[sel]
					addObj = copy theAddObj
					
					convertTo addObj (Editable_Poly)
					allFaceNum = polyOp.getNumFaces addObj
					allFace = (for i = 1 to allFaceNum  collect i)
					polyOp.setFaceMatID addObj allFace (objList.count+1) 
			
					polyOp.attach $ addObj  
					
					addObj_btn.text = "拾取物体"
					manualMerge_btn.enabled = false
				)
				catch()
			)
			else createProStatus.caption = "未选择v_body！"
		)
		on selNullVertex_btn pressed  do
		(
			if (selection.count == 1 and selection[1].name == "v_body" and selection[1].modifiers["skin"] != undefined) then
			(
				try
				(
					infoSelNullVertex_lbl.caption = "搜索中..."
					nullVerts = #()
					allVerts = skinOps.GetNumberVertices $.modifiers[#Skin]
					y=1
					while y <= allVerts do
					(
						if (skinOps.GetVertexWeightCount $.modifiers[#Skin] y) == 0 do
						append nullVerts y
						y += 1
					)
					skinOps.SelectVertices $.modifiers[#Skin] nullVerts -- as bitarray)
					subObjectLevel = 1
					if nullVerts.count >= 1 then
						infoSelNullVertex_lbl.caption = "共有" + ((nullVerts.count) as string) + " 个空点被选择..."
						else infoSelNullVertex_lbl.caption = "没有空点..."
				)
				catch ()
			)
			else infoSelNullVertex_lbl.caption = "没有skin修改器..."
		)
		on refresh_btn pressed  do
		(
			boneSet_ddl.items = updateList()
			objSet_ddl.items = updateList()
		)
		on btn8 pressed  do
		(
			boneSet_ddl.items = updateList()
			objSet_ddl.items = updateList()
		)
	)
	if breakableObjFloater != undefined do
	(
	closeRolloutFloater breakableObjFloater
	)
	breakableObjFloater = newRolloutFloater "可破坏物件" 180 660
	addRollout rltFractureVoronoi breakableObjFloater
	addRollout autoSkin_Rollout breakableObjFloater
	rltFractureVoronoi.open = off
)
