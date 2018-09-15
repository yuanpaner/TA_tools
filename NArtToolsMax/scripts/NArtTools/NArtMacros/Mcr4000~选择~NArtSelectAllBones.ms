--选择场景内所有Bone骨骼--
macroscript NArtSelectAllBones
category:"_NArtTools"
buttontext:"选择所有Bone"
tooltip:"选择所有Bone"
(
	global TP_selBoneSet_rol

	on execute do
	(
		NArtName.ScriptFileIn "Act4000_NArtSelectAllBones"
	)
	
	on altExecute type do
	(
		NArtName.ScriptFileIn "Win4000_NArtSelectAllBonesAltExe"
	)
)