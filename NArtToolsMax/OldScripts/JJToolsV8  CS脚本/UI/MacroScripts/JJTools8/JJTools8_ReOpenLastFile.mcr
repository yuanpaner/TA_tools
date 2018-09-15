----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_ReOpenLastFile.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.3
-- Started:      	05 November 2002
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2002.11.05 -- First release
-- v1.1  -- 2004.06.06 -- Made more generic by using 'getdir' instead of an absolute path
-- v1.2  -- 2004.10.29 -- Now supports Max 7 by searching for FileList before File1
-- v1.3  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_ReOpenLastFile
category:"JJTools 8"
toolTip:"Open Recent File 1"
buttontext:"Open File 1"
icon:#("JJTools", 42)

(
	-- loads the most recent file, .max or .mx
	jroot = (getdir #maxroot) + "3dsmax.ini"
	inifile = openfile jroot
	skiptostring inifile "FileList"
	skiptostring inifile "File1="
	lastfilename = readline inifile
	if loadMaxfile lastfilename then
	(
	)
	else
	(
		messagebox ("Problem opening File: " + lastfilename)
	)
)


macroScript JJTools8_ReOpenRecentFile2
category:"JJTools 8"
toolTip:"Open Recent File 2"
buttontext:"Open File 2"
icon:#("JJTools", 33)

(
	-- loads the most recent file, .max or .mx
	jroot = (getdir #maxroot) + "3dsmax.ini"
	inifile = openfile jroot
	skiptostring inifile "FileList"
	skiptostring inifile "File2="
	lastfilename = readline inifile
	if loadMaxfile lastfilename then
	(
	)
	else
	(
		messagebox ("Problem opening File: " + lastfilename)
	)
)


macroScript JJTools8_ReOpenRecentFile3
category:"JJTools 8"
toolTip:"Open Recent File 3"
buttontext:"Open File 3"
icon:#("JJTools", 33)

(
	-- loads the most recent file, .max or .mx
	jroot = (getdir #maxroot) + "3dsmax.ini"
	inifile = openfile jroot
	skiptostring inifile "FileList"
	skiptostring inifile "File3="
	lastfilename = readline inifile
	if loadMaxfile lastfilename then
	(
	)
	else
	(
		messagebox ("Problem opening File: " + lastfilename)
	)
)
