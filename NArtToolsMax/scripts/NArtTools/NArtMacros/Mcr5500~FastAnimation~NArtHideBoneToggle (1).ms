macroscript NArtHideBoneToggle
category:"_NArtTools"
buttontext:"Hide Bone toggle"
tooltip:"Hide Bone toggle"
(
	on isChecked return (hideByCategory.bones)
	on execute do
	(	
		hideByCategory.bones=not hideByCategory.bones
	)

)