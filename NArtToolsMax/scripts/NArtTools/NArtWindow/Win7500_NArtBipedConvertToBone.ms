print "NArt工具：Biped转Bone"

rollout CreatePanel "BipedToBone" width:160 height:147
(
	button _btn_creat "create" pos:[22,105] width:122 height:25
	edittext _Prefix "" pos:[64,42] width:79 height:18
	label lbl1 "Prefix" pos:[26,44] width:34 height:20
	GroupBox grp2 "" pos:[12,30] width:138 height:108
	label lbl2 "Biped To Bone" pos:[43,11] width:111 height:22			
	checkbox _chk_toes "        delete toes" pos:[25,65] width:96 height:21
	checkbox _chk_Contraint "        Contraint" pos:[25,83] width:96 height:21
	
--获得biped置心
	fn GetBipedObj = 	
	(	
		_target = undefined
		for i in objects where (classOf i)== Biped_object do(
			if i.name.count <= 6 do 
			(
				_target = i
				break
			)
		)
		return _target
	)
	
	fn GetSize  target =	
	(
		_size = 0
		if target != undefined do(
			bipedCtrl = target.controller			
			_size = bipedCtrl.height/100
		)
		return _size
	)
	
--换算bone名
	fn BoneName _str _prefix=
	(
		_newname = _prefix
		_strArray = filterstring _str " "
		for i=2 to _strArray.count do 
		(
			_newname += "_" + _strArray[i]
		)			
		return _newname
	)
	
--根据biped创建bone
	fn CreatBone part size Child:undefined =
	(
		newBone = undefined
		if( part != undefined and part.children.count > 0 ) then(
			_pos = [0,0,0]	
			
			for i = 1 to part.children.count do
			(
				_pos += part.children[i].transform.pos
			)
			
			_pos = _pos/part.children.count
			
			if Child !=undefined  do(
				if  Child.parent==part do
				(
					_pos =Child.transform.pos
				)					
			)				
			newBone = (bonesys.createbone part.transform.pos _pos part.dir)
		)else(
			_length = (biped.gettransform part #scale).x
			newBone = (bonesys.createbone [0,0,0] [_length,0,0] part.dir)	
			newBone.transform = part.transform
		)
			newBone.name = BoneName part.name (_Prefix.text)
			newBone.width = size
			newBone.height = size	
			newBone.taper = 40
		return newBone
	)
	
--根据biped链创建bone链	
	fn CreatBoneChain target  BipedLabel size Child:undefined =
	(	
		bipedChain = #()
		_link = 1
		
		while (biped.getNode target BipedLabel link:_link) != undefined  do(
			_biped = (biped.getNode target BipedLabel link:_link)
			append bipedChain _biped
			_link += 1
		)
		
		BoneArray = #()
		
		for i in bipedChain do
		(
			newbone = CreatBone i size Child:Child
			append BoneArray newbone
		)
		
		return BoneArray
	)	
	
--链接bone链
	fn linkBoneChain part chain sub:1=
	(
		if chain.count > 0 do
		(
			for i=0 to (sub-1) do
			(
				for j=1 to (chain.count/sub) do
				(
					_index = i*(chain.count/sub)+j
					if j != 1 then
					(					
						chain[_index].parent = chain[_index-1]				
					)else(
						chain[_index].parent = part
					)				
				)			
			)		
		)
	)
	
--创建position约束	
	fn Postion_ContraitLink  _biped _bone= 
	(
		if _biped !=undefined and _bone != undefined do
		(
			_bone.pos.controller = position_list()
			_bone.pos.controller.available.controller = position_constraint()
			ctrl = _bone.pos.controller[2]
			ctrl.appendTarget _biped 50.0
			ctrl.relative = true
			_bone.pos.controller.active =2
		)
		
	)
	
--创建rotation约束		
	fn Rotation_ContraitLink  _biped _bone= 
	(
		if _biped !=undefined and _bone != undefined do
		(	
			_bone.rotation.controller = rotation_list()
			_bone.rotation.controller.available.controller = orientation_constraint()
			ctrl = _bone.rotation.controller[2]
			ctrl.appendTarget _biped 50.0
			ctrl.relative = true
			_bone.rotation.controller.active =2
		)
	)
	
--把所有bone约束至biped骨骼	
	fn BoneContraintToBiped= 
	(
		for i in objects where classof i == biped_object do
		(
			_targetName = BoneName (i.name) (_Prefix.text)
			_target
			for j in objects where classof j == boneGeometry or classof j == dummy do
			(
				if j.name == _targetName do 
				(
					_target = j
					break
				)
			)
			Postion_ContraitLink i _target
			Rotation_ContraitLink i _target
		)
		for i in objects where classof i == biped_object do
		(
			_targetName = BoneName (i.name) (_Prefix.text)
			_target
			for j in objects where classof j == boneGeometry do
			(
				if j.name == _targetName do 
				(
					_target = j
					break
				)
			)
			Postion_ContraitLink i _target
			Rotation_ContraitLink i _target
		)

		
	)
	
--设置层和选择集	
	fn SetLayerAndSets  _array=
	(		
		_BoneLayer = layermanager.getLayerFromName "BoneLayer"
		if _Bonelayer == undefined do 
			(_BoneLayer = layermanager.newlayerfromName "BoneLayer")
		_boneSets = #()
		for i in _array  do
		(
			_BoneLayer.addnode i				
		)		
		selectionSets["BoneSets"] = _array		
	)
	
--根据biped创建bone骨架	
	fn creatAllBones _convertBiped delToes: false =
	(	
		_boneSystem = #()
		if _convertBiped !=undefined then(
			_size = getsize _convertBiped
			_bipedCtrl = _convertBiped.controller
			-- 创建Bone
			_head = (biped.getNode _convertBiped #head )
			_pelvis = (biped.getNode _convertBiped #pelvis)	
			
			_B_head = CreatBone _head (2.5*_size)
			_B_pelvis = CreatBone _pelvis (3*_size)			
			
			_B_larm_chain = CreatBoneChain _convertBiped #larm _size
			_B_rarm_chain =  CreatBoneChain _convertBiped #rarm _size
			_B_lleg_chain = CreatBoneChain _convertBiped #lleg _size
			_B_rleg_chain = CreatBoneChain _convertBiped #rleg _size
			

			_B_neck_chain = #()
			if _bipedCtrl.necklinks > 1 then(
				_neck2 = (biped.getNode _convertBiped #neck link:2)
				_B_neck_chain = CreatBoneChain _convertBiped #neck (_size/2) Child:_neck2
			)else(
				_B_neck_chain = CreatBoneChain _convertBiped #neck (_size/2) Child:_head
			)
			_B_spine_chain = #()
			if _bipedCtrl.spinelinks > 1 then(
				_spine2 = (biped.getNode _convertBiped #spine link:2)
				_B_spine_chain = CreatBoneChain _convertBiped #spine _size child:_spine2
			)else(
				_neck = (biped.getNode _convertBiped #neck link:1)
				_B_spine_chain = CreatBoneChain _convertBiped #spine _size child:_neck
			)

			_B_Tail_chain = CreatBoneChain _convertBiped #Tail _size
			
			_B_lfingers_chain =	#()
			_B_rfingers_chain = #()
			if  _bipedCtrl.fingers > 1 do 
			(
				_B_lfingers_chain = CreatBoneChain _convertBiped #Lfingers (_size/3)
				_B_rfingers_chain = CreatBoneChain _convertBiped #rfingers (_size/3)
			)
			
			_B_ltoes_chain = #()
			_B_rtoes_chain = #()
			if delToes != true do
			(
				_B_ltoes_chain = CreatBoneChain _convertBiped #ltoes (_size/3)
				_B_rtoes_chain = CreatBoneChain _convertBiped #rtoes (_size/3)
			)

			-- 链接 bone
			_B_head.parent = _B_neck_chain[_B_neck_chain.count]		

			linkBoneChain _B_spine_chain[_B_spine_chain.count] _B_neck_chain
			linkBoneChain _B_spine_chain[_B_spine_chain.count] _B_larm_chain
			linkBoneChain _B_spine_chain[_B_spine_chain.count] _B_rarm_chain
			linkBoneChain _B_pelvis _B_lleg_chain
			linkBoneChain _B_pelvis _B_rleg_chain
			
			linkBoneChain _B_pelvis _B_Tail_chain
			linkBoneChain _B_pelvis _B_spine_chain				
			
			
			_fingersCount = _bipedCtrl.fingers 
			if _fingersCount>0  do
			(
				linkBoneChain _B_larm_chain[_B_larm_chain.count] _B_lfingers_chain sub:_fingersCount
				linkBoneChain _B_rarm_chain[_B_rarm_chain.count] _B_rfingers_chain sub:_fingersCount
			)

			
			
			if delToes != true do
			(
				_toesCount = _bipedCtrl.toes
				linkBoneChain _B_lleg_chain[_B_lleg_chain.count] _B_ltoes_chain sub:_toesCount
				linkBoneChain _B_rleg_chain[_B_rleg_chain.count] _B_rtoes_chain sub:_toesCount	
			)
			
			_B_Bone = Dummy boxsize:[_size,_size,_size]
			_B_Bone.name = _prefix.text
			_B_Bone.transform = _convertBiped.transform	
			_B_pelvis.parent = _B_bone					
			_B_Parent = Dummy boxsize:[_size,_size,_size]	
			setTransformLockFlags _B_Parent #all				
			_B_Parent.name = _prefix.text + "_root"
			_B_Bone.parent = _B_Parent				
			
			-- 获得创建集
			append _boneSystem _B_head
			append _boneSystem _B_pelvis
			append _boneSystem _B_Bone
			append _boneSystem _B_Parent
			append _boneSystem _B_pelvis
			
			join _boneSystem _B_larm_chain
			join _boneSystem _B_rarm_chain
			join _boneSystem _B_lleg_chain
			join _boneSystem _B_rleg_chain
			join _boneSystem _B_neck_chain
			join _boneSystem _B_spine_chain
			join _boneSystem _B_Tail_chain
			join _boneSystem _B_lfingers_chain
			join _boneSystem _B_rfingers_chain				
			join _boneSystem _B_ltoes_chain
			join _boneSystem _B_rtoes_chain			

			return _boneSystem
		)
	)
	
--初始化	
	on CreatePanel open do
	(
		_Prefix.text = "Bone001"
		_chk_toes.state = true
		_chk_Contraint.state = true
	)
	
--创建按钮	
	on _btn_creat pressed do
	(
		_convertBiped = GetBipedObj()
		
		if _convertBiped ==undefined then 
		( 
			messagebox "No biped !!" 
		)
		else(
			if selectionSets["BoneSets"]!= undefined do
				delete selectionSets["BoneSets"]
			_boneSystem = creatAllBones _convertBiped	delToes:(_chk_toes.state)
			SetLayerAndSets _boneSystem	
			if _chk_Contraint.state do BoneContraintToBiped()
		)	
	)
	
)
createDialog CreatePanel