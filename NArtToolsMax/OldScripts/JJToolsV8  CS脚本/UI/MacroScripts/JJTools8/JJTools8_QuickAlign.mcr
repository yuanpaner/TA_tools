----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_QuickAlign.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v2.1
-- Started:      	13 June 2001
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v2.0  -- 2001.06.13 -- Second release
-- v2.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_QuickAlign
category:"JJTools 8" 
toolTip:"Qucik Align" 
buttontext:"Quick Align"
icon:#("JJTools", 39)

(
	on isEnabled return (selection.count > 0)
	on Execute do
	(
		try(
		Toolmode.coordsys #local

		selectedobj = selection as array
		targetobj = pickobject()
		selectedobj.rotation = targetobj.rotation
		selectedobj.pos = targetobj.transform.position
		)catch()
	)
)

