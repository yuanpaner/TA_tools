struct NArtNode(
	
	--收集子物体（单线）
	fn GetSingleChildNodes _obj=
	(
		Global m_childNodesArray = #()
		
		NArtNode.GetSingleChildNodesRecursion _obj
		
		return m_childNodesArray
	),

	
	fn GetSingleChildNodesRecursion	_obj = (
		
		if _obj.children.count == 1 then(
			
			append m_childNodesArray _obj.children[1]
			
			NArtNode.GetSingleChildNodesRecursion _obj.children[1]
		)
	),
	
	--物体坐标归零
	fn SetObjectPosZero _objs = (
		for i in _objs do(
			try(
				i.pos = [0,0,0]
			)catch()
		)
	),
	
	--删除空物体
	fn delEmpty list = 	(
		_deletObjects = #()
		print "start to delete"
		for i=1 to list.count do
		(
			_obj = list[i]
			if (classof _obj == Editable_Poly and polyOp.getNumFaces _obj == 0) then 
			(
				print _obj.name
				append _deletObjects list[i]
			)
		)
		delete _deletObjects
		if i!=0 then print "delete "+(_deletObjects.count as string)+" Editable_Poly"
		else print "no empty objects"
	),
	
	--排除数组中已删除的物体
	fn RemoveDelNodeFromArray _array=(
		m_delNodes = #()
		for i=1 to _array.count do(
			if isDeleted _array[i] do(
				append m_delNodes _array[i]
			)
		)
		for i in m_delNodes do(
			_delItem = findItem _array i
			deleteitem _array _delItem
		)
		return _array
	)
	
)