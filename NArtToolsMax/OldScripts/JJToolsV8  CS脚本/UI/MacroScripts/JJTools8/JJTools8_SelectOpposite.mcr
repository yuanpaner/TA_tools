----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_SelectOpposite.mcr
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

macroScript JJTools8_SelectOpposite
category:"JJTools 8"
toolTip:"Select Opposing Biped Bone"
buttontext:"Sel Opp"
icon:#("JJTools", 73)

(
	on isEnabled return (selection.count > 0)
	on Execute do
	(
		filein (getdir #maxroot+"scripts\\JJTools8\\JJTools8_SelectOpposite.ms")	
	)
)
