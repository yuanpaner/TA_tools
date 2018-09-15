try(destroyDialog openFile_rol)catch()

rollout openFile_rol "Webdance打开角色文件" width:1020 height:27
(
	spinner num_spn "角色编号：" pos:[104,2] width:100 height:16 range:[0,9999,0] type:#integer
	button openfile_btn "打开" pos:[885,1] width:52 height:18
	label path_lbl "" pos:[413,2] width:308 height:18
	dropdownList sex_ddl "" pos:[315,-1] width:74 height:22 items:#("男(boy)", "女(girl)")
	label lbl3 "角色性别：" pos:[248,4] width:64 height:16
	
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

createdialog openFile_rol 2000 18
cui.RegisterDialogBar openFile_rol style:#(#cui_dock_bottom,#cui_dock_top, #cui_floatable)
cui.DockDialogBar openFile_rol #cui_dock_top 