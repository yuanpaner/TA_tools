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
				
				subTexturePath1="D:\dance_characters\0000_boy\Textures\T"+subName1+".png"	
				
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
				
				subTexturePath1=texturePath+"\T"+subName1+".png"		
				
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
			subTexturePath2=texturePath+"\T"+subName2+".png"
			
			
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
