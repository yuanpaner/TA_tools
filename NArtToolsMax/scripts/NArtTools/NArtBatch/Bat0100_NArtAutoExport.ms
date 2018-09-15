--自动输出FBX

print "NArt执行：自动输出FBX"

_type = NArtExport.GetFileType()
print _type
case _type of (
	
	"Character":NArtName.ScriptFileIn "Bat0105_NArtCharacterExport"
	"CGAnimation":NArtName.ScriptFileIn "Bat0105_NArtCharacterExport"
	"Animation":NArtName.ScriptFileIn "Bat0105_NArtCharacterExport"
	"WorldEntities": NArtName.ScriptFileIn "Bat0106_NArtWorldEntitiesExport"
	default: print _type
)