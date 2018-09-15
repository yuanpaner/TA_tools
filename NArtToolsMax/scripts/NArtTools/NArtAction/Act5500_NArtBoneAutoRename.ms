print "自动重命名Bone"

local tp_BoneChildArray=#()
local tp_renameBoneArray=#()

if selection.count==1 then
(
	_selObj = selection[1]
	
	tp_NameHead = selection[1].name
	
	tp_getChidArray = NArtNode.GetSingleChildNodes _selObj
	
	append tp_renameBoneArray _selObj
	
	for i in tp_getChidArray do (

		append tp_renameBoneArray i
		
	)
		
	tp_foo = 0
	
	for i in tp_renameBoneArray do
	(
		tp_foo+=1
		i.name = tp_NameHead + tp_foo as string
		print i.name
	)
)
else
(
	messagebox"请选择单个骨骼物体" title:"选择错误"
)