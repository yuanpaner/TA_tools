macroScript NArtSelectBipChildren
category:"_NArtTools"
buttontext:"Select Bip Children"
toolTip:"Select bip children"
(
	on execute do(
		try(
			if selection.count!=0 do
			(
				actionMan.executeAction 0 "40180"  -- Selection: Select Children
				for a=1 to 20 do
				for i in selection do if classof i!=Biped_Object do deselect i
			)
		)catch()
	)
)