macroScript NArtCreateHelpPoint
category:"_NArtTools"
buttontext:"����Help Point"
toolTip:"����Help Point"
(
	on isVisible return (selection.count == 1)
	on execute do
	(
		NArtName.ScriptFileIn "Act5500_NArtCreateHelpPoint"		
	)
)