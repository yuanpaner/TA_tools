print "NArt���ߣ����������ֶ�"

clearListener()
global files=#()
global exfiles=#()
global filesName=#()
global errorfiles=#()
global exfiles=#()
	
try(destroydialog mergeMaxFiles)catch()

rollout renameGeo "����ģ������" width:288 height:176
(
	label lblOri "ԭ�ֶ�" pos:[26,46] width:66 height:26
	label lblNew "���ֶ�" pos:[24,88] width:66 height:24
	editText edtOri "" pos:[112,46] width:136 height:24
	editText edtNew "" pos:[112,82] width:136 height:24
	button btnRename "��    ��" pos:[24,127] width:224 height:24
	label lbl5 "ע��ԭ�ֶβ�Ҫ��ƴд����" pos:[24,16] width:224 height:26
	
	
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
		if geosError.count!=0 then (select geosError;messagebox "�Ѿ�ѡ��û�и����ɹ�������")
	)
	
)
createdialog renameGeo style:#(#style_border,#style_titlebar,#style_sysmenu,#style_minimizebox)