----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_PlaybackSpeeds.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	10 May 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.05.10 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_StopAnimation
category:"JJTools 8"
toolTip:"Playback Stop"
buttontext:"Stop"
icon:#("JJTools", 73)

(
	stopAnimation()
)


macroScript JJTools8_PlaybackSpeed14
category:"JJTools 8"
toolTip:"Playback 1/4x Speed"
buttontext:"1/4x Speed"
icon:#("JJTools", 73)

(
	stopAnimation()
	timeconfiguration.playbackspeed = 1
	playAnimation()
)


macroScript JJTools8_PlaybackSpeed12
category:"JJTools 8"
toolTip:"Playback 1/2x Speed"
buttontext:"1/2x Speed"
icon:#("JJTools", 73)

(
	stopAnimation()
	timeconfiguration.playbackspeed = 2
	playAnimation()
)


macroScript JJTools8_PlaybackSpeed1
category:"JJTools 8"
toolTip:"Playback 1x Speed"
buttontext:"1x Speed"
icon:#("JJTools", 73)

(
	stopAnimation()
	timeconfiguration.playbackspeed = 3
	playAnimation()
)


macroScript JJTools8_PlaybackSpeed2
category:"JJTools 8"
toolTip:"Playback 2x Speed"
buttontext:"2x Speed"
icon:#("JJTools", 73)

(
	stopAnimation()
	timeconfiguration.playbackspeed = 4
	playAnimation()
)


macroScript JJTools8_PlaybackSpeed4
category:"JJTools 8"
toolTip:"Playback 4x Speed"
buttontext:"4x Speed"
icon:#("JJTools", 73)

(
	stopAnimation()
	timeconfiguration.playbackspeed = 5
	playAnimation()
)
