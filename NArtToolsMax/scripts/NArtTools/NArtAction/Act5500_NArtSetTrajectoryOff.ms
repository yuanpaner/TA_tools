print "�ر�Trajectory(����·��)"

if selection.count>0 then
(
	for i in selection do
	(
		i.showTrajectory = off
	)
)
else
(
	for i in objects do i.showTrajectory = off
)