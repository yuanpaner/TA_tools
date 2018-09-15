macroscript hidetrackbar
	category:"Web热舞工具"
	buttontext:"Tool_隐藏/显示时间轴"
	tooltip:"Tool_隐藏/显示时间轴"
(
	on isChecked return ((timeSlider.isVisible()) and (trackbar.visible))
	
	on execute do(
		foo=not timeSlider.isVisible()
		timeSlider.setVisible foo
		trackbar.visible=foo
	)
)

macroscript apngkin_Auto
	category:"Web热舞工具"
	buttontext:"Skin_添加Skin修改器"
	tooltip:"Skin_添加Skin修改器"
(	
	on isEnabled return (
		bipArray=#(	"bip",
					"bip_Footsteps",
					"bip_Pelvis",
					"bip_Spine",
					"bip_Spine1",
					"bip_Spine2",
					"bip_Neck",
					"bip_Head",
					"bip_HeadNub",
					"bip_L_Clavicle",
					"bip_L_UpperArm",
					"bip_L_Forearm",
					"bip_L_Hand",
					"bip_L_Finger0",
					"bip_L_Finger01",
					"bip_L_Finger0Nub",
					"bip_L_Finger1",
					"bip_L_Finger11",
					"bip_L_Finger1Nub",
					"bip_L_Finger2",
					"bip_L_Finger21",
					"bip L Finger2Nub",
					"bip_R_Clavicle",
					"bip_R_UpperArm",
					"bip_R_Forearm",
					"bip_R_Hand",
					"bip_R_Finger0",
					"bip_R_Finger01",
					"bip_R_Finger0Nub",
					"bip_R_Finger1",
					"bip_R_Finger11",
					"bip_R_Finger1Nub",
					"bip_R_Finger2",
					"bip_R_Finger21",
					"bip R Finger2Nub",
					"bip_L_Thigh",
					"bip_L_Calf",
					"bip_L_Foot",
					"bip_L_Toe0",
					"bip_L_Toe0Nub",
					"bip_R_Thigh",
					"bip_R_Calf",
					"bip_R_Foot",
					"bip_R_Toe0",
					"bip_R_Toe0Nub"
		)
		for i in bipArray do
		(
			if getNodeByName i==undefined do return false
		)			
		
		if selection.count>0 do return true
			
	)
	on execute do
	(
		selArray=for i in selection collect i
		objArray=for i in selection where classof i==Editable_Poly collect i
		for i in objArray do
		(
			filterArray=filterString i.name "_"
			if filterArray.count==3 then
			(
				type=filterArray[2]
			)
			else
			(
				continue
			)
			local boneArray=#()
			boneArray=case type of
			(
				"head":#(	$bip_Head,
							$bip_Neck,
							$bip_Spine2,
							$Bone_hair_back1,
							$Bone_hair_back2,
							$Bone_hair_right1,
							$Bone_hair_right2,
							$Bone_hair_left1,
							$Bone_hair_left2,
							$Bone_hair_bottom1,
							$Bone_hair_bottom2
						)
				"face":#($bip_Head)
				"upbody":#(		$bip_Head,
								$bip_Neck,
								$bip_Spine2,
								$bip_Spine1,
								$bip_Spine,
								$bip_Pelvis,
								$bip_L_Clavicle,
								$bip_L_UpperArm,
								$bip_L_Forearm,
								$bip_L_Hand,
								$bip_L_Finger0,
								$bip_L_Finger01,
								$bip_L_Finger1,
								$bip_L_Finger11,
								$bip_L_Finger2,
								$bip_L_Finger21,
								$bip_R_Clavicle,
								$bip_R_UpperArm,
								$bip_R_Forearm,
								$bip_R_Hand,
								$bip_R_Finger0,
								$bip_R_Finger01,
								$bip_R_Finger1,
								$bip_R_Finger11,
								$bip_R_Finger2,
								$bip_R_Finger21,
								$bip_L_Thigh,
								$bip_R_Thigh
							)
				"downbody":#(	$bip_Spine1,
								$bip_Spine,
								$bip_Pelvis,
								$bip_L_Thigh,
								$bip_L_Calf,
								$bip_L_Foot,
								$bip_R_Thigh,
								$bip_R_Calf,
								$bip_R_Foot
							)
				"foot":#(	$bip_L_Calf,
							$bip_L_Foot,
							$bip_L_Toe0,
							$bip_R_Calf,
							$bip_R_Foot,
							$bip_R_Toe0
						)
				default:undefined
			)
			
			if boneArray==undefined do continue
			skinModi=undefined
			print boneArray
			skinModi=skin()
			addModifier i skinModi
			max modify mode
			select i
			for a in boneArray do
			(
				skinOps.addbone skinModi a 0
			)
			
		)
		select selArray
	)
)

macroscript delSkin
	category:"Web热舞工具"
	buttontext:"Skin_删除Skin修改器"
	tooltip:"Skin_删除Skin修改器"
(
	on isEnabled return (
		foo=false
		
		for i in selection do
		(
			for modi in i.modifiers do
			(
				if classof modi==skin do 
				(
					foo=true
					break
				)
			)
		)
		
		return selection.count>0 and foo	
	)
	on execute do
	(
		selArray=for i in selection collect i
		objArray=for i in selection where superclassof i==GeometryClass collect i

		for i in objArray do
		(
			for modi in i.modifiers do
			(
				if classof modi==skin do 
				(
					max modify mode
					select i

					deletemodifier i modi
				)
			)
		)
		select selArray
	)
)	

macroscript delSkinZero
	category:"Web热舞工具"
	buttontext:"Skin_删除0权重骨骼"
	tooltip:"Skin_删除0权重骨骼"
(
	on isEnabled return (
		foo=false
		
		for i in selection do
		(
			for modi in i.modifiers do
			(
				if classof modi==skin do 
				(
					foo=true
					break
				)
			)
		)
		
		return selection.count>0 and foo	
	)

	on execute do
	(
		selArray=for i in selection collect i
		objArray=for i in selection where superclassof i==GeometryClass collect i

		for i in objArray do
		(
			for modi in i.modifiers do
			(
				if classof modi==skin do 
				(
					max modify mode
					select i
					skinOps.RemoveZeroWeights modi
				)
			)
		)
		select selArray
	)
)

macroscript clothRename_Auto
	category:"Web热舞工具"
	buttontext:"Char_角色命名工具"
	tooltip:"Char_角色命名工具"
