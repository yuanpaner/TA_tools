macroscript tp_Check_Name
category:"茶壶未完善工具"
buttontext:"TP Check Name"
tooltip:"TP Check Name"
(	
	tp_allObj=for i in objects collect i
	tp_contrastArray
	tp_repeatName=#()
	for tp_contrastObj in tp_allObj do
	(
		tp_contrastArray=for i in tp_allObj where i!=tp_contrastObj collect i
		for i in tp_contrastArray do
		(
			if i.name==tp_contrastObj.name do 
			(
				tp_CheckNamefoo=false
				for a in tp_repeatName do
				(
					if i.name==a.name do tp_CheckNamefoo=true
				)
				if tp_CheckNamefoo==false do append tp_repeatName i
			)
		)
	)
	if tp_repeatName.count>0 then
	(
		tp_msgboxText="发现重名物体：\r\n\r\n"
		for i in tp_repeatName do
		(v
			tp_msgboxText+=("    "+i.name+"\r\n\r\n")
		)
		messageBox tp_msgboxText
	)
	else
	(
		messageBox "未发现重名物体"

	)
)