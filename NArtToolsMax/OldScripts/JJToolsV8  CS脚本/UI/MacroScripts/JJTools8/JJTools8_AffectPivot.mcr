----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_AffectPivot.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.1
-- Started:      	26 October 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.10.26 -- First release
-- v1.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_AffectPivot
category:"JJTools 8"
toolTip:"Affect Pivot"
buttontext:"Affect Pivot"
icon:#("JJTools", 73)

(
	Try
	(
		jj_point = pickpoint prompt:"Click to select new pivot position."
		$.pivot = jj_point
	)
	catch()
)