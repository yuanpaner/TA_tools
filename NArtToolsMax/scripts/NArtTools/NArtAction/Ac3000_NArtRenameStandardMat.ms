print "NArt执行：根据贴图名重命名材质球"

		undo "Rename Materials as Diffusemap Texture" on
		(
			NArtMaterial.RenameStandardMat()
		)