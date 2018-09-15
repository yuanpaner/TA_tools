----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_UnhideSelected.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	20 May 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0 -- 2004.05.20 -- First release
-- v1.1 -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_UnhideSelected
category:"JJTools 8"
toolTip:"Unhide Selected"
buttontext:"Unhide Selected"
icon:#("JJTools", 73)

(
	try(unhide $)catch()
)
