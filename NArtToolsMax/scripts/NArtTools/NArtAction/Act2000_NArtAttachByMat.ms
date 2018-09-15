print "NArt执行：相同材质球物体合并"

allgeo = selection as array
-- if select, use selectionl; or use all geometries
if allgeo.count==0 do allgeo = geometry
	
NArtGeometry.attachByMat allgeo