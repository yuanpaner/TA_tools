----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_CleverRotate.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.0
-- Started:      	17 January 2003
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2003.01.17 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_CleverRotate
category:"JJTools 8"
Buttontext:"Clever Rotate"
tooltip:"Clever Rotate"
icon:#("JJTools", 20)

(
	global rotate_state = 1
	
	on execute do
	(
		case of
		(
			(rotate_state == 1): (toolmode.coordsys #view
							      rotate_state = 2
							      max rotate)
			(rotate_state == 2): (toolmode.coordsys #local
							      rotate_state = 1
							      max rotate)
		)					   
	)	
)