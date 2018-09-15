macroScript NArtPickSetParent
category:"_NArtTools"
ButtonText:"拾取设置父物体"
Tooltip:"拾取设置父物体"
(
	on isEnabled return (selection.count > 0)
	on execute do
	(
		NArtName.ScriptFileIn "Act5500_NArtPickSetParent"	
	)
)