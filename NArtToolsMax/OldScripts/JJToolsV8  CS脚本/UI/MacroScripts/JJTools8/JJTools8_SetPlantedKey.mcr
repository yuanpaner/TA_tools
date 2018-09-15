----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_SetPlantedKey.mcr
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

macroScript JJTools8_SetPlantedKey
category:"JJTools 8" 
toolTip:"Set Planted Key" 
buttontext:"Plabted Key" 
icon:#("JJTools", 8)

(
	if selection.count > 0 then
	(
		for i = 1 to selection.count do
		(
			try
			(
				biped.setPlantedKey selection[i]
			)
			catch()
			
			try
			(
				biped.setPlantedKey selection[i] true true true
			)	
			catch()	 
		)
	)
)

