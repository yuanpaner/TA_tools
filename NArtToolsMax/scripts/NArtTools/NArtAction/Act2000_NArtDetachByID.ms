print "NArt执行：根据ID分离模型"

NArtNode.delEmpty geometry
allgeo = selection as array
-- if select, use selectionl; or use all geometries
if allgeo.count==0 do allgeo = geometry

for i in allgeo do
(
	converttopoly i 
	if classof i.material == Multimaterial do
	(
		NArtGeometry.detachByID i
	)
)
NartNode.delEmpty geometry