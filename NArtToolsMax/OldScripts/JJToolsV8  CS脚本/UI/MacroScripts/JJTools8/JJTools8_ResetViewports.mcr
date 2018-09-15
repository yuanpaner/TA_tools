----------------------------------------------------------------------------------------
-- Script Name:		JJTools8-ResetViewports.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v2.1
-- Started:      	13 June 2001
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v2.0  -- 2001.06.13 -- First release
-- v2.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_ResetViewports
category:"JJTools 8"
toolTip:"Reset all Viewports"
buttontext:"Reset Views"
icon:#("JJTools", 43)

(
   --resets to Max Standard
   viewport.ResetAllViews()
   
   --frames all viewports
   actionMan.executeAction 0 "311"
)

