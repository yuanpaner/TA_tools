macroScript NArtLoadFN
category:"_NArtTools"
tooltip:"Load Functions"
buttontext:"Load Functions"
(
	
	on execute do(
		try(
			filein @"E:\3DArtShared\ToolsAndPlug-ins\NArtToolsMax\startup\NArtStart.ms"
		)catch(
			print " \"E:\3DArtShared\ToolsAndPlug-ins\NArtToolsMax\startup\NArtStart.ms\" Load failed!"
		)
	)

) 