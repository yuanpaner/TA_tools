macroscript addSkin_Auto
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
				"upbody":#(		$bip_Neck,
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
								$bip_R_Finger21
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
				skinOps.addbone skinModi a 1
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
	)v
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

		checkbox multiMaterial_chk "多维材质" pos:[83,104] width:74 height:22 checked:true
		checkbox newMaterial_chk "新建材质" pos:[8,105] width:70 height:22 checked:true
		
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
					
					subTexturePath1="D:\dance_characters\0000_boy\Textures\T"+subName1+".dds"	
					
					selObj.material[1].name="M"+subName1				
					
					if(not(doesFileExist subTexturePath1)) do
					(
						if queryBox ("贴图："+subTexturePath1+" 未找到，是否新建贴图？\n 点击“是(Y)：新建空贴图        否(N):跳过") then
						(
							bitMap1=bitmap 256 256
							bitMap1.filename=subTexturePath1
							save bitMap1
						)
						else
						(
							---手动指定贴图
						)
						
					)
					
					selObj.material[1].diffusemap=Bitmaptexture fileName:subTexturePath1
					selObj.material[1].diffusemap.name="B"+subName1
					selObj.material[1].showInViewport=true
					
				)
				else
				(
					selObj.material[1].name="M"+subName1
					
					subTexturePath1=texturePath+"\T"+subName1+".dds"		
					
					if(not(doesFileExist subTexturePath1)) do
					(
						if queryBox ("贴图："+subTexturePath1+" 未找到，是否新建贴图？\n 点击“是(Y)：新建贴图文件        否(N):跳过") then
						(
							bitMap1=bitmap 256 256
							bitMap1.filename=subTexturePath1
							save bitMap1
						)
						else
						(
							---手动指定贴图
						)
					)
					
					selObj.material[1].diffusemap=Bitmaptexture fileName:subTexturePath1
					selObj.material[1].diffusemap.name="B"+subName1
					selObj.material[1].showInViewport=true
				)
				
				selObj.material[2].name="M"+subName2
				subTexturePath2=texturePath+"\T"+subName2+".dds"
				
				
				if(not(doesFileExist subTexturePath2)) do
				(
					if queryBox ("贴图："+subTexturePath2+" 未找到，是否新建贴图？\n 点击“是(Y)：新建贴图文件        否(N):") then
					(
						bitMap2=bitmap 256 256
						bitMap2.filename=subTexturePath2
						save bitMap2
					)
					else
					(
						---手动指定贴图
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
		
		)--on pressed do end
		
		on clearUpMaterial_btn pressed do
		(
			macros.run "Medit Tools" "clear_medit_slots"
			num=0
			for i in sceneMaterials do
			(
				num+=1
				meditMaterials[num]=i
			)
			
		)--on pressed do end
	)
	createdialog charRename_rol style:#(#style_toolwindow,#style_sysmenu)
)

macroscript checkupScene
	category:"Web热舞工具"
	buttontext:"Char_文件检查工具"
	tooltip:"Char_文件检查工具"
(
	
	try(DestroyDialog checkupScene_rol)catch()
		
	rollout checkupScene_rol "文件检查工具" width:238 height:413
	(
		radiobuttons type_rdo "" pos:[66,12] width:106 height:16 labels:#("角色", "场景") columns:2
		spinner objNum_spn "物体编号" pos:[32,35] width:115 height:16 enabled:true range:[0,1000,0] type:#integer scale:1
		label sex_lbl "性别类型" pos:[14,62] width:54 height:16
		dropdownList sex_ddl "" pos:[77,59] width:84 height:22 items:#("男(boy)", "女(girl)") selection:1
		
		button selectAll_btn "全选" pos:[8,89] width:49 height:21
		button none_btn "全取消" pos:[60,89] width:49 height:21
		button checkAll_btn "全部检查" pos:[111,89] width:58 height:21
		button alterAll_btn "全部修改" pos:[173,89] width:58 height:21
		
		checkbox SystemUnit_chk "场景尺寸单位-----" pos:[11,114] width:109 height:18
		radiobuttons SystemUnit_rdo "" pos:[126,115] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
		
		checkbox rubbishObj_chk "多余物体-----------" pos:[11,138] width:109 height:18
		radiobuttons rubbishObj_rdo "" pos:[126,139] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
		
		checkbox group_chk "Group----------------" pos:[11,162] width:109 height:18
		radiobuttons group_rdo "" pos:[126,163] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
		
		checkbox layer_chk "图层设置-----------" pos:[11,186] width:109 height:18
		radiobuttons layer_rdo "" pos:[126,187] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
		

		checkbox delPView_chk "删除particle view--" pos:[11,210] width:109 height:18
		radiobuttons delPView_rdo "" pos:[126,211] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
		
		checkbox hideFace_chk "模型内隐藏面-----" pos:[11,234] width:109 height:18
		radiobuttons hideFace_rdo "" pos:[126,235] width:106 height:16 labels:#("检查", "修改") default:1 columns:2

		checkbox isolatedV_chk "模型内悬浮点-----" pos:[11,258] width:109 height:18
		radiobuttons isolatedV_rdo "" pos:[126,259] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
		
		checkbox weldVertices_chk "模型内未焊接点--" pos:[11,282] width:109 height:18
		radiobuttons weldVertices_rdo "" pos:[126,283] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
		
		checkbox pivot_chk "角色装备坐标-----" pos:[11,306] width:109 height:18
		radiobuttons pivot_rdo "" pos:[126,307] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
		
		checkbox xform_chk "Xform-----------------" pos:[11,330] width:109 height:18
		radiobuttons xform_rdo "" pos:[127,330] width:106 height:16 labels:#("检查", "修改") default:1 columns:2
	
	
		

		checkbox chk11 "不生成报告" pos:[71,354] width:89 height:23
		button run_btn "开始检查" pos:[135,380] width:91 height:26
		
		
		
		
		on type_rdo changed stat do
		(
			if type_rdo.state==1 then
			(
				--编号和性别
				objNum_spn.enabled=true
				sex_lbl.enabled=true
				sex_ddl.enabled=true
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
			else
			(
				--编号和性别
				objNum_spn.enabled=false
				sex_lbl.enabled=false
				sex_ddl.enabled=false
				--场景单位
				SystemUnit_chk.enabled=true
				SystemUnit_rdo.enabled=true
				--多余物体
				rubbishObj_chk.enabled=false
				rubbishObj_chk.checked=false
				rubbishObj_rdo.enabled=false
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
		)--角色场景选项
		
		
	)--rollot end
	
	
	createdialog checkupScene_rol style:#(#style_toolwindow,#style_sysmenu)
)

































