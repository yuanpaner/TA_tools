rollout Rollout_Wait "Wait" width:169 height:95
(
	label lbl1 "wait ..." pos:[63,48] width:40 height:21
	GroupBox grp2 "Auto Export FBX" pos:[6,10] width:156 height:79
)

fn CharacterExport =(
	createDialog Rollout_Wait
	fileIn @"D:\art_ta\Public\ToolsAndPlug-ins\NArtToolsMax\scripts\NArtTools\NArtAction\Ac0105_NArtCharacterExport.ms"
	DestroyDialog Rollout_Wait
)

fn WorldEntitiesExport =(
	createDialog Rollout_Wait
	fileIn @"D:\art_ta\Public\ToolsAndPlug-ins\NArtToolsMax\scripts\NArtTools\NArtAction\Ac0106_NArtWorldEntitiesExport.ms"
	DestroyDialog Rollout_Wait
)

fn Export =(
	createDialog Rollout_Wait
	fileIn @"D:\art_ta\Public\ToolsAndPlug-ins\NArtToolsMax\scripts\NArtTools\NArtWindow\Win0100_NArtExport.ms"
	DestroyDialog Rollout_Wait
)

fn DoExport =(
	_queryBox = yesNoCancelBox "是否要自动输出？ \n\n\n\n Yes：自动输出      No:手动输出      Cancel：取消"
	
	if _queryBox == #yes do(
			_type = NArtExport.GetFileType()
		case _type of (
			
			"Character":CharacterExport()							
			"Animation":CharacterExport()
			"WorldEntities": WorldEntitiesExport()
			default: Export()
		)
	)
	
	if _queryBox == #no do Export()

)	

DoExport()