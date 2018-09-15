
struct NArtMaterial(
	--清空材质球编辑器的材质球
	fn ClearMEditor =(
		macros.run "Medit Tools" "clear_medit_slots"
	),
	
	--整理编辑器的材质球，变成场景中用到的材质球
	--2015/5/11 增加提示信息 by张子萌
	fn ClearEditorMaterials = (
		
		NArtMaterial.ClearMEditor()
		
		_maxCount = sceneMaterials.count
		
		if _maxCount>24 do (
			_msgStr = "场景材质球数量：" + (_maxCount as string) + "  超过24,只能收集24个"
			print _msgStr
			_maxCount=24
		)
		
		for i = 1 to _maxCount do(
			meditMaterials[i] = sceneMaterials[i]
		)

	),

	
	--合并相同贴图的材质球
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
		tmpStr="合并材质球数目： "
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
