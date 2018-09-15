----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_HideUnhideBiped.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Requirements:	Character Studio
--					JJTools8_Functions
-- Version:			v1.1
-- Started:      	12 May 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.05.12 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_HideBiped
category:"JJTools 8"
toolTip:"Hide Biped"
buttontext:"Hide Bip"
icon:#("JJTools", 73)

(
	bip_bones = getAllBipBones()
	hide bip_bones
)

macroScript JJTools8_UnhideBiped
category:"JJTools 8"
toolTip:"Unhide Biped"
buttontext:"Unhide Bip"
icon:#("JJTools", 73)

(
	bip_bones = getAllBipBones()
	unhide bip_bones
)
