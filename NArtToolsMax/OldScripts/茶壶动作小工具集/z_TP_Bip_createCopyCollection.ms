macroscript TP_Bip_createCopyCollection
	category:"²èºøÎ´ÍêÉÆ¹¤¾ß"
	buttontext:"TP Create Collection"
	tooltip:"TP Create Collection"
(
	
	
	on isEnabled return (selection.count==1 and classof selection[1]==biped_object)
	
	on execute do
	(	
		tp_modelnameAry=filterstring maxfilename "_ ."
		tp_modelname=tp_modelnameAry[1]
		biped.createCopyCollection $.controller tp_modelname
	)

)

