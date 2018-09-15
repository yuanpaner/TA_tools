fn ReMaterialName Obj newName=
(
	Obj.Material.name="M"+newName
)

fn ReBitmapName Obj newName=
(
	Obj.Material.diffusemap.name="B"+newName
)

fn ReTextureName Obj oldFileName newName=
(
	
	if (getFilenameType oldFileName)==".dds" then
	(
		oldTextureNamePath=getFilenamePath oldFileName
		newTextureName=oldTextureNamePath+"T"+newName+".dds"
		renameFile oldFileName newTextureName
		Obj.material.diffusemap.filename=newTextureName
	)
)

rollout autoRename "AutoReName beta01" width:200 height:60
(
	edittext name_Text "new name" pos:[12,5] width:180 height:18
	button goReName "ReName" pos:[119,33] width:70 height:22
	checkbox useOld_chb "use old name" pos:[10,35] width:100 height:18
	
	
	on goReName pressed do
	(
		try
		(
			
			undo on
			(
				tp_Geo=for i in selection where classof i==Editable_Poly collect i
				for i in tp_Geo do
				(	
					if useOld_chb.checked then
					(
						oldname=i.name
						i.name="G"+oldname
						if i.Material!=undefined do
						(
							oldMaterialName=i.Material.name
							ReMaterialName i oldMaterialName				
							oldTexturefileName=i.material.diffusemap.filename
							newName=getFilenameFile oldTexturefileName
							ReBitmapName i newName
							ReTextureName i i.material.diffusemap.filename newName							
						)
					)
					else
					(
						newText=name_Text.text
						if newText.count!=0 do
						(						
							i.name="G"+newText
							
							if i.Material!=undefined do
							(
								ReMaterialName i newText
								ReBitmapName i newText
								ReTextureName i i.material.diffusemap.filename newText
						
							)
						)
					)
				)		
			)
		)
		catch(messagebox "请按规范步骤附材质与贴图")
	)
	on useOld_chb changed state do
	(
		if useOld_chb.checked then
		(
			name_Text.enabled=false
		)
		else
		(
			name_Text.enabled=true
		)
	
	)
)
createdialog autoRename