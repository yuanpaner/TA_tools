global gnameX
rollout myfly "文件分段保存" width:397 height:348
(
	GroupBox grp1 "动作分隔帧" pos:[203,25] width:161 height:92
	label lbl2 "1：" pos:[221,61] width:27 height:20
	label lbl3 "2：" pos:[221,87] width:27 height:20
	button btn1 "保存" pos:[278,300] width:83 height:24
	Timer tmr1 "Timer" pos:[171,2] width:24 height:24
	label xxxlujing "文件全路径" pos:[34,147] width:517 height:19
	label lujinga "储存文件全路径1" pos:[31,175] width:517 height:19 enabled:true
	label lujingb "储存文件全路径2" pos:[32,194] width:517 height:19
	label lujingc "储存文件全路径3" pos:[32,212] width:517 height:19
	GroupBox grp7 "怪物名称" pos:[24,23] width:146 height:53
	label gname "--------" pos:[34,47] width:121 height:21
	
	spinner jg2 "" pos:[253,87] width:50 height:16 enabled:true range:[0,300,5] type:#integer scale:1 
	spinner jg1 "" pos:[253,62] width:50 height:16 enabled:true range:[0,300,5] type:#integer scale:1 
	
	
	on btn1 pressed  do
	(
		gnameX=filterstring maxfilename "_."
		
			if gnameX[2]=="浮空" then 
		(
			anisave=#("被击浮空","浮空循环","浮空落地") 
		)
		else
		(
			if gnameX[2]=="被击倒" then 
			(
			anisave=#("被击倒落地","被击倒循环","被击倒起身")
			)
			else
			(
			anisave=#("xx错误xx","xx错误xx","xx错误xx")
			)
		
		)
		
		
		
		patha=maxfilepath+gnameX[1]+"_"+anisave[1]
		pathb=maxfilepath+gnameX[1]+"_"+anisave[2]
		pathc=maxfilepath+gnameX[1]+"_"+anisave[3]
			
			anistart=animationrange.start
			aniend=animationrange.end
			jgn1=(jg1.value as time)
			jgn2=(jg2.value as time)
		
		    animationrange=(interval anistart jgn1)
			
			savemaxfile patha
			
			animationrange=(interval jgn1 jgn2)
			
			savemaxfile pathb
			
			animationrange=(interval jgn2 aniend)
			
			savemaxfile pathc
		)
	on tmr1 tick do
	(
		if maxfilename != "" then 
			(
			xxxlujing.caption=maxfilepath+maxfilename
			gnameX=filterstring maxfilename "_."
			gname.caption=gnameX[1]
			)
		else
		(
		gnameX[1]="未知"
		)
		if gnameX[2]=="浮空" then 
		(
			anisave=#("被击浮空","浮空循环","浮空落地") 
		)
		else
		(
			if gnameX[2]=="被击倒" then 
			(
			anisave=#("被击倒落地","被击倒循环","被击倒起身")
			)
			else
			(
			anisave=#("xx错误xx","xx错误xx","xx错误xx")
			)
		
		)
	
	   lujinga.caption=maxfilepath+gnameX[1]+"_"+anisave[1]+".max            "+(animationrange.start as string)+"------"+(jg1.value as string)+"f"
	   lujingb.caption=maxfilepath+gnameX[1]+"_"+anisave[2]+".max            "+(jg1.value as string)+"f------"+(jg2.value as string)+"f"
	   lujingc.caption=maxfilepath+gnameX[1]+"_"+anisave[3]+".max            "+(jg2.value as string)+"f------"+(animationrange.end as string)
	
		
		)
)



mainloater=newrolloutfloater "zzm工具" 135 800 
cui.RegisterDialogBar mainloater style:#(#cui_floatable,#cui_dock_left)
cui.DockDialogBar mainloater #cui_dock_left

