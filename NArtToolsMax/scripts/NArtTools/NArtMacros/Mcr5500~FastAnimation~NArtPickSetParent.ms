macroScript NArtPickSetParent
category:"_NArtTools"
ButtonText:"Pick And Set Parent"
Tooltip:"Pick And Set Parent"
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