(
	global charRename_rol

	global subType1=undefined
	global subType2=undefined
		
	try(DestroyDialog charRename_rol)catch()

	fn suitNumber_fn oldNumber =
	(
		stringNumber=oldNumber as string
		stringCount=4-stringNumber.count
		for i=1 to stringCount do
		(
			stringNumber="0"+stringNumber
		)
		return stringNumber
	)

	fn objectType_fn typeSelection =
	(
		local newString
		case typeSelection of
		(
			1:
			(
				newString="head"
				subType1="hat"
				subType2="hair"
			)
			2:
			(
				newString="upbody"
				subType1="body"
				subType2="cloth"
			)
			3:
			(
				newString="downbody"
				subType1="body"
				subType2="pants"
			)
			4:
			(
				newString="foot"
				subType1="body"
				subType2="shoes"
			)
			default:
			(
				newString="head"
				subType1="hat"
				subType2="hair"
			)
		)
		return newString
	)

	fn sexType_fn typeSelection =
	(
		newString=case typeSelection of
		(
			1:"boy"
			2:"girl"
			default:"boy"
		)
		return newString
	)


	rollout charRename_rol "Webdance角色命名工具" width:160 height:216
	(
		spinner suitNumbers_spn "物体编号" pos:[21,12] width:108 height:16 range:[0,9999,0] type:#integer scale:0.1
		dropdownList objectType_ddl "" pos:[67,38] width:84 height:22 items:#("头(head)", "上身(upbody)", "下身(downbody)", "脚(foot)")
		dropdownList sexType_ddl "" pos:[68,72] width:82 height:22 items:#("男(boy)", "女(girl)")
	 
		label objectType_lbl "物体类型" pos:[13,44] width:50 height:16
		label sexType_lbl "性别类型" pos:[13,76] width:50 height:16

-- 		checkbox multiMaterial_chk "多维材质" pos:[83,104] width:74 height:22 checked:true
-- 		checkbox newMaterial_chk "新建材质" pos:[8,105] width:70 height:22 checked:true
		
		button createfile_btn "按路径储存文件" pos:[16,130] width:128 height:25
		button reName_btn "自动命名" pos:[16,159] width:128 height:22
		button clearUpMaterial_btn "整理场景材质" pos:[16,185] width:128 height:22
		
		local suitNumber
		local objectType
		local sexType
		local allName
		local selObj
		local subName1
		local subName2
		
		on charRename_rol open  do
		(
			try(
				filterNaxName=filterString maxfilename "_"
				idStrA=subString filterNaxName[1] 2 4
				idNumA=idStrA as integer
				suitNumbers_spn.value=idNumA
			)catch()
			try(
				if (findString maxfilename "girl")!=undefined do
					sexType_ddl.selection=2
			)catch()
		)
		on createfile_btn pressed do
		(
			local characterFilePath="D:\dance_characters"
			
			suitNumber=suitNumber_fn suitNumbers_spn.value
			
			sexType=sexType_fn sexType_ddl.selection
			
			local newFileName=suitNumber+"_"+sexType
			
			local newDir=characterFilePath+"\\"+newFileName
			
			
			local newAllFileName=newDir+"\\"+"X"+newFileName+".max"
				
			format "fileExist:%\n" fileExist
			format "newAllFileName:%\n" newAllFileName
			format "exist:%\n" (doesFileExist newAllFileName)
			format "subType1:%\n" subType1
			format "subType2:%\n" subType2
				
			
			if doesFileExist newAllFileName then
			(
				if queryBox ("文件："+newAllFileName+" 文件已存在，覆盖原文件吗？") do
				(
					makeDir newDir
					saveMaxFile newAllFileName
					print "saved"
				)
			)
			else
			(
			
				if queryBox ("文件："+newAllFileName+" 文件未创建，保存文件到此目录吗？") do
				(
					makeDir newDir
					saveMaxFile newAllFileName
					print "saved"
				)
			)		
		
		)--on pressed do end
		on reName_btn pressed do
		(
			if maxfilepath!="" or maxfilename!="" then(
				if selection.count==1 then
				(
					suitNumber=suitNumber_fn suitNumbers_spn.value
					objectType=objectType_fn objectType_ddl.selection
					sexType=sexType_fn sexType_ddl.selection
					allName=suitNumber+"_"+objectType+"_"+sexType
					selObj=selection[1]
					
					subName1=suitNumber+"_"+subType1+"_"+sexType			
					subName2=suitNumber+"_"+subType2+"_"+sexType
					local texturePath=maxfilePath+"Textures"
					
					makeDir texturePath
					
					selObj.name="G"+allName
					selObj.material=multimaterial numsubs:2
					selObj.material.name="M"+allName
					
					if subType1=="body" then
					(
						subName1="0000_body_"+sexType
						
						subTexturePath1="D:\dance_characters\0000_"+sexType+"\Textures\T"+subName1+".png"	
						
						selObj.material[1].name="M"+subName1				
						
						if(not(doesFileExist subTexturePath1)) do
						(
							if queryBox ("贴图："+subTexturePath1+" 未找到，是否新建贴图？\n 点击“是(Y)：新建空贴图        否(N):手动指定贴图") then
							(
								bitMap1=bitmap 256 256
								bitMap1.filename=subTexturePath1
								save bitMap1
							)
							else
							(
								---手动指定贴图
								pngFilePath=getOpenFileName caption:("选择贴图自动复制到"+subTexturePath1) types:"png (*.png)|*.png| all (*.*)|*.*|"
								if pngFilePath!=undefined do(
									bitFile=getfiles pngFilePath
									copyBitmap=copy (openbitmap pngFilePath)
									copyBitmap.filename=subTexturePath1
									save copyBitmap
								)
		
							)
						)
						
						selObj.material[1].diffusemap=Bitmaptexture fileName:subTexturePath1
						selObj.material[1].diffusemap.name="B"+subName1
						selObj.material[1].showInViewport=true
						
					)
					else
					(
						selObj.material[1].name="M"+subName1
						
						subTexturePath1=texturePath+"\T"+subName1+".png"		
						
						if(not(doesFileExist subTexturePath1)) do
						(
							if queryBox ("贴图："+subTexturePath1+" 未找到，是否新建贴图？\n 点击“是(Y)：新建贴图文件        否(N):手动指定贴图") then
							(
								bitMap1=bitmap 256 256
								bitMap1.filename=subTexturePath1
								save bitMap1
							)
							else
							(
								---手动指定贴图
								pngFilePath=getOpenFileName caption:("选择贴图自动复制到"+subTexturePath1) types:"png (*.png)|*.png| all (*.*)|*.*|"
								if pngFilePath!=undefined do(
									bitFile=getfiles pngFilePath
									copyBitmap=copy (openbitmap pngFilePath)
									copyBitmap.filename=subTexturePath1
									save copyBitmap
								)
		
							)
						)
						
						selObj.material[1].diffusemap=Bitmaptexture fileName:subTexturePath1
						selObj.material[1].diffusemap.name="B"+subName1
						selObj.material[1].showInViewport=true
					)
					
					selObj.material[2].name="M"+subName2
					subTexturePath2=texturePath+"\T"+subName2+".png"
					
					
					if(not(doesFileExist subTexturePath2)) do
					(
						if queryBox ("贴图："+subTexturePath2+" 未找到，是否新建贴图？\n 点击“是(Y)：新建贴图文件        否(N):手动指定贴图") then
						(
							bitMap2=bitmap 256 256
							bitMap2.filename=subTexturePath2
							save bitMap2
						)
						else
						(
							---手动指定贴图
							pngFilePath=getOpenFileName caption:("选择贴图自动复制到"+subTexturePath2) types:"png (*.png)|*.png| all (*.*)|*.*|"
							if pngFilePath!=undefined do(
								bitFile=getfiles pngFilePath
								copyBitmap=copy (openbitmap pngFilePath)
								copyBitmap.filename=subTexturePath2
								save copyBitmap
							)
		
						)
					)
					
					selObj.material[2].diffusemap=Bitmaptexture fileName:subTexturePath2
					selObj.material[2].diffusemap.name="B"+subName2
					selObj.material[2].showInViewport=true
					
					if subType2=="hair" do
					(
						hairOpacityMap=BitmapTexture fileName:subTexturePath2
						selObj.material[2].opacityMap=hairOpacityMap
						selObj.material[2].opacityMap.name="B"+subName1+"_o"
						selObj.material[2].opacityMap.monoOutput=1
					)
					
				)else( messagebox "请选择单个物体！" )--if selection.count==1 end
			)else( messagebox "请先保存max文件到正确位置！" )--if  maxfilepath!="" or maxfilename!="" end
		
		)--on pressed do end
		
		on clearUpMaterial_btn pressed do
		(
			num=0
			sceneMatArray=for i in sceneMaterials collect i
			unUseMatArray=#()
			for i in sceneMatArray do(
				foo=true
				for objA in objects do(	
					if objA.material==i do foo=false
				)
				if foo do append unUseMatArray i
			)
			for i in unUseMatArray do i=standard()
			macros.run "Medit Tools" "clear_medit_slots"
			for i in sceneMaterials do
			(
				 
				num+=1
				if num<=24 do meditMaterials[num]=i
			)
			
		)--on pressed do end
	)
	createdialog charRename_rol style:#(#style_toolwindow,#style_sysmenu)
)

