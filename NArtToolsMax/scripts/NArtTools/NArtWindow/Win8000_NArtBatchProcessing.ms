print "NArt工具：批处理脚本"

try(DestroyDialog m_batchPathScript_rol)catch()
rollout m_batchPathScript_rol "Batch Script Tool" width:997 height:667
(
	local m_batchPath
	local m_maxFileArray
	local m_scriptPath
	local m_scriptDir
	local m_fliePaths
	
	GroupBox grp_batchFile "批处理文件" pos:[16,94] width:961 height:509
	edittext edt_filePath "MAX文件路径" pos:[31,123] width:890 height:17 fieldwidth:434
	button btn_getFilePath "..." pos:[933,120] width:34 height:22
	GroupBox grp_scriptFile "Script文件" pos:[16,15] width:963 height:73
	edittext edt_msFilePath "脚本文件路径" pos:[294,57] width:627 height:17 fieldwidth:434
	button btm_getMsFilePath "..." pos:[935,56] width:30 height:19
	button btn_run "运行" pos:[700,610] width:250 height:46
	checkbox chk_autoSave "自动储存max文件" pos:[56,629] width:128 height:22
	dropdownList ddl_function "预设功能列表" pos:[33,36] width:242 height:41
	listbox lbx_maxFile "" pos:[37,191] width:910 height:27
	button btn_remove "移除所选文件" pos:[447,150] width:118 height:30
	button btn_refresh "刷新列表" pos:[348,150] width:77 height:30
	spinner spn_recTime "搜索层级 -1为无限" pos:[148,158] width:168 height:16 range:[-1,100,0] type:#integer scale:1 value:-1
	label lbl_count "" pos:[523,626] width:149 height:20
	
	fn updateCount =(
		lbl_count.text = "共" + (lbx_maxFile.items.count as string) + "个MAX文件"
	)
	
	fn ReadMaxFile =(
		m_batchPath = edt_filePath.text
		m_maxFileArray = NArtName.RecGetFileForm edt_filePath.text "max" m_maxFileArray spn_recTime.value
		lbx_maxFile.items = m_maxFileArray
		updateCount()
	)
	
	fn updateMSPath =(
		edt_msFilePath.text = m_fliePaths[ddl_function.selection]
	)
	
	fn getFlieChineseName _path =(
		_stream = OpenFile _path mode:"r"
		if _stream == undefined do return "错误"
		_firstLine = readLine _stream
		_firstLine = subString _firstLine 3 -1
		close _stream
		return _firstLine
	)

	on m_batchPathScript_rol open do
	(
		m_scriptDir = GetDir #userScripts
		m_scriptDir += @"\NArtTools\NArtBatch"
		_functionFiles = getfiles (m_scriptDir + "\*.ms")
		_items = #()
		m_fliePaths = #()
		for i in _functionFiles do (
			_fileName = getFileNameFile i
			
			append m_fliePaths i
			
			append _items (getFlieChineseName i)
		)
		ddl_function.items = _items 
		updateMSPath()
		updateCount()
	)
	on edt_filePath entered text do
	(
		ReadMaxFile()
	)
	on btn_getFilePath pressed do
	(
		m_maxFileArray = #()
		_getPath = getSavePath caption:"请选择批处理的MAX文件路径"
		if _getPath != undefined do(
			edt_filePath.text = _getPath
			ReadMaxFile()
		)
	)
	on btm_getMsFilePath pressed do
	(
		m_scriptPath = getopenFileName caption:"指定脚本文件ms" types:"script files (*.ms)|*.ms|All Files (*.*)|*.*|"
		if m_scriptPath!="" and m_scriptPath != undefined then edt_msFilePath.text = m_scriptPath else edt_msFilePath.text = "未指定"
	)
	on btn_run pressed do
	(
		m_scriptPath = edt_msFilePath.text
		m_maxFileArray = lbx_maxFile.items
		if m_maxFileArray != undefined and m_scriptPath != "" and m_scriptPath != undefined then
		(
			for tp_Mf in m_maxFileArray do
			(
				loadmaxfile tp_Mf Quiet:true
				try(fileIn m_scriptPath)catch()
				if chk_autoSave.checked do(
					savemaxfile tp_Mf
				)
			)
		)else messagebox"路径指定错误。"title:"错误"
	)
	on ddl_function selected sel do
	(
		updateMSPath()
	)
	on btn_remove pressed do
	(
		m_maxFileArray = lbx_maxFile.items
		deleteItem  m_maxFileArray lbx_maxFile.selection
		lbx_maxFile.items = m_maxFileArray
		updateCount()
	)
	on btn_refresh pressed do
	(
		m_maxFileArray = #()
		ReadMaxFile()
	)
)
createDialog m_batchPathScript_rol style:#(#style_toolwindow,#style_sysmenu) pos:[400,100]