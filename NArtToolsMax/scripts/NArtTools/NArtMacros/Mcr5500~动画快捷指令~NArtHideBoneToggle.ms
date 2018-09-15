macroscript NArtHideBoneToggle
category:"_NArtTools"
buttontext:"Òþ²Ø\ÏÔÊ¾Bone"
tooltip:"Òþ²Ø\ÏÔÊ¾Bone"
(
	on isChecked return (hideByCategory.bones)
	on execute do
	(	
		hideByCategory.bones = not hideByCategory.bones
	)

)