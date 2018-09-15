--选择ROOT
macroScript select_Root
	category:"ZZM动作工具"
	toolTip:"select root"
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

--选择所有BIP
macroScript sel_all_bip
category:"ZZM动作工具"
toolTip:"sel all bip"
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

--选择所有BONE
macroScript sel_all_bone
category:"ZZM动作工具"
toolTip:"sel all bone"
(
		allbones=#()
		for i in objects do 
		if classof i == BoneGeometry do append allbones i
		select allbones
)

--选择所有骨骼物体
macroScript sel_bonbip
category:"ZZM动作工具"
toolTip:"sel bonbip"
(
		allbonesarray=#()
		for i in objects do if classof I == Biped_Object or classof i == BoneGeometry do append allbonesarray  i
		if allbonesarray.count>0 do
		(
		select allbonesarray
		deselect $bip01_footsteps
		)
)

--隐藏BIPNUB
macroScript hide_BIPnub
category:"ZZM动作工具"
toolTip:"hide BIPnub"
	(
BipedObjArray = #()
			for i in objects do if classof I == Biped_Object do append BipedObjArray  i
			if BipedObjArray .count > 0  do    
			(
			select $bip*nub
			max hide selection
			max motion mode
			)
)
--隐藏所有骨骼
macroScript hide_bonbip
category:"ZZM动作工具"
toolTip:"hide bonbip"
(
			biparray=#()
			for i in helpers do
			if classof i.controller == BipSlave_Control do i.ishidden = on
			for i in objects do 
			if classof i==biped_object or classof i == BoneGeometry do append biparray i
			if biparray.count >0 do 
			if biparray[1].isHidden == true then unhide biparray  else hide biparray
)
--解除所有冻结隐藏
macroScript unhidefreeze_all
category:"ZZM动作工具"
toolTip:"unhidefreeze_all"
	(
			max unfreeze all
			max unhide all
	)
--冻结并显示材质	
macroScript showfreeze_selection
category:"ZZM动作工具"
toolTip:"showfreeze selection"
(
		if $ !=undefined then
		(	
			$.showFrozenInGray = off
			max freeze selection
		)
)
macroScript BipWorkBench
category:"ZZM动作工具"
toolTip:"BipWorkBench"
(
BipWorkBench.Open()
)

macroScript mergelink000
category:"ZZM动作工具"
toolTip:"mergelink000"
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

macroScript fly
category:"ZZM动作工具"
toolTip:"fly"
(
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
createdialog myfly
)

