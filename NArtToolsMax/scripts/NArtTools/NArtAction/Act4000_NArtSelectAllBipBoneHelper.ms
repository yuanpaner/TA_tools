print "ѡ������Bip Bone Helper"

tp_BipBoneHelperobjArray=#()
for i in objects do 
(
	if classof i == biped_object and classof i.controller!=Footsteps and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i
	if superclassof i == helper and classof i.controller!=BipSlave_Control and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i
	if classof i == BoneGeometry and classof i.controller!=Footsteps and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i
	
	if TP_rejectFootstepsfoo==false do
		if classof i==biped_object and classof i.controller==Footsteps and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i
	if TP_rejectNubfoo==false do
		if classof i==Dummy and classof i.controller==BipSlave_Control and getappdata i 20110429!="rejectBipedBoneHelperselect" do append tp_BipBoneHelperobjArray i

)--��BIP������������
if tp_BipBoneHelperobjArray.count>0 do select tp_BipBoneHelperobjArray