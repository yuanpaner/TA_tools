----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_CentrePivot.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v2.2
-- Started:      	18 May 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v2.1  -- 2004.06.02 -- Re-release
-- v2.2  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroscript JJTools8_CentrePivot
category:"JJTools 8"
tooltip:"Centre pivot of selected objects"
buttontext:"Centre Pivot"
icon:#("JJTools", 18)

(
	on isEnabled return (selection.count >= 1)
	on Execute do
	(
		try
		(
			--loop through selected objects and set pivot point to object's centre
			for i in selection do (i.pivot = i.min)
		)
		catch
		(
			messageBox "The object's pivot point could not be centered!" title:"JJTools Error" beep:true
		)
	)
)


