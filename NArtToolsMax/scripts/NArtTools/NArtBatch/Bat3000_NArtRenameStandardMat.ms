--根据贴图名重命名材质

print "NArt执行：根据贴图名重命名材质"

undo "Rename Materials as Diffusemap Texture" on
(
	NArtMaterial.RenameStandardMat()
)