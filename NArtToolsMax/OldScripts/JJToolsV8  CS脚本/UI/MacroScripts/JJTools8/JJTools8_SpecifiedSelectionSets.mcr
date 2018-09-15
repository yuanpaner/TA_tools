----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_SpecifiedSelectionSets.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.2
-- Started:      	20 January 2003
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2003.01.20 -- First release
-- v1.1  -- 2004.06.25 -- Fixed for Max 6
-- v1.2  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_SpecifiedSelectionSets
category:"JJTools 8"
toolTip:"Organise Specified Selection Sets"
buttontext:"Selection Sets"
icon:#("JJTools", 35)

(
	global myname = #()

	fn existfile fname =
	(
		(getfiles fname).count != 0
	)

    inifile = (getdir #maxroot+"plugcfg\\JJTools8_SpecifiedSelectionSets.ini")
	if existfile (inifile) != true then
    (
		messagebox "\\plugcfg\\JJTools8_SpecifiedSelectionSets.ini does not exist!\n"
	)
		
    inistring = openfile inifile
    seek inistring 0
    myarray = (readline inistring)
    execute myarray

	if myname == UNDEFINED then
	(
		global myname = #("Bone", "Control")
	)
	CreateUI2=("if myname == UNDEFINED then\n(\n  global myname = #(\"Bone\", \"Control\", \"Dummy\", \"Other\")\n)\nelse()\n\n")
	CreateUI2=CreateUI2+("global selectionsets_floater\nglobal selectionsets_pos = [223, 77]\n\n")
	CreateUI2=CreateUI2+("rollsize = (105+(myname.count*20))\n\n")
	
	CreateUI2=CreateUI2+("fn reset_selection_sets =\n(\n  try\n  (\n")
	CreateUI2=CreateUI2+("    for i = 1 to getnumnamedselsets() do\n    (\n      deleteitem selectionsets 1\n    )\n  )catch()\n)\n\n")
	
	CreateUI2=CreateUI2+("fn init_object_selection_sets =\n(\n")
	CreateUI2=CreateUI2+("  for i = 1 to myname.count do\n  (\n    selectionsets[myname[i]] = execute (\"$'\" + (myname[i]) + \"'*\")\n  )\n)\n")
			
	-- Create UI	
	CreateUI=("rollout ss_roll \"Specified Selection Set v1.1\"\n(\n")
	CreateUI=CreateUI+("  button all " + "\"" + "All " + "\"" +"width:40 align:#center across:3\n")
	CreateUI=CreateUI+("  button None " + "\"" + "None " + "\"" +"width:40\n")
	CreateUI=CreateUI+("  button Invert " + "\"" + "Invert " + "\"" +"width:40\n")
	for i = 1 to myname.count do
	(
		CreateUI=CreateUI+("  checkbox check" + (i as string)  + "\"" + myname[i] + "\"\n")
	)
	
	CreateUI=CreateUI+("\n  on all pressed do\n  (  \n")	
	for i = 1 to myname.count do
	(
		CreateUI=CreateUI+("    " + "check" + (i as string) +".checked = true\n    hide selectionsets[" + "\"" + myname[i] + "\"" + "]\n")
	)
	CreateUI=CreateUI+("  )\n")
	
	CreateUI=CreateUI+("\n  on none pressed do\n  (\n")	
	for i = 1 to myname.count do
	(		CreateUI=CreateUI+("    " + "check" + (i as string) +".checked = false\n    unhide selectionsets[" + "\"" + myname[i] + "\"" + "]\n")
	)
	CreateUI=CreateUI+("  )\n")
	
	CreateUI=CreateUI+("\n  on invert pressed do\n  (\n")
	for i = 1 to myname.count do
	(
		CreateUI=CreateUI+("    if " + "check" + (i as string) +".checked == true then\n    (\n      ")
		CreateUI=CreateUI+("check" + (i as string) +".checked = false\n      unhide selectionsets[" + "\"" + myname[i] + "\"" + "]\n    )\n    else\n    (\n      ")
		CreateUI=CreateUI+("check" + (i as string) +".checked  = true\n      hide selectionsets[" + "\"" + myname[i] + "\"" + "]\n    )\n\n")
	)
	CreateUI=CreateUI+("  )\n")
	
	for i = 1 to myname.count do
	(		
		CreateUI=CreateUI+("\n  on " + "check" + (i as string) + " changed state do\n  (\n    if state == on then\n")
		CreateUI=CreateUI+("    (\n      hide selectionsets[" + "\"" + myname[i] + "\"" + "]\n    )\n    else\n")
		CreateUI=CreateUI+("    (\n      unhide selectionsets[" + "\"" + myname[i] + "\"" + "]\n    )\n  )\n")
	)
	CreateUI=CreateUI+(")\n\n")
	
	
	CreateUI=CreateUI+("rollout Initialise_box \"Setup\"\n(\n")
	CreateUI=CreateUI+("  button init \"Edit\" width:80 align:#center\n")
		
	CreateUI=CreateUI+("\n  on init pressed do\n  (\n")
	CreateUI=CreateUI+("    shellLaunch (getdir #maxroot+\"\\plugcfg\\JJTools8_SpecifiedSelectionSets.ini\") \"\"\n  )\n")
	
	CreateUI=CreateUI+("\n  on removesel pressed do\n  (\n")
	CreateUI=CreateUI+("    if querybox \"This will remove all Selection Sets from the current file.\n    Are you sure you wish to continue?\" beep:false then\n    (\n")	
	CreateUI=CreateUI+("      reset_selection_sets()\n    )\n  )\n")
	CreateUI=CreateUI+(")\n")
	
	CreateUI=CreateUI+("rollout ax2_about \"About\"\n(\n")	
	CreateUI=CreateUI+("activeXControl ax2 \"http://jimjagger.com/JPages/JJTools/JJTools8_SpecifiedSelectionSets.htm\" height:75 width:130 align:#center\n)\n")	
	CreateUI=CreateUI+("\n\n")	
		
	-- end of rollout
	
	CreateUI=CreateUI+("\ntry\n(\n")
	CreateUI=CreateUI+("  closerolloutfloater selectionsets_floater\n")
	CreateUI=CreateUI+("  selectionsets_pos = selectionsets_floater.pos\n")
	CreateUI=CreateUI+(")catch()\n\n")
	
	CreateUI=CreateUI+("selectionsets_floater = newrolloutfloater \"Selection Sets V1\" 170 (rollsize)\n")
	CreateUI=CreateUI+("selectionsets_floater.pos = selectionsets_pos\n")
	CreateUI=CreateUI+("addrollout ss_roll selectionsets_floater\n")
	CreateUI=CreateUI+("addrollout initialise_box selectionsets_floater rolledup:true\n")
	CreateUI=CreateUI+("addrollout ax2_about selectionsets_floater rolledup:true\n")			CreateUI=CreateUI+("\ninit_object_selection_sets()\n")
	
--	try
--	(
		print createUI2
		execute CreateUI2	
		Print CreateUI
		execute CreateUI
--	)
--	catch(messagebox "Tough shit dog!\n\nThere was a problem with the script.\nJim is your only hope now.\n\nGood Luck (You're gonna need it!)")
)	
