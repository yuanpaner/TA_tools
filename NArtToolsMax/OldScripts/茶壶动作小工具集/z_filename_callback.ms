
rollout filename "file_name" width:162 height:46
(
	label Aname "文件名称" pos:[10,1] width:600 height:13
	Timer tmr4 "Timer" pos:[13,18] width:24 height:24 enabled:true interval:500 active:true
	label lbl5 "Label" pos:[1100,1] width:200 height:13
	label Obname "物体名称" pos:[650,1] width:200 height:13
	button EX "X" pos:[1250,1] width:13 height:13

	on tmr4 tick do
	(
	Aname.caption=maxfilepath+maxfilename
	lbl5.text = " 时间：" + localtime as string
	if selection.count==1 then 
		(
		Obname.caption=$.name+" Selected"
		)
	if selection.count==0 then
		(
		Obname.caption="None Selected"
		)
	if selection.count>1 then
		(
		Obname.caption=(selection.count as string)+" Object Selected"
		)
	)
	on EX pressed  do
		(
		quitmax()
		)
)

createdialog filename 1280 18
cui.RegisterDialogBar filename style:#(#cui_dock_bottom,#cui_dock_top, #cui_floatable)
cui.DockDialogBar filename #cui_dock_bottom

-------------------模式-------------------------------------------------------------
cui.expertModeOn()	-- Views: Expert Mode 
actionMan.executeAction 0 "50026"	-- Tools: Maximize Viewport Toggle

-------------------auto key 颜色-----------------------------------------------------
fn tp_color=
(
	tp_judgekey=0
	if selection.count==1 then
	(
		if classof $==BoneGeometry then 
			(
				try(
					tp_BONEcontroller=$.rotation.zero_euler_XYZ.controller
					tp_keys=tp_BONEcontroller.keys
					)
					catch
					(
					tp_keys=#()
					)
				
			)
			else 
			(
				if classof $==Biped_Object then 
					(
						if classof $.controller==Vertical_Horizontal_Turn then
						(
							tp_keys=#()
							tp_BIPhorizontal=$.controller.horizontal.controller.keys
							tp_BIPvertical=$.controller.vertical.controller.keys
							tp_BIPturning=$.controller.turning.controller.keys
							for q in tp_BIPhorizontal do append tp_keys q
							for q in tp_BIPvertical do append tp_keys q
							for q in tp_BIPturning do append tp_keys q
						)
						else
						(
							tp_BIPcontroller=$.controller
							tp_keys=tp_BIPcontroller.keys
						)
					)
					else tp_keys=#()
			)
			
		
		for a = 1 to tp_keys.count do 
			(
				if tp_keys[a].time==slidertime then 
				(
				tp_judgekey=1
				
				)
			)
		if tp_judgekey==1 then 
			(
			setUIcolor 12 [0.9,0,0]
			colorMan.repaintUI #repaintTimeBar
		
			)
			else 
			(
			setUIcolor 12 [0.678431,0,0]
			colorMan.repaintUI #repaintTimeBar
			
			)
	)
)
registerTimeCallback tp_color
callbacks.addscript #selectionsetchanged "tp_color()" 
	