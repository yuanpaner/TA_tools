----------------------------------------------------------------------
--作者 ：煮饺子的茶壶
--QQ  ：344272088
--E-mail：344272088@qq.com
--		2011-05-12
------------------------------------------------------------------------
-----------------------------------------------------------检查重名物体--------------------------------------------------------------------------------
macroscript tp_Check_Name
category:"茶壶小工具集"
buttontext:"TP Check Name"
tooltip:"TP Check Name"
(	
	tp_allObj=for i in objects collect i
	tp_contrastArray
	tp_repeatName=#()
	for tp_contrastObj in tp_allObj do
	(
		tp_contrastArray=for i in tp_allObj where i!=tp_contrastObj collect i
		for i in tp_contrastArray do
		(
			if i.name==tp_contrastObj.name do 
			(
				tp_CheckNamefoo=false
				for a in tp_repeatName do
				(
					if i.name==a.name do tp_CheckNamefoo=true
				)
				if tp_CheckNamefoo==false do append tp_repeatName i
			)
		)
	)
	if tp_repeatName.count>0 then
	(
		tp_msgboxText="发现重名物体：\r\n\r\n"
		for i in tp_repeatName do
		(v
			tp_msgboxText+=("    "+i.name+"\r\n\r\n")
		)
		messageBox tp_msgboxText
	)
	else
	(
		messageBox "未发现重名物体"

	)
)

---------------------------------------------模型初始化(检查贴图类型并开启双面，开启模型冻结显示)------------------------------------------------------------------------------
macroScript TP_model_Initialize
category:"茶壶小工具集"
buttontext:"TP model Initialize"
toolTip:"TP model Initialize"
(
	Global GeometryArray=#()
	Global msg=0
	for i in objects do if superclassof I==geometryclass do append GeometryArray i
	for i in GeometryArray do 
		(
		if i.material!=undefined then
			(
			if classof i.material==Standardmaterial then
				(
				i.material.twosided=on
				if i.material.diffusemap!=undefined then
					(
					diffilename=i.material.diffusemap.filename
					difnameArray=filterstring diffilename "."
					difmapexe=difnameArray[difnameArray.count] as name
					if difmapexe !=#dds then
						(
						msg=1
						)
					)
				if i.material.opacitymap!=undefined then
					(
					Opafilename=i.material.opacitymap.filename
					OpanameArray=filterstring Opafilename "."
					Opaexe=OpanameArray[OpanameArray.count] as name
					if Opaexe !=#dds then
						(
						msg=1
						)
					)
				)
			else
				(
				if classof i.material==Multimaterial then
					(
					for a in i.material.material do
						(
						a.twosided=on
							
					if a.diffusemap!=undefined then
					(
					diffilename=a.diffusemap.filename
					difnameArray=filterstring diffilename "."
					difmapexe=difnameArray[difnameArray.count] as name
					if difmapexe !=#dds then
						(
						msg=1
						)
					)
				if a.opacitymap!=undefined then
					(
					Opafilename=a.opacitymap.filename
					OpanameArray=filterstring Opafilename "."
					Opaexe=OpanameArray[OpanameArray.count] as name
					if Opaexe!=#dds then
						(
						msg=1
						)
					)
					)
					)
				)
			)
		if classof i!=Biped_Object do
			(
			i.showFrozenInGray = off
			i.backfacecull=off
			)
		)
	try
		(
		units.systemscale=1.0
		units.systemtype=#inches
		units.DisplayType=#Generic
		framerate=30
		)
	catch()
	if msg==1 then
	(
	messagebox"发现未贴图错误，类型不是dds或未指定贴图"Title:"贴图错误"
	actionMan.executeAction 0 "50048"  -- Tools: Material Editor Toggle
	)

)





-----------------------------------------------------------------------------隐藏000———————————————————————————————————————
macroscript TP_hide000
category:"茶壶小工具集"
buttontext:"TP hide 000"
tooltip:"TP hide 000"
(
	fn tp_find000=
	(
		if $000!=undefined then 
		(
			if $000.ishidden==true then return true else return false
		)
		else return false
	)
	
	on isEnabled return ($000!=undefined)	
	on isChecked return (tp_find000())
		
	on execute do
	(	
		undo "hide 000" on
		(
		if $000!=undefinde do 
			if $000.ishidden==false then $000.ishidden=true else $000.ishidden=false
		)
	)
)

--------------------------------------------------------------------------拾取父物体（link 链接）--------------------------------------------------------------------------
macroScript TP_PickParent
ButtonText:"TP Pick Parent"
category:"茶壶小工具集"
Tooltip:"TP Pick Parent"
(
	on isEnabled return (selection.count>0)
	on execute do
	(
		try(
		tp_selobj=for i in selection collect i
		tp_Parent=pickobject()
		for i in selection do i.parent=tp_Parent
		append tp_selobj tp_Parent
		select tp_selobj
		tp_selobj=#()
		)catch() 
	)
)

--------------------------------------------------------------------------清理ParticleView物体--------------------------------------------------------------
macroscript TP_Del_ParticleView
	category:"茶壶小工具集"
	buttontext:"TP Del ParticleView"
	tooltip:"TP Del ParticleView"
(
	undo on
	(
		tp_ParticleView=#()
		for i in objects do
		(
			if classof i==Particle_View do append tp_ParticleView i
		)
		delete tp_ParticleView	
	)
)

----------------------------------------------------------------------------BIP Bendlinks 模式----------------------------------------------------------
macroscript TP_Bip_Bendlinksmode
	category:"茶壶小工具集"
	buttontext:"TP BIP Bendlinks Mode"
	tooltip:"TP BIP Bendlinks Mode"
