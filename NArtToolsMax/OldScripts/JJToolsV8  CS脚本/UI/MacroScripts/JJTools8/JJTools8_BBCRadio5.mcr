----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_BBCRadio5.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	4 June 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- 1.0  -- 2004.06.04 -- First release
-- 1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroscript JJTools8_BBCRadio5
category:"JJTools 8"
tooltip:"BBC Radio 5"
buttontext:"Radio 5"
icon:#("JJTools", 38)

(
	global ActiveX_floater
	global ActiveX_floater_pos = [407,77]
	
	rollout AX1_cont "Football Commentary"
	(
		activeXControl ax1 "http://www.bbc.co.uk/radio/aod/fivelive.shtml?listen" height:359 width:662 align:#center
	)
	
	rollout AX2_about "About"
	(
		activeXControl ax2 "http://jimjagger.com/JPages/JJTools/JJTools8_BBCRadio5.htm" height:75 width:130 align:#center 
	)
			
	try
	(
		closerolloutfloater ActiveX_floater
		ax_pos = ax_floater.pos
	)
	catch()
	
	ActiveX_floater = newrolloutfloater "BBC Radio 5" 700 425
	ActiveX_floater.pos = ActiveX_floater_pos
	addrollout AX1_cont ActiveX_floater rolledup:false
	addrollout AX2_about ActiveX_floater rolledup:true
)

