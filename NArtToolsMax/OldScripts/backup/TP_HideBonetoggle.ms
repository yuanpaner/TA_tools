macroscript TP_HideBonetoggle
category:"���δ���ƹ���"
buttontext:"TP Hide Bone toggle"
tooltip:"TP Hide Bone toggle"
(
	on isChecked return (hideByCategory.bones)
	on execute do
	(	
		hideByCategory.bones=not hideByCategory.bones
	)

)