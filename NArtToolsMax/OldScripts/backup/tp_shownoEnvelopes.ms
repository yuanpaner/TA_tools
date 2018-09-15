macroScript TPshowNoEnvelopes
ButtonText:"TP show No Envelopes"
Category:"²èºøÎ´ÍêÉÆ¹¤¾ß" 
Tooltip:"TP show No Envelopes (Skin)" 
(
	fn tp_skinshowNoEnvelops =
	(
		try(	
			if $.skin.showNoEnvelopes==true then
			(
				return true 
			)
			else 
			(
				return false
			)
		)catch(return false)
		
	)
	on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
	on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (tp_skinshowNoEnvelops())
	on Execute do
	(
		try(
		if $.skin.showNoEnvelopes==true then
			(
				$.skin.showNoEnvelopes=false 
			)
			else 
			(
				$.skin.showNoEnvelopes=true
			)
		)catch()
	)
)