macroscript autoRenameObj
	category:"Web热舞工具"
	buttontext:"Sc_自动命名工具"
	tooltip:"Sc_自动命名工具"
(
	
	try(DestroyDialog autoRename)catch()
	
	fn ReMaterialName Obj newName=
	(
		Obj.Material.name="M"+newName
	)

	fn ReBitmapName Obj newName=
	(
		Obj.Material.diffusemap.name="B"+newName
		if Obj.Material.opacitymap!=undefined do
			Obj.Material.opacitymap.name="B"+newName
	)

	fn ReTextureName Obj oldFileName newName=
	(
		
		if (getFilenameType oldFileName)==".png" then
		(
			oldTextureNamePath=getFilenamePath oldFileName
			newTextureName=oldTextureNamePath+"T"+newName+".png"
			renameFile oldFileName newTextureName
			Obj.material.diffusemap.filename=newTextureName
		)
	)
	
	fn ReOpacityName Obj oldFileName newName=
	(
		if (getFilenameType oldFileName)==".png" then
		(
			oldTextureNamePath=getFilenamePath oldFileName
			
			newTextureName=oldTextureNamePath+"T"+newName+".png"
			
			renameFile oldFileName newTextureName
			
			Obj.material.opacitymap.filename=newTextureName
		)
	)

	rollout autoRename "AutoReName" width:200 height:60
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
				)--undo end
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
	createdialog autoRename style:#(#style_toolwindow,#style_sysmenu)

)

macroscript checkupScene
	category:"Web热舞工具"
	buttontext:"Char_文件检查工具"
	tooltip:"Char_文件检查工具"
