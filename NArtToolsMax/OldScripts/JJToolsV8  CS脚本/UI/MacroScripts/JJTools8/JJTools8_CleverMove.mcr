----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_CleverMove.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	17 January 2003
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2003.01.17 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_CleverMove
category:"JJTools 8"
Buttontext:"Clever Move"
tooltip:"Clever Move"
icon:#("JJTools", 19)

(
	global move_state = 1
	
	on execute do
	(	
		case of
		(
			(move_state == 1): (toolmode.coordsys #view
							    move_state = 2
							    max move)
			(move_state == 2): (toolmode.coordsys #local
							    move_state = 1
							    max move)
		)					   
	)
)