macroScript BatchScript
category:"茶壶未完善工具"
buttontext:"Batch Script"
tooltip:"Batch Script"
(	
	Global tp_BatchScript_rol
	if tp_BatchScript_rol==undefined then
	(
		rollout tp_BatchScript_rol "Batch Script Tool" width:520 height:159
		(
			local tp_Batch
			local tp_MaxfileArray
			local tp_MsBatch
			
			
			GroupBox grp1 "批处理文件路径" pos:[14,16] width:489 height:48
			edittext TP_BatchText "未指定" pos:[26,35] width:438 height:17 fieldwidth:434 
 
			button tp_getMaxfilePath "get" pos:[466,35] width:30 height:18
			GroupBox grp3 "Script文件" pos:[14,70] width:489 height:48
			edittext TP_MsfileText "未指定" pos:[26,89] width:438 height:17 fieldwidth:434
			button tp_getMsfilePath "get" pos:[466,89] width:30 height:18
			button tp_run "运行" pos:[431,126] width:68 height:24
			checkbox saveFile_chk "自动储存max文件" pos:[16,127] width:128 height:22
		
		
			on tp_getMaxfilePath pressed do
			(
				global tp_MaxfileArray=#()
				tp_Batch=getSavePath caption:"请选择批处理的MAX文件路径"
				if tp_Batch!=undefined do(
					TP_BatchText.text=tp_Batch 
					tp_MaxfileArray=getfiles (tp_Batch+"\*.max" as string)
					tp_Direcories=getDirectories (tp_Batch+"\*" as string)
					for i in tp_Direcories do
					(
						tp_MaxfileArrayFoo=getfiles (i+"*.max" as string)
						for a in tp_MaxfileArrayFoo do append tp_MaxfileArray a
					)
				)
			)
			on tp_getMsfilePath pressed do
			(
				tp_MsBatch=getopenFileName caption:"指定脚本文件ms" types:"script files (*.ms)|*.ms|All Files (*.*)|*.*|"
				if tp_MsBatch!="" and tp_MsBatch!=undefined then TP_MsfileText.text=tp_MsBatch else TP_MsfileText.text="未指定"
			)
			on tp_run pressed do
			(
				if tp_MaxfileArray!=undefined and tp_MsBatch!="" and tp_MsBatch!=undefined then
				(
					for tp_Mf in tp_MaxfileArray do
					(
						loadmaxfile tp_Mf Quiet:true
						try(fileIn tp_MsBatch)catch()
						if saveFile_chk.checked do(
							savemaxfile tp_Mf
						)
					)
				)else messagebox"路径指定错误。"title:"错误"
					 
				
			)
		)
	createDialog tp_BatchScript_rol style:#(#style_toolwindow,#style_sysmenu) pos:[400,100]
	)
	else
	(
		if tp_BatchScript_rol.isDisplayed then
		 DestroyDialog tp_BatchScript_rol 
		else Createdialog tp_BatchScript_rol style:#(#style_toolwindow,#style_sysmenu) pos:[400,100]	)
)