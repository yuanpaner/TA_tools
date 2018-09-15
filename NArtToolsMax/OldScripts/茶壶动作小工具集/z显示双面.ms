macroScript twosidedall
category:"自定义工具"
toolTip:"twosidedall"
(
GeometryArray=#()
for i in objects do if superclassof I==geometryclass do append GeometryArray i
for i in GeometryArray do 
	(
	if i.material!=undefined then
		(
		if classof i.material==Standardmaterial then
			(
			i.material.twosided=on
			)
		else
			(
			if classof i.material==Multimaterial then
				(
				for a in i.material.material do
					(
					a.twosided=on
					)
				)
			)
		)
	if classof i!=Biped_Object do
		(
		i.showFrozenInGray = off
		)
	)
)
