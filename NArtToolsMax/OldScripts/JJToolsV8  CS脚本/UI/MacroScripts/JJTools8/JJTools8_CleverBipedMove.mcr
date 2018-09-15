----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_CleverBipedMove.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	23 June 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.06.23 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_CleverBipedMove
category:"JJTools 8"
Buttontext:"Biped Move"
tooltip:"Clever Biped Move"
icon:#("JJTools", 19)

(
	biped_move_state = 1

	on execute do
	(	
		try
		(
			case of
			(
				(biped_move_state == 1): (biped_move_state = 2
									      max move
										  $.transform.controller.trackSelection=1)
				(biped_move_state == 2): (biped_move_state = 1
									      max move
										  $.transform.controller.trackSelection=2)
			)	
		)catch()
	)
)