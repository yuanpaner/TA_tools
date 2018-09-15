macroScript NArtAutoExportFBX
category:"_NArtTools"
tooltip:"�Զ����FBX"
buttontext:"�Զ����FBX"
(
	on execute do
	(
		fn DoExport =(
			_queryBox = yesNoCancelBox "�Ƿ�Ҫ�Զ������ \n\n\n\n Yes���Զ����      No:�ֶ����      Cancel��ȡ��"
			
			if _queryBox == #yes do(
					_type = NArtExport.GetFileType()
				print _type
				case _type of (
					
					"Character":NArtName.ScriptFileIn "Bat0105_NArtCharacterExport"
					
					"CGAnimation":NArtName.ScriptFileIn "Bat0105_NArtCharacterExport"
					
					"Animation":NArtName.ScriptFileIn "Bat0105_NArtCharacterExport"
					
					"WorldEntities": NArtName.ScriptFileIn "Bat0106_NArtWorldEntitiesExport"
					
					default: NArtName.ScriptFileIn "Win0100_NArtExport"
				)
			)
			
			if _queryBox == #no do NArtName.ScriptFileIn "Win0100_NArtExport"

		)
		if MaxFilePath == "" then(
			NArtName.ScriptFileIn "Win0100_NArtExport"
		)else(
			DoExport()
		)
	)
)