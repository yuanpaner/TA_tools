print "NArtִ�У�����ģ��(����������Ϣ)"

if selection.count == 1 do (
	_obj = $
	if classof _obj == Editable_Poly do(
		disableSceneRedraw() 
		_copyObj = copy _obj
		
		max modify mode
		subobjectLevel = 4
		max delete
		_obj.EditablePoly.delete #Face
		
		select _copyObj
		max modify mode
		subobjectLevel = 4
		max select invert

		max delete
		_obj.EditablePoly.delete #Face
		subobjectLevel = 0
		enableSceneRedraw() 
	)
)
