----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_ToggleEdgeFaces.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	18 August 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.18.08 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroscript JJTools8_ToggleEdgeFaces
category:"JJTools 8"
tooltip:"Toggle Edge Faces"
buttontext:"Tog Edge Faces"
icon:#("JJTools", 18)

(
	on isEnabled return (selection.count >= 1)
	on Execute do
	(
		try
		(
			--loop through selected objects and set pivot point to object's centre
			for i in selection do 
			(
				if i.alledges == on then
				(
					i.alledges = off
				)
				else
				(
					i.alledges = on
				) 
			)
		)
		catch
		(
			messageBox "The object's edge faces could not be toggled" title:"JJTools Error" beep:true
		)
	)
)


