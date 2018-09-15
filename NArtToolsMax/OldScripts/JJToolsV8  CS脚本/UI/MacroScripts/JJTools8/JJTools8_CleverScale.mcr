----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_CleverScale.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	4 January 2005
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0 -- 2005.01.04 -- First release
-- v1.1 -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_CleverScale
category:"JJTools 8"
Buttontext:"Clever Scale"
tooltip:"Clever Scale"
icon:#("JJTools", 20)

(
	global scale_state = 1
	
	on execute do
	(
		case of
		(
			(scale_state == 1): (toolmode.coordsys #view
							      scale_state = 2
							      max scale)
			(scale_state == 2): (toolmode.coordsys #local
							      scale_state = 1
							      max scale)
		)					   
	)	
)
