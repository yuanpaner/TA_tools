--�������FBX

print "NArtִ�У��������FBX"

rollout Rollout_Wait "Wait" width:169 height:95
(
	label lbl1 "��ȴ� ..." pos:[63,48] width:40 height:21
	GroupBox grp2 "Auto Export FBX" pos:[6,10] width:156 height:79
)

try(DestroyDialog Rollout_Wait)catch()
createDialog Rollout_Wait

NArtExport.WorldEntitiesExport()

DestroyDialog Rollout_Wait