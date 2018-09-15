macroScript NArtAttachByMat
category:"_NArtTools"
toolTip:"Attach By Matetrial"
buttontext:"Attach By Matetrial"
(
	on execute do(
		
		allgeo = selection as array
		-- if select, use selectionl; or use all geometries
		if allgeo.count==0 do allgeo = geometry
		
		NArtGeometry.attachByMat allgeo
	)

)