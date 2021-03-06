--------------------BIP工具--------------------------------------
--选择场景内所有BIP骨骼/隐藏解除隐藏BIP骨骼
macroscript Select_Biped
category:"茶壶动作工具"
buttontext:"Select Biped"
tooltip:"Select Biped"
(
	
	on execute do
	(
		tp_bipobjArray=#()
		for i in objects do 
			(
				if classof i == biped_object do
					(
						if classof i.controller!=Footsteps do append tp_bipobjArray i
					)
			)--把BIP骨骼加入数组
		if tp_bipobjarray.count>0 do select tp_bipobjArray
		max motion mode
	)
	
	on altExecute type do
	(
		tp_bipobjArray=#()
		for i in objects do 
			(
				if classof i == biped_object do
					(
						if classof i.controller!=Footsteps do append tp_bipobjArray i
					)
			)--把BIP骨骼加入数组
		if tp_bipobjarray.count>0 do 
		if tp_bipobjArray[1].isHidden == true then unhide tp_bipobjArray else hide tp_bipobjArray
			
	)
)


--选择场景内所有bone骨骼/隐藏解除隐藏BONE骨骼
macroscript Select_Bone
category:"茶壶动作工具"
buttontext:"Select Bone"
tooltip:"Select Bone"
(
	on execute do
	(
		tp_boneobjArray=#()
		for i in objects do 
		if classof i == BoneGeometry do append tp_boneobjArray i  --把bone骨骼加入数组
		if tp_boneobjarray.count>0 do select tp_boneobjArray
	)
	on altExecute type do
	(
		tp_boneobjArray=#()
		for i in objects do 
		if classof i == BoneGeometry do append tp_boneobjArray i  --把bone骨骼加入数组
		if tp_boneobjarray.count>0 do 
		if tp_boneobjArray[1].isHidden == true then unhide tp_boneobjArray else hide tp_boneobjArray
	)
)

--选择场景内所有BIP和bone骨骼/隐藏解除隐藏场景内所有BIP和bone骨骼
macroscript Select_Biped_and_Bone
category:"茶壶动作工具"
buttontext:"Select BipBone"
tooltip:"Select Biped and Bone"
(
	on execute do
	(
		tp_BipBoneObjArray=#()
		for i in objects do 
			(
				if classof i == biped_object or classof i == BoneGeometry do
					(
						if classof i.controller!=Footsteps do append tp_BipBoneObjArray i
					)
			)--把BIP骨骼加入数组
		if tp_BipBoneObjArray.count>0 do select tp_BipBoneObjArray
		max motion mode
	)
	on altExecute type do
	(
		tp_BipBoneObjArray=#()
		for i in objects do 
			(
				if classof i == biped_object or classof i == BoneGeometry do
					(
						if classof i.controller!=Footsteps do append tp_BipBoneObjArray i
					)
			)--把BIP骨骼加入数组
		if tp_BipBoneObjArray.count>0 do 
		if tp_BipBoneObjArray[1].isHidden == true then unhide tp_BipBoneObjArray else hide tp_BipBoneObjArray
	)
)

--选择质心/隐藏NUB
macroscript Select_Root
category:"茶壶动作工具"
buttontext:"Select Root"
tooltip:"Select Root"
(
	on execute do
		(
			tp_boneroot=#()
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #turn)
					Exit
				)
			)
			max motion mode
		)
)