(
	global tp_biproot
	global tp_biprootcontroller
	global tp_bipBend
	fn tp_getBend =
	(
		for i in geometry do
		(
			if classof i==biped_object do	
			(
				tp_biproot=(Biped.GetNode i #turn)
				tp_biprootcontroller=tp_biproot.controller
				tp_bipBend=tp_biprootcontroller.bendLinksMode
				return tp_bipBend
			)
		)
	)
	fn tp_BendDisEnabled =
	(
		tp_foo=true
		if selection.count>0 then
		(
			for i in selection do
			(
				if classof i!=biped_object do
				(
					tp_foo=false
					exit
				)
			)
		)
		else tp_foo=false
		return tp_foo
	)
	on isEnabled return (tp_BendDisEnabled())
	on isVisible return (tp_BendDisEnabled())
	on isChecked return (tp_getBend())
	on execute do
	(	
		for i in geometry do
		(
			if classof i==biped_object do	
			(
				tp_biproot=(Biped.GetNode i #turn)
				tp_biprootcontroller=tp_biproot.controller
				tp_bipBend=tp_biprootcontroller.bendLinksMode
			)
		)
		if tp_bipBend==true then tp_biprootcontroller.bendLinksMode=false else tp_biprootcontroller.bendLinksMode=true
	)

)

-------------------------------------------------------------------------------------取消所有物体路径显示--------------------------------------------------------
macroscript TP_TrajectoryOff
category:"茶壶小工具集"
buttontext:"TP Trajectory off"
tooltip:"TP Trajectory off"
(
	for i in objects do try(i.showTrajectory = off)catch()
)

-----------------------------------------------------------------------------------选择BIP子物体-------------------------------------------------------------
macroScript TP_SelectBipChildren
category:"茶壶小工具集"
buttontext:"TP Select Bip Children"
toolTip:"TP select bip children"
(
	try(
		if selection.count!=0 do
		(
			actionMan.executeAction 0 "40180"  -- Selection: Select Children
			for a=1 to 20 do
			for i in selection do if classof i!=Biped_Object do deselect i
		)
	)catch()
)

-------------------------------------------------------------------------------------Skin修改器show No Envelopes-----------------------------------------
macroScript TPshowNoEnvelopes
ButtonText:"TP show No Envelopes"
Category:"茶壶小工具集" 
Tooltip:"TP show No Envelopes (Skin)" 
(
	fn tp_skinshowNoEnvelops =
	(
		try(	
			if $.skin.showNoEnvelopes==true then
			(
				return true 
			)
			else 
			(
				return false
			)
		)catch(return false)
		
	)
	on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
	on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (tp_skinshowNoEnvelops())
	on Execute do
	(
		try(
		if $.skin.showNoEnvelopes==true then
			(
				$.skin.showNoEnvelopes=false 
			)
			else 
			(
				$.skin.showNoEnvelopes=true
			)
		)catch()
	)
)

--------------------------------------------------------------------添加加SKIN修改器 并拾取单个骨骼----------------------------------------
MacroScript tp_Skin_and_Add_Bones
ButtonText:"TP Skin and Add Bones"
Category:"茶壶小工具集" 
Tooltip:"TP Skin and Add Bones" 
(
    on isEnabled return (selection.count==1 and superclassof selection[1]==GeometryClass)
	On Execute do
	(
		modPanel.addModToSelection (Skin ()) ui:on	
		skinOps.AddBoneFromViewStart  (modPanel.GetcurrentObject())
	)
)

-----------------------------------------------------解除所有冻结隐藏------------------------------------------
macroScript TP_unhidefreezeall
category:"茶壶小工具集"
ButtonText:"TP_unhidefreezeall"
toolTip:"TP unhidefreezeall"
(
	max unfreeze all
	max unhide all
)

-----------------------------------------------------解除\冻结场景内所有模型物体 (右键菜单显示的小框为隐藏除模型外的物体)-----------------------------
macroscript TP_Freeze_Geomertry
category:"茶壶小工具集"
buttontext:"TP Freeze Geomertry"
tooltip:"TP Freeze Geomertry"
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

-----------------------------------------------------骨骼镜像并重命名R/L(骨骼命名时R与L表示左右，必须用"_"分隔开)--------------------------------------------------
macroscript TP_BoneMirrortool
category:"茶壶小工具集"
buttontext:"TP Bone Mirror tool"
tooltip:"TP Bone Mirror tool"
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

----------------------------------------------------------子骨骼自动根据根骨骼重命名(现只支持单个骨骼链，多个子物体不能识别)Bone---------------
macroscript TP_BoneRenametool
category:"茶壶小工具集"
buttontext:"TP Bone Rename tool"
tooltip:"TP Bone Rename tool"
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

-------------------------------------------------------------选择质心并切换到运动面板------------------------------------------------------------
macroscript TP_Select_Root
category:"茶壶小工具集"
buttontext:"TP Select Root"
tooltip:"TP Select Root"
(
	global tp_rootSet_Rol
	global tp_ignoreBip
	on execute do
	(
		tp_boneroot=#()
		for i in objects do
		(
			tp_getRootData=getappdata i 20110328
			if tp_getRootData=="Root" do append tp_boneroot i
		)
		select tp_boneroot
		if tp_ignoreBip!=true do
		(
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #turn)
					if getCommandPanelTaskMode()!=#motion do setCommandPanelTaskMode #motion
					Exit
				)
			)
		)

	)
	on altExecute type do
	(
		
		try(DestroyDialog tp_rootSet_Rol)catch()
		rollout tp_rootSet_Rol "根骨骼设置" width:162 height:161
		(
			pickbutton tp_SelRoot_btn "拾取根骨骼" pos:[4,82] width:75 height:25 enabled:true message:""
			label tp_lbl "当前根骨骼：" pos:[6,6] width:152 height:20
			label tp_rootName_lbl "Label" pos:[8,30] width:152 height:24
			button tp_cancel_btn "取消" pos:[83,111] width:65 height:25
			button tp_OK_btn "确定" pos:[14,111] width:65 height:25
			button tp_DelApp_btn "清空记录" pos:[83,82] width:75 height:25
			
			HyperLink tp_cgjoy_hk "2011.03.28  | 查看更新|" pos:[33,142] width:135 height:15 address:"http://www.cgjoy.com/viewthread.php?tid=12750&fromuid=3815" 
 
			checkbox tp_ignoreBIP_chk "忽略BIP" pos:[51,59] width:108 height:16
 
 

			on tp_rootSet_Rol open do
			(
				tp_rootName_lbl.caption="未发现根骨骼，请拾取"
				for i in objects do
				(
					tp_getRootData=getappdata i 20110328
					if tp_getRootData=="Root" do tp_rootName_lbl.caption=i.name
					tp_foo=true
				)
				if tp_ignoreBip==true then tp_ignoreBIP_chk.checked=true else tp_ignoreBIP_chk.checked=false
				
			)
			on tp_SelRoot_btn picked obj do
			(
			    tp_rootName_lbl.caption=obj.name
				global tp_RootObj=obj
			)
			on tp_cancel_btn pressed do
			(
				try(DestroyDialog tp_rootSet_Rol)catch()
			)
			on tp_OK_btn pressed do
			(
				for i in objects do 
				(
					tp_oldData=getappdata i 20110328
					if tp_oldData=="Root" do deleteappdata i 20110328
				)
				if tp_RootObj!=undefined do
				setappdata tp_RootObj 20110328 "Root"
				try(DestroyDialog tp_rootSet_Rol)catch()
			)
			on tp_DelApp_btn pressed do
			(
				
				for i in objects do 
				(
					tp_oldData=getappdata i 20110328
					if tp_oldData=="Root" do deleteappdata i 20110328
				)
				tp_RootObj=undefined
				tp_rootName_lbl.caption="未发现根骨骼，请拾取"
				tp_ignoreBIP_chk.checked=false
				tp_ignoreBip=false
			)--on press do
			on tp_ignoreBIP_chk changed state do
			(
				if tp_ignoreBIP_chk.checked==true then tp_ignoreBip=true else tp_ignoreBip=false
			)
		)		
		--
		--
		--
		createdialog tp_rootSet_rol
		
	)--altexecute 
)

