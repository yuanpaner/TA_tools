----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_FileNamer.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	7 December 2004
-- Last Modified: 	10 November 2005
-- Code by:			Carl Boulay
--				Jim Jagger
-- Modified by:		Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.12.07 -- First release from Carl
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroscript JJTools8_FileNamer
category:"JJTools 8"
tooltip:"File Namer"
buttontext:"File Namer"
icon:#("JJTools", 14)

(
	if $'JJTools_Filename' != undefined then
	(
		delete $'JJTools_Filename'
	)
	
	TheText = (maxFileName as string)
	AnimStart = (animationRange.start.frame as integer) as string
	AnimEnd = (animationRange.end.frame as integer) as string
	TheText += " = "+AnimStart+"-"+AnimEnd
	TheObject = text name:"JJTools_Filename" text:TheText size:25 wireColor:(color 88 199 225)
	rotate TheObject (eulerangles 90 0 0)
	TheObject.center = [0,0,-120]
	addModifier TheObject (Edit_Mesh())
	freeze TheObject
)