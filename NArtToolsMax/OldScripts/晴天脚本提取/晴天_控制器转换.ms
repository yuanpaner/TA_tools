/*
1.01新增：
位置归零，支持多个物体
添加返回按钮，可以让"位置归零"的物体回到原来的位置并连接。
创建初始位置 增加删除按钮
*/
macroScript TransformCtrl
category:"MAX Script Tools"
tooltip:"控制器转换1.01"
buttonText:"控制器转换1.01" 
(

	if TransformCtrl != undefined do
					(
					DestroyDialog TransformCtrl
					)
	
	Sets_Name  		= 		""
	Sets_Num	 		= 		0
	Obj_Point			=		#()
	PointSets			= 		#()
	Default_Setting	=		#()
	Data_Path 		= 		(getDir #Scripts)+"\TransformCtrl.def"
	Data_File 		= 		Openfile Data_Path
	
	
	rollout TransformCtrl "控制器转换1.01" width:160 height:384
	(
		button TransformTCB "转换为TCB" pos:[17,12] width:125 height:24
		button TransformEuler "转换为Euler" pos:[17,44] width:125 height:24
		button TransformZero "位置归零" pos:[76,85] width:66 height:21 toolTip:"旋转和位移归0"	
		checkbox TransformZero_Link "断开" pos:[21,89] width:52 height:16
		button RotationZero "旋转值归零" pos:[17,138] width:125 height:24
		colorPicker Point_Color "" pos:[19,205] width:23 height:19 color:(color 28 28 177) title:"Choose a color"
		spinner Point_Size "" pos:[19,180] width:41 height:16 range:[5,100,5] type:#integer scale:1 	
		button Point_Create "创建初始位置" pos:[53,203] width:88 height:24
		listbox Point_Sets "选择集:" pos:[15,234] width:125 height:6 items:#("None")
		button Point_Recover "恢复位置" pos:[15,346] width:65 height:20
		button Point_Del "删除" pos:[83,346] width:58 height:20
		edittext Sets_InputName "" pos:[63,178] width:76 height:19
		--dropDownList Point_Sets "DropDownList" pos:[5,239] width:89 height:40
		button resetTramform_btn "返回位置" pos:[76,110] width:66 height:21 toolTip:"恢复到归0前的位置，有链接关系的自动连接"
		GroupBox grp1 "" pos:[8,-1] width:144 height:75
		GroupBox grp2 "" pos:[8,72] width:144 height:97
		GroupBox grp3 "" pos:[8,167] width:144 height:205
		button clearInfo "Clear!" pos:[17,110] width:51 height:21 toolTip:"清空选择物体的最后一次链接和位置信息"

	fn FnPrint =
		( 
		undo off
			( 
				Default_Setting[1] 		=		TransformZero_Link.checked 
				Default_Setting[2] 		=		Point_Size.value	
				Default_Setting[3]			= 		Point_Color.color
				Default_Setting[4]			=		Sets_InputName.text
				
				print Default_Setting
				
				Data_File = CreateFile Data_Path
				print Default_Setting to:Data_File
				close Data_File
			)
	    )
		
	fn FnRead =
	    (
		undo off
			(
				i=1
				Data_File = Openfile Data_Path	 	  
				while not(eof Data_File) do
				(
					Default_Setting[i]= readValue Data_File
					i+=1
				)
				TransformZero_Link.checked 		= 		Default_Setting[1]
				Point_Size.value				=		Default_Setting[2]
				Point_Color.color				=		Default_Setting[3]
				Sets_InputName.text			=		Default_Setting[4]
	
			)
	     )
			 
	
		
	fn CheckSets =
	(
		
		Sets_Name = "_"+Sets_InputName.text+"000"
		for i = 1 to getNumNamedSelSets() do
		(
			if (getNamedSelSetName i) == "初始位置"+Sets_Name do
			(
			     Sets_Num = Sets_Num + 1
				if Sets_Num < 10 then Sets_Name= "_"+Sets_InputName.text+"00"+ Sets_Num as string
				else if Sets_Num<100 then Sets_Name= "_"+Sets_InputName.text+"0"+ Sets_Num as string
				else Sets_Name= "_"+Sets_InputName.text+Sets_Num as string	
				i = 1		 
			)
			
		)
		--print ("Sets_Name="+Sets_Name as string)
	)
	
	fn Point_Refresh =
	(
		PointSets		= 		#()
		PointList		=		#()
		Point_Sets.items =		#()
		x=1
		for i = 1 to getNumNamedSelSets() do
		(
			if matchPattern (getNamedSelSetName i) pattern:"初始位置*" do
			(
				PointSets[x] = i
				PointList[x] = (getNamedSelSetName PointSets[x]) as string
				x=x+1
			)
		)
		Point_Sets.items = PointList
		
		Obj_Point = #()
		if Pointsets.count> 0 do
		(	
			--print Point_Sets.selection
			if Point_Sets.selection == 0 do Point_Sets.selection = Point_Sets.items.count
			for i = 1 to getNamedSelSetItemCount Pointsets[Point_Sets.selection] do 
				Obj_Point[i] = getNamedSelSetItem Pointsets[Point_Sets.selection] i
		)
		--select Obj_Point
	)

		on TransformCtrl open do
		(
			if Data_File == undefined then
			(
				Default_Setting[1] 		= 		false 
				Default_Setting[2] 		= 		30
				Default_Setting[3] 		= 		(color 28 28 177)
				Default_Setting[4] 		= 		""
				FnPrint() 
			)
			else FnRead()
			
			CheckSets()
			Point_Refresh()
		
		)
		on TransformCtrl close do
		(	
			FnPrint()
		)
		on TransformTCB pressed do
		(
			undo on
			(
				if $ != undefined then
					(  
					if $[1].name == "Visibility" then $.rotation.controller = TCB_Rotation()
				else
					for i = 1 to $.count do $[i].rotation.controller = TCB_Rotation()
					)
			)
		)
		on TransformEuler pressed do
		(
			undo on
			(
				if $ != undefined then
				(  
					if $[1].name == "Visibility" then $.rotation.controller = Euler_XYZ()
						else
							for i = 1 to $.count do $[i].rotation.controller = Euler_XYZ()
				)
			)
		)
		on TransformZero pressed do
		(
			undo on
				(
					if $ != undefined then
					(  
						for i in selection do
						(
							if i.parent != undefined do
							(
							setAppData i 1 i.parent.name
							--setAppData i 2 ((in coordSys parent i.pos) as string)
							--setAppData i 3 ((in coordSys parent i.rotation) as string)
							)
							setAppData i 2 (i.transform as string)
							i.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
							/*
							i.pos.x 					=	0
							i.pos.y					=	0
							i.pos.z					=	0
							i.rotation.x_rotation 		=	0
							i.rotation.y_rotation 		=	0
							i.rotation.z_rotation 		=	0
							*/
							if TransformZero_Link.checked do i.parent = undefined		
						)
					)
				)
		)
		on TransformZero_Link changed state do
		(
			print state
		)
		on RotationZero pressed do
		(
			undo on
			(
				obj=#()
				i=1
				for o in selection do 
					(				
					obj[i] = o
					i=i+1
					)
		
				for i = 1 to obj.count do
				(
					select obj[i]
					Rota_Y = $.rotation.y_rotation 
					Rota_Z = $.rotation.z_rotation
					Rota_X = $.rotation.x_rotation 
				
					actionMan.executeAction 0 "40180" 
				
		
					$.rotation.y_rotation = Rota_Y
					$.rotation.z_rotation = Rota_Z
					$.rotation.x_rotation = Rota_X
					
					
				)
			)
			select obj
		)
		on Point_Create pressed do
		(
			AnimButton = false
			if animButtonState then
			(
				AnimButton = true
				animButtonState = false
			)
			undo on 
			(
				Obj 				= 		#()
				Obj_Point			=		#()
				if selection.count > 0 then
				(
					i=1
					for o in selection do 
					(				
						Obj[i] = o
						i=i+1
					)
		
					
				)
				else 
				(
					messagebox ("没有选择物体")
					return()
				)
				
				--创建辅助点
				for i=1 to Obj.count do
				(
		 			Obj_Pos = Obj[i].transform
					Obj_Point[i] = Point  centermarker:on cross:off transform:(Obj_Pos) size:Point_Size.value name:(Obj[i].name+"_初始位置") wirecolor:Point_Color.color
				)
				
				--编组
				CheckSets()
				selectionSets["初始位置"+Sets_Name] = Obj_Point
				select Obj_Point
				Obj_Point=#()
				
			)
			Point_Sets.selection = Point_Sets.items.count+1
			Point_Refresh()
			animButtonState = AnimButton
		)
		on Point_Sets selected sel do
		(
			CheckSets()
			Point_Refresh()
			select Obj_Point
		)
		on Point_Recover pressed do
		(
			AnimButton = true
			
			if animButtonState == false then
			(
				AnimButton = false
				animButtonState = true
			)
			undo on
			(
				Obj=#()
				for i = 1 to Obj_Point.count do	
				(
					Obj[i] = getNodeByName (substring Obj_Point[i].name 1 (Obj_Point[i].name.count-5))
					if Obj[i] == undefined do
					(
						undo off	select Obj_Point[i]
						messageBox ("错误!和虚拟体 \""+Obj_Point[i].name+"\" 对应的骨骼 \""+(substring Obj_Point[i].name 1 (Obj_Point[i].name.count-5))+"\" 不存在 请检查文件名")		
						return()
					)
				)
				i=1
				while Obj.count >= 1 do
				(	
					if Obj[i] == undefined do exit
					--TestParent[i] = if Obj[i].parent != undefined do matchPattern (Obj as string) pattern:("*"+Obj[i].parent.name as string+"*") 
					--print ("obj"+i as string+"="+obj[i] as string)
					if Obj[i].parent == undefined then  --判断需要对齐物体父物体是否存在 并且是否包含在所选集合中(对齐动作必须由上至下进行)		
						TestParent = 0
					else TestParent = findItem Obj Obj[i].parent
					if TestParent == 0 then
					(
						--print ("obj.count="+obj.count as string)
						--辅助点到骨骼的形态复制
						Obj[i].transform = Obj_Point[i].transform
						--从骨骼列表中除去已经计算过的部分
						deleteitem Obj i		
						deleteitem Obj_Point i
					)
					else i=i+1
					if i > Obj.count do i= 1
				)						
			)
			animButtonState = AnimButton
			clearSelection()
		)
		on Point_Del pressed do
		(
			undo on
			(
			CheckSets()
			--Point_Refresh()
			select Obj_Point
			max delete 
			Point_Refresh()
			)
		)
		on resetTramform_btn pressed do
		(
			try
			(
				for i in selection do
				(
					oParentName = getAppData i 1
					if oParentName != undefined then
					(
					oParent = getNodeByName oParentName
					i.parent = oParent
					i.transform = i.parent.transform
					--in coordsys parent move i (execute(getAppData i 2))
					--in coordsys parent rotate i (execute(getAppData i 3))
					)
					else i.transform = execute(getAppData i 2)
				)
			)
			catch()
		)
		on clearInfo pressed do
		(
			try
			(
				for i in selection do 
				(
					deleteAppData i 1
					deleteAppData i 2
				)
			)
			catch()
		)
	)

CreateDialog TransformCtrl
)
