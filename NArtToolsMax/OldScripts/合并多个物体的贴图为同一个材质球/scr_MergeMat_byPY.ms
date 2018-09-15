
-- Merge Material with the same Diffuse Texture
-- By Pan Yuan / QQ:185734359
-- 2014.10.27
-- you can assign objects with the same diffusemap texture the same material

-- problem: offset subMaterial; without considering Normalmap and others
-- problemII:optimization : ok
macroscript MergeMatByDiffusemapTexture category:"script for optimization" tooltip:"merge material by diffuse texture" Icon:#("fbjqt",18)
(
	undo "Merge Mat By Diffusemap Texture" on
	(
	
		arraymat = #()
		arrayDiffMap = #()
		arrayGeo=#()
		for o in Geometry where classof o.material != Multimaterial do
		(
			if(o.material != undefined and o.material.diffusemap!=undefined and o.material.diffusemap.filename!=undefined  )then
			(
			append arrayGeo o
		 	append arrayMat o.material
		 	append arrayDiffMap o.material.diffusemap.filename
			)
		)
		/* print info */
		-- for i=1 to arrayGeo.count do 
		-- (
		-- 		print arrayGeo[i]
		-- 		print arrayGeo[i].material
		-- 		print arrayGeo[i].material.diffusemap.filename
		-- 		print "---"
		-- )
		-- print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

		k=0
		tmpStr="合并材质球数目： "
		for i=1 to arrayGeo.count do
		(
			for j=2 to arrayGeo.count do
			(
				/* below for optimization*/
				if arrayDiffMap[j] == arrayDiffMap[i] then 
				(
					arrayGeo[j].material=arrayGeo[i].material
					k+=1
					
				)
			)
		)
		strK=k as string
		tmpStr+=strK
		messageBox tmpStr
 


		/*acount of scene geometry*/
		-- arrayT=#()
		-- for i in Geometry where i!=undefined do
		-- (
		-- 	k=1
		-- 	append arrayT i
		-- 	print arrayT[k]
		-- 	k+=1
		-- 	)
	)
)
