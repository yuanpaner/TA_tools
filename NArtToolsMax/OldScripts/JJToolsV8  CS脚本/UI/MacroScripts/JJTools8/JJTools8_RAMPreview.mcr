----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_RAMPreview.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v2.2
-- Started:      	13 June 2001
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v2.0  -- 2001.06.13 -- Second release
-- v2.1  -- 2004.10.29 -- Fixed bug if no previews have ever been made
-- v2.2  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_RamPreview
category:"JJTools 8"
toolTip:"RAM Play Last Two Previews"
buttontext:"RAM Preview"
icon:#("JJTools", 40)

(
	deletefile ((getDir #preview)+ "\\_scene2.avi")
	copyfile  ((getDir #preview)+ "\\_scene.avi") ((getDir #preview)+ "\\_scene2.avi")
	max preview
	if (doesfileexist ((getDir #preview)+ "\\_scene2.avi")) == false then
	(
		RAMplayer ((getDir #preview)+ "\\_scene.avi") ""
	)
	else
	(
		RAMplayer ((getDir #preview)+ "\\_scene.avi") ((getDir #preview)+ "\\_scene2.avi")	
	)
)
