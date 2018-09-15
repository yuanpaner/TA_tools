----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_Reloadfile.ms
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.3
-- Started:      	05 November 2002
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2002.11.05 -- First release
-- v1.1  -- 2004.05.18 -- Made more generic by using 'getdir' instead of an absolute path
-- v1.2  -- 2004.10.29 -- Added support for Max 7
-- v1.3  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

(

	if querybox "Would you like to load the most recent file?" title:"Auto Load File" beep:false then
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
)