----------------------------------------------------------------------------------选择场景内所有BIP骨骼，并切换到运动面板----------------------------
macroscript TP_Select_Biped
category:"茶壶小工具集"
buttontext:"TP Select Biped"
tooltip:"TP Select Biped"
(
	global TP_selbipedSet_rol
	global TP_rejectNubfoo
	global TP_rejectFootstepsfoo
	on execute do
	(
		tp_bipobjArray=#()
		for i in objects do 
		(
			if classof i == biped_object and classof i.controller!=Footsteps and getappdata i 20110406!="rejectBipedselect" do append tp_bipobjArray i
			
			if TP_rejectFootstepsfoo==false do
				if classof i==biped_object and classof i.controller==Footsteps do append tp_bipobjArray i
			if TP_rejectNubfoo==false do
				if classof i==Dummy and classof i.controller==BipSlave_Control do append tp_bipobjArray i

		)--把BIP骨骼加入数组
		if tp_bipobjarray.count>0 do select tp_bipobjArray
		if getCommandPanelTaskMode()!=#motion do setCommandPanelTaskMode #motion
	)
	
	on altExecute type do
	(
		try(DestroyDialog TP_selbipedSet_rol)catch()
		rollout TP_selbipedSet_rol "Biped物体排除" width:162 height:370
		(
			multiListBox TP_rejectBiped_lbx "Biped Select 排除列表" pos:[7,8] width:148 height:15
			button TP_addbiped_btn "╋" pos:[8,245] width:25 height:25
			button TP_removeBiped_btn "━" pos:[36,245] width:25 height:25
			checkbox TP_rejectNub_chk "排除Nub" pos:[16,275] width:135 height:20 
 
 
 
			button tp_OK_btn "确定" pos:[18,319] width:60 height:25
			button tp_cancel_btn "取消" pos:[85,319] width:60 height:25
			button TP_refurbish_btn "重置" pos:[64,245] width:45 height:25
			button TP_empty_btn "清空" pos:[111,245] width:45 height:25
			checkbox TP_rejectFootstep_chk "排除footstep" pos:[16,295] width:135 height:20 checked:false
			HyperLink tp_cgjoy_hk "2011.04.06  | 查看更新|" pos:[30,351] width:135 height:15 address:"http://www.cgjoy.com/viewthread.php?tid=12750&fromuid=3815" 
 
 
			
			
			on TP_selbipedSet_rol open do
			(
				TP_selbipedSet_rol.TP_rejectBiped_lbx.items=#()
				tp_rejectBipeditems=#()
				for i in objects where classof i==Biped_Object do
				(
					
					tp_getselBipedData=getappdata i 20110406
					if tp_getselBipedData=="rejectBipedselect" do
						append tp_rejectBipeditems i.name
				)
				TP_selbipedSet_rol.TP_rejectBiped_lbx.items=tp_rejectBipeditems
				if TP_rejectNubfoo==true then  TP_rejectNub_chk.checked=true else TP_rejectNub_chk.checked=false
				if TP_rejectFootstepsfoo==true then TP_rejectFootstep_chk.checked=true else TP_rejectFootstep_chk.checked=false
					
			)--on open end
			on TP_addbiped_btn pressed do
			(
				tp_appendfoo=false
				TP_rejectBiped=TP_selbipedSet_rol.TP_rejectBiped_lbx.items
				for i in selection where classof i==Biped_Object do 
				(	
					for a in TP_rejectBiped do if i.name==a do tp_appendfoo=true
					if tp_appendfoo!=true do append TP_rejectBiped i.name
					tp_appendfoo=false
				)
				TP_selbipedSet_rol.TP_rejectBiped_lbx.items=TP_rejectBiped
				
			)--on pressed end
			on TP_removeBiped_btn pressed do
			(
				tp_deleteItemArray=#()
				tp_rejectBipeditems=TP_selbipedSet_rol.TP_rejectBiped_lbx.items
				tp_rejectBipedsel=TP_selbipedSet_rol.TP_rejectBiped_lbx.selection
				
				if tp_rejectBipeditems.count>0 and tp_rejectBipedsel.count>0 do
				(
					for i in tp_rejectBipedsel do
					(
						append tp_deleteItemArray tp_rejectBipeditems[i]
					)
					for i in tp_deleteItemArray do
					(
						deleteitem tp_rejectBipeditems (finditem tp_rejectBipeditems i)
					)
					
					TP_selbipedSet_rol.TP_rejectBiped_lbx.items=tp_rejectBipeditems
				)
			)--on pressed end
			on tp_OK_btn pressed do
			(
				for i in objects where classof i==Biped_Object do
				(
					tp_oldData=getappdata i 20110406
					if tp_oldData=="rejectBipedselect" do deleteappdata i 20110406
				)
				for i in TP_selbipedSet_rol.TP_rejectBiped_lbx.items do
				(
					a=getNodeByName i all:true
					
					setappdata a[1] 20110406 "rejectBipedselect"
				)
				if TP_rejectNub_chk.checked==true then TP_rejectNubfoo=true else TP_rejectNubfoo=false
				if TP_rejectFootstep_chk.checked==true then TP_rejectFootstepsfoo=true else TP_rejectFootstepsfoo=false
				
				try(DestroyDialog TP_selbipedSet_rol)catch()
			)--on pressed end
			on tp_cancel_btn pressed do
			(
				try(DestroyDialog TP_selbipedSet_rol)catch()
			)
			on TP_refurbish_btn pressed do
			(
				TP_selbipedSet_rol.TP_rejectBiped_lbx.items=#()
				tp_rejectBipeditems=#()
				for i in objects where classof i==Biped_Object do
				(
					
					tp_getselBipedData=getappdata i 20110406
					if tp_getselBipedData=="rejectBipedselect" do
						append tp_rejectBipeditems i.name
				)
				TP_selbipedSet_rol.TP_rejectBiped_lbx.items=tp_rejectBipeditems
			)
			on TP_empty_btn pressed do
			(
				TP_selbipedSet_rol.TP_rejectBiped_lbx.items=#()
			)
		)
		createdialog TP_selbipedSet_rol
			
	)
)

------------------------------------------------------------------------选择场景内所有Bone骨骼---------------------------------------------------
macroscript TP_Select_Bone
category:"茶壶小工具集"
buttontext:"TP Select Bone"
tooltip:"TP Select Bone"
(
	global TP_selBoneSet_rol

	on execute do
	(
		tp_BoneobjArray=#()
		for i in objects do 
		(
			
			if classof i == BoneGeometry and getappdata i 20110407!="rejectBoneselect" do append tp_BoneobjArray i

		)--把BIP骨骼加入数组
		if tp_Boneobjarray.count>0 do select tp_BoneobjArray
	)
	
	on altExecute type do
	(
		try(DestroyDialog TP_selBoneSet_rol)catch()
		rollout TP_selBoneSet_rol "Bone物体排除" width:162 height:330
		(
			multiListBox TP_rejectBone_lbx "Bone Select 排除列表" pos:[7,8] width:148 height:15
			button TP_addBone_btn "╋" pos:[8,245] width:25 height:25
			button TP_removeBone_btn "━" pos:[36,245] width:25 height:25
			button tp_OK_btn "确定" pos:[18,275] width:60 height:25
			button tp_cancel_btn "取消" pos:[85,275] width:60 height:25
			button TP_refurbish_btn "重置" pos:[64,245] width:45 height:25
			button TP_empty_btn "清空" pos:[111,245] width:45 height:25
			HyperLink tp_cgjoy_hk "2011.04.07  | 查看更新|" pos:[30,309] width:135 height:15 address:"http://www.cgjoy.com/viewthread.php?tid=12750&fromuid=3815" 
			
			on TP_selBoneSet_rol open do
			(
				TP_selBoneSet_rol.TP_rejectBone_lbx.items=#()
				tp_rejectBoneitems=#()
				for i in objects where classof i==BoneGeometry do
				(
					tp_getselBoneData=getappdata i 20110407
					if tp_getselBoneData=="rejectBoneselect" do
						append tp_rejectBoneitems i.name
				)
				TP_selBoneSet_rol.TP_rejectBone_lbx.items=tp_rejectBoneitems
			)--on open end
			on TP_addBone_btn pressed do
			(
				tp_appendfoo=false
				TP_rejectBone=TP_selBoneSet_rol.TP_rejectBone_lbx.items
				for i in selection where classof i==BoneGeometry do 
				(	
					for a in TP_rejectBone do if i.name==a do tp_appendfoo=true
					if tp_appendfoo!=true do append TP_rejectBone i.name
					tp_appendfoo=false
				)
				TP_selBoneSet_rol.TP_rejectBone_lbx.items=TP_rejectBone
				
			)--on pressed end
			on TP_removeBone_btn pressed do
			(
				tp_deleteItemArray=#()
				tp_rejectBoneitems=TP_selBoneSet_rol.TP_rejectBone_lbx.items
				tp_rejectBonesel=TP_selBoneSet_rol.TP_rejectBone_lbx.selection
				
				if tp_rejectBoneitems.count>0 and tp_rejectBonesel.count>0 do
				(
					for i in tp_rejectBonesel do
					(
						append tp_deleteItemArray tp_rejectBoneitems[i]
					)
					for i in tp_deleteItemArray do
					(
						deleteitem tp_rejectBoneitems (finditem tp_rejectBoneitems i)
					)
					
					TP_selBoneSet_rol.TP_rejectBone_lbx.items=tp_rejectBoneitems
				)
			)--on pressed end
			on tp_OK_btn pressed do
			(
				for i in objects where classof i==BoneGeometry do
				(
					tp_oldData=getappdata i 20110407
					if tp_oldData=="rejectBoneselect" do deleteappdata i 20110407
				)
				for i in TP_selBoneSet_rol.TP_rejectBone_lbx.items do
				(
					a=getNodeByName i all:true
					setappdata a[1] 20110407 "rejectBoneselect"
				)
								
				try(DestroyDialog TP_selBoneSet_rol)catch()
			)--on pressed end
			on tp_cancel_btn pressed do
			(
				try(DestroyDialog TP_selBoneSet_rol)catch()
			)
			on TP_refurbish_btn pressed do
			(
				TP_selBoneSet_rol.TP_rejectBone_lbx.items=#()
				tp_rejectBoneitems=#()
				for i in objects where classof i==BoneGeometry do
				(
					
					tp_getselBoneData=getappdata i 20110407
					if tp_getselBoneData=="rejectBoneselect" do
						append tp_rejectBoneitems i.name
				)
				TP_selBoneSet_rol.TP_rejectBone_lbx.items=tp_rejectBoneitems
			)
			on TP_empty_btn pressed do
			(
				TP_selBoneSet_rol.TP_rejectBone_lbx.items=#()
			)
		)
		createdialog TP_selBoneSet_rol
			
	)
)

