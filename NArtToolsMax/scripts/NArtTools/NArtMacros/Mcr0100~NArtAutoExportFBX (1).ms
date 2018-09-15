macroScript NArtAutoExportFBX
category:"_NArtTools"
tooltip:"自动输出FBX"
buttontext:"自动输出FBX"
(
	on execute do
	(
		fn DoExport =(
			_queryBox = yesNoCancelBox "是否要自动输出？ \n\n\n\n Yes：自动输出      No:手动输出      Cancel：取消"
			
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