(
	try(DestroyDialog checkupScene_rol)catch()
		
	rollout checkupScene_rol "Web热舞-文件检查工具" width:238 height:448
	(
		local Report_str="您检查的项目发现如下错误：\n\n"
		local oldStr=""
		local polyArray=#()

		--角色模型命名
		fn charName_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 角色名称命名"
			
			sextype="boy"
			oldStr=Report_str
			polyArray=for i in Geometry where classof i==Editable_Poly or classof i==PolyMeshObject collect i
			
			if checkupScene_rol.sex_ddl.selection==2 do sextype="girl"
			checkupScene_rol.subPlan_pb.value=0
			
			if polyArray.count!=0 do
				pbSub=100/polyArray.count
			for i in polyArray do
			(
				--判断模型名称
				namefilter=filterString i.name "_"
				if nameFilter.count!=3 do(
					Report_str+="角色命名检查："+i.name+"\t不符合命名规范-----模型名称\n"
					continue
				)
				if (substring nameFilter[1] 1 1)!="G" do(
					Report_str+="角色命名检查："+i.name+"\t不符合命名规范-----模型名称首字母\n"
					continue
				)
				
				idStr=subString nameFilter[1] 2 4
				idNum=idStr as number
				
				if idNum!=checkupScene_rol.objNum_spn.value do	(
					Report_str+="角色命名检查："+i.name+"\t不符合命名规范-----编号\n"
					continue
				)
				if nameFilter[2]!="head" and nameFilter[2]!="upbody" and nameFilter[2]!="downbody" and nameFilter[2]!="foot" do	(
					Report_str+="角色命名检查："+i.name+"\t不符合命名规范-----物体类型\n"
					continue
				)
				if nameFilter[3]!=sextype do(
					Report_str+="角色命名检查："+i.name+"\t不符合命名规范------性别类型\n"
					continue
				)
				unHeadName=subString i.name 2 (i.name.count-1)
				
				objectType=nameFilter[2]
				objectSexType=nameFilter[3]
				
				--判断材质名称
				
				if i.material.name!="M"+unHeadName do(
					Report_str+="角色命名检查："+i.name+"\t不符合命名规范------父材质名称\n"
					continue
				)
				if classof i.material!=Multimaterial do(
					Report_str+="角色命名检查："+i.name+"\t不符合命名规范------父材质类型\n"
					continue
				)
				mList=i.material.materialList
				
				if mList.count!=2 do(
					Report_str+="角色命名检查："+i.name+"\t不符合命名规范------子材质个数\n"
					continue
				)
				
				--第一个子材质名称
				bodyMaterial=mList[1]
				
				
				if objectType!="head" then	(
					standardBodyMName="M0000_body_"+objectSexType
					if bodyMaterial.name!=standardBodyMName do	(
						Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第1个子材质名称\n"
						continue
					)
					
					bodyPath="D:\dance_characters\0000_"+objectSexType+"\Textures\T0000_body_"+objectSexType+".png"
					bodyPathName=bodyPath as name
					bitmapName="B0000_body_"+objectSexType
					
					
					if bodyMaterial.diffusemap!=undefined do(
						
						if bodyMaterial.diffusemap.name!=bitmapName do (
							Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第1个子材质bitmap名称\n"
							continue
						)
						
						
						diffusemapName=bodyMaterial.diffusemap.filename 
						
						if diffusemapName==undefined do(
							Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第1个子材质贴图路径\n"
							continue
						)
						
						mapAsName=diffusemapName as name
						if mapAsName!=bodyPathname do(
								
							Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第1个子材质贴图路径\n"
							continue
						)
					)
-- 					
				)else(
					standardHatName="M"+idStr+"_hat_"+objectSexType
					if bodyMaterial.name!=standardHatName do(
						Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第1个子材质名称\n"
						continue
					)
					hatPath="D:\\dance_characters\\"+idStr+"_"+objectSexType+"\\Textures\\T"+idStr+"_hat_"+objectSexType+".png"
					hatPathName=hatPath as name
					bitmapName="B"+idStr+"_hat_"+objectSexType
					
					if bodyMaterial.diffusemap!=undefined do(
						if bodyMaterial.diffusemap.name!=bitmapName do(
							Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第1个子材质bitmap名称\n"
							continue
						)
						if (bodyMaterial.diffusemap.filename as name)!=hatPathName do(
							Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第1个子材质贴图路径\n"
							continue
						)
					)
					
				)
				
				--第二个子材质名称
				
				secMaterial=mList[2]
				case objectType of
				(
					"head":(
						subMaterialName="M"+idStr+"_hair_"+objectSexType
						subMaterialBitName="B"+idStr+"_hair_"+objectSexType
						subMaterialMapName="D:\\dance_characters\\"+idStr+"_"+objectSexType+"\\Textures\\T"+idStr+"_hair_"+objectSexType+".png"			
					)
					"upbody":(
						subMaterialName="M"+idStr+"_cloth_"+objectSexType
						subMaterialBitName="B"+idStr+"_cloth_"+objectSexType
						subMaterialMapName="D:\\dance_characters\\"+idStr+"_"+objectSexType+"\\Textures\\T"+idStr+"_cloth_"+objectSexType+".png"	
					
					)
					"downbody":(
						subMaterialName="M"+idStr+"_pants_"+objectSexType
						subMaterialBitName="B"+idStr+"_pants_"+objectSexType
						subMaterialMapName="D:\\dance_characters\\"+idStr+"_"+objectSexType+"\\Textures\\T"+idStr+"_pants_"+objectSexType+".png"	
					)
					"foot":(
						subMaterialName="M"+idStr+"_shoes_"+objectSexType
						subMaterialBitName="B"+idStr+"_shoes_"+objectSexType
						subMaterialMapName="D:\\dance_characters\\"+idStr+"_"+objectSexType+"\\Textures\\T"+idStr+"_shoes_"+objectSexType+".png"	
					)
					default:()
				)
				
				if secMaterial.name!=subMaterialName do
				(
					Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第2个子材质名称\n"
					continue
				)
				
				if secMaterial.diffusemap!=undefined do(
					if secMaterial.diffusemap.name!=subMaterialBitName do (
						Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第2个子材质bitmap名称\n"
						continue
					)
					if (secMaterial.diffusemap.filename as name)!=(subMaterialMapName as name) do (
						Report_str+="角色命名检查："+i.name+"\t不符合命名规范------第2个子材质贴图路径\n"
						
						print (secMaterial.diffusemap.filename+"--"+subMaterialMapName)
						continue
					)
				)
				checkupScene_rol.subPlan_pb.value+=pbSub
			)--for end
			
			return Report_str==oldStr	
		)
		
		--图层
		fn layer_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 角色图层设置"
			
			oldStr=Report_str
			geoArray=for i in Geometry where classof i==Editable_Poly or classof i==PolyMeshObject collect i
			checkupScene_rol.subPlan_pb.value=0
			if geoArray.count!=0 do
				pbSub=100/geoArray.count	
			for i in geoArray do(
				nameFilterArray=#()
				nameFilterArray=filterString i.name "_"
				
				if nameFilterArray.count!=3 do continue
				
				idStr=subString nameFilterArray[1] 2 4
				
				try (idNum=idStr as number )catch continue
				
				objSexType=nameFilterArray[3]
				
				layerName=idStr+"_"+objSexType
				print layerName
				
				if i.layer.name!=layerName do(
					Report_str+="图层设置："+i.name+"图层错误\n"
				)
				if rdoState==2 do(
					if (layerManager.getLayerFromName layerName)==undefined then(
						newLayer=layerManager.newLayerFromName layerName
					)else(
						newLayer=layerManager.getLayerFromName layerName
					)
					print newLayer.name
					newLayer.addnode i
				)
				checkupScene_rol.subPlan_pb.value+=pbSub
			)
			return Report_str==oldStr
		)

		--尺寸单位
		fn SystemUnit_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 文件尺寸单位"
			checkupScene_rol.subPlan_pb.value=0
			oldStr=Report_str
			
			if units.DisplayType!=#Metric do
				Report_str+="现显示单位类型："+units.metricType+"        显示单位标准：Metric\n"
			if units.metricType!=#centimeters do
				Report_str+="现显示单位："+units.metricType+"        显示单位标准：centimeters\n"
			if units.SystemType!=#centimeters do
				Report_str+="现系统单位："+units.metricType+"        系统单位标准：centimeters\n"
			if units.SystemScale!=1.0 do
				Report_str+="现系统单位缩放："+units.SystemScale+"       系统单位缩放标准：1.0\n"

			if rdoState==2 do
			(
				units.DisplayType=#Metric
				units.metricType=#centimeters
				units.SystemScale=1.0
				units.SystemType=#centimeters
				print "xiugai"
			)
			
			checkupScene_rol.subPlan_pb.value=100
			return Report_str==oldStr
		)
		
		--空物体
		fn rubbishObj_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 空物体"
			checkupScene_rol.subPlan_pb.value=0
			if Geometry.count!=0 do
				pbSub=100/Geometry.count
			oldStr=Report_str
			deleteobj=#()
			for i in Geometry do 
			(
				try(
					num=getNumVerts i
					if num==0 do
					(
						Report_str+="空物体："+i.name+"\n"
						append deleteobj i
					)
				)catch()
				checkupScene_rol.subPlan_pb.value+=pbSub
			)
			
			if rdoState==2 do
				delete deleteobj
		
			return Report_str==oldStr
		)
		
		--Group
		fn group_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n Group"
			checkupScene_rol.subPlan_pb.value=0
			
			if objects.count!=0 do
				pbSub=100/objects.count
			selArray=for i in selection collect i
			oldStr=Report_str
			groupArray=#()
			
			
			for i in objects do
			(
				if isOpenGroupMember i do
				(
					select i
					actionMan.executeAction 0 "40143"  -- Groups: Group Close
					max group close

				)
				
				if isGroupHead i do
				(
					Report_str+="组(Group)："+i.name+"\n"
					append groupArray i
				)
				checkupScene_rol.subPlan_pb.value+=pbSub
			)
			
			if rdoState==2 do(
				for i in groupArray do
				(
					if (findItem selArray i)!=0 do deleteItem selArray (findItem selArray i)
					explodeGroup i
				)
			)
			select selArray
			return Report_str==oldStr
		)
		
		--删除particle view
		fn delPView_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 垃圾particle view"
			checkupScene_rol.subPlan_pb.value=0
			if objects.count!=0 do
				pbSub=100/objects.count
			oldStr=Report_str
			tp_ParticleView=#()
			for i in objects do
			(
				if classof i==Particle_View do append tp_ParticleView i
				checkupScene_rol.subPlan_pb.value+=pbSub	
			)
			if tp_ParticleView.count>0 do
			(
				Report_str+="垃圾particle View物体："+(tp_ParticleView.count as string)+"个\n"
			)
			if rdoState==2 do delete tp_ParticleView
			return Report_str==oldStr
		)
		
		--模型内隐藏面
		fn hideFace_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 模型内隐藏面"
			oldStr=Report_str
			checkupScene_rol.subPlan_pb.value=0
			
			
			polyArray=for i in Geometry where classof i==Editable_Poly collect i
			if polyArray.count!=0 do
				pbSub=100/polyArray.count	
			unhideArray=#()
			for i in polyArray do
			(
				select i
				hidFaceArray=polyop.getHiddenFaces i
				hidFaceCount=hidFaceArray.numberset
				
				if hidFaceCount>0 do Report_str+="有隐藏面的物体："+i.name+"  发现"+(hidFaceCount as string)+"个隐藏面\n"
				append unhideArray i
				checkupScene_rol.subPlan_pb.value+=pbSub
			)
			
			if rdoState==2 do
			(
				for i in unhideArray do
				(
					polyop.setFaceSelection i (polyop.getHiddenFaces i)
					polyop.unHideAllFaces i
				)
			)
		
			return Report_str==oldStr
		)
		
		--模型内悬浮点
		fn isolatedV_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 模型内悬浮点"
			checkupScene_rol.subPlan_pb.value=0
			selArray=for i in selection collect i
			oldStr=Report_str
			
			if rdoState==2 do
			(
				polyArray=for i in Geometry where classof i==Editable_Poly collect i
				if polyArray.count!=0 do
					pbSub=100/polyArray.count
				for i in polyArray do
				(
					if i.deleteisoverts() do Report_str+="有悬浮点的物体："+i.name+"\n"
					checkupScene_rol.subPlan_pb.value+=pbSub
				)
			)
			select selArray
			return Report_str==oldStr
		)
		
		--模型内未焊接点
		fn weldVertices_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 模型内未焊接点"
			oldStr=Report_str
			polyArray=for i in Geometry where classof i==Editable_Poly collect i
				
			checkupScene_rol.subPlan_pb.value=0
			if polyArray.count!=0 do
				pbSub=100/polyArray.count
			
			for i in polyArray do
			(
				vertList=#()
				verticesArrayA=#()
				verticesArrayB=#()
				verticesArrayEnd=#()
				
				maxNum=i.GetNumVertices()
				verticesArrayA=for a=1 to maxNum collect (i.getVertex a)
				verticesArrayB=for a in verticesArrayA collect a
				
				for num=1 to verticesArrayA.count do
				(
					vert=verticesArrayA[num]
					verticesArrayB[num]="end"
					for vert2 in verticesArrayB do
					(
						if vert==vert2 and vert!="end"	do(
							foo=true
							for vertX in verticesArrayEnd do(
								if vertX==vert2 do foo=false
							)
							if foo do append verticesArrayEnd vert2
						)
					)
				)
				
				if verticesArrayEnd.count>0 do(
					Report_str+="模型内未焊接点："+i.name+"\t模型内有"+ ( verticesArrayEnd.count as string ) +  "个位置有多个未焊接点\n"
				)
				
				if rdoState==2 do(
					maxNum=i.GetNumVertices()
					vertList=for a=1 to maxNum collect a
					polyop.weldVertsByThreshold i vertList
				)
				checkupScene_rol.subPlan_pb.value+=pbSub
			)
			
			return Report_str==oldStr
		)
		
		--角色装备坐标
		fn pivot_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 角色装备坐标"
			if rdoState==2 do
			(
				polyArray=for i in Geometry where classof i==Editable_Poly collect i
				checkupScene_rol.subPlan_pb.value=0
				if polyArray.count!=0 do
					pbSub=100/polyArray.count
				
				for i in polyArray do
				(
					oldPivot=i.pivot
					
					centerpivot i
					redrawviews()
					i.pivot.x=0
					
					print i.pivot
					
					checkupScene_rol.subPlan_pb.value+=pbSub
				)
			)
			return true
		)
		
		--模型动画信息
		fn aniObject_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n 模型动画信息"
			selArray=for i in selection collect i
			geoArray=for i in Geometry where classof i==Editable_Poly or classof i==PolyMeshObject collect i
				
			checkupScene_rol.subPlan_pb.value=0
			if geoArray.count!=0 do
				pbSub=100/geoArray.count
			
			oldStr=Report_str
			
			for i in geoArray do 
			(
				if i.isanimated do Report_str+="动画物体："+i.name+"\n"
				checkupScene_rol.subPlan_pb.value+=pbSub
			)
			
			if rdoState==2 do
			(
				select geoArray
				macros.run "Animation Tools" "DeleteSelectedAnimation"
			)
			
			select selArray
			return Report_str==oldStr
		)
		
		--Xform
		fn xform_fn rdoState=
		(
			checkupScene_rol.explain_lbl.text="正在检查:\n Xform"
			oldStr=Report_str
			foo=true
			geoArray=for i in Geometry where classof i==Editable_Poly or classof i==Editable_mesh collect i
			meshArray=for i in Geometry where classof i==Editable_mesh collect i
			polyArray=for i in Geometry where classof i==Editable_Poly collect i
			
			if rdoState==1 then
			(
				for i in geoArray do
				(
					if i.rotation!=(quat 0 0 0 1) or i.scale!=[1,1,1] do 
					(
						Report_str+="需要进行xform的物体:"+i.name+"\n"
					)
				)
				if geoArray.count>0 do
					Report_str+="您已经选择检查xform，检查xform功能并不能完全统计需要添加xform的物体，建议选择“修改”。"
			)
			else
			(
				for i in geoArray do
				(
					resetXForm i
					resetTransform i
				)
				for i in meshArray do
				(
					convertToMesh(i)

				)
				for i in polyArray do
				(
					convertToPoly(i)
				)
				if geoArray.count>0 do
					Report_str+="您已经选择xform—修改，所有模型已经加入xform并塌陷。"
			)
			return oldStr==Report_str
		)
		
		radiobuttons type_rdo "" pos:[31,9] width:174 height:16 labels:#("角色", "场景", "蒙皮后") default:1 columns:3
		spinner objNum_spn "物体编号" pos:[45,35] width:115 height:16 enabled:true range:[0,1000,0] type:#integer scale:1
		label sex_lbl "性别类型" pos:[22,62] width:54 height:16
		dropdownList sex_ddl "" pos:[80,59] width:84 height:22 items:#("男(boy)", "女(girl)") selection:1
