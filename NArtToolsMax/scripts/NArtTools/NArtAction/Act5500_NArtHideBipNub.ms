print "����BIPNUB"

_bipNubArray = #()
for i in objects do(
	if classof i.controller == BipSlave_Control and classof i == Dummy do(
		append _bipNubArray i
	)
)
select _bipNubArray
max hide selection
max motion mode