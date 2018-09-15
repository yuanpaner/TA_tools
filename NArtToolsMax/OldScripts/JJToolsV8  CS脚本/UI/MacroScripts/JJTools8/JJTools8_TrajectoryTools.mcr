----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_TrajectoryTools.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.3
-- Started:      	17 May 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.05.17 -- First release
-- v1.1  -- 2004.06.04 -- Included support for biped
-- v1.2  -- 2004.10.29 -- Fixed bug with trajectories not turning off on biped
-- v1.3  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_HideAllTrajectories
category:"JJTools 8"
toolTip:"Hide All Trajectories"
buttontext:"Hide Traj"
icon:#("JJTools", 73)

(
	for obj in objects do
	(
		settrajectoryon obj false	

		if iskindof obj biped_object then
		(
			(obj.controller.rootnode).controller.displaytrajectories = false
		)
	)
)

macroScript JJTools8_ToggleTrajectories
category:"JJTools 8"
toolTip:"Toggle Trajectories"
buttontext:"Toggle Traj"
icon:#("JJTools", 73)

(	
	on isEnabled return (selection.count > 0)
	on execute do
	(
		for obj in selection do
		(
			if iskindof obj Biped_Object then
			(
				(obj.controller.rootnode).controller.displaytrajectories = not((obj.controller.rootnode).controller.displayTrajectories)
			)
			else if (iskindof obj biped_object == false) then
			(
				settrajectoryon obj (not(getTrajectoryOn obj))
			)
		)
	)
)



