print "ѡ�񳡾�������BIP���������л����˶����"

tp_bipobjArray=#()
for i in objects do 
(
	if classof i == biped_object and classof i.controller!=Footsteps and getappdata i 20110406!="rejectBipedselect" do append tp_bipobjArray i
	
	if TP_rejectFootstepsfoo==false do
		if classof i==biped_object and classof i.controller==Footsteps do append tp_bipobjArray i
	if TP_rejectNubfoo==false do
		if classof i==Dummy and classof i.controller==BipSlave_Control do append tp_bipobjArray i

)--��BIP������������
if tp_bipobjarray.count>0 do select tp_bipobjArray
if getCommandPanelTaskMode()!=#motion do setCommandPanelTaskMode #motion