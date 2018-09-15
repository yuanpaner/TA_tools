----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_PlaybackTools.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	5 January 2005
-- Last Modified: 	10 November 2005
-- Code by:			Cameron Fielding
--				Jim Jagger
--					Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0 -- 2005.01.05 -- First release
-- v1.1 -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroscript JJTools8_PlaybackTools
category:"JJTools 8"
tooltip:"Playback Tools"
buttontext:"Playback Tools"
icon:#("JJTools", 18)

(
	global PlaybackTools_floater
	global PlaybackTools_pos = [407,77]
	global PlaybackTools_Begin		   = openbitmap (getdir #maxroot+"UI\Icons\PlaybackTools_Begin.bmp")
	global PlaybackTools_PreviousKey   = openbitmap (getdir #maxroot+"UI\Icons\PlaybackTools_PreviousKey.bmp")
	global PlaybackTools_PreviousFrame = openbitmap (getdir #maxroot+"UI\Icons\PlaybackTools_PreviousFrame.bmp")
	global PlaybackTools_Play		   = openbitmap (getdir #maxroot+"UI\Icons\PlaybackTools_Play.bmp")
	global PlaybackTools_NextFrame     = openbitmap (getdir #maxroot+"UI\Icons\PlaybackTools_NextFrame.bmp")
	global PlaybackTools_NextKey	   = openbitmap (getdir #maxroot+"UI\Icons\PlaybackTools_NextKey.bmp")
	global PlaybackTools_End		   = openbitmap (getdir #maxroot+"UI\Icons\PlaybackTools_End.bmp")

	rollout PlaybackTools_cont "Playback Tools v1.0" width:176 height:100
	(
		
		local a = ( animationRange.end as integer ) / ticksPerFrame
		local b = ( animationRange.start as integer ) / ticksPerFrame
		button pt_Begin pos:[8,8] 													width:16 height:16 images:#(getdir #maxroot+"UI\Icons\PlaybackTools_Begin.bmp", undefined, 1, 1, 1, 1, 1) tooltip:"Start Frame"
		button pt_PreviousKey   pos:[(pt_Begin.pos.x)+17,pt_Begin.pos.y] 			width:16 height:16 images:#(getdir #maxroot+"UI\Icons\PlaybackTools_PreviousKey.bmp", undefined, 1, 1, 1, 1, 1) tooltip:"Previous Key Frame"
		button pt_PreviousFrame pos:[(pt_PreviousKey.pos.x)+17,pt_Begin.pos.y] 		width:16 height:16 images:#(getdir #maxroot+"UI\Icons\PlaybackTools_PreviousFrame.bmp", undefined, 1, 1, 1, 1, 1) tooltip:"Previous Frame"
		checkbutton pt_Play		pos:[(pt_PreviousFrame.pos.x)+17,pt_Begin.pos.y] 	width:50 height:16 images:#(getdir #maxroot+"UI\Icons\PlaybackTools_Play.bmp", undefined, 1, 1, 1, 1, 1) tooltip:"Play"
		button pt_NextFrame		pos:[(pt_Play.pos.x)+51,pt_Begin.pos.y] 			width:16 height:16 images:#(getdir #maxroot+"UI\Icons\PlaybackTools_NextFrame.bmp", undefined, 1, 1, 1, 1, 1) tooltip:"Next Frame"
		button pt_NextKey		pos:[(pt_NextFrame.pos.x)+17,pt_Begin.pos.y] 		width:16 height:16 images:#(getdir #maxroot+"UI\Icons\PlaybackTools_NextKey.bmp", undefined, 1, 1, 1, 1, 1) tooltip:"Next Key Frame"
		button pt_End			pos:[(pt_NextKey.pos.x)+17,pt_Begin.pos.y] 			width:16 height:16 images:#(getdir #maxroot+"UI\Icons\PlaybackTools_End.bmp", undefined, 1, 1, 1, 1, 1) tooltip:"End Frame"
		
		spinner tbrstart "Start" pos:[18,30] width:60 height:16 range:[-100000,100000,b] type:#integer		
		spinner tbrend "End" pos:[100,30] width:60 height:16 range:[-100000,100000,a] type:#integer
					
		on pt_NextFrame pressed do
		(	
			sliderTime += 1
		)
							
		on pt_NextKey pressed do
		(	
			try 
			(
				sliderTime = ( trackbar.getnextKeyTime() as integer ) / ticksperframe
			)
			catch ()
		)
		
		on pt_PreviousFrame pressed do
		(	
			sliderTime -= 1
		)
		
		on pt_PreviousKey pressed do
		(	
			try			
			(
				sliderTime = ( trackbar.getpreviousKeyTime() as integer ) / ticksPerFrame
			)
			catch ()
		)
				
		on pt_End pressed do
		(
			sliderTime = (animationRange.end as integer ) / ticksPerFrame
		)
		
		on pt_Begin pressed do
		(
			sliderTime = (animationRange.start as integer ) / ticksPerFrame
		)
		
		on tbrend changed val do
		(
			strt = tbrstart.value
			
		    if val > strt then
			(
				animationRange = interval tbrstart.value val
			)
			else
			(
				tbrstart.value = val
			)
		)
		
		on tbrstart changed val do
		(
			nd = tbrend.value
			
	    	if val < nd then
		 	(
				animationRange = interval val tbrend.value
		 	)
			else
			(
				tbrend.value = val
			)
		)
		
		on pt_Play changed state do
		( 
			if state == true then 
			(
				playanimation()				
			)
			else
			( 
				stopanimation() 
			)
		)
	)
	
	rollout PlaybackTools_about "About"
	(
		activeXControl ax1 "http://jimjagger.com/JPages/JJTools/JJTools8_PlaybackTools.htm" height:75 width:130 align:#center 
	)
	
	try
	(
		closerolloutfloater PlaybackTools_floater
		PlaybackTools_pos = PlaybackTools_floater.pos
	)catch()
	
	PlaybackTools_floater = newrolloutfloater "Playback Tools v1.0" 183 105
	PlaybackTools_floater.pos = PlaybackTools_pos
	addrollout PlaybackTools_cont PlaybackTools_floater rolledup:false
	addrollout PlaybackTools_about PlaybackTools_floater rolledup:true
)

