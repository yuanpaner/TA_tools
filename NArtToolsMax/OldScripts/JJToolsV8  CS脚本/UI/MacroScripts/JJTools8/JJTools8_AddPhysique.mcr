----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_AddPhysique.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Requirements:	Character Studio
-- Version:			v1.2
-- Started:      	13 June 2001
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0 -- 2001.06.13 -- First release
-- v1.2 -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_AddPhysique
category:"JJTools 8" 
toolTip:"Add Physique" 
buttontext:"Physique" 
icon:#("JJTools", 14)

(
	on isEnabled return (selection.count >=1)
	on Execute do
	(
		try
		(
			modPanel.addModToSelection (Physique ()) ui:on
		)
		catch
		(
			messageBox "Physique could not be added!" title:"JJTools Error" beep:true
		)
	)
)

