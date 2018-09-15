macroScript JDL_convertBipedToBones
	category:"JDLtools"
	buttonText:"Convert Biped to Bones"
	toolTip:"Convert Biped to Bones"
(
	on execute do
	(
		scriptFile = (getDir #scripts + "\\JDLtools\\JDL_convertBipedToBones.ms")
		if (doesFileExist scriptFile) != false then fileIn scriptFile
		else messageBox "Cannot find script file! File doesn't exist, or was placed in the wrong folder."
	)
)