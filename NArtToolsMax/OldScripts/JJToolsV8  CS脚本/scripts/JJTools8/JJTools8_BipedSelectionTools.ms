global BST_floater
global BST_pos = [407,97]
roll_width=110
roll_height=445

global img_LeftFootA1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootA1.bmp")
global img_LeftFootB1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootB1.bmp")
global img_LeftFootC1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootC1.bmp")
global img_LeftFootD1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootD1.bmp")
global img_LeftFootE1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootE1.bmp")
global img_LeftFootF1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootF1.bmp")
global img_LeftFootC2 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootC2.bmp")
global img_LeftFootD2 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootD2.bmp")
global img_LeftFootE2 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootE2.bmp")
global img_LeftFootF2 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_LeftFootF2.bmp")
global img_RightFootA1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootA1.bmp")
global img_RightFootB1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootB1.bmp")
global img_RightFootC1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootC1.bmp")
global img_RightFootD1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootD1.bmp")
global img_RightFootE1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootE1.bmp")
global img_RightFootF1 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootF1.bmp")
global img_RightFootC2 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootC2.bmp")
global img_RightFootD2 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootD2.bmp")
global img_RightFootE2 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootE2.bmp")
global img_RightFootF2 = openbitmap (getdir #maxroot+"UI\Icons\BipSelTools_RightFootF2.bmp")
global bip_state
global mesh_state
global bone_state
global box_state

	global registerBipedToolsCallback

	fn registerBipedToolsCallback =
	(
		try
		(
			filein (getdir #maxroot+"scripts\\JJTools8\\JJTools8_BipedSelectionTools.ms")
		)catch()
	)


allbipsName =#()
allbips = getallbips()

fn BipedPivot PivotNumber =
(
	TheKeyIndex = getKeyIndex ($.controller) currentTime
	if TheKeyIndex != 0 then
	(
		TheKey = biped.getKey $.controller TheKeyIndex
		TheKey.ikPivotIndex = PivotNumber
	)
)

for i = 1 to allbips.count do
(
	append allbipsName allbips[i].name
)

max motion mode

rollout BST_cont "Bip Tools 1.61"
(	
	dropdownlist bip_list items:allbipsName width:70 pos:[5,5]
	button refresh_bips "R" pos:[(bip_list.pos.x)+70,(bip_list.pos.y)] width:22 tooltip:"Refresh Bip List"
	button select_head_btn "Head" 		pos:[(roll_width/2)-21,(bip_list.pos.y)+25] 					width:26 height:20 images:#(getdir #maxroot+"UI\Icons\BipSelTools_head1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select Head (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_neck_btn "Neck" 		pos:[(select_head_btn.pos.x)+5,(select_head_btn.pos.y)+20] 		width:16 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select Neck (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"

	button select_spine1_btn "Spine" 	pos:[(select_head_btn.pos.x)+5,(select_neck_btn.pos.y)+15] 		width:30 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_spine1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select Spine3 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_spine2_btn "Spine2" 	pos:[(select_head_btn.pos.x)+5,(select_spine1_btn.pos.y)+15] 	width:30 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_spine1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select Spine2 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_spine3_btn "Spine3" 	pos:[(select_head_btn.pos.x)+5,(select_spine2_btn.pos.y)+15] 	width:30 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_spine1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select Spine  (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_spine4_btn "Spine4" 	pos:[(select_head_btn.pos.x)-10,(select_neck_btn.pos.y)+15] 	width:15 height:45 images:#(getdir #maxroot+"UI\Icons\BipSelTools_spine1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select All Spine (Shift-for Children, Ctrl-Add to selection)"
	button select_pelvis_btn "Pelvis" 	pos:[(select_head_btn.pos.x),(select_spine3_btn.pos.y)+15] 		width:26 height:20 images:#(getdir #maxroot+"UI\Icons\BipSelTools_pelvis1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select Pelvis (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"

	button select_ruleg_btn "LULeg" 	pos:[(select_head_btn.pos.x)-10,(select_pelvis_btn.pos.y)+20] 	width:20 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Thigh (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_rlleg_btn "LLLeg" 	pos:[(select_ruleg_btn.pos.x),(select_ruleg_btn.pos.y)+30] 		width:20 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Calf (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_rfoot_btn "LLLeg" 	pos:[(select_rlleg_btn.pos.x)-5,(select_rlleg_btn.pos.y)+30] 	width:25 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Foot (Ctrl-Add to selection, Alt-Deselect)"
	button select_rtoe_btn "LToe" 		pos:[(select_rfoot_btn.pos.x)-15,(select_rfoot_btn.pos.y)] 		width:15 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Foot (Ctrl-Add to selection, Alt-Deselect)"

	button select_luleg_btn "RULeg" 	pos:[(select_head_btn.pos.x)+16,(select_pelvis_btn.pos.y)+20] 	width:20 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_right1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Thigh (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_llleg_btn "RLLeg" 	pos:[(select_luleg_btn.pos.x),(select_luleg_btn.pos.y)+30] 		width:20 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_right1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Calf (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_lfoot_btn "RLLeg" 	pos:[(select_llleg_btn.pos.x),(select_llleg_btn.pos.y)+30] 		width:25 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_right1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Foot (Ctrl-Add to selection, Alt-Deselect)"
	button select_ltoe_btn "RToe" 		pos:[(select_lfoot_btn.pos.x)+25,(select_lfoot_btn.pos.y)] 		width:15 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_right1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Foot (Ctrl-Add to selection, Alt-Deselect)"

	button select_rclav_btn "LClav" 	pos:[(select_head_btn.pos.x)-20,(select_neck_btn.pos.y)+5] 		width:20 height:10 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Clavicle (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_ruarm_btn "LUArm" 	pos:[(select_rclav_btn.pos.x)-10,(select_rclav_btn.pos.y)+10] 	width:16 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Upperarm (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_rlarm_btn "LUArm" 	pos:[(select_ruarm_btn.pos.x),(select_ruarm_btn.pos.y)+30] 		width:16 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Forearm (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_rhand_btn "LHand" 	pos:[(select_rlarm_btn.pos.x)-2,(select_rlarm_btn.pos.y)+30] 	width:20 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Hand (Shift-for Children, Ctrl-Add to selection, Alt-Deselect, Shift+Ctrl-Snapshot)"

	button select_lclav_btn "RClav" 	pos:[(select_head_btn.pos.x)+26,(select_neck_btn.pos.y)+5] 		width:20 height:10 images:#(getdir #maxroot+"UI\Icons\BipSelTools_right1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Clavicle (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_luarm_btn "RUArm" 	pos:[(select_lclav_btn.pos.x)+14,(select_lclav_btn.pos.y)+10] 	width:16 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_right1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Upperarm (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_llarm_btn "RUArm" 	pos:[(select_luarm_btn.pos.x),(select_luarm_btn.pos.y)+30] 		width:16 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_right1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Forearm (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_lhand_btn "RHand" 	pos:[(select_llarm_btn.pos.x)-2,(select_llarm_btn.pos.y)+30] 	width:20 height:15 images:#(getdir #maxroot+"UI\Icons\BipSelTools_right1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Hand (Shift-for Children, Ctrl-Add to selection, Alt-Deselect, Shift+Ctrl-Snapshot)"

	button select_hori_btn "Root" 		pos:[(select_head_btn.pos.x)-20,(select_rfoot_btn.pos.y)+20] 	width:22 height:22 images:#(getdir #maxroot+"UI\Icons\BipSelTools_Hori.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Translate Bip"	
	button select_vert_btn "Root" 		pos:[(select_hori_btn.pos.x)+22,(select_hori_btn.pos.y)] 		width:22 height:22 images:#(getdir #maxroot+"UI\Icons\BipSelTools_vert.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Root"	
	button select_rot_btn "Root" 		pos:[(select_vert_btn.pos.x)+22,(select_hori_btn.pos.y)] 		width:22 height:22 images:#(getdir #maxroot+"UI\Icons\BipSelTools_rot.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Rotate Bip"	
	button select_rootnode_btn "Root" 	pos:[(select_hori_btn.pos.x),(select_vert_btn.pos.y)+22] 		width:66 height:10 images:#(getdir #maxroot+"UI\Icons\BipSelTools_Hori.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Translation and Rotation  (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"	

	button select_all_btn "Root" 		pos:[(bip_list.pos.x),(bip_list.pos.y+25)] 						width:22 height:22 images:#(getdir #maxroot+"UI\Icons\BipSelTools_all.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Root"	
	button select_sym_btn "Root" 		pos:[(refresh_bips.pos.x)-5,(select_all_btn.pos.y)] 			width:22 height:22 images:#(getdir #maxroot+"UI\Icons\BipSelTools_sym.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Root"	
/*
	button select_rhand1_btn "LHand"	pos:[(roll_width/2)-28,295]											width:60 height:40 images:#(getdir #maxroot+"UI\Icons\BipSelTools_left1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Hand (Shift-for Children, Ctrl-Add to selection, Alt-Deselect, Shift+Ctrl-Snapshot)"
	button select_rfing11_btn "LHand"	pos:[(select_rhand1_btn.pos.x),(select_rhand1_btn.pos.y)-22]		width:20 height:22 images:#(getdir #maxroot+"UI\Icons\BipSelTools_lfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Finger 11 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_rfing12_btn "LHand"	pos:[(select_rfing11_btn.pos.x)+1,(select_rfing11_btn.pos.y)-21]	width:18 height:21 images:#(getdir #maxroot+"UI\Icons\BipSelTools_lfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Finger 12 (Ctrl-Add to selection, Alt-Deselect)"

	button select_rfing21_btn "LHand"	pos:[(select_rhand1_btn.pos.x)+20,(select_rhand1_btn.pos.y)-23]		width:20 height:23 images:#(getdir #maxroot+"UI\Icons\BipSelTools_lfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Finger 21 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_rfing22_btn "LHand"	pos:[(select_rfing21_btn.pos.x)+1,(select_rfing21_btn.pos.y)-23]	width:18 height:23 images:#(getdir #maxroot+"UI\Icons\BipSelTools_lfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Finger 22 (Ctrl-Add to selection, Alt-Deselect)"

	button select_rfing31_btn "LHand"	pos:[(select_rhand1_btn.pos.x)+40,(select_rhand1_btn.pos.y)-22]		width:20 height:22 images:#(getdir #maxroot+"UI\Icons\BipSelTools_lfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Finger 21 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_rfing32_btn "LHand"	pos:[(select_rfing31_btn.pos.x)+1,(select_rfing31_btn.pos.y)-21]	width:18 height:21 images:#(getdir #maxroot+"UI\Icons\BipSelTools_lfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Finger 22 (Ctrl-Add to selection, Alt-Deselect)"

	button select_rthumb1_btn "LHand"	pos:[(select_rhand1_btn.pos.x)-20,(select_rhand1_btn.pos.y)]		width:20 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_lthumbs1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Thumb 1 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_rthumb2_btn "LHand"	pos:[(select_rthumb1_btn.pos.x),(select_rthumb1_btn.pos.y)-25]		width:18 height:25 images:#(getdir #maxroot+"UI\Icons\BipSelTools_lthumbs1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select R Thumb 2 (Ctrl-Add to selection, Alt-Deselect)"

	button select_lhand1_btn "LHand"	pos:[(select_rthumb1_btn.pos.x),(select_rhand1_btn.pos.y)+90] 		width:60 height:40 images:#(getdir #maxroot+"UI\Icons\BipSelTools_right1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Hand (Shift-for Children, Ctrl-Add to selection, Alt-Deselect, Shift+Ctrl-Snapshot)"
	button select_lfing11_btn "LHand"	pos:[(select_lhand1_btn.pos.x)+40,(select_lhand1_btn.pos.y)-22]		width:20 height:22 images:#(getdir #maxroot+"UI\Icons\BipSelTools_rfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Finger 11 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_lfing12_btn "LHand"	pos:[(select_lfing11_btn.pos.x)+1,(select_lfing11_btn.pos.y)-21]	width:18 height:21 images:#(getdir #maxroot+"UI\Icons\BipSelTools_rfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Finger 12 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"

	button select_lfing21_btn "LHand"	pos:[(select_lhand1_btn.pos.x)+20,(select_lhand1_btn.pos.y)-23]		width:20 height:23 images:#(getdir #maxroot+"UI\Icons\BipSelTools_rfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Finger 21 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_lfing22_btn "LHand"	pos:[(select_lfing21_btn.pos.x)+1,(select_lfing21_btn.pos.y)-23]	width:18 height:23 images:#(getdir #maxroot+"UI\Icons\BipSelTools_rfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Finger 22 (Ctrl-Add to selection, Alt-Deselect)"

	button select_lfing31_btn "LHand"	pos:[(select_lhand1_btn.pos.x),(select_lhand1_btn.pos.y)-22]		width:20 height:22 images:#(getdir #maxroot+"UI\Icons\BipSelTools_rfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Finger 21 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_lfing32_btn "LHand"	pos:[(select_lfing31_btn.pos.x)+1,(select_lfing31_btn.pos.y)-21]	width:18 height:21 images:#(getdir #maxroot+"UI\Icons\BipSelTools_rfingers1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Finger 22 (Ctrl-Add to selection, Alt-Deselect)"

	button select_lthumb1_btn "LHand"	pos:[(select_lhand1_btn.pos.x)+60,(select_lhand1_btn.pos.y)]		width:20 height:30 images:#(getdir #maxroot+"UI\Icons\BipSelTools_rthumbs1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Thumb 1 (Shift-for Children, Ctrl-Add to selection, Alt-Deselect)"
	button select_lthumb2_btn "LHand"	pos:[(select_lthumb1_btn.pos.x)+2,(select_lthumb1_btn.pos.y)-25]	width:18 height:25 images:#(getdir #maxroot+"UI\Icons\BipSelTools_rthumbs1.bmp", undefined, 1, 1, 1, 1, 1) toolTip:"Select L Thumb 2 (Ctrl-Add to selection, Alt-Deselect)"
*/
	imgTag LeftFootA_btn "LHand"		pos:[(bip_list.pos.x)-2,248]									bitmap:img_LeftFootA1
	imgTag LeftFootB_btn "LHand"		pos:[(leftfootA_btn.pos.x)+20,(leftfootA_btn.pos.y)]			bitmap:img_LeftFootB1
	imgTag LeftFootC_btn "LHand"		pos:[(leftfootB_btn.pos.x)+40,(leftfootA_btn.pos.y)]			bitmap:img_LeftFootC1
	imgTag LeftFootD_btn "LHand"		pos:[(leftfootA_btn.pos.x),(leftfootA_btn.pos.y)+27]			bitmap:img_LeftFootD1
	imgTag LeftFootE_btn "LHand"		pos:[(leftfootB_btn.pos.x),(leftfootA_btn.pos.y)+27]			bitmap:img_LeftFootE1
	imgTag LeftFootF_btn "LHand"		pos:[(leftfootC_btn.pos.x),(leftfootA_btn.pos.y)+27]			bitmap:img_LeftFootF1
		
	imgTag RightFootC_btn "LHand"		pos:[(leftfootA_btn.pos.x),(leftfootA_btn.pos.y)+58]			bitmap:img_RightFootC1
	imgTag RightFootB_btn "LHand"		pos:[(RightfootC_btn.pos.x)+30,(RightfootC_btn.pos.y)]			bitmap:img_RightFootB1
	imgTag RightFootA_btn "LHand"		pos:[(RightfootB_btn.pos.x)+40,(RightfootC_btn.pos.y)]			bitmap:img_RightFootA1
	imgTag RightFootD_btn "LHand"		pos:[(RightfootA_btn.pos.x),(RightfootA_btn.pos.y)+27]			bitmap:img_RightFootD1
	imgTag RightFootE_btn "LHand"		pos:[(RightfootB_btn.pos.x),(RightfootA_btn.pos.y)+27]			bitmap:img_RightFootE1
	imgTag RightFootF_btn "LHand"		pos:[(RightfootC_btn.pos.x),(RightfootA_btn.pos.y)+27]			bitmap:img_RightFootF1

	button Tog_Biped_btn "Toggle Biped"	pos:[(rightfootc_btn.pos.x)-1,(RightfootA_btn.pos.y)+60]		width:22 height:22 toolTip:"Toggle Biped" images:#(getdir #maxroot+"UI\Icons\BipSelTools_Fig.bmp", undefined, 1, 1, 1, 1, 1)
	button Tog_Bones_btn "Toggle Bones"	pos:[(Tog_Biped_btn.pos.x)+23,(Tog_Biped_btn.pos.y)] 			width:22 height:22 toolTip:"Toggle Bones" images:#(getdir #maxroot+"UI\Icons\BipSelTools_all.bmp", undefined, 1, 1, 1, 1, 1)
	button Tog_Mesh_btn "Toggle Mesh"	pos:[(tog_bones_btn.pos.x)+23,(tog_bones_btn.pos.y)] 			width:22 height:22 toolTip:"Toggle Mesh" images:#(getdir #maxroot+"UI\Icons\BipSelTools_Mesh.bmp", undefined, 1, 1, 1, 1, 1)
	button Tog_Box_btn "Toggle Box"		pos:[(tog_mesh_btn.pos.x)+23,(tog_bones_btn.pos.y)] 			width:22 height:22 toolTip:"Toggle Box" images:#(getdir #maxroot+"UI\Icons\BipSelTools_Box.bmp", undefined, 1, 1, 1, 1, 1)

	on tog_box_btn pressed do
	(
		if box_state == undefined or box_state == 0 then
		(
			box_state = 1
			try
			(	
				bip_bones = getAllBipBones()
				for i = 1 to bip_bones.count do
				(
					bip_bones[i].boxmode = on
				)
			)catch(messagebox ("This button failed.\nYou may not have the latest JJTools8_JimFunctions.ms file.\n"))
		)
		else
		(
			box_state = 0
			try
			(	
				bip_bones = getAllBipBones()
				for i = 1 to bip_bones.count do
				(
					bip_bones[i].boxmode = off
				)
			)catch(messagebox ("This button failed.\nYou may not have the latest JJTools8_JimFunctions.ms file.\n"))
		)
	)

	on tog_biped_btn pressed do
	(
		if bip_state == undefined or bip_state == 0 then
		(
			bip_state = 1
			try
			(	
				bip_bones = getAllBipBones()
				hide bip_bones
			)catch(messagebox ("This button failed.\nYou may not have the latest JJTools8_JimFunctions.ms file.\n"))
		)
		else
		(
			bip_state = 0
			try
			(	
				bip_bones = getAllBipBones()
				unhide bip_bones
			)catch(messagebox ("This button failed.\nYou may not have the latest JJTools8_JimFunctions.ms file.\n"))
		)
	)
	
	on tog_bones_btn pressed do
	(
		if bone_state == undefined or bone_state == 0 then
		(
			hide $'b_*'
			bone_state = 1
		)
		else
		(
			unhide $'b_*'
			bone_state = 0
		)	
	)
	
	on tog_mesh_btn pressed do
	(
		if mesh_state == undefined or mesh_state == 0 then
		(
			hide $'*mesh*'
			mesh_state = 1
		)
		else
		(
			unhide $'*mesh*'
			mesh_state = 0
		)		
	)
	
	fn Bip_Select Index LinkNode =
	(
		try(
		max motion mode
		if keyboard.shiftpressed == true then
		(
			with redraw off
			(
				temparray =#()
				select (biped.getNode allbips[bip_list.selection] Index link:LinkNode)		
				for i = 1 to 25 do
				(
					for j = 1 to $selection.count do
					(
						append temparray ($selection[j])
					)
					max select child
				)
				
				for i = 1 to temparray.count do
				(
					selectmore temparray[i]
				)
			)
		)
		else if keyboard.altpressed == true then
		(
			deselect (biped.getNode allbips[bip_list.selection] Index link:LinkNode)
		)
		else if keyboard.controlpressed == true then
		(
			selectmore (biped.getNode allbips[bip_list.selection] Index link:LinkNode)
		)
		else
		(
			select (biped.getNode allbips[bip_list.selection] Index link:LinkNode)
		)
		)catch()
	)

	fn foot_pivot Index LinkNode PivotPoint =
	(
		max motion mode
		select (biped.getNode allbips[bip_list.selection] Index link:LinkNode)
		bipedPivot(PivotPoint)
	)
	
	on LeftFootC_btn mousedown do (LeftFootC_btn.bitmap = img_LeftFootC2)
	on LeftFootC_btn mouseup   do (LeftFootC_btn.bitmap = img_LeftFootC2)		
	on LeftFootC_btn mouseover do (LeftFootC_btn.bitmap = img_LeftFootC2)
	on LeftFootC_btn mouseout  do (LeftFootC_btn.bitmap = img_LeftFootC1)

	on LeftFootD_btn mousedown do (LeftFootD_btn.bitmap = img_LeftFootD2)
	on LeftFootD_btn mouseup   do (LeftFootD_btn.bitmap = img_LeftFootD2)		
	on LeftFootD_btn mouseover do (LeftFootD_btn.bitmap = img_LeftFootD2)
	on LeftFootD_btn mouseout  do (LeftFootD_btn.bitmap = img_LeftFootD1)

	on LeftFootE_btn mousedown do (LeftFootE_btn.bitmap = img_LeftFootE2)
	on LeftFootE_btn mouseup   do (LeftFootE_btn.bitmap = img_LeftFootE2)		
	on LeftFootE_btn mouseover do (LeftFootE_btn.bitmap = img_LeftFootE2)
	on LeftFootE_btn mouseout  do (LeftFootE_btn.bitmap = img_LeftFootE1)

	on LeftFootF_btn mousedown do (LeftFootF_btn.bitmap = img_LeftFootF2)
	on LeftFootF_btn mouseup   do (LeftFootF_btn.bitmap = img_LeftFootF2)		
	on LeftFootF_btn mouseover do (LeftFootF_btn.bitmap = img_LeftFootF2)
	on LeftFootF_btn mouseout  do (LeftFootF_btn.bitmap = img_LeftFootF1)

	on RightFootC_btn mousedown do (RightFootC_btn.bitmap = img_RightFootC2)
	on RightFootC_btn mouseup   do (RightFootC_btn.bitmap = img_RightFootC2)		
	on RightFootC_btn mouseover do (RightFootC_btn.bitmap = img_RightFootC2)
	on RightFootC_btn mouseout  do (RightFootC_btn.bitmap = img_RightFootC1)

	on RightFootD_btn mousedown do (RightFootD_btn.bitmap = img_RightFootD2)
	on RightFootD_btn mouseup   do (RightFootD_btn.bitmap = img_RightFootD2)		
	on RightFootD_btn mouseover do (RightFootD_btn.bitmap = img_RightFootD2)
	on RightFootD_btn mouseout  do (RightFootD_btn.bitmap = img_RightFootD1)

	on RightFootE_btn mousedown do (RightFootE_btn.bitmap = img_RightFootE2)
	on RightFootE_btn mouseup   do (RightFootE_btn.bitmap = img_RightFootE2)		
	on RightFootE_btn mouseover do (RightFootE_btn.bitmap = img_RightFootE2)
	on RightFootE_btn mouseout  do (RightFootE_btn.bitmap = img_RightFootE1)

	on RightFootF_btn mousedown do (RightFootF_btn.bitmap = img_RightFootF2)
	on RightFootF_btn mouseup   do (RightFootF_btn.bitmap = img_RightFootF2)		
	on RightFootF_btn mouseover do (RightFootF_btn.bitmap = img_RightFootF2)
	on RightFootF_btn mouseout  do (RightFootF_btn.bitmap = img_RightFootF1)

	on LeftFootC_btn click do try((foot_pivot 5 3 1))catch()
	on LeftFootD_btn click do try((foot_pivot 5 3 8))catch()
	on LeftFootE_btn click do try((foot_pivot 5 3 6))catch()
	on LeftFootF_btn click do try((foot_pivot 5 3 3))catch()
	on RightFootC_btn click do try((foot_pivot 6 3 1))catch()
	on RightFootD_btn click do try((foot_pivot 6 3 8))catch()
	on RightFootE_btn click do try((foot_pivot 6 3 6))catch()
	on RightFootF_btn click do try((foot_pivot 6 3 3))catch()

	on select_rootnode_btn pressed do
	(
		try
		(
			max hierarchy mode
			if keyboard.controlpressed == true then (selectmore (allbips[bip_list.selection]))
			else if keyboard.altpressed == true then (deselect (allbips[bip_list.selection]))
			else if keyboard.shiftpressed == true then 
			(
				with redraw off
				(
					temparray =#()
					select (biped.getNode allbips[bip_list.selection] 13 link:1)		
					for i = 1 to 25 do
					(
						for j = 1 to $selection.count do (append temparray ($selection[j]))
						max select child
					)			
					for i = 1 to temparray.count do (selectmore temparray[i])
				)		
			)
			else (select (allbips[bip_list.selection]))
		)catch()
	)
	
	on select_hori_btn pressed do
	(
		try
		(
			max motion mode
			select (allbips[bip_list.selection])
			$.transform.controller.trackSelection=1
		)catch(format"Error: No biped in the scene\n")			
	)

	on select_vert_btn pressed do
	(
		try
		(
			max motion mode
			select (allbips[bip_list.selection])
			$.transform.controller.trackSelection=2
		)catch(format"Error: No biped in the scene\n")			
	)

	on select_rot_btn pressed do
	(
		try
		(
			max motion mode
			select (allbips[bip_list.selection])
			$.transform.controller.trackSelection=3
		)catch(format"Error: No biped in the scene\n")			
	)

	on select_sym_btn pressed do
	(
		try
		(
			filein (getdir #maxroot+"scripts\\JJTools8\\JJTools8_SelectOpposite.ms")
		)
		catch(format"You may be missing the following files:\n\n %" (getdir #maxroot+"scripts\\JJTools8\\JJTools8_SelectOpposite.ms"))
	)
	
	on refresh_bips pressed do
	(
		allbipsName =#()
		allbips = getallbips()
		for i = 1 to allbips.count do (append allbipsName allbips[i].name)
		bip_list.items=allbipsName
	)
	
	on select_all_btn pressed do
	(
		try
		(
			max motion mode
			with redraw off
			(
				temparray =#()
				select (biped.getNode allbips[bip_list.selection] 13 link:1)		
				for i = 1 to 25 do
				(
					for j = 1 to $selection.count do (append temparray ($selection[j]))
					max select child
				)			
				for i = 1 to temparray.count do (selectmore temparray[i])
			)
		)catch()
	)
		
	on select_ruleg_btn pressed do (Bip_Select 6 1)
	on select_rlleg_btn pressed do (Bip_Select 6 2)
	on select_rfoot_btn pressed do (Bip_Select 6 3)
	on select_rtoe_btn pressed do (Bip_Select 8 1)
	on select_luleg_btn pressed do (Bip_Select 5 1)
	on select_llleg_btn pressed do (Bip_Select 5 2)
	on select_lfoot_btn pressed do (Bip_Select 5 3)
	on select_ltoe_btn pressed do (Bip_Select 7 1)
	
	on select_lclav_btn pressed do (Bip_Select 1 1)
	on select_luarm_btn pressed do (Bip_Select 1 2)
	on select_llarm_btn pressed do (Bip_Select 1 3)
	
	on select_lhand_btn pressed do (Bip_Select 1 4)
	on select_lthumb1_btn pressed do (Bip_Select 3 1)
	on select_lthumb2_btn pressed do (Bip_Select 3 2)
	on select_lfing11_btn pressed do (Bip_Select 3 3)			
	on select_lfing12_btn pressed do (Bip_Select 3 4)
	on select_lfing21_btn pressed do (Bip_Select 3 5)
	on select_lfing22_btn pressed do (Bip_Select 3 6)
	on select_lfing31_btn pressed do (Bip_Select 3 7)
	on select_lfing32_btn pressed do (Bip_Select 3 8)
	on select_lhand1_btn pressed do (Bip_Select 1 4)
	
	on select_rclav_btn pressed do (Bip_Select 2 1)
	on select_ruarm_btn pressed do (Bip_Select 2 2)
	on select_rlarm_btn pressed do (Bip_Select 2 3)
	
	on select_rhand_btn pressed do (Bip_Select 2 4)
	on select_rthumb1_btn pressed do (Bip_Select 4 1)
	on select_rthumb2_btn pressed do (Bip_Select 4 2)
	on select_rfing11_btn pressed do (Bip_Select 4 3)			
	on select_rfing12_btn pressed do (Bip_Select 4 4)
	on select_rfing21_btn pressed do (Bip_Select 4 5)
	on select_rfing22_btn pressed do (Bip_Select 4 6)
	on select_rfing31_btn pressed do (Bip_Select 4 7)
	on select_rfing32_btn pressed do (Bip_Select 4 8)
	on select_rhand1_btn pressed do (Bip_Select 2 4)

	on select_pelvis_btn pressed do (Bip_Select 12 1)		
	on select_head_btn pressed do (Bip_Select 11 1)
	on select_neck2_btn pressed do (Bip_Select 17 1)
	on select_neck_btn pressed do (Bip_Select 17 2)
	on select_spine3_btn pressed do (Bip_Select 9 1)
	on select_spine2_btn pressed do (Bip_Select 9 2)
	on select_spine1_btn pressed do (Bip_Select 9 3)
	on select_spine4_btn pressed do
	(
		max motion mode
		if keyboard.shiftpressed == true then
		(
			with redraw off
			(
				temparray =#()
				select (biped.getNode allbips[bip_list.selection] 9 link:1)		
				for i = 1 to 25 do
				(
					for j = 1 to $selection.count do (append temparray ($selection[j]))
					max select child
				)			
				for i = 1 to temparray.count do (selectmore temparray[i])
			)
		)
		else if keyboard.altpressed == true then
		(
			deselect #((biped.getNode allbips[bip_list.selection] 9 link:1))
		)
		else if keyboard.controlpressed == true then
		(
			selectmore (biped.getNode allbips[bip_list.selection] 9 link:1)
			try(selectmore (biped.getNode allbips[bip_list.selection] 9 link:2))catch()
			try(selectmore (biped.getNode allbips[bip_list.selection] 9 link:3))catch()
			try(selectmore (biped.getNode allbips[bip_list.selection] 9 link:4))catch()
		)
		else
		(
			select #((biped.getNode allbips[bip_list.selection] 9 link:1))
			try(selectmore (biped.getNode allbips[bip_list.selection] 9 link:2))catch()
			try(selectmore (biped.getNode allbips[bip_list.selection] 9 link:3))catch()
			try(selectmore (biped.getNode allbips[bip_list.selection] 9 link:4))catch()
		)
	)
	
	on BST_cont close do
	(
		try(callbacks.removeScripts id:#Ubi_BipedTools)catch()
	)
)
	
rollout BST_about "About"
(
	activeXControl ax1 "http://jimjagger.com/JPages/JJTools/JJTools8_BipedSelectionTools.htm" height:85 width:130 align:#center 
)
			
try
(
	closerolloutfloater BST_floater
	BST_pos = BST_floater.pos
	BST_roll_height = BST.floater.height
)
catch()

try(callbacks.removeScripts id:#Ubi_BipedTools)catch()
callbacks.addscript #filePostOpen "registerBipedToolsCallback()" id:#Ubi_BipedTools

BST_floater = newrolloutfloater "Biped Selection Tools 1.61" roll_width roll_height
BST_floater.pos = BST_pos
try
(
	addrollout BST_cont BST_floater rolledup:false
	addrollout BST_about BST_floater rolledup:true
)
catch(messagebox ("There was a problem generating the script.\nYou are probably missing some or all of the image files.\n\nIf the problem persists please contact JimJagger@hotmail.com\n"))