try(
Delete $SkinData_*
)catch()
exportPath=@"D:\\webdance\\client_art\\Assets\\Animations\\morpherModel"

filterNameArray=filterString maxfilename "."

theName=substring filterNameArray[1] 2 -1
-- if filterNameArray.count>3 do(
-- 	for i=3 to filterNameArray.count-1 do(
-- 		if filterNameArray[i]=="special_characters" do(
-- 			filterNameArray[i]=="_special_characters"
-- 		)
-- 		exportPath=exportPath+filterNameArray[i]+"\\"
-- 	)
-- )

-- exportFilePath=exportPath+theName+"\\Textures\\"

exportFileAllName=exportPath+"\\F"+theName+".fbx"
-- makeDir exportFilePath

-- oldTexturePath=maxfilepath+"\\Textures\\"

-- DOSCommand("copy "+oldTexturePath+" "+exportFilePath)

exportFile exportFileAllName #noprompt
