----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_BipCollector.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Requirements:	BSLib.ms
-- Version:			v1.1
-- Started:      	12 July 2005
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0 -- 2005.07.12 -- First release
-- v1.1 -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroscript JJTools8_BipCollector
category:"JJTools 8"
tooltip:"Bip Collector"
buttontext:"Bip Collector"
icon:#("JJTools", 9)

(
	include "$scripts\BlurScripts\BSLib.ms"
	
	global BipCollector_floater, new_path, files, newbipname, BipCollector_cont
	global BipCollector_floater_pos = [407,97]

	recurse = true
	
	fn process_bipeds =
	(
		for i = 1 to files.count do
		(
			BipCollector_cont.process_gauge.value = ((i as float)/(files.count as float))*100
			loadmaxfile files[i] quiet: true
			newbipname = ""
			for j = 1 to (files[i].count-4) do
			(
				newbipname += files[i][j]	
			)
			newbipname += ("_" +(animationrange.start as string) + "_" +(animationrange.end as string) + ".bip")
			format "%\n" newbipname
			try
			(
				biped.saveBipFileSegment $B.transform.controller newbipname 0 5000 #saveSubAnimControllers
			)
			catch
			(
				format "WARNING! % WARNING!\n" maxfilename
			)
		)
		BipCollector_cont.process_gauge.value = 0	
	)
	
	rollout BipCollector_cont "Bip Collector"
	(
		group "test"
		(
			button get_bip_path "BipPath" align:#left across:3
			checkbox check_recursion "Include Subfolders" checked:true
			label lab_num_files
			edittext lab_bip_path
		)

		group "Process"
		(
			button execute_process "Process" height:25
			label prog_label
			progressbar process_gauge 
		)

		on get_bip_path pressed do
		(
			new_path = getSavePath()
			if getSavePath != undefined then lab_bip_path.text = new_path
			files = get_all_files_in_dir new_path recurse "max"
			lab_num_files.text = ("Total MAXs: ") + (files.count as string)
		)
		
		on check_recursion changed state do
		(
			recurse = state
		)

		on execute_process pressed do process_bipeds()
	)
	
	try
	(
		closerolloutfloater BipCollector_floater
		BipCollector_floater_pos = BipCollector_floater.pos
	)
	catch()
	
	BipCollector_floater = newrolloutfloater "Bip Collector" 350 203
	BipCollector_floater.pos = BipCollector_floater_pos
	addrollout BipCollector_cont BipCollector_floater rolledup:false

)