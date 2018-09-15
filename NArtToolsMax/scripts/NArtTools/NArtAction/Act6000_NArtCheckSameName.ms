print "检查重名"

tp_repeatName= NArtCheck.CheckSameName()

if tp_repeatName.count > 0 then
(
	tp_msgboxText="发现重名物体：\r\n\r\n"
	for i in tp_repeatName do
	(
		tp_msgboxText+=("    "+i.name+"\r\n\r\n")
	)
	messageBox tp_msgboxText
)
else
(
	messageBox "未发现重名物体"

)