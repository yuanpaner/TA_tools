macroScript NArtAddPrefix_G
category:"_NArtTools"
buttontext:"添加前缀G"
tooltip:"添加前缀G"
(	
	on execute do
	(
		if selection.count == 0 then (
			for i in Geometry do(
				i.name = NArtName.AddPrefix_G i.name
			) 
		)else(
			for i in selection do (
				if superClassof i == GeometryClass and Classof i != Biped_Object do(
					i.name = NArtName.AddPrefix_G i.name
				)
			)
		)
	)
)