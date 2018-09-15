--根据diffusemap贴图的名称 重命名材质球
macroscript NArtRenameStandardMat
category:"_NArtTools"
buttontext:"Rename Materials as Diffusemap"
tooltip:"Rename Materials as Diffusemap"
(
	on execute do
	(
		undo "Rename Materials as Diffusemap Texture" on
		(
			NArtMaterial.RenameStandardMat()
		)
	)
	
)