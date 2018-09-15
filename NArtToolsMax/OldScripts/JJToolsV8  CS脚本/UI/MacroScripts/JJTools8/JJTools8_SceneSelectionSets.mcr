----------------------------------------------------------------------------------------
-- Script Name:		JJTools7_SceneSelectionSets.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.2
-- Started:      	20 January 2003
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2003.01.20 -- First release
-- v1.1  -- 2004.10.29 -- Tweaked
-- v1.2  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_SceneSelectionSets
category:"JJTools 8"
toolTip:"Organise Scene Selection Sets"
buttontext:"Selection Sets"
icon:#("JJTools", 34)

(
	CreateUI2=("if myname == UNDEFINED then\n(\n  global myname = #(\"Bone\", \"Control\", \"Dummy\", \"Other\")\n)\nelse()\n\n")
	CreateUI2=CreateUI2+("global sceneselectionsets_floater\nglobal sceneselectionsets_pos = [223, 77]\n\n")
	CreateUI2=CreateUI2+("rollsize = (85+(selectionsets.count*20))\n\n")
	
	CreateUI2=CreateUI2+("fn reset_selection_sets =\n(\n  try\n  (\n")
	CreateUI2=CreateUI2+("    for i = 1 to getnumnamedselsets() do\n    (\n      deleteitem selectionsets 1\n    )\n  )catch()\n)\n\n")
		
--	execute CreateUI2

	CreateUI3=("rollout ss_roll2 \"Selection Set By Scene\"\n(\n")
	CreateUI3=CreateUI3+("  button all " + "\"" + "All " + "\"" +"width:40 align:#center across:3\n")
	CreateUI3=CreateUI3+("  button None " + "\"" + "None " + "\"" +"width:40\n")
	CreateUI3=CreateUI3+("  button Invert " + "\"" + "Invert " + "\"" +"width:40\n")
	for i = 1 to selectionsets.count do
	(
		CreateUI3=CreateUI3+("  checkbox check" + (i as string)  + " \"" + getnamedselsetname(i) + "\"\n")
	)
	
	CreateUI3=CreateUI3+("\n  on all pressed do\n  (  \n")	
	for i = 1 to selectionsets.count do
	(
		CreateUI3=CreateUI3+("    " + "check" + (i as string) +".checked = true\n    hide selectionsets[" + "\"" + getnamedselsetname(i) + "\"" + "]\n")
	)
	CreateUI3=CreateUI3+("  )\n")
	
	CreateUI3=CreateUI3+("\n  on none pressed do\n  (\n")	
	for i = 1 to selectionsets.count do
	(
 		CreateUI3=CreateUI3+("    " + "check" + (i as string) +".checked = false\n    unhide selectionsets[" + "\"" + getnamedselsetname(i) + "\"" + "]\n")
	)
	CreateUI3=CreateUI3+("  )\n")
	
	CreateUI3=CreateUI3+("\n  on invert pressed do\n  (\n")
	for i = 1 to selectionsets.count do
	(
		CreateUI3=CreateUI3+("    if " + "check" + (i as string) +".checked == true then\n    (\n      ")
		CreateUI3=CreateUI3+("check" + (i as string) +".checked = false\n      unhide selectionsets[" + "\"" + getnamedselsetname(i) + "\"" + "]\n    )\n    else\n    (\n      ")
		CreateUI3=CreateUI3+("check" + (i as string) +".checked = true\n      hide selectionsets[" + "\"" + getnamedselsetname(i) + "\"" + "]\n    )\n\n")
	)
	CreateUI3=CreateUI3+("  )\n")
	
	for i = 1 to selectionsets.count do
	(		
		CreateUI3=CreateUI3+("\n  on " + "check" + (i as string) + " changed state do\n  (\n    if state == on then\n")
		CreateUI3=CreateUI3+("    (\n      hide selectionsets[" + "\"" + getnamedselsetname(i) + "\"" + "]\n    )\n    else\n")
		CreateUI3=CreateUI3+("    (\n      unhide selectionsets[" + "\"" + getnamedselsetname(i) + "\"" + "]\n    )\n  )\n")
	)

	CreateUI3=CreateUI3+(")\n\n")	
	
	CreateUI3=CreateUI3+("rollout ax2_about \"About\"\n(\n")	
	CreateUI3=CreateUI3+("activeXControl ax2 \"http://jimjagger.com/JPages/JJTools/JJTools8_SceneSelectionSets.htm\" height:75 width:130 align:#center\n)\n")	
	CreateUI3=CreateUI3+("\n\n")	
	
	-- end of rollout
	
	
	CreateUI=("\ntry\n(\n")
	CreateUI=CreateUI+("  closerolloutfloater sceneselectionsets_floater\n")
	CreateUI=CreateUI+("  sceneselectionsets_pos = sceneselectionsets_floater.pos\n")
	CreateUI=CreateUI+(")catch()\n\n")
	
	CreateUI=CreateUI+("sceneselectionsets_floater = newrolloutfloater \"Selection Sets V1\" 170 (rollsize)\n")
	CreateUI=CreateUI+("sceneselectionsets_floater.pos = sceneselectionsets_pos\n")
	CreateUI=CreateUI+("addrollout ss_roll2 sceneselectionsets_floater\n")
	CreateUI=CreateUI+("addrollout ax2_about sceneselectionsets_floater rolledup:true\n")
		
--	CreateUI=CreateUI+("\ninit_object_selection_sets()\n")
	
--	try
--	(
		print createui2
		execute CreateUI2	
--	)
--	catch(messagebox "Tough shit dog!\n\nThere was a problem with the script.\nJim is your only hope now.\n\nGood Luck (You're gonna need it!)")
	
	try
	(
		Print CreateUI3
		execute CreateUI3
		print createui
		execute createui
	)--catch()
--	catch(messagebox "ui")
	catch(messagebox "There was a problem with some of your selection sets.\n\nEither:-\na) There are no selection sets in the current scene.\nb) The selection sets have spaces in their names.\n\nIf the problem persists, please see Jim")
)	
