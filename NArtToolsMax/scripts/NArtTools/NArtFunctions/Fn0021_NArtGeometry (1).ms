struct NArtGeometry(
	--获取模型大小
	fn GetSize _obj = (
		if _obj == undefined do return [0, 0, 0]
		return _obj.max - _obj.min
	),
	
	--获取模型宽度（X）
	fn GetWidth _obj = (
		_size = NArtGeometry.GetSize(_obj)
		return _size.x
	),
	
	--获取模型长度（Y）
	fn GetLength _obj = (
		_size = NArtGeometry.GetSize(_obj)
		return _size.y
	),
	
	--获取模型高度（Z）
	fn GetHeight _obj = (
		_size = NArtGeometry.GetSize(_obj)
		return _size.y
	),
	
	--各角度排列模型，为渲染模型用
	fn CopyGeoForRender _obj _space = (
		_copy1 = copy _obj
		move _copy1 [_space, 0, 0]
		_rotObj = eulerangles 0 0 45
		rotate _copy1 _rotObj
		
		_copy2 = copy _obj
		move _copy2 [_space * 2, 0, 0]
		_rotObj = eulerangles 0 0 90
		rotate _copy2 _rotObj
		
		_copy3 = copy _obj
		move _copy3 [_space * 3, 0, 0]
		_rotObj = eulerangles 0 0 135
		rotate _copy3 _rotObj
		
		_copy4 = copy _obj
		move _copy4 [_space * 4, 0, 0]
		_rotObj = eulerangles 0 0 180
		rotate _copy4 _rotObj
	),
	-- 按多为子材质拆分模型
	fn detachByID geo =
	(
		for idcount=1 to geo.material.count do
		(
			print geo.name
			geo.selectByMaterial idcount
			tempFace=polyOp.getFaceSelection geo
			tempName=(uniqueName(geo.name+"_Part"))
			ret = polyOp.detachFaces geo tempFace asNode:true name: tempName
			if ret then
			(
				_newNode=(getnodebyname tempname)
				if _newNode!=null then
				(
					_newNode.material=geo.material[idcount]
					--sometimes material undefine
					_newNode.wirecolor=(color(random 0 255)(random 0 255)(random 0 255))
				)
				else 
				(
					print idcount
					print "not detach nodename"
				)
			)
			
		)
	),
	
	-- 炸开所有的面
	fn faceBreakFunc desObj deleteOriginal parentFacesToHelper useFaceSelection newNameFace =
	(		
		if desObj!=undefined then
		(
			with redraw off 
			(
				faceObjectsArray = #()

				max create mode

				if deleteOriginal then (
						 obj = desObj
					) else  obj = copy desObj
					
				convertTo obj Editable_Poly
					
				pHelperName = (uniquename (obj.name + "_FacesPoint"))
				pHelper = Point name:pHelperName pos:obj.pos
				
				local selectedFaces = #{}	
					--If user wants only selected faces to be detached
				if useFaceSelection == true then (
						--Get current face selection
						selectedFaces = polyop.getFaceSelection obj 
						
						--If subselection for object is empty, assume that the user wants all faces in this object
						if selectedFaces.isEmpty then (
							selectedFaces = #{1..obj.numfaces}
						)
						
					) 
						
				for f = obj.getNumFaces() to 1 by -1 do 
					(
						
						if useFaceSelection == false OR findItem selectedFaces f != 0 then (
		
							-- Detach face as a new obj
							local newName = uniqueName newNameFace
							polyop.detachFaces obj #{f} asNode:true delete:deleteOriginal name:newName
							newFaceObj = getNodeByName newName
								
							-- Center Pivot of the newly created object and set its rotation to match the face's original orientation
							CenterPivot newFaceObj							
							
							-- Parent the new object to the point helper we created earlier	
							if parentFacesToHelper == true then newFaceObj.parent = pHelper
		
							append faceObjectsArray newFaceObj
							)	
						)-- End of For Face loop
						
						clearSelection()

						delete obj
						
						if parentFacesToHelper then selectmore pHelper else delete pHelper
				return faceObjectsArray
			
			)
			return(faceObjectsArray)
			
		)
		else  return false 
		
	),-- End of Function
	
	-- 相同材质的物体合并成一个模型
	fn attachByMat list=(
		geo=#()
		 for m in sceneMaterials do
		 (
			temp=#()
			for obj in list do
			(
				if obj.material == m then append temp obj
			)
			append geo temp
			print m.name
			print temp
		 )
		 for i in geo do
		 (
			if i.count > 1 then
			(
				for x =2 to i.count do
				(
					i[1].attach i[x] i[1]
				)
			)
		 )	
	)
	
)