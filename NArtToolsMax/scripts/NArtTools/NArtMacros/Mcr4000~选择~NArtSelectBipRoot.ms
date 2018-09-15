--选择质心并切换到运动面板--
macroscript NArtSelectBipRoot
category:"_NArtTools"
buttontext:"选择biped质心"
tooltip:"选择biped质心"
(
	global tp_rootSet_Rol
	global tp_ignoreBip
	on execute do
	(
		NArtName.ScriptFileIn "Act4000_NArtSelectBipRoot"
	)
	on altExecute type do
	(
		NArtName.ScriptFileIn "Win4000_NArtSelectBipRoot"	
	) 
)