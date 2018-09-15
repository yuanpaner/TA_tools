print "NArt工具：选择biped质心"

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