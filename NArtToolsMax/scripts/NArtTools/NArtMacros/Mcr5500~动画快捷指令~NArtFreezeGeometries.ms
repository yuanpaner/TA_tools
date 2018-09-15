--解除\冻结场景内所有模型物体 (右键菜单显示的小框为隐藏除模型外的物体)--
macroscript NArtFreezeGeometries
category:"_NArtTools"
buttontext:"解除\冻结场景内所有模型物体"
tooltip:"解除\冻结场景内所有模型物体"
(
	on execute do
	(
		tp_GeometryClass=#()
		tp_GeoArray=#()
		for i in objects do
		if superclassof i==GeometryClass do append tp_GeometryClass i
		for i in tp_GeometryClass do
			(
				if classof i!=Biped_Object and classof i!=BoneGeometry then append tp_GeoArray i
			)
		for i in tp_GeoArray do i.showFrozenInGray=off
		if tp_GeoArray[1].isFrozen==false then 
		(
			freeze tp_GeoArray
			for i in selection do
			(
				for a in tp_GeoArray do
				(
					if i==a do deselect i
				)
			)
		)
		else unfreeze tp_GeoArray

	)
	
	on altExecute type do
	(
		tp_exGeoArray=#()
		for i in objects do
		(
			if classof i!=PolyMeshObject and classof i!=Editable_Poly and classof i!=Editable_mesh then append tp_exGeoArray i
		)
		if tp_exGeoArray[1].ishidden==false then hide tp_exGeoArray else unhide tp_exGeoArray

	)
)