
struct NArtNewSkin(		

	--删除前缀
		fn fn_ReplaceStr _str _part _Part2=
		(
			_newStr = _str
			_index= findString _str _part
			if _index !=undefined do
			(
				_newStr = replace _str _index (_part.count) _Part2
			)	
			return _newStr
		),
	
	--换算Dummy名
		fn fn_nameConvert _str _prefix=
		(
			_newname = _prefix
			_PartName = NArtNewSkin.fn_ReplaceStr _str _prefix "" 

			_PartName = NArtNewSkin.fn_ReplaceStr _PartName "Bone" "B"
			_PartName = NArtNewSkin.fn_ReplaceStr _PartName "Bip001" "P"
			_PartName = NArtNewSkin.fn_ReplaceStr _PartName "Dummy"	"D"		
			
			_strArray  = filterstring _PartName " _"
	
			for i=1 to _strArray.count do 
			(
				_newname  +="_" + _strArray[i]				
			)			                         
			return _newname
		),
		
	--创建position约束	
		fn fn_postionContraitLink  _biped _bone= 
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
		),
		
	--创建rotation约束		
		fn fn_rotationContraitLink  _biped _bone= 
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
		),		
		
	--创建蒙皮的Dummy 并绑定给骨骼 
		fn fn_CreatSkinDummy part _Prefix=
		(
			_skinDummy = undefined
			if part != undefined   then(
				_name =  NArtNewSkin.fn_nameConvert (part.name) _Prefix	
				for i in objects  where i.name == _name do  _skindummy = i
				if( _skindummy == undefined )do(					
					_skinDummy = Dummy ()
					_skinDummy.name  = _name
					_skinDummy.transform = part.transform	
					NArtNewSkin.fn_postionContraitLink part _skinDummy
					NArtNewSkin.fn_rotationContraitLink part _skinDummy						
				)
			
			)	
			return _skinDummy
		),		
	
	--设置层和选择集	
		fn fn_SetLayerAndSets  _array _LayerName=
		(		
			_DummyLayer = layermanager.getLayerFromName _LayerName
			if _DummyLayer == undefined do 
				(_DummyLayer = layermanager.newlayerfromName _LayerName)
			_boneSets = #()
			for i in _array  do
			(
				_DummyLayer.addnode i				
			)		
			selectionSets[_LayerName] = _array		
		),
		
	--链接所有SkinDummy到父集Dummy
		fn fn_LinkDummy _array  _Parent=
		(
			for i in _array  where  i.name != _Parent.name do 
			(
				i.parent = _Parent
			)			
		),
		
	--根据蒙皮创建DummySkin	
		fn fn_creatAllSKinDummy _Target _Prefix =
		(	
			_DummySkinSystem = #()
			
			select _target
			max modify mode	

			for i=1 to (skinops.getnumberbones _target.skin)do
			(
				_ObjName =  skinOPs.getBoneName _target.skin i 1
				_bone = undefined
				for j in objects do
				(
					if j.name == _ObjName do
					(
						_bone = j
						exit
					)					
				) 
				if _bone != undefined do
				(
					_skinDummy = NArtNewSkin.fn_CreatSkinDummy _bone _Prefix	
					append _DummySkinSystem _skinDummy
				) 				
			)	
			_DummyRoot = dummy()
			_DummyRoot.name = "_root"
			append _DummySkinSystem _DummyRoot
			NArtNewSkin.fn_LinkDummy _DummySkinSystem _DummyRoot			
			return _DummySkinSystem 
		),
		
		--获得skin物体
		fn fn_getSKinOBJ  = 
		(
			_targetArray = #()
			_target = undefined
			for i in objects do 
			(
				if i.modifiers.count > 0 do
				(
					for j in i.modifiers do
					(
						j.name = "skin"
						_target = i
						append _targetArray i
						exit
					)					
				)

			)
			return _targetArray
		),
		
	--获得点的权重数值	
		fn fn_getWeightValuelist _skin _index = 
		(
			_WeightValuelist = #()
			_count = skinOPS.getVertexWeightCount _skin _index
			for i=1 to _count do
			(
				_Weight= skinOPS.getVertexWeight _skin _index i
				append _WeightValuelist _Weight
			)	
			return _WeightValuelist
		),
		
	--获得点的骨骼控制组--name
		fn fn_getWeightBipedNameList _skin _index =
		(
			_BipedNameList = #()
			_count = skinOPS.getVertexWeightCount _skin _index
			for i=1 to _count do
			(
				_BipedID= skinOPS.getVertexWeightBoneID _skin _index i
				_BipedName = skinops.getBoneName _skin _BipedID 1	
				append _BipedNameList _BipedName
			)
			return _BipedNameList
		),

	--获得新的骨骼控制组--Name
		fn fn_GetBoneNameList  _NameList  _Prefix= 
		(	
			_NewNameList = #()
			for i in _NameList do 
			(	
				_newName = NArtNewSkin.fn_nameConvert i _Prefix
				append _NewNameList _newName
			)
			return _NewNameList
		),
		
	--	骨骼控制组Name转换成ID信息
		fn fn_nameListConvertTOID _skin _NameList =
		(
			_IDList = #()
			for n in _NameList do
			(
				for i=1 to (skinops.GetNumberbones _skin) do
				(
					if (skinops.getBoneName _skin i 1) == n do
					(					
						append _IDList i
						exit
					)
				)
			)
			return _IDList
		),
		
	--获得蒙皮信息
		fn fn_GetNewSkinDate _obj _Prefix= 
		(	
			_skinDate = #()
			if _obj !=undefined do
			(
				select _obj
				max modify mode
				_VertsCount = skinOPs.getNumberVertices _obj.skin
				for i = 1 to _VertsCount  do 
				(
					_WeightsList = NArtNewSkin.fn_getWeightValuelist _obj.skin i 
					_Namelist = NArtNewSkin.fn_getWeightBipedNameList _obj.skin i
					j=1
					while j < _WeightsList.count do
					(
						if _WeightsList[j] == 0.0 then
						(
							deleteItem _WeightsList j
							deleteItem _Namelist j
						)else (
							j +=1
						)
					) 
					_newNamelist = NArtNewSkin.fn_GetBoneNameList _Namelist _Prefix
					_vertDate = #()
					append _vertDate _newNamelist
					append _vertDate _WeightsList
					append _skinDate _vertDate
				)				
			)
			
			return _skinDate					
		),
		
	-- 清除旧蒙皮信息
		fn fn_clearSkin  _Obj =
		(	
			sliderTime = 0f			
			addmodifier _obj (XForm())				
			maxOps.CollapseNode _Obj true
			_NewSkin = addmodifier _obj (skin())
			
		) ,
		
	--重新蒙皮
		fn fn_NewSkin _obj _SkinDate _BoneArray=
		(
			select _obj	
			max modify mode
			NArtNewSkin.fn_clearSkin _obj
			for i in _BoneArray where i.name != "_root" do
			(
				skinops.addBone _obj.skin i -1
			)
			select _obj	
			max modify mode
			for  _v=1 to _SkinDate.count do
			(
				_valueList = _SkinDate[_v][2]
				_NameList = _skinDate[_v][1]
				_IDlist = NArtNewSkin.fn_nameListConvertTOID _obj.skin _NameList
				
				if _valueList.count >0 then 					
				(
					
					skinops.replaceVertexWeights (_obj.skin) _v _IDList[1] 1
					skinops.replaceVertexWeights _obj.skin _v _IDList _valueList
					
				)					
			)
			
		),
		
	-- 删除不参与蒙皮的Bone
		fn fn_delUnuesedBone  _skinDate _BoneArray= 
		(
			for _bone in _BoneArray  where _bone.name != "_root" do 
			(
				_index = 0
				for _nameArray in _skindate do
				(
					if  findItem _nameArray[1] (_bone.name) > 0 do
					(
						_index = findItem _nameArray[1] (_bone.name)
						exit
					)					
				)				
				if _index == 0 do delete _bone
			)		
		),
		
	--找出挂点并重新连接 	
		fn  fn_GetHanging  _Prefix= 
		(
			_HangingArray = #()
			for _Hanging in objects where matchpattern _Hanging.name pattern: "HH_*" do(
				
				_ParentName = undefined
				_NewParentName = undefined
				if  _Hanging.parent !=undefined then(
					
					_ParentName = _Hanging.parent.name
					_NewParentName =  NArtNewSkin.fn_nameConvert _ParentName _Prefix	
				)else(
					_NewParentName = "_root"
				)							
				_newParent = undefined 

				for j in Objects where j.name == _NewParentName do _newParent = j

				_Hanging.parent = _newParent					
				append _HangingArray _Hanging					
		
			)
			return _HangingArray
		),
		
	--动画输出时
			
		
	-- 流程创建

		fn fn_createBoneAndSkin =
		(

			_PreName = "Ops"
			_LayerName = "DummySystemLayer"	
			_dummySystem = #()
			unhide objects
			unfreeze objects			
						
			_targetArray  = NArtNewSkin.fn_getSKinOBJ()
			for _skinObj in _targetArray do(	
				_target = _skinObj
				if _target ==undefined then 
				( 
					select objects
				)else(	
					
					_skinDate = NArtNewSkin.fn_GetNewSkinDate _target _PreName
					_dummySystem = NArtNewSkin.fn_creatAllSKinDummy _target _PreName

					
-- 					if selectionSets[_LayerName]!= undefined do
-- 						delete selectionSets[_LayerName]
-- 					NArtNewSkin.fn_SetLayerAndSets _dummySystem	_LayerName		

					NArtNewSkin.fn_NewSkin _target _skinDate _dummySystem	
-- 					NArtNewSkin.fn_delUnuesedBone _skinDate _dummySystem					

				)
			)  

			_HangingArray = NArtNewSkin.fn_GetHanging _PreName
			
			if _HangingArray != undefined do join _dummySystem _HangingArray
			
		--当文件为共用骨骼动画文件时,导出其他骨骼	
			if (matchpattern maxfilename pattern: "Xrig*"  )do(
				clearSelection()
				_rootDummy 
				for i in objects where i.name == "_root" do  _rootDummy = i
				if _rootDummy == undefined do (
					_rootDummy = dummy ()
					_rootDummy.name = "_root"
					append _dummySystem _rootDummy
				)
				
				for i in objects do (		
					
					if classof i == BoneGeometry or classof i == Biped_Object or i == dummy do(
						if 	(not matchpattern i.name pattern: "Ops*") \
						and (not matchpattern i.name pattern: "_root") \
						and (not matchpattern i.name pattern: "*Nub") \
						and (not matchpattern i.name pattern: "Bip001") \
						and (not matchpattern i.name pattern: "*Footsteps")  do(
							
							_skinDummy = NArtNewSkin.fn_CreatSkinDummy i "Ops"
							print _skinDummy.name
							
							if(_skinDummy !=undefined) do(
								append _dummySystem _skinDummy
								_skinDummy.parent =  _rootDummy
							)
							
						)
					)
				)
				
			--当物体没有蒙皮时，再添加一层父级		
				if _dummySystem ==undefined  do (
					_testdummy = dummy ()
					_rootDummy.parent = _testdummy
				)				
			)
			
		--选择蒙皮系统
			if (_dummySystem.count!=0) do(
				clearSelection()
				
				for i=1 to _targetArray.count do(	
					
					if (_targetArray[i] != undefined) do(
							selectMore 	_targetArray[i]										
					)					
				)
				
				for i=1 to _dummySystem.count do(
					if (_dummySystem[i] != undefined) do(
						try(
							selectMore 	_dummySystem[i]	
						)catch(
-- 							print _dummySystem[i]
						)										
					)					
				)	
			)		
		
		)
	)