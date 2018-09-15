macroScript AlignTool
category:"MAX Script Tools"
tooltip:"AlignTool"
buttonText:"AlignTool"
(
global Floater_Align,AlignToolFloater
Obj_ViewSelected as string
Obj_Source 			= 		#()	
obj_Target 			= 		#()
Obj_Source_Name 	=		#()
obj_Target_Name		=		#()
Default_Setting		=		#()
Obj_ViewSelected	= 		"SourceName"
Data_Path 			= 		(getDir #Scripts)+"\AlignTool.ini"
Data_File 			= 		Openfile Data_Path

fn FnPrint =
	( 
	undo off
		( 			
			Data_File = CreateFile Data_Path
			print Default_Setting to:Data_File
			close Data_File
		)
    )
	
fn FnRead =
    (
	undo off
		(		
			Data_File = Openfile Data_Path
			try	Default_Setting[1]= readValue Data_File
			catch Default_Setting[1] = #("None")
			if Data_File == undefined or Default_Setting[1][1]!="AlignTools_2.1b" then 
			(	
				Default_Setting[1]			=		#("AlignTools_2.1b")
				Default_Setting[2]			=		#([270,427], [630,100], true)
				Default_Setting[3] 			=		#(0,0)
				Default_Setting[4] 			=		#(false,false,true,false,false,false)
				Default_Setting[5]			= 		#(true,true,true)
				Default_Setting[6]			= 		#(true,true,true)
				Default_Setting[7]			= 		#(true,true,true)
				Default_Setting[8]			= 		#()
				Default_Setting[9]			= 		#()
				FnPrint() 
			)
			else
			(
	  			i=2
				while not(eof Data_File) do
				(
					Default_Setting[i]= readValue Data_File
					i+=1
				)
			)			
		)
     )

--在运行界面之前读入初始设置 便于窗口大小和位置的初始化
FnRead()

rollout Floater_Align "AlignTool 2.1a" width:275 height:400
(
	label Obj_SourceSign "源物体列表" pos:[12,5] width:89 height:17 enabled:false
	listbox Obj_SourceName "" pos:[7,22] width:100 height:11 readOnly:false
	checkbutton Pick_Source "拾取源物体" pos:[12,180] width:71 height:25 toolTip:"拾取源物体 按鼠标右键退出拾取"
	label lb_Source "0 objects" pos:[88,187] width:54 height:14
	label Obj_TargetSign "目标物体列表" pos:[157,5] width:92 height:17 enabled:false
	listbox Obj_TargetName "" pos:[153,22] width:100 height:11 readOnly:false
	checkbutton Pick_Target "拾取目标" pos:[145,180] width:71 height:25 toolTip:"拾取目标物体 按鼠标右键退出拾取"
	label lb_Target "0 objects" pos:[218,187] width:51 height:13
	button btn_Up "↑" pos:[115,17] width:30 height:22 toolTip:"列表所选项目上移一行"
	button btn_Delete "Del" pos:[115,42] width:30 height:22 toolTip:"删除列表所选项目"
	button btn_Down "↓" pos:[115,68] width:30 height:22 toolTip:"列表所选项目下移一行"
	button btn_Clear "Clr" pos:[115,95] width:30 height:22 toolTip:"清空列表"
	button btn_Swap "Swap" pos:[115,122] width:30 height:22 toolTip:"交换列表中的项目"
	checkbox Check_Swap "只换选中" pos:[110,146] width:43 height:28
	spinner Frame_Start "" pos:[21,223] width:49 height:16 range:[0,9999,0] type:#integer scale:1 
	spinner Frame_Stop "" pos:[21,249] width:49 height:16 range:[0,9999,0] type:#integer scale:1 
	button Frame_PickStart "起始帧" pos:[76,221] width:50 height:22 toolTip:"设定当前时间为起始帧"
	button Frame_PickStop "结束帧" pos:[75,247] width:50 height:22 toolTip:"设定当前时间为结束帧"
	checkbox Check_AlignSel "只对齐选中" pos:[136,216] width:115 height:18 
	checkbox Check_AlignMulti "对齐到多个目标" pos:[136,234] width:116 height:18 
	checkbox Check_AlignOnce "只对齐父物体" pos:[136,252] width:115 height:18
	checkbox Check_FullKey "逐帧写入" pos:[177,294] width:72 height:18 
	GroupBox grp1 "" pos:[15,206] width:238 height:71
	label lbl9 "_____________________________" pos:[22,345] width:146 height:19 enabled:false
	button Pos_lb "位移" pos:[23,293] width:32 height:17 toolTip:"同时改变位移三个轴的勾选"
	checkbox Pos_X "X" pos:[62,294] width:32 height:16 
	checkbox Pos_Y "Y" pos:[101,294] width:32 height:16 
	checkbox Pos_Z "Z" pos:[140,294] width:32 height:16 
	button Rotation_lb "旋转" pos:[23,313] width:32 height:17 toolTip:"同时改变旋转三个轴的勾选"
	checkbox Rotation_X "X" pos:[62,314] width:32 height:16 
	checkbox Rotation_Y "Y" pos:[101,314] width:32 height:16 
	checkbox Rotation_Z "Z" pos:[140,314] width:32 height:16 
	button Scale_lb "缩放" pos:[23,334] width:32 height:17 toolTip:"同时改变缩放三个轴的勾选"
	checkbox Scale_X "X" pos:[62,335] width:32 height:16 
	checkbox Scale_Y "Y" pos:[101,335] width:32 height:16 
	checkbox Scale_Z "Z" pos:[140,335] width:32 height:16 
	button Align_go "开始对齐" pos:[178,337] width:61 height:47 toolTip:"" widthe:88
	GroupBox grp2 "" pos:[14,279] width:238 height:112
	button Setting_SaveAS "另存设置" pos:[28,363] width:55 height:22 toolTip:"将设置文件另存为其它文件"
	button Setting_LoadAS "读取设置" pos:[101,363] width:55 height:22 toolTip:"读取设置文件并更新设置"
	checkbox RlinkL_chk "右←左" pos:[176,312] width:72 height:18 
	
fn Obj_NameIO Obj_Array AssessType =
(
	if AssessType == "Input" do
	(
		--Obj_Array = #()		
		case Obj_Array of
		(
			Obj_Source:	Obj_Temp_Name 	=	Obj_Source_Name
			Obj_Target:	Obj_Temp_Name 	=	Obj_Target_Name
		)
		for x = 1 to Obj_Temp_Name.count do
		(
			Obj_Temp	= #()
			for y = 1 to Obj_Temp_Name[x].count do
			(
				
				if Obj_Temp_Name[x][y] == undefined and Obj_Array.count !=0 then
				(
					case Obj_Array of
					(
						Obj_Source:	messagebox "Error:源物体列表中的物件不存在"
						Obj_Target:	messagebox "Error:目标物体列表中的物件不存在"
					)
					return()
				)
				else Obj_Temp[y] = getnodebyname Obj_Temp_Name[x][y]
			)		
			Obj_Array[x]=Obj_Temp
		)
	)
	if AssessType == "Output" do
	(	
		case Obj_Array of
		(
			Obj_Source:	Obj_Source_Name	=	#()
			Obj_Target:	Obj_Target_Name 	=	#()
		)
		for x = 1 to Obj_Array.count do	
		(
			Obj_Temp	= #()
			for y = 1 to Obj_Array[x].count do
			(
			 	if Obj_Array[x][y] != undefined do Obj_Temp[y]=Obj_Array[x][y].name
			)
			case Obj_Array of
			(
				Obj_Source:	Obj_Source_Name[x] 	=	Obj_Temp
				Obj_Target:	Obj_Target_Name[x] 	=	Obj_Temp
			)
		)
	)
)

fn Default_IO IO_Class=
(
	if IO_Class == "Input" do
	(
		try 
		(
			Floater_Align.open				= 		Default_Setting[2][3]
			Frame_Start.value				= 		Default_Setting[3][1]
			Frame_Stop.value 				= 		Default_Setting[3][2]
			Check_AlignSel.checked			=		Default_Setting[4][1]
			Check_AlignMulti.checked		=		Default_Setting[4][2]
			Check_FullKey.checked			=		Default_Setting[4][3]
			Check_AlignOnce.checked			=		Default_Setting[4][4]
			Check_Swap.checked				=		Default_Setting[4][5]
			Pos_X.checked					=		Default_Setting[5][1]
			Pos_Y.checked					=		Default_Setting[5][2]
			Pos_Z.checked					=		Default_Setting[5][3]
			Rotation_X.checked				=		Default_Setting[6][1]
			Rotation_Y.checked				=		Default_Setting[6][2]
			Rotation_Z.checked				=		Default_Setting[6][3]
			Scale_X.checked				=		Default_Setting[7][1]
			Scale_Y.checked				=		Default_Setting[7][2]
			Scale_Z.checked				=		Default_Setting[7][3]
			Obj_Source_Name				=		Default_Setting[8]
			obj_Target_Name				=		Default_Setting[9]
			RlinkL_chk.enabled				=		Default_Setting[4][4]
			RlinkL_chk.checked				=		Default_Setting[4][6]
			Obj_NameIO Obj_Source "Input"
			Obj_NameIO Obj_Target "Input"	
		)	
		catch()

	)
	if IO_Class == "Output" do
	(
		Obj_NameIO Obj_Source "Output"
		Obj_NameIO Obj_Target "Output"	
		Default_Setting[2] 			=		#(AlignToolFloater.size,AlignToolFloater.pos,Floater_Align.open)
		Default_Setting[3] 			=		#(Frame_Start.value,Frame_Stop.value)
		Default_Setting[4] 			=		#(Check_AlignSel.checked,Check_AlignMulti.checked,Check_FullKey.checked,Check_AlignOnce.checked,Check_Swap.checked,RlinkL_chk.checked)
		Default_Setting[5]				= 		#(Pos_X.checked,Pos_Y.checked,Pos_Z.checked)
		Default_Setting[6]				= 		#(Rotation_X.checked,Rotation_Y.checked,Rotation_Z.checked)
		Default_Setting[7]				= 		#(Scale_X.checked,Scale_Y.checked,Scale_Z.checked)	
		Default_Setting[8]				=		Obj_Source_Name
		Default_Setting[9]				=		Obj_Target_Name
	)
)
	
fn RefreshView =
(	
	try
	(

		--print ("Obj_Source.count = "+Obj_Source.count as string)
		--print ("Obj_Target.count = "+Obj_Target.count as string)
		--if Obj_Source.count!=0 do print Obj_Source[Obj_Source.count][1]
		--if Obj_target.count!=0 do print obj_target[obj_target.count][1]	
		Obj_Source = #()
		Obj_Target = #()	
		--print obj_source_name
		x=1
		while x <= Obj_Source_Name.count do 
		(	
			obj_Temp=#()
			--print ("x="+x as string)
			--print Obj_Source_Name[x][1]
			if (getnodebyname Obj_Source_Name[x][1]) != undefined then
			(
				y = 1
				while y <= Obj_Source_Name[x].count do
				(
					--检查Obj_Source_Name中的字符对应的物件是否存在 否则删除
					if (getnodebyname Obj_Source_Name[x][y] != undefined) then
					(
						Obj_Temp[y] = getnodebyname Obj_Source_Name[x][y]
						y = y+1	
					)
					else deleteItem Obj_Source_Name[x] y
				)
				Obj_Source[x] = Obj_Temp
				x= x+1
			)
			else deleteItem Obj_Source_Name x
		)
		--print Obj_Source
		Obj_ViewName = #()
		for i = 1 to Obj_Source.count do 
		(
			if Obj_Source[i][1] != undefined then 
			(

				Obj_ViewName[i] = Obj_Source[i][1].name
				)
			else Obj_Source =#()
		)
		Obj_SourceName.items = Obj_ViewName
		x=1
		while x <= Obj_Target_Name.count do 
		(	
			obj_Temp=#()
			if (getnodebyname Obj_Target_Name[x][1]) != undefined then
			(
				y = 1
				while y <= Obj_Target_Name[x].count do
				(
					--检查Obj_Target_Name中的字符对应的物件是否存在 否则删除
					if (getnodebyname Obj_Target_Name[x][y] != undefined) then
					(
						Obj_Temp[y] = getnodebyname Obj_Target_Name[x][y]
						y = y+1	
					)
					else deleteItem Obj_Target_Name[x] y
				)
				Obj_Target[x] = Obj_Temp
				x= x+1
			)
			else deleteItem Obj_Target_Name x
		)	
		--print Obj_Target
		Obj_ViewName = #()
		for i = 1 to obj_Target.count do 
		(
			if obj_Target[i][1] != undefined then Obj_ViewName[i] = obj_Target[i][1].name
			else Obj_Target = #()
		)
		Obj_TargetName.items = Obj_ViewName

	)
	catch
	(
		messagebox "Error 1:列表中的物体不存在 请更新列表"
		return()
	)

	if Obj_SourceName.selection > Obj_Source.count or Obj_SourceName.selection == 0 do 
		Obj_SourceName.selection = Obj_Source.count
	if Obj_TargetName.selection > obj_Target.count or Obj_TargetName.selection == 0 do 
		Obj_TargetName.selection = obj_Target.count
	try
	(
		case Obj_ViewSelected of
		(
		"SourceName"	:	Obj_TargetName.selection = Obj_SourceName.selection
		"TargetName"	:	Obj_SourceName.selection = Obj_TargetName.selection
		)
	)
	catch()	
	try
	(
		if Obj_Source.count != 0 then
			lb_Source.text = Obj_Source[Obj_SourceName.selection].count as string +" objects"
		else lb_Source.text = "0 objects"
		if obj_Target.count != 0 then
			lb_Target.text = obj_Target[Obj_TargetName.selection].count as string +" objects"
		else lb_Target.text = "0 objects"
	)
	catch()
)


fn Checkbone obj_Selected =
(
	i = 1
	obj = #()
	obj_Name = #()
	obj[i]=obj_Selected
	while obj[i].children.count != 0 do
	(
		i = i+1
		--if obj[i-1].children.count == 1 then
		--(
			obj[i]=obj[i-1].children[1]	
	--	)
	--	else
	--	(
			--messagebox "不支持同时链接多个子物体 骨骼链分叉以下部分不被选中"
			--exit
			
	--	)
	)
	selectMore obj
	for i = 1 to Obj.count do Obj_Name[i] = obj[i].name	
	return Obj_Name
)

--Pick_Obj Obj_SourceName Obj_Source
fn Pick_Obj Pick_Class Obj_Array_Name  =
(
	Floater_Align.Pick_source.enabled 		= false
	Floater_Align.Pick_Target.enabled 		= false
	Floater_Align.Obj_SourceName.enabled		= false
	Floater_Align.Obj_TargetName.enabled 		= false
	Floater_Align.btn_Up.enabled 			= false
	Floater_Align.btn_Delete.enabled 		= false
	Floater_Align.btn_Down.enabled 			= false	
	Floater_Align.btn_Clear.enabled			= false
	clearSelection()
	obj_Pick=#()
	Obj_ViewName = #()	
	while true do
	(		
		Pick = pickObject forceListenerFocus:false		
		if Pick == undefined or Pick == #escape do exit
		Pick_Obj_index = Obj_Array_Name.count+1	
		--print ("Pick_Obj_index="+ Pick_Obj_index as string)
		--print ("Obj_Array.count="+ obj_Array.count as string)	
		if not (matchPattern (Obj_Array_Name as string) pattern:("*"+Pick.name+"*")) do -- 判断同一个物件是否拾取两次
		(
			Obj_Array_Name[Pick_Obj_index] = Checkbone Pick
			selectMore Pick
			Pick_Class.selection = Obj_Array_Name.count
			RefreshView()
		)
	)
	Floater_Align.Pick_source.enabled 		= true
	Floater_Align.Pick_Target.enabled 		= true
	Floater_Align.Obj_SourceName.enabled		= true
	Floater_Align.Obj_TargetName.enabled 		= true
	Floater_Align.btn_Up.enabled 			= true
	Floater_Align.btn_Delete.enabled 		= true
	Floater_Align.btn_Down.enabled 			= true
	Floater_Align.btn_Clear.enabled			= true	
	Floater_Align.Pick_Source.checked		= false
	Floater_Align.Pick_Target.checked 		= false

)


fn Obj_NameOder Pick_Class OderType=
(	
	Obj_ArrayTemp = #()
	
	--print Pick_Class
	
	if Pick_Class != undefined do
	(
		case Pick_Class of
		(
			"SourceName"	:	(Pick_Class = Obj_SourceName; Obj_Array = Obj_Source_Name )
			"TargetName"	:	(Pick_Class = Obj_TargetName; Obj_Array = Obj_Target_Name )
		)
		if Pick_Class.selection + OderType > 0 and Pick_Class.selection + OderType <= Pick_Class.items.count do
		(
			Obj_ArrayTemp[1] 							= Obj_Array[Pick_Class.selection]
			Obj_ArrayTemp[2] 							= Obj_Array[Pick_Class.selection + OderType]
			Obj_Array[Pick_Class.selection] 				= Obj_ArrayTemp[2]
			Obj_Array[Pick_Class.selection + OderType] 	= Obj_ArrayTemp[1]
			Pick_Class.selection 						= Pick_Class.selection + OderType
		)
		if OderType == 0 and Obj_Array.count !=0 do deleteItem Obj_Array Pick_Class.selection
		RefreshView()
	)
)





	on Floater_Align open do
	(
		Obj_Source 			= 	#()	
		obj_Target 			= 	#()
		Default_IO "Input"
		RefreshView()
		if Check_FullKey.checked == false do
		(
			Frame_Start.enabled = false
			Frame_Stop.enabled = false
			Frame_PickStart.enabled = false
			Frame_PickStop.enabled = false
		)
	)
	on Floater_Align close do
	(	
		Default_IO "Output"
		FnPrint()
	)
	on Obj_SourceName selected sel do
	(	
		Obj_SourceSign.enabled = true
		Obj_TargetSign.enabled = false
		Obj_ViewSelected = "SourceName"
		RefreshView()
		select Obj_Source[sel]
	)
	on Pick_Source changed state do
	(	
		RefreshView()
		Obj_SourceSign.enabled = true
		Obj_TargetSign.enabled = false
		Obj_ViewSelected = "SourceName"
		Pick_Obj Obj_SourceName Obj_Source_Name	
	)
	on Obj_TargetName selected sel do
	(	
		Obj_SourceSign.enabled = false
		Obj_TargetSign.enabled = true
		Obj_ViewSelected = "TargetName"
		RefreshView()
		select Obj_Target[sel]
		
	)
	on Pick_Target changed state do
	(	
		RefreshView()
		Obj_SourceSign.enabled = false
		Obj_TargetSign.enabled = true
		Obj_ViewSelected = "TargetName"
		Pick_Obj Obj_TargetName obj_Target_Name
	)
	on btn_Up pressed do
		Obj_NameOder Obj_ViewSelected -1
	on btn_Delete pressed do
		Obj_NameOder Obj_ViewSelected 0
	on btn_Down pressed do
		Obj_NameOder Obj_ViewSelected 1
	on btn_Clear pressed do
	(
		Obj_Source_Name = #()
		Obj_Target_Name = #()
		RefreshView()
	)
	on btn_Swap pressed do
	(
		if Check_Swap.checked then 
		(
			case Obj_ViewSelected of
			(
				"SourceName"	:	SwapSelection = Obj_SourceName.selection
				"TargetName"	:	SwapSelection = Obj_TargetName.selection
			)
			--print (" SwapSelection = "+ SwapSelection as string)
			if  SwapSelection!=0 do
			(
				if Obj_Source[SwapSelection] != undefined and Obj_Target[SwapSelection] != undefined do 
				(
					--break()
					swap Obj_Source_Name[SwapSelection] Obj_Target_Name[SwapSelection]
			 	)
			)
		)
		else 
		(
			try swap Obj_Source_Name Obj_Target_Name
			catch()
		)
		RefreshView()
	)
	on Frame_PickStart pressed do
	(
		if Frame_Stop.value != undefined do 
			if (int slidertime) >= Frame_Stop.value then Frame_Start.value = Frame_Stop.value
			else Frame_Start.value =int slidertime
		
	)
	on Frame_PickStop pressed do
	(
		if Frame_Start.value != undefined do 
			if (int slidertime) <= Frame_Start.value then Frame_Stop.value = Frame_Start.value
			else Frame_Stop.value =int slidertime
	)
	on Check_AlignSel changed state do
		if state do Check_AlignMulti.checked = false
	on Check_AlignMulti changed state do
		if state do Check_AlignSel.checked = false
	on Check_AlignOnce changed state do
	(
	 RlinkL_chk.enabled = state
	)
	on Check_FullKey changed state do
	(
		Frame_Start.enabled = state
		Frame_Stop.enabled = state
		Frame_PickStart.enabled = state
		Frame_PickStop.enabled = state
	)
	on Pos_lb pressed do
	(
		if Pos_X.checked or Pos_Y.checked or Pos_Z.checked then
			(Pos_X.checked = false;Pos_Y.checked = false;Pos_Z.checked = false)
		else	(Pos_X.checked = true;	Pos_Y.checked = true;Pos_Z.checked = true)
	)
	on Rotation_lb pressed do
	(
		if Rotation_X.checked or Rotation_Y.checked or Rotation_Z.checked then
			(Rotation_X.checked = false;Rotation_Y.checked = false;Rotation_Z.checked = false)
		else	(Rotation_X.checked = true;Rotation_Y.checked = true;Rotation_Z.checked = true)
	)
	on Scale_lb pressed do
	(
		if Scale_X.checked or Scale_Y.checked or Scale_Z.checked then
			(Scale_X.checked = false;Scale_Y.checked = false;Scale_Z.checked = false)
		else	(Scale_X.checked = true;Scale_Y.checked = true;Scale_Z.checked = true)	
	)
	on Align_go pressed do
	(	
		FnPrint()
		RefreshView()
		AnimButton = true	
		if animButtonState == false then
		(
			AnimButton = false
			animButtonState = true
		)
		undo on 
		(
			Obj_TargetBasic = #(#())
			Obj_Index=1
			Obj_subIndex_Start =1
			if Check_AlignSel.checked then 
			(
				Obj_index_Start = Obj_SourceName.selection
				Obj_index_Stop = Obj_SourceName.selection			
			)
			
			else 
			(
				Obj_index_Start = 1
				Obj_index_Stop = Obj_Target.count
			)
			if Check_AlignMulti.checked do Obj_index_Stop = Obj_Target.count
			if Check_FullKey.state == true then
			(
				for i= Frame_Start.value to Frame_Stop.value do
				(	
		
					for Obj_Index = Obj_index_Start  to Obj_index_Stop do
					(				
						
						if  Check_AlignMulti.checked then 
						(
							Obj_Index_Source = Obj_SourceName.selection
							if  Obj_Index > Obj_Target.count  do exit
						)
						else 
						(
							Obj_Index_Source = Obj_Index
							if  Obj_Index > Obj_Source.count  do exit
						)
						--try 
						(	
							if Check_AlignOnce.checked then 
							(
								Obj_subIndex_Stop = 1
								if RlinkL_chk.checked do Obj_Target[Obj_Index][1].parent = Obj_Source[Obj_Index_Source][1]
							)
							else  Obj_subIndex_Stop = Obj_Target[Obj_Index].count
							for Obj_subIndex_Start = 1 to Obj_subIndex_Stop do
							(	
								if  Obj_subIndex_Start > Obj_Target[Obj_Index_Source].count or Obj_subIndex_Start > Obj_Source[Obj_Index_Source].count then exit	
								sliderTime = i
								if Rotation_X.checked 		do Obj_Target[Obj_Index][Obj_subIndex_Start].rotation.x_rotation		=	Obj_Source[Obj_Index_Source][Obj_subIndex_Start].rotation.x_rotation 
								if Rotation_Y.checked 		do Obj_Target[Obj_Index][Obj_subIndex_Start].rotation.y_rotation		=	Obj_Source[Obj_Index_Source][Obj_subIndex_Start].rotation.y_rotation
								if Rotation_Z.checked 		do Obj_Target[Obj_Index][Obj_subIndex_Start].rotation.z_rotation		=	Obj_Source[Obj_Index_Source][Obj_subIndex_Start].rotation.z_rotation
								if Pos_X.checked 			do Obj_Target[Obj_Index][Obj_subIndex_Start].pos.x					=	Obj_Source[Obj_Index_Source][Obj_subIndex_Start].pos.x
								if Pos_Y.checked 			do Obj_Target[Obj_Index][Obj_subIndex_Start].pos.y					=	Obj_Source[Obj_Index_Source][Obj_subIndex_Start].pos.y
								if Pos_Z.checked 			do Obj_Target[Obj_Index][Obj_subIndex_Start].pos.z					=	Obj_Source[Obj_Index_Source][Obj_subIndex_Start].pos.z
								if Scale_X.checked 		do Obj_Target[Obj_Index][Obj_subIndex_Start].Scale.x				=	Obj_Source[Obj_Index_Source][Obj_subIndex_Start].Scale.x
								if Scale_Y.checked 		do Obj_Target[Obj_Index][Obj_subIndex_Start].Scale.y				=	Obj_Source[Obj_Index_Source][Obj_subIndex_Start].Scale.y
								if Scale_Z.checked 		do Obj_Target[Obj_Index][Obj_subIndex_Start].Scale.z				=	Obj_Source[Obj_Index_Source][Obj_subIndex_Start].Scale.z
							)
							
	
						)
						--catch
						(
							--messagebox "Error 2:列表中的物体不存在 请更新列表"
							--return()
						)
					)					
				)						
			)
			else
			(
				for Obj_Index = Obj_index_Start  to Obj_index_Stop do
				(
					if  Obj_Index > Obj_Target.count do exit			
					if  Check_AlignMulti.checked then Obj_Index_Source = Obj_SourceName.selection
					else Obj_Index_Source = Obj_Index
					try
					(
						if Check_AlignOnce.checked then 
						(
							Obj_subIndex_Stop = 1
							if RlinkL_chk.checked do Obj_Target[Obj_Index][1].parent = Obj_Source[Obj_Index_Source][1]
						)
						else  Obj_subIndex_Stop = Obj_Target[Obj_Index_Source].count
						for Obj_subIndex_Start = 1 to Obj_subIndex_Stop do
						(	
							if  Obj_subIndex_Start > Obj_Target[Obj_Index_Source].count or Obj_subIndex_Start > Obj_Source[Obj_Index_Source].count then exit			
							Key_Pos = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].pos.controller.keys
							Key_Rotation = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].rotation.controller.keys
							Key_Scale = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].scale.controller.keys
							if Obj_Target[Obj_Index][Obj_subIndex_Start] == undefined do exit
						
							for i = 1 to Key_Rotation.count do
							(
								sliderTime = Key_Rotation[i].time
								if Rotation_X.checked do Obj_Target[Obj_Index][Obj_subIndex_Start].rotation.x_rotation = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].rotation.x_rotation 
								if Rotation_Y.checked do Obj_Target[Obj_Index][Obj_subIndex_Start].rotation.y_rotation = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].rotation.y_rotation
								if Rotation_Z.checked do Obj_Target[Obj_Index][Obj_subIndex_Start].rotation.z_rotation = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].rotation.z_rotation
							)							
							for i = 1 to Key_Pos.count do
							(
								sliderTime = Key_Pos[i].time
								if Pos_X.checked do Obj_Target[Obj_Index][Obj_subIndex_Start].pos.x = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].pos.x
								if Pos_Y.checked do Obj_Target[Obj_Index][Obj_subIndex_Start].pos.y = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].pos.y
								if Pos_Z.checked do Obj_Target[Obj_Index][Obj_subIndex_Start].pos.z = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].pos.z
							)
							for i = 1 to Key_Scale.count do
							(
								sliderTime = Key_Scale[i].time
								if Scale_X.checked do Obj_Target[Obj_Index][Obj_subIndex_Start].Scale.x = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].Scale.x
								if Scale_Y.checked do Obj_Target[Obj_Index][Obj_subIndex_Start].Scale.y = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].Scale.y
								if Scale_Z.checked do Obj_Target[Obj_Index][Obj_subIndex_Start].Scale.z = Obj_Source[Obj_Index_Source][Obj_subIndex_Start].Scale.z
							)
							
						)
					)
					catch
					(
						messagebox "Error 3:列表中的物体不存在 请更新列表"
						return()
					)
				)
			)		
		)
		animButtonState = AnimButton	
	)
	on Setting_SaveAS pressed do
	(
		try
		( 	
			Default_IO "Output"
			NewPath 		=		getSaveFileName caption:"存储设置文件为:" types:"Data(*.dat)|*.dat"
			Data_File 	= 		CreateFile NewPath
			print Default_Setting to:Data_File
			close Data_File
		)
		catch ()
	)
	on Setting_LoadAS pressed do
	(
		try
		( 
			Obj_Source 	= 		#()	
			obj_Target 	= 		#()
			i 			= 		1
			NewPath 		=		getOpenFileName caption:"读取设置文件:" types:"Data(*.dat)|*.dat"
			Data_File 	= 		Openfile NewPath
			while not(eof Data_File) do
			(
				Default_Setting[i]= readValue Data_File
				i+=1
			)
			Default_IO "Input"		
			RefreshView()
		)
		catch ()
	)
)