rollout start1 "初始导入骨骼" width:130 height:70
(
	button startB1 "人形怪" pos:[4,26] width:58 height:18
	button startB2 "四足怪" pos:[65,26] width:59 height:18
	button startB3 "人形NPC" pos:[4,4] width:120 height:18
	button merge "导000并link" pos:[4,46] width:120 height:18
	on startB1 pressed  do
(
		if $bip01 == undefined then
		(
		mergemaxfile "d:\\merge\\人形怪骨骼.max"
		)
	)
	on merge pressed do
	(
	if $000 == undefined then
	(
	mergemaxfile "d:\\merge\\000.max"
	)
	if $bip01 != undefined then	
	(
	$bip01.parent=$000
	)
	else
	(
	if $bone_Pelvis != undefined then $bone_Pelvis.parent=$000
	)
		)
)
rollout sel1 "选择工具" width:130 height:177
(
	button selbip "选择所有BIP" pos:[4,34] width:120 height:22
	button selbip01 "选择BIP01" pos:[4,7] width:120 height:22
	button selbon "选择所有BONE" pos:[4,60] width:120 height:22
	button selab "选择所有骨骼" pos:[4,86] width:120 height:22
	
	on selbip pressed do
	(
			BipedObjArray = #()
			for i in objects do if classof I == Biped_Object do append BipedObjArray  i
			if BipedObjArray .count > 0  do    
			(
			select BipedObjArray
			deselect $bip01_footsteps
			)
			max motion mode
	)
	on selbip01 pressed do
	(
		if $bip01!=undefined then 
		(
		select $bip01
		max motion mode
          )
		 else 
		(
		if $bone_Pelvis!=undefined  then select $bone_Pelvis
		)
		
	)
	on selbon pressed do
		(
		allbones=#()
		for i in objects do 
		if classof i == BoneGeometry do append allbones i
		select allbones
		)
	on selab pressed do
	(
		allbonesarray=#()
		for i in objects do if classof I == Biped_Object or classof i == BoneGeometry do append allbonesarray  i
		if allbonesarray.count>0 do
		(
		select allbonesarray
		deselect $bip01_footsteps
		)
     )
)
rollout ani1 "动画" width:130 height:177
(
	button btn1 "BipWorkBench" pos:[4,4] width:120 height:22
	on btn1 pressed  do
		BipWorkBench.Open()
)rollout hide1 "隐藏/冻结" width:130 height:177
(
	button hidebip "隐藏所有BIP" pos:[4,28] width:120 height:22
	button hidebon "隐藏所有Bone" pos:[3,53] width:120 height:22
	button hideab "隐藏所有骨骼" pos:[4,77] width:120 height:22
	button freeze "冻结并显示材质" pos:[4,102] width:120 height:22
	button unhfall "解除所有隐藏冻结" pos:[4,127] width:120 height:22
	button hidenub "隐藏bipnub" pos:[4,4] width:120 height:22
	on hidebip pressed  do
(
		BipedObjArray = #()
			for i in objects do if classof I == Biped_Object do append BipedObjArray  i
			if BipedObjArray .count > 0  do    
			(
			hide BipedObjArray
			max motion mode
			)
	)
	on hidebon pressed  do
(
		select $bone*
		max hide selection
		max motion mode
	)
	on hideab pressed do
	(
			biparray=#()
			for i in helpers do
			if classof i.controller == BipSlave_Control do i.ishidden = on
			for i in objects do 
			if classof i==biped_object or classof i == BoneGeometry do append biparray i
			if biparray.count >0 do 
			if biparray[1].isHidden == true then unhide biparray  else hide biparray
		)
	on freeze pressed do
	(
			$.showFrozenInGray = off
			max freeze selection
		)
	on unhfall pressed do
	(
			max unfreeze all
			max unhide all
	)
	on hidenub pressed do
	(
			select $bip*nub
			max hide selection
			max motion mode
		)
)
rollout ass1 "辅助工具" width:130 height:177
(
	label filename "文件名称" pos:[3,3] width:120 height:46
	Timer tmr1 "Timer" pos:[8,22] width:24 height:24
	button btn7 "浮空击倒分段保存" pos:[3,55] width:123 height:25
	on tmr1 tick do
		filename.caption=maxfilename
	on btn7 pressed  do
(
	createdialog myfly
	)
)
addrollout start1 mainloater
addrollout sel1 mainloater
addrollout ani1 mainloater
addrollout hide1 mainloater
addrollout ass1 mainloater