macroscript Hide_helper
category:"茶壶动作工具"
buttontext:"Hide helper"
tooltip:"Hide helper"
(
	on execute do
		(
			tp_HelperArray=#()
			tp_bipNub=#()
			tp_HHArray=for i in $hh* collect i
			if $000!=undefined do append tp_HHArray $000
			for i in helpers do
			(
				if classof i.controller==BipSlave_Control then append tp_bipNub i else append tp_HelperArray i
			)
			hide tp_bipNub
			hide tp_HHarray
			for i in objects do if classof i.controller==Footsteps do append tp_bipNub i
			if tp_HelperArray.count>0 do
			(
				if tp_HelperArray[1].isHidden==true then unhide tp_HelperArray else hide tp_HelperArray
			)
		)	
	on altExecute type do
		(
			tp_bipNub=#()
			tp_HHArray=for i in $hh* collect i
			if $000!=undefined do append tp_HHArray $000
			for i in helpers do if classof i.controller==BipSlave_Control do append tp_bipNub i
			for i in objects do if classof i.controller==Footsteps do append tp_bipNub i
			for i in tp_HHArray do append tp_bipNub i
			
			if tp_bipNub.count>0 do
			if tp_bipNub[1].isHidden==true then unhide tp_bipNub else hide tp_bipNub
		)
)
--冻结/解冻场景内所有模型物体
macroscript Freeze_Geomertry
category:"茶壶动作工具"
buttontext:"Freeze Geomertry"
tooltip:"Freeze Geomertry"
(
	on execute do
		(
			tp_GeometryClass=#()
			tp_GeoArray=#()
			for i in objects do
			if superclassof i==GeometryClass do append tp_GeometryClass i
			for i in tp_GeometryClass do
				(
					if classof i!=Biped_Object and classof i!=BoneGeometry then append tp_GeoArray i
				)
			for i in tp_GeoArray do i.showFrozenInGray=off
			if tp_GeoArray[1].isFrozen==false then 
			(
				freeze tp_GeoArray
				for i in selection do
				(
					for a in tp_GeoArray do
					(
						if i==a do deselect i
					)
				)
			)
			else unfreeze tp_GeoArray

		)
	on altExecute type do
		(
			tp_exGeoArray=#()
			for i in objects do
			(
				if classof i!=PolyMeshObject and classof i!=Editable_Poly and classof i!=Editable_mesh then append tp_exGeoArray i
			)
			if tp_exGeoArray[1].ishidden==false then hide tp_exGeoArray else unhide tp_exGeoArray

		)
)


-------------------------------------bip工具--------------------------------


---------------------------------项目工具----------------------------------
--骨骼镜像并重命名
macroscript BoneMirrortool
category:"茶壶动作工具"
buttontext:"Bone Mirror tool"
tooltip:"Bone Mirror tool"
(
	tp_getCoordCenter=getCoordCenter()
	tp_getRefCoordSys=getRefCoordSys()
	
	setRefCoordSys #world
	setCoordCenter #system 
	
	tp_OldSelArray=for i in selection collect i
	tp_SelBones=for i in selection collect i
	select tp_SelBones
	
	max mirror
	tp_MirrorBone=for i in selection collect i
	
	for i=1 to tp_MirrorBone.count do 
	(
		tp_namefilterArray=filterString tp_SelBones[i].name "_"	
		tp_foo=1
		for a=1 to tp_namefilterArray.count do
		(
			if tp_namefilterArray[a]=="L" then 
			(
			tp_namefilterArray[a]="R"
			tp_foo=2
			)
			else
			(
				if tp_namefilterArray[a]=="R" then
				(
					 tp_namefilterArray[a]="L"
					 tp_foo=2
				)
			)
		)
		if tp_foo==2 then
		(
			tp_NewBonename=tp_namefilterArray[1]
			for b=2 to tp_namefilterArray.count do tp_NewBonename=tp_NewBonename+"_"+tp_namefilterArray[b]
			tp_MirrorBone[i].name=tp_NewBonename
		)
	)
	
	setRefCoordSys tp_getRefCoordSys
	setCoordCenter tp_getCoordCenter

)

macroscript BoneRenametool
category:"茶壶动作工具"
buttontext:"Bone Rename tool"
tooltip:"Bone Rename tool"
(	
	tp_BoneChildArray=#()
	tp_renameBoneArray=#()
	fn tp_getChildArray_fn tp_selobj=
	(
		if tp_selobj.children.count==1 then
		(
			append tp_BoneChildArray tp_selobj.children[1] 
			tp_getChildArray_fn tp_selobj.children[1] 
		)
		else return tp_BoneChildArray
	)
	
	if selection.count==1 then
	(
		tp_NameHead=$.name
		tp_getChidArray=tp_getChildArray_fn $
		append tp_renameBoneArray $
		for i in tp_getChidArray do append tp_renameBoneArray i
		tp_foo=0
		for i in tp_renameBoneArray do
		(
			tp_foo+=1
			i.name=tp_NameHead+tp_foo as string
		)
	)
	else
	(
		messagebox"请选择单个骨骼物体" title:"选择错误"
	)
)
		