macroscript NArtHideBoneToggle
category:"_NArtTools"
buttontext:"����\��ʾBone"
tooltip:"����\��ʾBone"
(
	on isChecked return (hideByCategory.bones)
	on execute do
	(	
		hideByCategory.bones = not hideByCategory.bones
	)

)