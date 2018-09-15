macroScript TP_PickParent
ButtonText:"TP Pick Parent"
category:"²èºøÎ´ÍêÉÆ¹¤¾ß"
Tooltip:"TP Pick Parent"
(
	on isEnabled return (selection.count>0)
	on execute do
	(
		try(
		tp_selobj=for i in selection collect i
		tp_Parent=pickobject()
		for i in selection do i.parent=tp_Parent
		append tp_selobj tp_Parent
		select tp_selobj
		tp_selobj=#()
		)catch() 
	)
)