------------------------------------------------------------------------------------选择场景内所有Helper（辅助物体）--------------------------------------
macroscript TP_Select_helper
category:"茶壶小工具集"
buttontext:"TP Select helper"
tooltip:"TP Select helper"
(
	global TP_selhelperSet_rol
	global TP_HrejectNubfoo
	global TP_rejectFootstepsfoo
	on execute do
	(
		tp_helperobjArray=#()
		for i in objects do 
		(
			if TP_HrejectNubfoo==false do
				if classof i==Dummy and classof i.controller==BipSlave_Control and getappdata i 20110413!="rejecthelperselect" do append tp_helperobjArray i
			if superclassof i == helper and classof i.controller!=BipSlave_Control and getappdata i 20110413!="rejecthelperselect" do append tp_helperobjArray i
		)--把Helper加入数组
		if tp_helperobjarray.count>0 do select tp_helperobjArray
	)
	
	on altExecute type do
	(
		try(DestroyDialog TP_selhelperSet_rol)catch()
		rollout TP_selhelperSet_rol "helper物体排除" width:162 height:350
		(
			multiListBox TP_rejecthelper_lbx "helper Select 排除列表" pos:[7,8] width:148 height:15
			button TP_addhelper_btn "╋" pos:[8,245] width:25 height:25
			button TP_removehelper_btn "━" pos:[36,245] width:25 height:25
			checkbox TP_rejectNub_chk "排除bipNub" pos:[16,275] width:135 height:20 
 
 
  
			button tp_OK_btn "确定" pos:[18,296] width:60 height:25
			button tp_cancel_btn "取消" pos:[85,296] width:60 height:25
			button TP_refurbish_btn "重置" pos:[64,245] width:45 height:25
			button TP_empty_btn "清空" pos:[111,245] width:45 height:25
			HyperLink tp_cgjoy_hk "2011.04.13  | 查看更新|" pos:[30,328] width:135 height:15 address:"http://www.cgjoy.com/viewthread.php?tid=12750&fromuid=3815" 
 
 
 			
			on TP_selhelperSet_rol open do
			(
				TP_selhelperSet_rol.TP_rejecthelper_lbx.items=#()
				tp_rejecthelperitems=#()
				for i in objects where superclassof i==helper do
				(
					
					tp_getselhelperData=getappdata i 20110413
					if tp_getselhelperData=="rejecthelperselect" do
						append tp_rejecthelperitems i.name
				)
				TP_selhelperSet_rol.TP_rejecthelper_lbx.items=tp_rejecthelperitems
				if TP_HrejectNubfoo==true then  TP_rejectNub_chk.checked=true else TP_rejectNub_chk.checked=false
									
			)--on open end
			on TP_addhelper_btn pressed do
			(
				tp_appendfoo=false
				TP_rejecthelper=TP_selhelperSet_rol.TP_rejecthelper_lbx.items
				for i in selection where superclassof i==helper do 
				(	
					for a in TP_rejecthelper do if i.name==a do tp_appendfoo=true
					if tp_appendfoo!=true do append TP_rejecthelper i.name
					tp_appendfoo=false
				)
				TP_selhelperSet_rol.TP_rejecthelper_lbx.items=TP_rejecthelper
				
			)--on pressed end
			on TP_removehelper_btn pressed do
			(
				tp_deleteItemArray=#()
				tp_rejecthelperitems=TP_selhelperSet_rol.TP_rejecthelper_lbx.items
				tp_rejecthelpersel=TP_selhelperSet_rol.TP_rejecthelper_lbx.selection
				
				if tp_rejecthelperitems.count>0 and tp_rejecthelpersel.count>0 do
				(
					for i in tp_rejecthelpersel do
					(
						append tp_deleteItemArray tp_rejecthelperitems[i]
					)
					for i in tp_deleteItemArray do
					(
						deleteitem tp_rejecthelperitems (finditem tp_rejecthelperitems i)
					)
					
					TP_selhelperSet_rol.TP_rejecthelper_lbx.items=tp_rejecthelperitems
				)
			)--on pressed end
			on tp_OK_btn pressed do
			(
				for i in objects where superclassof i==helper do
				(
					tp_oldData=getappdata i 20110413
					if tp_oldData=="rejecthelperselect" do deleteappdata i 20110413
				)
				for i in TP_selhelperSet_rol.TP_rejecthelper_lbx.items do
				(
					a=getNodeByName i all:true
					
					setappdata a[1] 20110413 "rejecthelperselect"
				)
				if TP_rejectNub_chk.checked==true then TP_HrejectNubfoo=true else TP_HrejectNubfoo=false
				
				
				try(DestroyDialog TP_selhelperSet_rol)catch()
			)--on pressed end
			on tp_cancel_btn pressed do
			(
				try(DestroyDialog TP_selhelperSet_rol)catch()
			)
			on TP_refurbish_btn pressed do
			(
				TP_selhelperSet_rol.TP_rejecthelper_lbx.items=#()
				tp_rejecthelperitems=#()
				for i in objects where superclassof i==helper do
				(
					
					tp_getselhelperData=getappdata i 20110413
					if tp_getselhelperData=="rejecthelperselect" do
						append tp_rejecthelperitems i.name
				)
				TP_selhelperSet_rol.TP_rejecthelper_lbx.items=tp_rejecthelperitems
			)
			on TP_empty_btn pressed do
			(
				TP_selhelperSet_rol.TP_rejecthelper_lbx.items=#()
			)
		)
		createdialog TP_selhelperSet_rol
			
	)
)

