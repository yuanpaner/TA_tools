----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_ToggleVertexColours.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v2.1
-- Started:      	13 June 2001
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v2.0  -- 2001.06.32 -- Second release
-- v2.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_ToggleVertexColors
category:"JJTools 8"
toolTip:"Toggle Vertex Colours"
buttontext:"Vert Colours"
icon:#("JJTools", 58)

(
	on isEnabled return (selection.count >= 1)
	global gbVertexColorState
	
	on Execute do
	(
		--store the current global state of the vertex color toggle
		--if its already defined ( meaning you already used this script ) then
		--simply switch its state. If not call it true.
		if gbVertexColorState != UNDEFINED then gbVertexColorState = NOT gbVertexColorState
		else gbVertexColorState = TRUE
		
		--get current selection as array
		selArray = GetCurrentSelection()
		
		--loop through selected objects
		for obj in selArray do 
		(
			if obj != UNDEFINED do 
				(
					try ( obj.showVertexColors = gbVertexColorState )
					catch ( format "Unable to change vertex color toggle for some reason\n" 
				)
			)
		)
	)
)	

