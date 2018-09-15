----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_UVWMapSelected.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	16 August 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.08.16 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_UVWMapSelected
category:"JJTools 8" 
toolTip:"UVWMap Selected" 
buttontext:"UVWMap $"  
icon:#("JJTools", 15)

(
	for obj in selection do
	(
		if isKindOf obj geometryclass then
		(
			addmodifier obj (uvwmap ())
			obj.modifiers[#UVWMapping].maptype = 4
		)
	)
)