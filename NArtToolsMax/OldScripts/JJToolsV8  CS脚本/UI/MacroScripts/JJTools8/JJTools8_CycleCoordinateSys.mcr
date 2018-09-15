----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_CycleCoordinateSys.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	5 May 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.05.05 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_CycleCoordinateSys
category:"JJTools 8"
Buttontext:"Cycle CoordSys"
tooltip:"Cycle Coordinate System"
icon:#("JJTools", 29)

(
	global movestate = 1
	
	on execute do
	(	
		case of
		(
			(movestate == 1): (toolmode.coordsys #view
							   movestate = 2)
			(movestate == 2): (toolmode.coordsys #screen
							   movestate = 3)
			(movestate == 3): (toolmode.coordsys #world
							   movestate = 4)
			(movestate == 4): (toolmode.coordsys #parent
							   movestate = 5)
			(movestate == 5): (toolmode.coordsys #local
							   movestate = 6)
			(movestate == 6): (toolmode.coordsys #gimbal
							   movestate = 7)
			(movestate == 7): (toolmode.coordsys #grid
							   movestate = 1)
		)					   
	)
)