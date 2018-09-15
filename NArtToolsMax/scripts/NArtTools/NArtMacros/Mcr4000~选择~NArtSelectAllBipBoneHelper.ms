--选择场景内所有Biped Bone Helper（选择后 整体拖帧用或隐藏冻结等）---------------------------------
macroscript NArtSelectAllBipBoneHelper
category:"_NArtTools"
buttontext:"选择所有Bip Bone Helper"
tooltip:"选择所有Bip Bone Helper"
(
	global TP_selbipBoneHelperSet_rol
	global TP_rejectNubfoo=true
	global TP_rejectFootstepsfoo=true
	on execute do
	(
		NArtName.ScriptFileIn "Act4000_NArtSelectAllBipBoneHelper"
	)
	
	on altExecute type do
	(
		NArtName.ScriptFileIn "Win4000_NArtSelectAllBipBoneHelperAltExe"
	)
)