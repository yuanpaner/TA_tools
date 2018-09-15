----------------------------------------------------------------------
--作者 ：煮饺子的茶壶
--QQ  ：344272088
--E-mail：344272088@qq.com
--		2011-04-07 		
--------------------Bone工具--------------------------------------
--选择场景内所有Bone骨骼/
macroscript TP_Select_Bone
category:"茶壶动作工具"
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

tp_QueryBoxFoo=queryBox "茶壶增效工具1-3 TP Select Bone 宏脚本命令已经加载。

宏脚本命令使用设置：主菜单栏Customize(自定义)—> Customize User Interface...(自定义用户界面...)
在Category下拉列表中可以找到“茶壶动作工具”。
然后对下面Action中的 TP Select Bone 设置快捷键、右键菜单或拖放到工具栏上。
Good luck!
                                                          --------------------
                                                          作者 ：煮饺子的茶壶
                                                           QQ  ：344272088
                                                         E-mail：344272088@qq.com
                                                                 2011-04-07
                                                          --------------------																 \n
											
立即打开Customize User Interface...(自定义用户界面...)对话框吗？" title:"茶壶增效工具系列1-3 TP Select Bone"

if tp_QueryBoxFoo==true do
(
	cui.expertModeOff()
	max customize UI
)