JJTools7----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_ToggleSelectionBrackets.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	18 May 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.05.18 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_ToggleSelectionBrackets
category:"JJTools 8"
toolTip:"Toggle Selection Brackets"
buttontext:"Toggle SB"
icon:#("JJTools", 73)

(
	actionMan.executeAction 0 "370"
)
