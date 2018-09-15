
struct NArtMaterial(
	--��ղ�����༭���Ĳ�����
	fn ClearMEditor =(
		macros.run "Medit Tools" "clear_medit_slots"
	),
	
	--�����༭���Ĳ����򣬱�ɳ������õ��Ĳ�����
	--2015/5/11 ������ʾ��Ϣ by������
	fn ClearEditorMaterials = (
		
		NArtMaterial.ClearMEditor()
		
		_maxCount = sceneMaterials.count
		
		if _maxCount>24 do (
			_msgStr = "����������������" + (_maxCount as string) + "  ����24,ֻ���ռ�24��"
			print _msgStr
			_maxCount=24
		)
		
		for i = 1 to _maxCount do(
			meditMaterials[i] = sceneMaterials[i]
		)

	),

	
	--�ϲ���ͬ��ͼ�Ĳ�����
	fn MergeMaterials = (
-- 		arraymat = #()
-- 		arrayDiffMap = #()
		arrayGeo = #()
		
		saveGeo = #()
		
		for o in Geometry where classof o.material != Multimaterial do
		(
			if(o.material != undefined and o.material.diffusemap!=undefined and o.material.diffusemap.filename!=undefined  )then
			(
				append arrayGeo o
-- 				append arrayMat o.material
-- 				append arrayDiffMap o.material.diffusemap.filename
			)
		)


		k=0
		tmpStr="�ϲ���������Ŀ�� "
-- 		for i=1 to arrayGeo.count do
-- 		(
-- 			for j=1 to arrayGeo.count do
-- 			(
-- 				/* below for optimization*/
-- 				if arrayDiffMap[j] == arrayDiffMap[i] then 
-- 				(
-- 					arrayGeo[j].material=arrayGeo[i].material
-- 					k+=1
-- 					
-- 				)
-- 			)
-- 		)
		
		append saveGeo arrayGeo[1]
		
		for i = 2 to arrayGeo.count do(
			for j = 1 to saveGeo.count do(
				if arrayGeo[i].material.diffusemap.filename == saveGeo[j].material.diffusemap.filename then 
				(
					arrayGeo[i].material = saveGeo[j].material
					k+=1
					
				)else(
					append saveGeo arrayGeo[i]
				)
			)
		)
		
		
		strK=k as string
		tmpStr+=strK
		
		print tmpStr
		
		--messageBox tmpStr
	),
	fn getDiffFileName mat=
	(
		mapname = mat.diffusemap.filename
		print mapname
		if mapname !=undefined then
		(
			names = (filterstring mapname "\\")
			names2 = (filterstring names[names.count] ".")
			return names2[1]
			)
		else return "no"
	),
	fn RenameStandardMat = (
		for m in sceneMaterials do
		 (
			matA=#()
			matB=#()
			print m.name
			if classof m == Standardmaterial then
			(
					ret = (NArtMaterial.getDiffFileName m)
		-- 			print ret
					if ret!="no" then m.name = ret
					else append matA m
				)
			else append matB m
			print "Group of no diffuse map"
			print matA
			print "Group of not Standard material"
			print matB
	
		 )
	)
	
)

print "Load NArtMaterial"