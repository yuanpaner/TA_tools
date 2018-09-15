macroScript mergeHelpPlane
category:"ZZM动作工具"
buttontext:"merge HelpPlane"
toolTip:"merge HelpPlane"
(
    undo "merge HelpPlane" on
	(
		try
		(
			if $Tp_Help_Plane== undefined then
			(
				mergemaxfile "d:\\merge\\HelpPlane.max"
			)
			if $Tp_Help_Plane!= undefined then
			(
				$Tp_Help_Plane.showFrozenInGray = off
				freeze $Tp_Help_Plane
			)
		)catch()
	)
)
