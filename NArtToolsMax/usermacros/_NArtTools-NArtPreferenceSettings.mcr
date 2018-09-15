macroScript NArtPreferenceSettings
category:"_NArtTools"
tooltip:"Preference Settings"
buttontext:"Preference Settings"
(
	local _NPSetting = NArtPreferenceSetting()
	Try(DestroyDialog rol_NArtPreferenceSetting)Catch()
	rollout rol_NArtPreferenceSetting "rol_NArtPreferenceSetting" width:549 height:391
	(
		edittext edt_ProjectName "" pos:[17,35] width:183 height:19
		edittext edt_ArtSourcePath "" pos:[16,96] width:500 height:19
		edittext edt_ExportTargetPath "" pos:[16,152] width:500 height:19

		
		button btn_ok "OK" pos:[28,345] width:122 height:29
		button btn_cancel "Cancel" pos:[163,345] width:122 height:29
		button btn_Default "Default" pos:[398,345] width:122 height:29
		
		label lbl_ProjectName "Project Name:" pos:[17,16] width:96 height:18
		label lbl_ArtSource "Art Source Path:" pos:[16,72] width:96 height:18
		label lbl_ExportTargetPath "Export Target Path:" pos:[16,128] width:96 height:18

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
)