----------------------------------------------------------------------------------------选择场景内所有Biped Bone Helper（选择后 整体拖帧用或隐藏冻结等）---------------------------------
macroscript TP_Select_BipBoneHelper
category:"茶壶小工具集"
buttontext:"TP Select BipBoneHelper"
tooltip:"TP Select BipBoneHelper"
(
	global TP_selbipBoneHelperSet_rol
	global TP_rejectNubfoo=true
	global TP_rejectFootstepsfoo=true
	on execute do
	(
		tp_BipBoneHelperobjArray=#()
		for i in objects do 
		(
			if classof i == biped_object and classof i.controller!=Footsteps and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i
			if superclassof i == helper and classof i.controller!=BipSlave_Control and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i
			if classof i == BoneGeometry and classof i.controller!=Footsteps and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i
			
			if TP_rejectFootstepsfoo==false do
				if classof i==biped_object and classof i.controller==Footsteps and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i
			if TP_rejectNubfoo==false do
				if classof i==Dummy and classof i.controller==BipSlave_Control and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i

		)--把BIP骨骼加入数组
		if tp_BipBoneHelperobjArray.count>0 do select tp_BipBoneHelperobjArray
	)
	
	on altExecute type do
	(
		try(DestroyDialog TP_selbipBoneHelperSet_rol)catch()
		rollout TP_selbipBoneHelperSet_rol "Biped Bone Helper 物体排除" width:162 height:370
		(
			multiListBox TP_rejectBipBoneHelper_lbx "物体排除列表" pos:[7,8] width:148 height:15
			button TP_addbipbonehelper_btn "╋" pos:[8,245] width:25 height:25
			button TP_removebipbonehelper_btn "━" pos:[36,245] width:25 height:25
			checkbox TP_rejectNub_chk "排除Nub" pos:[16,275] width:135 height:20 
 
			button tp_OK_btn "确定" pos:[18,319] width:60 height:25
			button tp_cancel_btn "取消" pos:[85,319] width:60 height:25
			button TP_refurbish_btn "重置" pos:[64,245] width:45 height:25
			button TP_empty_btn "清空" pos:[111,245] width:45 height:25
			checkbox TP_rejectFootstep_chk "排除footstep" pos:[16,295] width:135 height:20 checked:false
			HyperLink tp_cgjoy_hk "2011.04.29  | 查看更新|" pos:[30,351] width:135 height:15 address:"http://www.cgjoy.com/viewthread.php?tid=12750&fromuid=3815" 
 

			on TP_selbipBoneHelperSet_rol open do
			(
				TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items=#()
				tp_rejectBipBoneHelperitems=#()
				for i in objects do
				(
					
					tp_getselBipedData=getappdata i 20110429
					if tp_getselBipedData=="rejectBipedBoneHelperselect" do
						append tp_rejectBipBoneHelperitems i.name
				)
				TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items=tp_rejectBipBoneHelperitems
				if TP_rejectNubfoo==true then  TP_rejectNub_chk.checked=true else TP_rejectNub_chk.checked=false
				if TP_rejectFootstepsfoo==true then TP_rejectFootstep_chk.checked=true else TP_rejectFootstep_chk.checked=false
					
			)--on open end
			on TP_addbipbonehelper_btn pressed do
			(
				tp_appendfoo=false
				TP_rejectBipBoneHelper=TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items
				for i in selection where classof i==Biped_Object or superclassof i == helper or classof i == BoneGeometry do 
				(	
					for a in TP_rejectBipBoneHelper do if i.name==a do tp_appendfoo=true
					if tp_appendfoo!=true do append TP_rejectBipBoneHelper i.name
					tp_appendfoo=false
				)
				TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items=TP_rejectBipBoneHelper
				
			)--on pressed end
			on TP_removebipbonehelper_btn pressed do
			(
				tp_deleteItemArray=#()
				tp_rejectBipBoneHelperitems=TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items
				TP_rejectBipBoneHelpersel=TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.selection
				
				if tp_rejectBipBoneHelperitems.count>0 and TP_rejectBipBoneHelpersel.count>0 do
				(
					for i in TP_rejectBipBoneHelpersel do
					(
						append tp_deleteItemArray tp_rejectBipBoneHelperitems[i]
					)
					for i in tp_deleteItemArray do
					(
						deleteitem tp_rejectBipBoneHelperitems (finditem tp_rejectBipBoneHelperitems i)
					)
					
					TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items=tp_rejectBipBoneHelperitems
				)
			)--on pressed end
			on tp_OK_btn pressed do
			(
				for i in objects do
				(
					tp_oldData=getappdata i 20110429
					if tp_oldData=="rejectBipedBoneHelperselect" do deleteappdata i 20110429
				)
				for i in TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items do
				(
					a=getNodeByName i all:true
					
					setappdata a[1] 20110429 "rejectBipedBoneHelperselect"
				)
				if TP_rejectNub_chk.checked==true then TP_rejectNubfoo=true else TP_rejectNubfoo=false
				if TP_rejectFootstep_chk.checked==true then TP_rejectFootstepsfoo=true else TP_rejectFootstepsfoo=false
				
				try(DestroyDialog TP_selbipBoneHelperSet_rol)catch()
			)--on pressed end
			on tp_cancel_btn pressed do
			(
				try(DestroyDialog TP_selbipBoneHelperSet_rol)catch()
			)
			on TP_refurbish_btn pressed do
			(
				TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items=#()
				tp_rejectBipBoneHelperitems=#()
				for i in objects do
				(
					
					tp_getselBipedData=getappdata i 20110429
					if tp_getselBipedData=="rejectBipedBoneHelperselect" do
						append tp_rejectBipBoneHelperitems i.name
				)
				TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items=tp_rejectBipBoneHelperitems
			)
			on TP_empty_btn pressed do
			(
				TP_selbipBoneHelperSet_rol.TP_rejectBipBoneHelper_lbx.items=#()
			)
		)
		createdialog TP_selbipBoneHelperSet_rol
			
	)
)


