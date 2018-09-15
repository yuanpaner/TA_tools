macroScript NArtCreateHelpPoint
category:"_NArtTools"
buttontext:"创建Help Point"
toolTip:"创建Help Point"
(
	on isVisible return (selection.count == 1)
	on execute do
	(
		NArtName.ScriptFileIn "Act5500_NArtCreateHelpPoint"		
	)
)