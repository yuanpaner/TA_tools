print "选择所有Bone"

tp_BoneobjArray=#()
for i in objects do 
(
	
	if classof i == BoneGeometry and getappdata i 20110407!="rejectBoneselect" do append tp_BoneobjArray i

)--把BIP骨骼加入数组

if tp_Boneobjarray.count>0 do select tp_BoneobjArray