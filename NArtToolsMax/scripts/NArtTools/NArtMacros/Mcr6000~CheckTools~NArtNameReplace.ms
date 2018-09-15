macroScript NArtNameReplace
category:"_NArtTools"
toolTip:"NameReplace"
buttontext:"Replace Name"
(
	on execute do(

	clearListener()
	global files=#()
	global exfiles=#()
	global filesName=#()
	global errorfiles=#()
	global exfiles=#()
		
	try(destroydialog mergeMaxFiles)catch()

	rollout renameGeo "更改模型名称" width:288 height:176
	(
		label lblOri "原字段" pos:[26,46] width:66 height:26
		label lblNew "新字段" pos:[24,88] width:66 height:24
		editText edtOri "" pos:[112,46] width:136 height:24
		editText edtNew "" pos:[112,82] width:136 height:24
		button btnRename "更    名" pos:[24,127] width:224 height:24
		label lbl5 "注意原字段不要有拼写错误！" pos:[24,16] width:224 height:26
		
		
		on btnRename pressed do with undo label:"Rename Geometry" on 
		(
			clearListener()
			geosError = #()
			if selection.count!=0 then geos = selection 
				else geos = geometry
			sSearch = copy edtOri.text
			sInsert = copy edtNew.text
			for geo in geos do
			(
				sName = copy geo.name
				print ("original name:\t"+sName)
				iLength = sSearch.count
				if(matchPattern sName pattern:("*"+sSearch+"*")) then
				(
					iIndexjjc = findString sName sSearch
					sTemp = substring sName 1 (iIndexjjc-1)
					sTemp2 = substring sName (iIndexjjc+iLength) -1
					sNewName = sTemp+sInsert+sTemp2
					print ("new name:\t"+sNewName)
					geo.name = sNewName					
					)
				else 
					(
						append geosError geo
						)
			)--end for
			if geosError.count!=0 then (select geosError;messagebox "已经选中没有更名成功的物体")
		)
		
	)
	createdialog renameGeo style:#(#style_border,#style_titlebar,#style_sysmenu,#style_minimizebox)

	)-- end execute
)