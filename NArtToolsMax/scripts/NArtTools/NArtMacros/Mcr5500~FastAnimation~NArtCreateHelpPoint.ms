macroScript NArtCreateHelpPoint
category:"_NArtTools"
buttontext:"Create Help Point"
toolTip:"Create Help Point"
(
	on isVisible return (selection.count == 1)
	on execute do
	(
		
		tp_pickobject = selection[1]
		
		tp_NewPoint = Point isSelected:on size:30 box:on axistripod:on centermarker:on wirecolor:orange
			
		try(
			tp_NewPoint.transform = tp_pickobject.transform
			tp_NewPoint.scale = [1, 1, 1]
		)catch()
	)
)