--		
		button selectAll_btn "全选" pos:[8,89] width:49 height:21
		button none_btn "全取消" pos:[60,89] width:49 height:21
		button checkAll_btn "全部检查" pos:[111,89] width:58 height:21
		button alterAll_btn "全部修改" pos:[173,89] width:58 height:21
--		
--		
		checkbox charName_chk "角色模型命名-----" pos:[11,117] width:109 height:18
		radiobuttons charName_rdo "" pos:[128,118] width:106 height:16 enabled:true labels:#("检查", "——") default:1 columns:2
--		
		checkbox SystemUnit_chk "文件尺寸单位-----" pos:[11,163] width:109 height:18
		radiobuttons SystemUnit_rdo "" pos:[128,164] width:106 height:16 labels:#("检查", "修改") default:1 columns:2				
				
				
				
				
--				
--	
		checkbox rubbishObj_chk "空物体--------------" pos:[11,186] width:109 height:18
		radiobuttons rubbishObj_rdo "" pos:[128,187] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
--		
		checkbox group_chk "Group----------------" pos:[11,209] width:109 height:18
		radiobuttons group_rdo "" pos:[128,210] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
--		
		checkbox layer_chk "角色图层设置-----" pos:[11,140] width:109 height:18
		radiobuttons layer_rdo "" pos:[128,141] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
