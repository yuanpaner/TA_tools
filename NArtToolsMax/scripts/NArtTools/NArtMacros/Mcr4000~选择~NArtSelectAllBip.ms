---选择场景内所有BIP骨骼，并切换到运动面板---
macroscript NArtSelectAllBip
category:"_NArtTools"
buttontext:"选择所有Biped"
tooltip:"选择所有Biped"
(
	global TP_selbipedSet_rol
	global TP_rejectNubfoo
	global TP_rejectFootstepsfoo
	on execute do
	(
		NArtName.ScriptFileIn "Act4000_NArtSelectAllBip"	
	)
	
	on altExecute type do
	(
		NArtName.ScriptFileIn "Win4000_NArtSelectAllBipAltExe"	
	)
)