print "选择所有Helpers"

tp_helperobjArray=#()
for i in objects do 
(
	if TP_HrejectNubfoo==false do
		if classof i==Dummy and classof i.controller==BipSlave_Control and getappdata i 20110413!="rejecthelperselect" do append tp_helperobjArray i
	if superclassof i == helper and classof i.controller!=BipSlave_Control and getappdata i 20110413!="rejecthelperselect" do append tp_helperobjArray i
)--把Helper加入数组
if tp_helperobjarray.count>0 do select tp_helperobjArray