--		
--
		checkbox delPView_chk "particle view--------" pos:[11,232] width:109 height:18
		radiobuttons delPView_rdo "" pos:[128,233] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
--		
		checkbox hideFace_chk "模型内隐藏面-----" pos:[11,255] width:109 height:18
		radiobuttons hideFace_rdo "" pos:[128,256] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
--
		checkbox isolatedV_chk "模型内悬浮点-----" pos:[11,278] width:109 height:18
		radiobuttons isolatedV_rdo "" pos:[128,279] width:106 height:16 labels:#("——", "修改") default:1 columns:2
--	
		checkbox weldVertices_chk "模型内未焊接点--" pos:[11,301] width:109 height:18
		radiobuttons weldVertices_rdo "" pos:[128,302] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
--		
		checkbox pivot_chk "角色坐标轴--------" pos:[11,347] width:109 height:18
		radiobuttons pivot_rdo "" pos:[128,348] width:106 height:16 labels:#("——", "修改") default:1 columns:2
--		
		checkbox aniObject_chk "动画信息-----------" pos:[11,324] width:109 height:18
		radiobuttons aniObject_rdo "" pos:[128,325] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
--		
--		
		checkbox xform_chk "Xform-----------------" pos:[11,370] width:109 height:18
		radiobuttons xform_rdo "" pos:[128,371] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
--	
		button run_btn "执行" pos:[155,397] width:68 height:39
		progressBar subPlan_pb "ProgressBar" pos:[7,428] width:142 height:8
		label explain_lbl "" pos:[9,395] width:138 height:29
		label lbl5 "2012.07.05" pos:[173,64] width:58 height:16