--------------------------------------------------------CS骨骼选择工具----------------------------------------------------------
macroscript TP_CSselector
category:"茶壶小工具集"
tooltip:"TP CS selector"
buttontext:"TP CS selector"
(
	global tp_BipHead_rol
	global tp_BipNeck_rol
			-------左上肢-------
	global tp_BipLclavicle_rol
	global tp_BipLupperArm_rol
	global tp_BipLforearm_rol
	global tp_BipLhand_rol
			-------右上肢-------
	global tp_BipRclavicle_rol
	global tp_BipRupperArm_rol
	global tp_BipRforearm_rol
	global tp_BipRhand_rol
			-------躯干-------
	global tp_BipSpine_rol
	global tp_BipSpine1_rol
	global tp_BipSpine2_rol
			-------质心-------
	global	tp_Bip_rol
			-------盆骨-------
	global tp_BipPelvis_rol
			-------左腿-------
	global tp_BipLthigh_rol
	global tp_BipLCalf_rol
	global tp_BipLFoot_rol
			-------右腿-------
	global tp_BipRthigh_rol
	global tp_BipRCalf_rol
	global tp_BipRFoot_rol
	
	fn tp_CreatCSrol_fn=
	(
		try(
			-------------坐标--------------
			tp_BipHead_Pos=[mouse.screenpos.x-20,mouse.screenpos.y-145]
			tp_BipNeck_Pos=[mouse.screenpos.x-7,mouse.screenpos.y-102]
			-------左上肢-------
			tp_BipLclavicle_Pos=[mouse.screenpos.x+20,mouse.screenpos.y-95]
			tp_BipLupperArm_Pos=[mouse.screenpos.x+38,mouse.screenpos.y-77]
			tp_BipLforearm_pos=[mouse.screenpos.x+38,mouse.screenpos.y-27]
			tp_BipLhand_pos=[mouse.screenpos.x+38,mouse.screenpos.y+20]
			-------右上肢-------
			tp_BipRclavicle_Pos=[mouse.screenpos.x-57,mouse.screenpos.y-95]
			tp_BipRupperArm_Pos=[mouse.screenpos.x-57,mouse.screenpos.y-77]
			tp_BipRforearm_pos=[mouse.screenpos.x-57,mouse.screenpos.y-27]
			tp_BipRhand_pos=[mouse.screenpos.x-57,mouse.screenpos.y+20]
			-------躯干-------
			tp_BipSpine_pos=[mouse.screenpos.x-25,mouse.screenpos .y-33]
			tp_BipSpine1_pos=[mouse.screenpos.x-25,mouse.screenpos.y-55]
			tp_BipSpine2_pos=[mouse.screenpos.x-25,mouse.screenpos.y-77]
			-------置心-------
			tp_Bip_pos=[mouse.screenpos.x-3,mouse.screenpos.y-10]
			-------盆骨-------
			tp_BipPelvis_pos=[mouse.screenpos.x-25,mouse.screenpos.y-10]
			-------左腿-------
			tp_BipLthigh_pos=[mouse.screenpos.x+5,mouse.screenpos.y+13]
			tp_BipLCalf_pos=[mouse.screenpos.x+5,mouse.screenpos.y+65]
			tp_BipLFoot_pos=[mouse.screenpos.x+5,mouse.screenpos.y+117]
			-------右腿-------
			tp_BipRthigh_pos=[mouse.screenpos.x-25,mouse.screenpos.y+13]
			tp_BipRCalf_pos=[mouse.screenpos.x-25,mouse.screenpos.y+65]
			tp_BipRFoot_pos=[mouse.screenpos.x-34,mouse.screenpos.y+117]
			
			---------------建立对话框----------------
			
			createdialog tp_BipHead_rol pos:tp_BipHead_Pos style:#()
			createdialog tp_BipNeck_rol pos:tp_BipNeck_Pos style:#()
			-------左上肢-------
			createdialog tp_BipLclavicle_rol pos:tp_BipLclavicle_Pos style:#()
			createdialog tp_BipLupperArm_rol pos:tp_BipLupperArm_Pos style:#()
			createdialog tp_BipLforearm_rol pos:tp_BipLforearm_pos style:#()
			createdialog tp_BipLhand_rol pos:tp_BipLhand_pos style:#()
			-------右上肢-------
			createdialog tp_BipRclavicle_rol pos:tp_BipRclavicle_Pos style:#()
			createdialog tp_BipRupperArm_rol pos:tp_BipRupperArm_Pos style:#()
			createdialog tp_BipRforearm_rol pos:tp_BipRforearm_pos style:#()
			createdialog tp_BipRhand_rol pos:tp_BipRhand_pos style:#()	
			-------躯干-------
			createdialog tp_BipSpine_rol pos:tp_BipSpine_Pos style:#()
			createdialog tp_BipSpine1_rol pos:tp_BipSpine1_Pos style:#()
			createdialog tp_BipSpine2_rol pos:tp_BipSpine2_Pos style:#()
			-------盆骨-------
			createdialog tp_BipPelvis_rol pos:tp_BipPelvis_pos style:#()
			
			-------置心-------
			createdialog tp_Bip_rol pos:tp_Bip_Pos style:#()
			
			-------左腿-------
			createdialog tp_BipLthigh_rol pos:tp_BipLthigh_pos style:#()
			createdialog tp_BipLCalf_rol pos:tp_BipLCalf_pos style:#()
			createdialog tp_BipLFoot_rol pos:tp_BipLFoot_pos style:#()
			-------右腿-------
			createdialog tp_BipRthigh_rol pos:tp_BipRthigh_pos style:#()
			createdialog tp_BipRCalf_rol pos:tp_BipRCalf_pos style:#()
			createdialog tp_BipRFoot_rol pos:tp_BipRFoot_pos style:#()
			
		)catch()

	)
	
	fn tp_DestroyCSrol_fn=
	(
		try(
			DestroyDialog tp_BipHead_rol
			DestroyDialog tp_BipNeck_rol
			-------左上肢-------
			DestroyDialog tp_BipLclavicle_rol
			DestroyDialog tp_BipLupperArm_rol
			DestroyDialog tp_BipLforearm_rol
			DestroyDialog tp_BipLhand_rol
			-------右上肢-------
			DestroyDialog tp_BipRclavicle_rol
			DestroyDialog tp_BipRupperArm_rol
			DestroyDialog tp_BipRforearm_rol
			DestroyDialog tp_BipRhand_rol
			-------躯干-------
			DestroyDialog tp_BipSpine_rol
			DestroyDialog tp_BipSpine1_rol
			DestroyDialog tp_BipSpine2_rol
			-------质心-------
			DestroyDialog tp_Bip_rol
			-------盆骨-------
			DestroyDialog tp_BipPelvis_rol
			-------左腿-------
			DestroyDialog tp_BipLthigh_rol
			DestroyDialog tp_BipLCalf_rol
			DestroyDialog tp_BipLFoot_rol
			-------右腿-------
			DestroyDialog tp_BipRthigh_rol
			DestroyDialog tp_BipRCalf_rol
			DestroyDialog tp_BipRFoot_rol
			------------------------------------------------------------

		)catch()

	)
	
	tp_DestroyCSrol_fn()
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-头-------------------------------------------------------------
		rollout tp_BipHead_rol "BipHead" width:40 height:40
		(
			imgTag tp_SelHead_btn "头"  pos:[0,0] bitmap:(bitmap 40 40 color:(color 166 202 240))  tooltip:"头"
			
			on tp_SelHead_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #Head )
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_SelHead_btn mouseover do
			( 	
				tp_SelHead_btn.bitmap=bitmap 40 40 color:white
			)
			
			on tp_SelHead_btn mouseout do
			( 	
				tp_SelHead_btn.bitmap=bitmap 40 40 color:(color 166 202 240)
			)	
		)	
		
		
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-脖子---------tp_BipNeck_rol------------------------------------
		rollout tp_BipNeck_rol "Neck" width:17 height:20
		(
			imgTag tp_SelNeck_btn "脖子"  pos:[0,0] bitmap:(bitmap 17 20 color:(color 8 110 134))  tooltip:"Neck"
			
			on tp_SelNeck_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #Neck link:1)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_SelNeck_btn mouseover do
			( 	
				tp_SelNeck_btn.bitmap=bitmap 17 20 color:white
			)
			
			on tp_SelNeck_btn mouseout do
			( 	
				tp_SelNeck_btn.bitmap=bitmap 17 20 color:(color 8 110 134)
			)	
		)	

	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-左肩---------tp_BipLclavicle_rol----------------------------
		rollout tp_BipLclavicle_rol "L_Clavicle" width:37 height:15
		(
			imgTag tp_BipLclavicle_btn "左肩"  pos:[0,0] bitmap:(bitmap 37 15 color:(color 28 28 177))  tooltip:"L_Clavicle"
			
			on tp_BipLclavicle_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #larm link:1)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipLclavicle_btn mouseover do
			( 	
				tp_BipLclavicle_btn.bitmap=bitmap 37 15 color:white
			)
			
			on tp_BipLclavicle_btn mouseout do
			( 	
				tp_BipLclavicle_btn.bitmap=bitmap 37 15 color:(color 28 28 177)
			)	
		)	

	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-左大臂---------tp_BipLupperArm_rol----------------------------
		rollout tp_BipLupperArm_rol "L_UpperArm" width:18 height:48
		(
			imgTag tp_BipLupperArm_btn "左大臂"  pos:[0,0] bitmap:(bitmap 18 48 color:(color 28 28 177))  tooltip:"L_UpperArm"
			
			on tp_BipLupperArm_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #larm link:2)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipLupperArm_btn mouseover do
			( 	
				tp_BipLupperArm_btn.bitmap=bitmap 18 48 color:white
			)
			
			on tp_BipLupperArm_btn mouseout do
			( 	
				tp_BipLupperArm_btn.bitmap=bitmap 18 48 color:(color 28 28 177)
			)	
		)	

	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-左小臂---------tp_BipLforearm_rol----------------------------
		rollout tp_BipLforearm_rol "L_Forearm" width:18 height:45
		(
			imgTag tp_BipLforearm_btn "左小臂"  pos:[0,0] bitmap:(bitmap 18 45 color:(color 28 28 177))  tooltip:"L_Forearm"
			
			on tp_BipLforearm_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #larm link:3)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipLforearm_btn mouseover do
			( 	
				tp_BipLforearm_btn.bitmap=bitmap 18 45 color:white
			)
			
			on tp_BipLforearm_btn mouseout do
			( 	
				tp_BipLforearm_btn.bitmap=bitmap 18 45 color:(color 28 28 177)
			)	
		)	
		
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-左手---------tp_BipLhand_rol----------------------------
		rollout tp_BipLhand_rol "L_hand" width:18 height:18
		(
			imgTag tp_BipLhand_btn "左手"  pos:[0,0] bitmap:(bitmap 18 18 color:(color 28 28 177))  tooltip:"L_hand"
			
			on tp_BipLhand_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #larm link:4)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipLhand_btn mouseover do
			( 	
				tp_BipLhand_btn.bitmap=bitmap 18 18 color:white
			)
			
			on tp_BipLhand_btn mouseout do
			( 	
				tp_BipLhand_btn.bitmap=bitmap 18 18 color:(color 28 28 177)
			)	
		)	
			
		
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-右肩---------tp_BipRclavicle_rol----------------------------
		rollout tp_BipRclavicle_rol "R_Clavicle" width:37 height:15
		(
			imgTag tp_BipRclavicle_btn "右肩"  pos:[0,0] bitmap:(bitmap 37 15 color:(color 6 134 6))  tooltip:"R_Clavicle"
			
			on tp_BipRclavicle_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #rarm link:1)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipRclavicle_btn mouseover do
			( 	
				tp_BipRclavicle_btn.bitmap=bitmap 37 15 color:white
			)
			
			on tp_BipRclavicle_btn mouseout do
			( 	
				tp_BipRclavicle_btn.bitmap=bitmap 37 15 color:(color 6 134 6)
			)	
		)	

	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-右大臂---------tp_BipRupperArm_rol----------------------------
		rollout tp_BipRupperArm_rol "R_UpperArm" width:18 height:48
		(
			imgTag tp_BipRupperArm_btn "左大臂"  pos:[0,0] bitmap:(bitmap 18 48 color:(color 6 134 6))  tooltip:"R_UpperArm"
			
			on tp_BipRupperArm_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #rarm link:2)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipRupperArm_btn mouseover do
			( 	
				tp_BipRupperArm_btn.bitmap=bitmap 18 48 color:white
			)
			
			on tp_BipRupperArm_btn mouseout do
			( 	
				tp_BipRupperArm_btn.bitmap=bitmap 18 48 color:(color 6 134 6)
			)	
		)	

	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-右小臂---------tp_BipRforearm_rol----------------------------
		rollout tp_BipRforearm_rol "R_Forearm" width:18 height:45
		(
			imgTag tp_BipRforearm_btn "左小臂"  pos:[0,0] bitmap:(bitmap 18 45 color:(color 6 134 6))  tooltip:"R_Forearm"
			
			on tp_BipRforearm_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #rarm link:3)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipRforearm_btn mouseover do
			( 	
				tp_BipRforearm_btn.bitmap=bitmap 18 45 color:white
			)
			
			on tp_BipRforearm_btn mouseout do
			( 	
				tp_BipRforearm_btn.bitmap=bitmap 18 45 color:(color 6 134 6)
			)	
		)	
		
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-右手---------tp_BipRhand_rol----------------------------
		rollout tp_BipRhand_rol "R_hand" width:18 height:18
		(
			imgTag tp_BipRhand_btn "左手"  pos:[0,0] bitmap:(bitmap 18 18 color:(color 6 134 6))  tooltip:"R_hand"
			
			on tp_BipRhand_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #rarm link:4)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipRhand_btn mouseover do
			( 	
				tp_BipRhand_btn.bitmap=bitmap 18 18 color:white
			)
			
			on tp_BipRhand_btn mouseout do
			( 	
				tp_BipRhand_btn.bitmap=bitmap 18 18 color:(color 6 134 6)
			)	
		)	
		
		------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-躯干---------tp_BipSpine_rol----------------------------
		rollout tp_BipSpine_rol "Spine" width:51 height:20
		(
			imgTag tp_BipSpine_btn "躯干"  pos:[0,0] bitmap:(bitmap 51 20 color:(color 8 110 134))  tooltip:"Spine"
			
			on tp_BipSpine_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #Spine link:1)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipSpine_btn mouseover do
			( 	
				tp_BipSpine_btn.bitmap=bitmap 51 20 color:white
			)
			
			on tp_BipSpine_btn mouseout do
			( 	
				tp_BipSpine_btn.bitmap=bitmap 51 20 color:(color 8 110 134)
			)	
		)
		------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-躯干1---------tp_BipSpine1_rol----------------------------
		rollout tp_BipSpine1_rol "Spine1" width:51 height:20
		(
			imgTag tp_BipSpine1_btn "躯干1"  pos:[0,0] bitmap:(bitmap 51 20 color:(color 8 110 134))  tooltip:"Spine1"
			
			on tp_BipSpine1_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						if (Biped.GetNode i #Spine link:2)!=undefined do
						Select (Biped.GetNode i #Spine link:2)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipSpine1_btn mouseover do
			( 	
				tp_BipSpine1_btn.bitmap=bitmap 51 20 color:white
			)
			
			on tp_BipSpine1_btn mouseout do
			( 	
				tp_BipSpine1_btn.bitmap=bitmap 51 20 color:(color 8 110 134)
			)	
		)
			------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-躯干2---------tp_BipSpine1_rol----------------------------
		rollout tp_BipSpine2_rol "Spine2" width:51 height:20
		(
			imgTag tp_BipSpine2_btn "躯干2"  pos:[0,0] bitmap:(bitmap 51 20 color:(color 8 110 134))  tooltip:"Spine2"
			
			on tp_BipSpine2_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						if (Biped.GetNode i #Spine link:3)!=undefined do
						Select (Biped.GetNode i #Spine link:3)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipSpine2_btn mouseover do
			( 	
				tp_BipSpine2_btn.bitmap=bitmap 51 20 color:white
			)
			
			on tp_BipSpine2_btn mouseout do
			( 	
				tp_BipSpine2_btn.bitmap=bitmap 51 20 color:(color 8 110 134)
			)	
		)

------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-置心---------tp_Bip_rol----------------------------
		
		rollout tp_Bip_rol "Spine" width:29 height:20
		(
			imgTag tp_Bip_btn "置心"  pos:[0,0] bitmap:(bitmap 29 20 color:red)  tooltip:"Bip"
			
			on tp_Bip_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #turn)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_Bip_btn mouseover do 
			( 	
				tp_Bip_btn.bitmap=bitmap 29 20 color:white
			)
			
			on tp_Bip_btn mouseout do
			( 	
				tp_Bip_btn.bitmap=bitmap 29 20 color:red
			)	
		)	
		
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-盆骨---------tp_BipPelvis_rol----------------------------
		
		rollout tp_BipPelvis_rol "Pelvis" width:20 height:20
			(
			imgTag tp_BipPelvis_btn "置心"  pos:[0,0] bitmap:(bitmap 20 20 color:(color 224 198 87))  tooltip:"Pelvis"
			
			on tp_BipPelvis_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #pelvis)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipPelvis_btn mouseover do
			( 	
				tp_BipPelvis_btn.bitmap=bitmap 20 20 color:white
			)
			
			on tp_BipPelvis_btn mouseout do
			( 	
				tp_BipPelvis_btn.bitmap=bitmap 20 20 color:(color 224 198 87)
			)	
		)	
		
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-左大腿---------tp_BipLthigh_rol----------------------------
		rollout tp_BipLthigh_rol "L_Thigh" width:21 height:50
		(
			imgTag tp_BipLthigh_btn "左大腿"  pos:[0,0] bitmap:(bitmap 21 50 color:(color 28 28 177))  tooltip:"L_Thigh"
			
			on tp_BipLthigh_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #lleg link:1)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipLthigh_btn mouseover do
			( 	
				tp_BipLthigh_btn.bitmap=bitmap 21 50 color:white
			)
			
			on tp_BipLthigh_btn mouseout do
			( 	
				tp_BipLthigh_btn.bitmap=bitmap 21 50 color:(color 28 28 177)
			)	
		)	

	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-左小腿---------tp_BipLCalf_rol----------------------------
		rollout tp_BipLCalf_rol "L_Calf" width:21 height:50
		(
			imgTag tp_BipLCalf_btn "左小腿"  pos:[0,0] bitmap:(bitmap 21 50 color:(color 28 28 177))  tooltip:"L_Calf"
			
			on tp_BipLCalf_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #lleg link:2)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipLCalf_btn mouseover do
			( 	
				tp_BipLCalf_btn.bitmap=bitmap 21 50 color:white
			)
			
			on tp_BipLCalf_btn mouseout do
			( 	
				tp_BipLCalf_btn.bitmap=bitmap 21 50 color:(color 28 28 177)
			)	
		)	
	
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-左脚---------tp_BipLFoot_rol----------------------------
		rollout tp_BipLFoot_rol "L_foot" width:30 height:20
		(
			imgTag tp_BipLFoot_btn "左小腿"  pos:[0,0] bitmap:(bitmap 30 20 color:(color 28 28 177))  tooltip:"L_foot"
			
			on tp_BipLFoot_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #lleg link:3)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipLFoot_btn mouseover do
			( 	
				tp_BipLFoot_btn.bitmap=bitmap 30 20 color:white
			)
			
			on tp_BipLFoot_btn mouseout do
			( 	
				tp_BipLFoot_btn.bitmap=bitmap 30 20 color:(color 28 28 177)
			)	
		)
		
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-右大腿---------tp_BipRthigh_rol----------------------------
		rollout tp_BipRthigh_rol "R_Thigh" width:21 height:50
		(
			imgTag tp_BipRthigh_btn "左大腿"  pos:[0,0] bitmap:(bitmap 21 50 color:(color 6 134 6))  tooltip:"R_Thigh"
			
			on tp_BipRthigh_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #rleg link:1)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipRthigh_btn mouseover do
			( 	
				tp_BipRthigh_btn.bitmap=bitmap 21 50 color:white
			)
			
			on tp_BipRthigh_btn mouseout do
			( 	
				tp_BipRthigh_btn.bitmap=bitmap 21 50 color:(color 6 134 6)
			)	
		)	

	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-右小腿---------tp_BipRCalf_rol----------------------------
		rollout tp_BipRCalf_rol "R_Calf" width:21 height:50
		(
			imgTag tp_BipRCalf_btn "左小腿"  pos:[0,0] bitmap:(bitmap 21 50 color:(color 6 134 6))  tooltip:"R_Calf"
			
			on tp_BipRCalf_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #rleg link:2)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipRCalf_btn mouseover do
			( 	
				tp_BipRCalf_btn.bitmap=bitmap 21 50 color:white
			)
			
			on tp_BipRCalf_btn mouseout do
			( 	
				tp_BipRCalf_btn.bitmap=bitmap 21 50 color:(color 6 134 6)
			)	
		)	
	
	------------------------------------------------------------------------------------------------------------------------------
	  ---------------------------------------------------rollout-右脚---------tp_BipRFoot_rol----------------------------
		rollout tp_BipRFoot_rol "R_foot" width:30 height:20
		(
			imgTag tp_BipRFoot_btn "左小腿"  pos:[0,0] bitmap:(bitmap 30 20 color:(color 6 134 6))  tooltip:"R_foot"
			
			on tp_BipRFoot_btn mousedown do
			( 	
				for i in geometry do
				(
					if classof i==biped_object do	
					(
						Select (Biped.GetNode i #rleg link:3)
						max motion mode;exit
					)
				)
				tp_DestroyCSrol_fn()
			)
			
			on tp_BipRFoot_btn mouseover do
			( 	
				tp_BipRFoot_btn.bitmap=bitmap 30 20 color:white
			)
			
			on tp_BipRFoot_btn mouseout do
			( 	
				tp_BipRFoot_btn.bitmap=bitmap 30 20 color:(color 6 134 6)
			)	
		)
		
		tp_CreatCSrol_fn()	
)



tp_QueryBoxFoo=queryBox "茶壶小工具集 宏脚本命令已经加载。

宏脚本命令使用设置：主菜单栏Customize(自定义)—> Customize User Interface...(自定义用户界面...)
在Category下拉列表中可以找到“茶壶小工具集”。
然后对下面Action中的 小命令设置快捷键，右键菜单或拖放到工具栏上。

Good luck!
                                                         
                                                         --------------------
                                                          作者 ：煮饺子的茶壶
                                                           QQ  ：344272088
                                                         E-mail：344272088@qq.com
                                                                 2011-05-12
                                                          --------------------																 \n
											
立即打开Customize User Interface...(自定义用户界面...)对话框吗？" title:"茶壶小工具集"

if tp_QueryBoxFoo==true do
(
	cui.expertModeOff()
	max customize UI
)