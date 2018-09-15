macroscript TP_HideBonetoggle
category:"²èºøÎ´ÍêÉÆ¹¤¾ß"
buttontext:"TP Hide Bone toggle"
tooltip:"TP Hide Bone toggle"
(
	on isChecked return (hideByCategory.bones)
	on execute do
	(	
		hideByCategory.bones=not hideByCategory.bones
	)

)