--		
		fn enabledSet_fn =
		(
			charName_rdo.enabled	=	charName_chk.checked
			SystemUnit_rdo.enabled 	= 	SystemUnit_chk.checked
			rubbishObj_rdo.enabled	=	rubbishObj_chk.checked
			group_rdo.enabled		=	group_chk.checked
			layer_rdo.enabled		=	layer_chk.checked
			delPView_rdo.enabled	=	delPView_chk.checked
			hideFace_rdo.enabled	=	hideFace_chk.checked
			isolatedV_rdo.enabled	=	isolatedV_chk.checked
			weldVertices_rdo.enabled=	weldVertices_chk.checked
			pivot_rdo.enabled		=	pivot_chk.checked
			aniObject_rdo.enabled	=	aniObject_chk.checked
			xform_rdo.enabled		=	xform_chk.checked 	
		)
		
		on checkupScene_rol open do
		(
			enabledSet_fn()
			try(
				
			filterNaxName=filterString maxfilename "_"
			idStrA=subString filterNaxName[1] 2 4
			idNumA=idStrA as integer
			objNum_spn.value=idNumA
			)catch()
			try(
				if (findString maxfilename "girl")!=undefined do
					sex_ddl.selection=2
			)catch()
			subPlan_pb.visible=false
			
		)
		on type_rdo changed state do
		(
			if type_rdo.state==1 do
			(
				
				
				--编号和性别
				objNum_spn.enabled=true
				sex_lbl.enabled=true
				sex_ddl.enabled=true
				
				--角色命名
				charName_chk.enabled=true
				charName_rdo.enabled=true
				
				--场景单位
				SystemUnit_chk.enabled=true
				SystemUnit_rdo.enabled=true
				--多余物体
				rubbishObj_chk.enabled=true
				rubbishObj_rdo.enabled=true
				--Group
				group_chk.enabled=true
				group_rdo.enabled=true
				--图层设置
				layer_chk.enabled=true
				layer_rdo.enabled=true
				--particle view
				delPView_chk.enabled=true
				delPView_rdo.enabled=true
				--模型内隐藏面
				hideFace_chk.enabled=true
				hideFace_rdo.enabled=true
				--模型内悬浮点
				isolatedV_chk.enabled=true
				isolatedV_rdo.enabled=true
				--模型内未焊接点
				weldVertices_chk.enabled=true
				weldVertices_rdo.enabled=true
				--角色装备坐标
				pivot_chk.enabled=true
				pivot_rdo.enabled=true
				--Xform
				xform_chk.enabled=true
				xform_rdo.enabled=true
			)
			if type_rdo.state==2 do
			(
				--编号和性别
				objNum_spn.enabled=false
				sex_lbl.enabled=false
				sex_ddl.enabled=false
				--角色命名
				charName_chk.enabled=false
				charName_rdo.enabled=false
				
				--场景单位
				SystemUnit_chk.enabled=true
				SystemUnit_rdo.enabled=true
				--多余物体
				rubbishObj_chk.enabled=true
				rubbishObj_rdo.enabled=true
				--Group
				group_chk.enabled=true
				group_rdo.enabled=true
				--图层设置
				layer_chk.enabled=false
				layer_chk.checked=false
				layer_rdo.enabled=false
				--particle view
				delPView_chk.enabled=true
				delPView_rdo.enabled=true
				--模型内隐藏面
				hideFace_chk.enabled=true
				hideFace_rdo.enabled=true
				--模型内悬浮点
				isolatedV_chk.enabled=true
				isolatedV_rdo.enabled=true
				--模型内未焊接点
				weldVertices_chk.enabled=true
				weldVertices_rdo.enabled=true
				--角色装备坐标
				pivot_chk.enabled=false
				pivot_chk.checked=false
				pivot_rdo.enabled=false
				--Xform
				xform_chk.enabled=true
				xform_rdo.enabled=true
			)
			if type_rdo.state==3 do
			(
				--编号和性别
				objNum_spn.enabled=true
				sex_lbl.enabled=true
				sex_ddl.enabled=true
				--角色命名
				charName_chk.enabled=true
				charName_rdo.enabled=true
				
				--场景单位
				SystemUnit_chk.enabled=true
				SystemUnit_rdo.enabled=true
				--多余物体
				rubbishObj_chk.enabled=true
				rubbishObj_rdo.enabled=true
				--Group
				group_chk.enabled=false
				group_chk.checked=false
				group_rdo.enabled=false
				--图层设置
				layer_chk.enabled=true
				layer_rdo.enabled=true
				--particle view
				delPView_chk.enabled=true
				delPView_rdo.enabled=true
				--模型内隐藏面
				hideFace_chk.enabled=false
				hideFace_chk.checked=false
				hideFace_rdo.enabled=false
				--模型内悬浮点
				isolatedV_chk.enabled=false
				isolatedV_chk.checked=false
				isolatedV_rdo.enabled=false
				--模型内未焊接点
				weldVertices_chk.enabled=false
				weldVertices_chk.checked=false
				weldVertices_rdo.enabled=false
				--角色装备坐标
				pivot_chk.enabled=false
				pivot_chk.checked=false
				pivot_rdo.enabled=false
				--Xform
				xform_chk.enabled=false
				xform_chk.checked=false
				xform_rdo.enabled=false
			)
			enabledSet_fn()	
		)--角色场景选项
		on selectAll_btn pressed do
		(
			--角色命名
			charName_chk.checked	= charName_chk.enabled
			
			--场景单位
			SystemUnit_chk.checked=SystemUnit_chk.enabled
		
			--多余物体
			rubbishObj_chk.checked=rubbishObj_chk.enabled
			--Group
			group_chk.checked=group_chk.enabled
		
			--图层设置
			layer_chk.checked=layer_chk.enabled
		
			--particle view
			delPView_chk.checked=delPView_chk.enabled
		
			--模型内隐藏面
			hideFace_chk.checked= hideFace_chk.enabled
		
			--模型内悬浮点
			isolatedV_chk.checked=isolatedV_chk.enabled
		
			--模型内未焊接点
			weldVertices_chk.checked=weldVertices_chk.enabled
		
			--角色装备坐标
			pivot_chk.checked=pivot_chk.enabled
			
			--模型动画信息
			aniObject_chk.checked=aniObject_chk.enabled
		
			--Xform
			xform_chk.checked=xform_chk.enabled
			
			enabledSet_fn()	
		)--全选
		on none_btn pressed do
		(
			
			charName_chk.checked=false
			--场景单位
			SystemUnit_chk.checked=false
			--多余物体
			rubbishObj_chk.checked=false
			--Group
			group_chk.checked=false
			--图层设置
			layer_chk.checked=false
			--particle view
			delPView_chk.checked=false
			--模型内隐藏面
			hideFace_chk.checked=false
			--模型内悬浮点
			isolatedV_chk.checked=false
			--模型内未焊接点
			weldVertices_chk.checked=false
			--角色装备坐标
			pivot_chk.checked=false
			--模型动画信息
			aniObject_chk.checked=false
			--Xform
			xform_chk.checked=false
			
			enabledSet_fn()	
			
		)--全取消
		on checkAll_btn pressed do
		(
			charName_rdo.state=1
			--场景单位
			SystemUnit_rdo.state=1
			--多余物体
			rubbishObj_rdo.state=1
			--Group
			group_rdo.state=1
			--图层设置
			layer_rdo.state=1
			--particle view
			delPView_rdo.state=1
			--模型内隐藏面
			hideFace_rdo.state=1
			--模型内悬浮点
			isolatedV_rdo.state=1
			--模型内未焊接点
			weldVertices_rdo.state=1
			--角色装备坐标
			pivot_rdo.state=1
			--模型动画信息
			aniObject_rdo.state=1
			--Xform
			xform_rdo.state=1
		)
		on alterAll_btn pressed do
		(
			charName_rdo.state=2
			--场景单位
			SystemUnit_rdo.state=2
			--多余物体
			rubbishObj_rdo.state=2
			--Group
			group_rdo.state=2
			--图层设置
			layer_rdo.state=2
			--particle view
			delPView_rdo.state=2
			--模型内隐藏面
			hideFace_rdo.state=2
			--模型内悬浮点
			isolatedV_rdo.state=2
			--模型内未焊接点
			weldVertices_rdo.state=2
			--角色装备坐标
			pivot_rdo.state=2
			--模型动画信息
			aniObject_rdo.state=2
			--Xform
			xform_rdo.state=2
		)
		on charName_chk changed state do
			charName_rdo.enabled = charName_chk.checked
		on SystemUnit_chk changed state do
			SystemUnit_rdo.enabled = SystemUnit_chk.checked
		on rubbishObj_chk changed state do
			rubbishObj_rdo.enabled = rubbishObj_chk.checked
		on group_chk changed state do
			group_rdo.enabled = group_chk.checked
		on layer_chk changed state do
			layer_rdo.enabled = layer_chk.checked
		on delPView_chk changed state do
			delPView_rdo.enabled = delPView_chk.checked
		on hideFace_chk changed state do
			hideFace_rdo.enabled = hideFace_chk.checked
		on isolatedV_chk changed state do
			isolatedV_rdo.enabled = isolatedV_chk.checked
		on weldVertices_chk changed state do
			weldVertices_rdo.enabled = weldVertices_chk.checked
		on pivot_chk changed state do
			pivot_rdo.enabled = pivot_chk.checked
		on aniObject_chk changed state do
			aniObject_rdo.enabled = aniObject_chk.checked
		on xform_chk changed state do
			xform_rdo.enabled = xform_chk.checked
		on run_btn pressed do
		(
			ReportFoo=true
			subPlan_pb.visible=true
			
			--角色模型名称
			
			if charName_chk.checked do
			(
				if not charName_fn(charName_rdo.state) do ReportFoo=false
			)
			
			--图层
			if layer_chk.checked do
			(
				if not layer_fn(layer_rdo.state) do ReportFoo=false
			)
				
			--场景单位
			if SystemUnit_chk.checked do 
			(
				if not SystemUnit_fn(SystemUnit_rdo.state) do ReportFoo=false
			)
			
			--空物体
			if rubbishObj_chk.checked do
			(
				if not rubbishObj_fn(rubbishObj_rdo.state) do ReportFoo=false
			)
			
			--Group
			if group_chk.checked do
			(
				if not group_fn(group_rdo.state) do ReportFoo=false
			)
			
			--删除particle view
			if delPView_chk.checked do
			(
				if not delPView_fn(delPView_rdo.state) do ReportFoo=false
			)
			
			--模型内隐藏面
			if hideface_chk.checked do
			(
				if not hideface_fn(hideface_rdo.state) do ReportFoo=false
			)
			
			--模型内悬浮点
			if isolatedV_chk.checked do
			(
				if not isolatedV_fn(isolatedV_rdo.state) do ReportFoo=false
			)
			
			--模型内未焊接点
			if weldVertices_chk.checked do(
				if not weldVertices_fn(weldVertices_rdo.state) do ReportFoo=false
			)
		
			--模型动画信息
			if  aniObject_chk.checked do
			(
				if not aniObject_fn(aniObject_rdo.state) do ReportFoo=false
			)
			
			--角色装备坐标
			if pivot_chk.checked do
			(
				if not pivot_fn(pivot_rdo.state) do ReportFoo=false
			)
			
			--Xform
			if xform_chk.checked do
			(
				if not xform_fn(xform_rdo.state) do ReportFoo=false
			)
			
			if ReportFoo then
				messagebox "恭喜！所选择的检查项没有错误。"
			else(
				
				Report_str+="\n————————————————————————————————————\n"
				messagebox Report_str
			)
			
			subPlan_pb.visible=false
			explain_lbl.text=""
			Report_str="您检查的项目发现如下错误：\n\n"
		)--on run_btn pressed end
	)
	createdialog checkupScene_rol style:#(#style_toolwindow,#style_sysmenu)
)

