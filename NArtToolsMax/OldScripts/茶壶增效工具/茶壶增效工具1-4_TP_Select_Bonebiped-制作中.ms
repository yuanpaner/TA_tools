--------------------Bone BIP工具--------------------------------------
--选择场景内所有Bone BIP骨骼---
macroscript TP_Select_BoneBiped
category:"茶壶动作工具"
buttontext:"TP Select BoneBiped"
tooltip:"TP Select BoneBiped"
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