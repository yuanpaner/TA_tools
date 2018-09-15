----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_CreateAlign.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	5 May 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.05.05 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_CreateAlign
category:"JJTools 8"
toolTip:"Create & Align"
buttontext:"CreateAlign"
icon:#("JJTools", 73)

(
	toolmode.coordsys #local
	Box lengthsegs:1 widthsegs:1 heightsegs:1 length:12 width:7 height:4 mapCoords:off pos:[0,0,0] isSelected:on
	selectedbox = selection as array
	targetbox = pickobject()
	selectedbox.rotation = targetbox.rotation
	selectedbox.pos = targetbox.transform.position
)
