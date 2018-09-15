print "NArt工具：选择所有Helpers"

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