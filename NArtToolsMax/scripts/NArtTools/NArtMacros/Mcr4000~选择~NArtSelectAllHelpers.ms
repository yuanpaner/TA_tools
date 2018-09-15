--选择场景内所有Helper（辅助物体）--
macroscript NArtSelectAllHelpers
category:"_NArtTools"
buttontext:"选择所有Helpers"
tooltip:"选择所有Helpers"
(
	global TP_selhelperSet_rol
	global TP_HrejectNubfoo
	global TP_rejectFootstepsfoo
	on execute do
	(
		NArtName.ScriptFileIn "Act4000_NArtSelectAllHelpers"
	)
	
	on altExecute type do
	(
		NArtName.ScriptFileIn "Win4000_NArtSelectAllHelpers"
	)
)