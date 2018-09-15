try(
	Delete $SkinData_*
)catch()
try(
	Delete $HH_*
)catch()
try(
	Delete $000
)catch()


try(
	tp_ParticleView=#()
	for i in objects do
	(
		if classof i==Particle_View do append tp_ParticleView i
	)
	delete tp_ParticleView
)catch()

exportPath=@"D:\\webdance\\art_resource\\Character\\playerFBX\\"
sName=(filterString maxfilename ".")[1]
fileNameArray=filterString sName "_"
endName=fileNameArray[fileNameArray.count]

if fileNameArray[2]=="item" or fileNameArray[2]=="skinitem" do(
	exportPath=@"D:\\webdance\\art_resource\\Character\\itemFBX\\"
)

skinObjArray=for i in objects where classof i==PolyMeshObject and (classof i.modifiers[1])==skin collect i

if skinObjArray.count==1 do(
	newObj=getNodeByName "debugMesh"
	if newObj==undefined do(
		debugMeshObj=copy skinObjArray[1]
		debugMeshObj.name="debugMesh"
	)
)

if endName!="geo" and endName!="skin" then(
	filterNameArray=filterString maxfilepath "\\"
	theName=filterNameArray[filterNameArray.count]

	if filterNameArray.count>3 do(
		for i=3 to filterNameArray.count-1 do(
			if filterNameArray[i]=="special_characters" do(
				filterNameArray[i]=="_special_characters"
			)
			exportPath=exportPath+filterNameArray[i]+"\\"
		)
	)

	exportFilePath=exportPath+theName
	exportFileAllName=exportPath+theName+"\\F"+theName+".fbx"
	makeDir exportFilePath

	-- copy textures

	-- oldTexturePath=maxfilepath+"\\Textures\\"

	-- DOSCommand("copy "+oldTexturePath+" "+exportFilePath)

	exportFile exportFileAllName #noprompt
	
	try(
		if debugMeshObj!=undefined then(
			delete debugMeshObj
		)else(
			print "can't find debugMesh"
		)
	)catch()
)else(
	print maxfilename+" didn't export"
)