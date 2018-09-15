macroScript HitmanTool
	category:"助手BIP"
	toolTip:"EasyBip"
(
try(DestroyDialog DrDc_Bip) Catch()
rollout DrDc_Bip "" width:124 height:60
(
	global SelBipOpen,SelBipsave
	button btn3 "导入" pos:[0,0] width:62 height:20
	button btn4 "导出" pos:[62,0] width:62 height:20
	button btn15 "批处理导出Bip" pos:[0,20] width:84 height:20
	button btn16 "批处理导入Bip" pos:[0,40] width:84 height:20
	button btn5 "关闭" pos:[84,20] width:40 height:40
	on btn3 pressed do
	(
		if $bip01 !=undefined then
		(
		SelBipOpen= getOpenFileName caption:"Open A Test File:" types:"BIP (*.bip)|*.bip|"
		print SelBipOpen
			if SelBipOpen != undefined then
			(
				animationRange = interval 0 1
				biped.loadbipfile $bip01.controller SelBipOpen
			)
			else ()
		)
		else (messagebox"请确认场景中存是否在CS骨骼。"Title:"导入错误")	
	)
	on btn4 pressed do
	(
		if $bip01 !=undefined then
		(
			SelBipsave= getsaveFileName caption:"Open A Test File:" types:"BIP (*.bip)|*.bip|"
			if SelBipsave != undefined then
			(
				biped.saveBipFile $bip01.controller SelBipsave 
			)
			else ()
		)
		else (messagebox"请确认场景中存是否在CS骨骼。"Title:"导出错误")
	)
	on btn15 pressed do
	(
		try(DestroyDialog DC_Bip) Catch()
		rollout DC_Bip "批处理导出Bip" width:307 height:55
		(
			global maxpath,BipPath
			button btn1 "路径" pos:[227,0] width:40 height:20
			button btn2 "OK" pos:[267,0] width:40 height:20
			edittext edt2 "" pos:[-6,-1] width:234 height:20 
			label SaveBipsm "说明：点击【浏览】按钮选择Max文件目录。点【OK】执行！" pos:[6,24] width:307 height:47
			on  DC_Bip open do
			(
				edt2.enabled=false
			)
			on btn1 pressed do
			(
				maxpath=getSavePath caption:"批处理目录"
				selmax="\*.max"
				selmaxpath=maxpath as string + selmax
				edt2.text=maxpath as string
				print selmaxpath
			)
			on btn2 pressed do
			(
				if edt2.text != "" and maxpath != undefined do
				(
					Files = getFiles selmaxpath
					makedir (maxpath as string +"/BIP/")
					BipPath=(maxpath as string +"/BIP/")
					DestroyDialog DC_Bip
					for selm in Files do
					(
						loadMAXFile selm
						BipName=getFilenameFile maxfilename
						BipPostfix=".bip"		
						SaveBipFile=(BipPath + BipName + BipPostfix)
						print SaveBipFile
						selBiparray=#()
						for i in objects do
						(
							if classof i == Biped_Object do append selBiparray i
						)
						----------------------------------------------------------
						for fe = 1 to Files.count  do
						(
							if selBiparray.count == 0 do continue;
							(
								bipeds=$bip01.controller
								if bipeds.figureMode==true do bipeds.figureMode=false
								biped.saveBipFile $bip01.controller SaveBipFile
							)
						)
				)
				resetMaxFile #noPrompt
				messagebox "导出BIP成功！"Title:"完成"	
				)				
			)
		)
		createdialog DC_Bip
	)
	on btn16 pressed do
	(
		for i in objects do
		if classof i == Biped_Object do
		(
			try(DestroyDialog DR_Bip) Catch()
			rollout DR_Bip "批处理导入Bip" width:307 height:55
			(
				global SelBipMaxPath,MaxBipPath
				editText edt1 "" pos:[-6,-1] width:234 height:20
				button btn1 "浏览" pos:[227,0] width:40 height:20
				button btn2 "OK" pos:[267,0] width:40 height:20
				label SaveMaxsm "说明：点击【浏览】按钮选择Bip文件目录。点【OK】执行！" pos:[6,24] width:307 height:47
				on  DR_Bip open do
				(
				edt1.enabled=false
				)
				on btn1 pressed  do
				(
					MaxBipPath=getSavePath caption:"批处理目录" types:"BIP (*.bip)|*.bip|"
					SelBipMax="\*.bip"
					SelBipMaxPath=MaxBipPath as string + selbipmax
					Edt1.text=MaxBipPath as string
					print SelBipMaxPath
				)
				on btn2 pressed  do
				(
					if edt1.text != "" and MaxBipPath != undefined do
					(
						Files = getFiles SelBipMaxPath 
						DestroyDialog DR_Bip
						for F in Files do 
						(
							Bip_MaxName ="/" + getfilenamefile F 
							Bip_MaxPostfix = ".bip" 
							Bip_Maxall = MaxBipPath  + Bip_MaxName + Bip_MaxPostfix 
							print Bip_Maxall
							animationRange = interval 0 1
							biped.loadbipfile $bip01.controller Bip_Maxall
							MaxSaveP=MaxBipPath + Bip_MaxName
							savemaxfile MaxSaveP useNewFile:true quiet:true
						)
						resetMaxFile #noPrompt
						messagebox "导入BIP成功！"Title:"完成"
					)
				)
			)
			createdialog DR_Bip	
		)			
	)
	on btn5 pressed  do
	(
		DestroyDialog DrDc_Bip
	)
)
createdialog DrDc_Bip style:#() Pos:[970,802]
)