macroscript clearRendererShaders
	category:"Web热舞工具"
	buttontext:"Skin_清除动画及渲染控制器"
	tooltip:"Skin_清除动画及渲染控制器"
(
	try(
		allObj=for i in objects collect i
		select allObj
		macros.run "Animation Tools" "DeleteSelectedAnimation"
	)catch()

	try(animationrange=(interval 0f 5f))catch()

	try(
		renderers.current.EnableContours=false
		renderers.current.contour_contrast_shader=undefined
		renderers.current.contour_store_shader=undefined
		renderers.current.contour_output_shader=undefined
	)catch()

)

macroscript openChrFile
	category:"Web热舞工具"
	buttontext:"Char_快速打开角色文件"
	tooltip:"Char_快速打开角色文件"
(
	try(DestroyDialog openFile_rol)catch()
	
	rollout openFile_rol "Webdance打开角色文件" width:294 height:128
	(
		spinner num_spn "角色编号：" pos:[78,10] width:100 height:16 range:[0,9999,0] type:#integer
		button openfile_btn "打开文件" pos:[79,95] width:132 height:26
		label path_lbl "" pos:[26,68] width:246 height:18
		dropdownList sex_ddl "" pos:[111,33] width:74 height:22 items:#("男(boy)", "女(girl)")
		label lbl3 "角色性别：" pos:[46,37] width:64 height:16
		
		local filePath_str
		fn suitNumber_fn oldNumber =
		(
			stringNumber=oldNumber as string
			stringCount=4-stringNumber.count
			for i=1 to stringCount do
			(
				stringNumber="0"+stringNumber
			)
			return stringNumber
		)
		
		fn getPath_fn numInt selsex=(
			if selsex==1 then(
				sex="boy"
			)else(
				sex="girl"
			)
			
			num=suitNumber_fn numInt
			
			filePath_str="D:\\dance_characters\\"+num+"_"+sex+"\\X"+num+"_"+sex+".max"
			if (getfiles filePath_str).count==0 then
			(
				return "未发现文件"
			)else(
				return filePath_str
			)
		)
		
		on openFile_rol open do
		(
			path_lbl.text=getPath_fn num_spn.value sex_ddl.selection
			
			openfile_btn.enabled=not (path_lbl.text=="未发现文件")
		
		)
		on num_spn changed val do
		(
			path_lbl.text=getPath_fn num_spn.value sex_ddl.selection
			
			openfile_btn.enabled=not (path_lbl.text=="未发现文件")
		)
		on openfile_btn pressed do
		(
			loadmaxfile path_lbl.text Quiet:false
		)
		on sex_ddl selected sel do
		(
			path_lbl.text=getPath_fn num_spn.value sex_ddl.selection
			openfile_btn.enabled=not (path_lbl.text=="未发现文件")
		)
	)
	createdialog openFile_rol
)






















