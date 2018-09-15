print "拾取设置父物体"

try(
	
	tp_selobj = for i in selection collect i
		
	tp_Parent = pickobject()
	
	for i in selection do i.parent = tp_Parent
		
	append tp_selobj tp_Parent
	
	select tp_selobj
	
	tp_selobj=#()
	
)catch() 