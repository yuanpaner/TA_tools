print "NArt工具：NArt工具设置"

_NPSetting = NArtPreferenceSetting()
Try(DestroyDialog rol_NArtPreferenceSetting)Catch()
rollout rol_NArtPreferenceSetting "rol_NArtPreferenceSetting" width:549 height:391
(
	edittext edt_ProjectName "" pos:[17,35] width:183 height:19 align:#left
	edittext edt_ArtSourcePath "" pos:[16,96] width:500 height:19 align:#left
	edittext edt_ExportTargetPath "" pos:[16,152] width:500 height:19 align:#left

	
	button btn_ok "确定" pos:[28,345] width:122 height:29 align:#left
	button btn_cancel "取消" pos:[163,345] width:122 height:29 align:#left
	button btn_Default "恢复默认" pos:[398,345] width:122 height:29 align:#left
	
	label lbl_ProjectName "项目名称:" pos:[17,16] width:96 height:18 align:#left
	label lbl_ArtSource "美术源文件（Art Source）路径:" pos:[16,72] width:183 height:18 align:#left
	label lbl_ExportTargetPath "输出目标路径:" pos:[16,128] width:96 height:18 align:#left

	fn UIToNps = (
		_NPSetting.m_ProjectName = edt_ProjectName.text
		_NPSetting.m_ArtSourcePath = edt_ArtSourcePath.text
		_NPSetting.m_ExportTargetPath = edt_ExportTargetPath.text	
	)
	
	fn NpsToUI = (
		edt_ProjectName.text = _NPSetting.m_ProjectName
		edt_ArtSourcePath.text = _NPSetting.m_ArtSourcePath
		edt_ExportTargetPath.text = _NPSetting.m_ExportTargetPath
	)

	on rol_NArtPreferenceSetting open do
	(
		_NPSetting.LoadValue()
		NpsToUI()
	)
	on btn_ok pressed do
	(
		UIToNps()
		_NPSetting.SaveValue()
		Try(DestroyDialog rol_NArtPreferenceSetting)Catch()
	)
	on btn_cancel pressed do
	(
		Try(DestroyDialog rol_NArtPreferenceSetting)Catch()
	)
	on btn_Default pressed do
	(
		_NPSetting.SetDefaultValue()
		NpsToUI()
	)
)
createdialog rol_NArtPreferenceSetting