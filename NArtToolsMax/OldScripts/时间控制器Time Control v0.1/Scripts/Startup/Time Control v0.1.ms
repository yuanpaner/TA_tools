/*
Time Control v0.1
-------------
Description:
Very Usefull to Control your Time Range
-------------
Created by : Ayoub Mahmoudi
Email : Ayoub_max@yahoo.com
*/
(
	global name_rol
	global timerange
	try(cui.UnRegisterDialogBar timerange)catch()
	try(destroyDialog timerange)catch()
	local Time_Control = getDir #plugcfg + "\\timecontrol.ini"
	rollout name_rol "Range Name"
	(
		edittext edt_name "" fieldWidth:120 across:2 offset:[-10,2]
		button bt_ok "Ok" width:30 height:20 offset:[30,1]
		on bt_ok pressed do
			(
				if edt_name.text != "" do
				(
					Anim_Range = (timerange.sp_start.value) as string + " " + (timerange.sp_end.value) as string
					name_ra = edt_name.text
					range_list = timerange.ddl_range.items
					a = ( name_ra + "   : " + Anim_Range )
					if findItem timerange.ddl_range.items a == 0 then
					(
					append range_list a
					timerange.ddl_range.items = range_list
					timerange.ddl_range.selection = range_list.count
					setIniSetting Time_Control "Data" "Ranges" (timerange.ddl_range.items as string)
					)else messagebox "There is Already One With The same Name and The same Range" title:"Time Control v0.1"
					try(destroyDialog name_rol)catch()
				)
			)
	)
	
rollout timerange "Time Control v0.1"
(
	button bt_addrange "Add" width:30 height:20 across:7 tooltip:"Add Current Range To List" offset:[-30,-2]
	dropdownlist ddl_range items:#() width:130 offset:[-40,-2]
	button bt_delete "Del" width:30 height:20 tooltip:"Delete Current Range From List" offset:[18,-2]
	spinner sp_start "Start :" range:[-99999999,99999999,0] type:#integer fieldWidth:50 offset:[40,0]
	spinner sp_end "End :" range:[-99999999,99999999,100] type:#integer fieldWidth:50 offset:[70,0]
	button bt_Prevframe "<--" width:20 height:18 offset:[55,-1] tooltip:"Previous Key"
	button bt_Nextframe "-->" width:20 height:18 offset:[20,-1] tooltip:"Next Key"
	
fn SetTimeRange = (
			stopAnimation()
			animationRange = interval sp_start.value sp_end.value
		)
fn updatesp_Values =(
		sp_start.value = (animationRange.start.frame as integer)   
		sp_end.value = (animationRange.end.frame as integer)
		)
fn GoToPrev_Key = (
			Previous_Key = trackbar.getPreviousKeyTime()
			if selection.count != undefine and Previous_Key != undefine do sliderTime = Previous_Key
			)
fn GoToNext_Key = (
			Next_Key = trackbar.getNextKeyTime()
			if selection.count != undefine and Next_Key != undefine do sliderTime = Next_Key
		)
fn load_range =
	(
		if ddl_range.selected != undefined do
		(
			rangeArray = filterString ddl_range.selected " "
			Start_range = rangeArray[(rangeArray.count)-1] as integer
			End_range = rangeArray[(rangeArray.count)] as integer
			if Start_range != undefined and End_range != undefined do
			animationRange = interval Start_range End_range
		)	
	)
	on ddl_range selected itm do
	(		
		load_range() 
		setIniSetting Time_Control "Data" "LastSelection" (ddl_range.selection as string)
	)
	on timerange open do
	(
		updatesp_Values()
		Range_items = execute (getIniSetting Time_Control "Data" "Ranges")
		if classof Range_items == Array do ddl_range.items = Range_items
		Range_selection = execute (getIniSetting Time_Control "Data" "LastSelection")
		if classof Range_selection == Integer do ddl_range.selection = Range_selection
	)
	on sp_start changed val do (
			if sp_start.value >= sp_end.value then sp_end.value = (sp_start.value)+1
			SetTimeRange()
		)
	on sp_end changed val do (
			if sp_end.value <= sp_start.value then sp_start.value = (sp_end.value)-1
			SetTimeRange()
		)
	on bt_Prevframe pressed do GoToPrev_Key()
	on bt_Nextframe pressed do GoToNext_Key()
	on bt_addrange pressed do try(createdialog name_rol)catch()
	on bt_delete pressed do
	(
		if ddl_range.selection > 0 do 
		(
			rangeArray = ddl_range.items 
			deleteItem rangeArray ddl_range.selection
			ddl_range.items = rangeArray
			if ddl_range.selection == 0 do ddl_range.selection = rangeArray.count
			setIniSetting Time_Control "Data" "Ranges" (ddl_range.items as string)
		)
	)
)
createdialog timerange 450 30
cui.RegisterDialogBar timerange style:#(#cui_dock_bottom,#cui_dock_top, #cui_floatable)
cui.DockDialogBar timerange #cui_dock_bottom
callbacks.addScript #animationRangeChange "timerange.updatesp_Values()" id:#Sp_Values
)