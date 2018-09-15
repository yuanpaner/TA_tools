macroScript KeyTools
category:"MAX Script Tools"
tooltip:"KeyTools "
buttonText:"KeyTools " 

(

--变量初始化
global KeyTools,KeyToolsF
KeyArray 					= 	#()
KeySign 					= 	#()
k							=	1
Key_offset 					=	0
Default_Setting				=	#()
DefaultPath 				=	(getDir #Scripts)+"/KeyTools.def"
DataPath 					= 	(getDir #Scripts)+"/KeyTools.txt"
Data_File					= 	OpenFile Datapath		
Default_File 				= 	OpenFile DefaultPath


--函数区 
fn FnPrint =
	( 
	undo off
		( 
		Data_File = CreateFile DataPath
		print KeySign to:Data_File
		close Data_File
		)
    )
	
fn FnRead =
    (
	undo off
		(
		KeySign=#()
		Data_File = Openfile DataPath
		i=1
		while not(eof Data_file) do
			(			 
			 KeySign[i]= readValue Data_File
			 i+=1
			)
		)

	)
fn DefaultSave = 
	( 
	undo off
		( 
		Default_File = CreateFile DefaultPath
		print Default_Setting to:Default_File
		close Default_File
		)
  )
fn DefaultLoad =
    (
	undo off
		(
		i=1
		Default_File = Openfile DefaultPath	 	  
		while not(eof Default_File) do
			(
			Default_Setting[i]= readValue Default_File
			i+=1
			)
		)

     )
	 
if Data_File == undefined then
	FnPrint()
	else
	close Data_File

if Default_File == undefined then
	(
	Default_Setting[1] = [170,542] 
	Default_Setting[2] = [660,70]
	Default_Setting[3] = #(true,false)
	Default_Setting[4] = #(0,1,2)
	DefaultSave ()   
	)
	else
	DefaultLoad()

--面板区
rollout KeyTools "自由创建" width:162 height:432
(
	button KeyAdd "添加关键帧" pos:[21,375] width:118 height:47 toolTip:"在列表中添加一个当前帧数的关键帧" 
	button Updel "删除" pos:[109,176] width:40 height:60 toolTip:"删除列表中最后一个添加的关键帧"
	button clear "清空" pos:[109,105] width:40 height:60 toolTip:"清空列表中所有的关键帧"
	GroupBox 关键帧列表 "关键帧列表" pos:[6,3] width:94 height:366
	button SaveDefault "存储" pos:[109,21] width:40 height:30 toolTip:"存储关键帧列表到默认"
	button ReadDefault "读取" pos:[109,59] width:40 height:30 toolTip:"读取默认值到关键帧列表"
	listbox KeyText "" pos:[10,20] width:85 height:26
	label lbl1 "从0开始" pos:[104,349] width:46 height:14
	checkbox Key_check "" pos:[106,333] width:34 height:18	
	button output "输出物体" pos:[104,251] width:55 height:30 toolTip:"将关键帧列表的内容复制到选中的物件上"
	


fn ShowKey =
	( 
	
	KeyArray = #()
	for i=1 to KeySign.count do	
		 KeyArray[i] = "key_"+(KeySign[i] as string)+"=1"  
	close Data_File
      
	k = KeyArray.count+1
	KeyTools.KeyText.items = KeyArray
	KeyTools.KeyText.selection  = k-1
	 
	)

	 
--命令区	
		 
--	on KeyTools resized size do
--		DefaultSave()
--	on KeyTools moved pos do
--		DefaultSave() */
--	--on KeyTools rolledUp Key01Up do
--	--( aa = "rolledup="+(key01up as string)
--	print aa
	

	--	Default_Setting[3][1] = Keytools.open
		
	--)

	button output4copy "输出文本" pos:[103,291] width:55 height:30 toolTip:"将关键帧列表的内容复制到选中的物件上"
	on KeyTools open do
	(
	Keytools.open = Default_Setting[3][1]
	)
	on KeyTools close do
	(
	Default_Setting[1] = KeytoolsF.size
	Default_Setting[2] = KeytoolsF.pos
	Default_Setting[3][1] = Keytools.open
	DefaultSave() 
	)
	on KeyAdd pressed do
	(  
	undo off
		(
		if k==1 then
			(
			slidertime = 0f
			Key_offset = int slidertime
			)		 
		case Key_check.checked of
			(
			true  :KeySign[k]=(int slidertime - Key_offset) 
			false :KeySign[k]=(int slidertime ) 
			)	
		if k>1 then
			(
			if KeySign[k] !=  KeySign[k-1] and KeySign[k] >  KeySign[k-1] then
				(
				KeyArray[k] = "key_"+(KeySign[k] as string)+"=1" 
				k =k+1
				KeyText.items = KeyArray
				KeyText.selection  = k-1
				)
			)
			else if k == 1 then
				(
				KeyArray[k] = "key_"+(KeySign[k] as string)+"=1" 
				k = 2
				KeyText.items = KeyArray
				KeyText.selection  = k
				)  
			
		)   
	)
	on Updel pressed do
	( 
	if k>1 do
		(
		deleteItem KeySign (k-1)
		ShowKey()
		)
	
	)
	on clear pressed do
	( 
	KeySign  = #()
	ShowKey()
		
	)
	on SaveDefault pressed do
	( 
	  FnPrint()
	 )
	on ReadDefault pressed do
	( 
	 fnread()
	 ShowKey()
	 )
	on KeyText doubleClicked itm do
	(
	deleteItem KeyArray itm
	deleteItem KeySign itm
	KeyText.items = KeyArray
	k=k-1
	)
	on output pressed do
	( 
		Key_Output = ""
		for i =1 to keyarray.count do
			Key_Output += (keyarray[i] + "\r\n")
		if $!=undefined then 
		setUserPropBuffer $ Key_Output
		else messagebox "没有选择物体"
	 )
	on output4copy pressed do
	( 
		outputKeyText = newscript()
		for i = 1 to KeyArray.count do format (KeyArray[i]+"\n") to: outputKeyText

	 )
)

-- create the rollout window and add the  rollout
--try
--(
	--cui.unregisterDialogBar BoneAdjustmentsFloater
--	closeRolloutFloater KeyToolsF

--)
--catch()

if KeyToolsF != undefined do
				(
				closeRolloutFloater KeyToolsF
				)		
--CreateDialog  KeyTools pos:[680,70] width:154 height:450
--KeyToolsF = newRolloutFloater "KeyTools 1.0" 165 460 600 70
KeyToolsF = newRolloutFloater "KeyTools 1.0" Default_Setting[1][1] Default_Setting[1][2] Default_Setting[2][1] Default_Setting[2][2]
addRollout KeyTools KeyToolsF 

)