rollout BipedCOM_align_Rollout "Biped 质心对齐工具" width:256 height:204
(
	checkbox unlink_chk "断开连接" pos:[168,73] width:75 height:16
	pickbutton pickObj_btn "拾取物体" pos:[18,28] width:138 height:30 toolTip:"拾取要被对齐的物体"
	local startFrame = animationRange.start
	spinner startFrame_spn "" pos:[16,133] width:50 height:16 range:[-1000,1000,startFrame] type:#integer scale:1
	button startFrame_btn "起始帧" pos:[72,132] width:49 height:18
	local endFrame = animationRange.end
	spinner endFrame_spn "" pos:[136,132] width:50 height:16 range:[-1000,1000,endFrame] type:#integer scale:1
	button endFrame_btn "结束帧" pos:[192,131] width:49 height:18
	GroupBox grp1 "时间范围" pos:[8,106] width:240 height:56
	button align_btn "开始对齐" pos:[164,168] width:83 height:25
	checkbox Pos_chk "位置" pos:[168,25] width:49 height:16 checked:true
	checkbox Rot_chk "旋转" pos:[168,49] width:49 height:16 checked:true
	GroupBox grp2 "对齐信息" pos:[8,9] width:240 height:86
	button clear_btn "Clear!" pos:[18,66] width:45 height:21 toolTip:"拾取要被对齐的物体"
	label info_lbl "" pos:[68,61] width:97 height:30
	label help_lbl "1. 选择任意一个biped 物体;  2. 指定一个源物体。" pos:[9,168] width:151 height:32 enabled:true
	
	on pickObj_btn picked obj do
	(
		pickObj_btn.text = obj.name
	)
	on startFrame_btn pressed do
	(
		if sliderTime < endFrame_spn.value do
		startFrame_spn.value = sliderTime
	)
	on endFrame_btn pressed do
	(
		if sliderTime > startFrame_spn.value do
		endFrame_spn.value = sliderTime
	)
	on align_btn pressed do
	(
		try
		(
			undo on
			(
				sourceObj = getNodeByName pickObj_btn.text
				if sourceObj != undefined then
				(
					if selection.count == 1 then 
					(
						for currFrame = startFrame_spn.value to endFrame_spn.value do
						(
							sliderTime = currFrame
							
							if (classof $) == Biped_Object then 
							(
								biped_COM = biped.getNode $ #horizontal
								if unlink_chk.checked do biped_COM.parent = undefined
								sourcePos = sourceObj.transform.position
								sourceRot = sourceObj.transform.rotation
								if Pos_chk.checked do (biped.setTransform biped_COM #pos sourcePos on)
								if Rot_chk.checked do (biped.setTransform biped_COM #rotation sourceRot on)
							)
							else 
								info_lbl.caption = "未选择biped骨骼!"
						)
					)
					else 
						info_lbl.caption = "只能选择任意一个biped骨骼!"
				)
				else info_lbl.caption = "未拾取源物体!"
			)
		)
		catch()
	)
	on clear_btn pressed do
	(
		pickObj_btn.text = "拾取物体"
		info_lbl.caption = ""
	)
)



if AlignToolFloater != undefined do
				(
				closerolloutfloater AlignToolFloater
				)		
AlignToolFloater = newRolloutFloater "AlignToolS" Default_Setting[2][1].x Default_Setting[2][1].y Default_Setting[2][2].x Default_Setting[2][2].y

addRollout Floater_Align AlignToolFloater
addRollout BipedCOM_align_Rollout AlignToolFloater
)