try(
Delete $SkinData_*
)catch()
exportPath=@"D:\\dance_FBX\\playerFBX\\"

filterNameArray=filterString maxfilepath "\\"

theName=filterNameArray[filterNameArray.count]
if filterNameArray.count>3 do(
	for i=3 to filterNameArray.count-1 do(
		if filterNameArray[i]=="special_characters" do(
			filterNameArray[i]=="_special_characters"
		)
		exportPath=exportPath+filterNameArray[i]+"\\"
	)
	print "wwwww"
)

exportFilePath=exportPath+theName+"\\Textures\\"

exportFileAllName=exportPath+theName+"\\F"+theName+".fbx"
makeDir exportFilePath

oldTexturePath=maxfilepath+"\\Textures\\"

DOSCommand("copy "+oldTexturePath+" "+exportFilePath)

exportFile exportFileAllName #noprompt
