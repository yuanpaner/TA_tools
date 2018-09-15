----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_SetSlidingKey.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Requirements:	Character Studio
-- Version:			v1.2
-- Started:      	25 April 2005
-- Last Modified: 	10 November 2005
-- Code by:			Cameron Fielding and Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2005.04.25 -- First release
-- v1.2  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_SetSlidingKey
category:"JJTools 8" 
toolTip:"Set Sliding Key" 
buttontext:"Sliding Key" 
icon:#("JJTools", 9)

(
	if selection.count > 0 then
	(
		for i = 1 to selection.count do
		(
			try
			(
				biped.setSlidingKey selection[i]
			)
			catch()
			
			try
			(
				biped.setSlidingKey selection[i] true true true
			)	
			catch()	 
		)
	)
)