print "NArt���ߣ�ѡ��biped����"

try(DestroyDialog tp_rootSet_Rol)catch()
rollout tp_rootSet_Rol "����������" width:162 height:161
(
	pickbutton tp_SelRoot_btn "ʰȡ������" pos:[4,82] width:75 height:25 enabled:true message:""
	label tp_lbl "��ǰ��������" pos:[6,6] width:152 height:20
	label tp_rootName_lbl "Label" pos:[8,30] width:152 height:24
	button tp_cancel_btn "ȡ��" pos:[83,111] width:65 height:25
	button tp_OK_btn "ȷ��" pos:[14,111] width:65 height:25
	button tp_DelApp_btn "��ռ�¼" pos:[83,82] width:75 height:25
	
	HyperLink tp_cgjoy_hk "2011.03.28  | �鿴����|" pos:[33,142] width:135 height:15 address:"http://www.cgjoy.com/viewthread.php?tid=12750&fromuid=3815" 

	checkbox tp_ignoreBIP_chk "����BIP" pos:[51,59] width:108 height:16



	on tp_rootSet_Rol open do
	(
		tp_rootName_lbl.caption="δ���ָ���������ʰȡ"
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
		tp_rootName_lbl.caption="δ���ָ���������ʰȡ"
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