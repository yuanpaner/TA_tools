macroScript NArtShowAll
category:"_NArtTools"
ButtonText:"Show All"
toolTip:"Show All"
(
	on execute do(
		max unfreeze all
		max unhide all
		hideByCategory.none()
	)
)
