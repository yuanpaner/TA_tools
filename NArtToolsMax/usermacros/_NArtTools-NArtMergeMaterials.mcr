macroScript NArtMergeMaterials
category:"_NArtTools"
buttontext:"Merge Same Materials"
tooltip:"Merge Same Materials"
(
	on execute do
	(
		undo "Merge Mat By Diffusemap Texture" on
		(
			NArtMaterial.MergeMaterials()
		)
	)
	
) 