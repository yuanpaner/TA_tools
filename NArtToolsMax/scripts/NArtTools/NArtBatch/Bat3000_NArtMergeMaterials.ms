--合并相同贴图的材质

print "NArt执行：合并相同贴图的材质"

undo "Merge Mat By Diffusemap Texture" on
(
	NArtMaterial.MergeMaterials()
)