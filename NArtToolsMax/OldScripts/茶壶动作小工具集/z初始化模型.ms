macroScript model_Initialize
category:"茶壶未完善工具"
toolTip:"model_Initialize"
(
Global GeometryArray=#()
Global msg=0
for i in objects do if superclassof I==geometryclass do append GeometryArray i
for i in GeometryArray do 
	(
	if i.material!=undefined then
		(
		if classof i.material==Standardmaterial then
			(
			i.material.twosided=on
			if i.material.diffusemap!=undefined then
				(
				diffilename=i.material.diffusemap.filename
				difnameArray=filterstring diffilename "."
				difmapexe=difnameArray[difnameArray.count] as name
				if difmapexe !=#dds then
					(
					msg=1
					)
				)
			if i.material.opacitymap!=undefined then
				(
				Opafilename=i.material.opacitymap.filename
				OpanameArray=filterstring Opafilename "."
				Opaexe=OpanameArray[OpanameArray.count] as name
				if Opaexe !=#dds then
					(
					msg=1
					)
				)
			)
		else
			(
			if classof i.material==Multimaterial then
				(
				for a in i.material.material do
					(
					a.twosided=on
						
				if a.diffusemap!=undefined then
				(
				diffilename=a.diffusemap.filename
				difnameArray=filterstring diffilename "."
				difmapexe=difnameArray[difnameArray.count] as name
				if difmapexe !=#dds then
					(
					msg=1
					)
				)
			if a.opacitymap!=undefined then
				(
				Opafilename=a.opacitymap.filename
				OpanameArray=filterstring Opafilename "."
				Opaexe=OpanameArray[OpanameArray.count] as name
				if Opaexe!=#dds then
					(
					msg=1
					)
				)
				)
				)
			)
		)
	if classof i!=Biped_Object do
		(
		i.showFrozenInGray = off
		i.backfacecull=off
		)
	)
try
	(
	units.systemscale=1.0
	units.systemtype=#inches
	units.DisplayType=#Generic
	framerate=30
	)
catch()
if msg==1 then
(
messagebox"发现未贴图错误，类型不是dds或未指定贴图"Title:"贴图错误"
actionMan.executeAction 0 "50048"  -- Tools: Material Editor Toggle
)

)
