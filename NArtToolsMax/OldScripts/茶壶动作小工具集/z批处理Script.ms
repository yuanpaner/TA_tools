macroscript BatchScript
category:"自定义工具"
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
			edittext TP_BatchText "" pos:[26,35] fieldWidth:434 text:"未指定" 
			button tp_getMaxfilePath "get" pos:[466,35] width:30 height:18
			GroupBox grp3 "Script文件" pos:[14,70] width:489 height:48
			edittext TP_MsfileText "" pos:[26,89] fieldWidth:434 text:"未指定"
			button tp_getMsfilePath "get" pos:[466,89] width:30 height:18
			button tp_run "运行" pos:[431,126] width:68 height:24
		
		
			on tp_getMaxfilePath pressed  do
			(
				tp_Batch=getSavePath caption:"请选择批处理的MAX文件路径"
				if tp_Batch!=undefined do
				( 
					TP_BatchText.text=tp_Batch 
					tp_MaxfileArray=getfiles (tp_Batch+"\*.max" as string)
				)
			)
			on tp_getMsfilePath pressed  do
			(
				tp_MsBatch=getopenFileName caption:"指定脚本文件ms" types:"script files (*.ms)|*.ms|All Files (*.*)|*.*|"
				if tp_MsBatch!="" and tp_MsBatch!=undefined then TP_MsfileText.text=tp_MsBatch else TP_MsfileText.text="未指定"
			)
			on tp_run pressed  do
			(
				if tp_MaxfileArray!=undefined and tp_MsBatch!="" and tp_MsBatch!=undefined then
				(
					for tp_Mf in tp_MaxfileArray do
					(
						loadmaxfile tp_Mf Quiet:true
						try(fileIn tp_MsBatch)catch()
						savemaxfile tp_Mf
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