----------------------------------------------------------------------
--作者 ：煮饺子的茶壶
--QQ  ：344272088
--E-mail：344272088@qq.com
--		2011-04-29 		
--------------------Biped Bone Helper工具--------------------------------------
--选择场景内所有Biped Bone Helper
macroscript TP_Select_BipBoneHelper
category:"茶壶动作工具"
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

tp_QueryBoxFoo=queryBox "茶壶增效工具1-5 TP Select BipBoneHelper 宏脚本命令已经加载。

宏脚本命令使用设置：主菜单栏Customize(自定义)—> Customize User Interface...(自定义用户界面...)
在Category下拉列表中可以找到“茶壶动作工具”。
然后对下面Action中的 TP Select BipBoneHelper 设置快捷键、右键菜单或拖放到工具栏上。

Good luck!
                                                         
                                                         --------------------
                                                          作者 ：煮饺子的茶壶
                                                           QQ  ：344272088
                                                         E-mail：344272088@qq.com
                                                                 2011-04-29
                                                          --------------------																 \n
											
立即打开Customize User Interface...(自定义用户界面...)对话框吗？" title:"茶壶增效工具1-5 TP Select BipBoneHelper"

if tp_QueryBoxFoo==true do
(
	cui.expertModeOff()
	max customize UI
)