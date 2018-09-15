print "NArt¹¤¾ß£ºBipedÑ¡Ôñ¹¤¾ß"

global tp_BipHead_rol
global tp_BipNeck_rol
		-------×óÉÏÖ«-------
global tp_BipLclavicle_rol
global tp_BipLupperArm_rol
global tp_BipLforearm_rol
global tp_BipLhand_rol
		-------ÓÒÉÏÖ«-------
global tp_BipRclavicle_rol
global tp_BipRupperArm_rol
global tp_BipRforearm_rol
global tp_BipRhand_rol
		-------Çû¸É-------
global tp_BipSpine_rol
global tp_BipSpine1_rol
global tp_BipSpine2_rol
		-------ÖÊÐÄ-------
global	tp_Bip_rol
		-------Åè¹Ç-------
global tp_BipPelvis_rol
		-------×óÍÈ-------
global tp_BipLthigh_rol
global tp_BipLCalf_rol
global tp_BipLFoot_rol
		-------ÓÒÍÈ-------
global tp_BipRthigh_rol
global tp_BipRCalf_rol
global tp_BipRFoot_rol

global tp_CreatCSrol_fn
fn tp_CreatCSrol_fn=
(
	try(
		-------------×ø±ê--------------
		tp_BipHead_Pos=[mouse.screenpos.x-20,mouse.screenpos.y-145]
		tp_BipNeck_Pos=[mouse.screenpos.x-7,mouse.screenpos.y-102]
		-------×óÉÏÖ«-------
		tp_BipLclavicle_Pos=[mouse.screenpos.x+20,mouse.screenpos.y-95]
		tp_BipLupperArm_Pos=[mouse.screenpos.x+38,mouse.screenpos.y-77]
		tp_BipLforearm_pos=[mouse.screenpos.x+38,mouse.screenpos.y-27]
		tp_BipLhand_pos=[mouse.screenpos.x+38,mouse.screenpos.y+20]
		-------ÓÒÉÏÖ«-------
		tp_BipRclavicle_Pos=[mouse.screenpos.x-57,mouse.screenpos.y-95]
		tp_BipRupperArm_Pos=[mouse.screenpos.x-57,mouse.screenpos.y-77]
		tp_BipRforearm_pos=[mouse.screenpos.x-57,mouse.screenpos.y-27]
		tp_BipRhand_pos=[mouse.screenpos.x-57,mouse.screenpos.y+20]
		-------Çû¸É-------
		tp_BipSpine_pos=[mouse.screenpos.x-25,mouse.screenpos .y-33]
		tp_BipSpine1_pos=[mouse.screenpos.x-25,mouse.screenpos.y-55]
		tp_BipSpine2_pos=[mouse.screenpos.x-25,mouse.screenpos.y-77]
		-------ÖÃÐÄ-------
		tp_Bip_pos=[mouse.screenpos.x-3,mouse.screenpos.y-10]
		-------Åè¹Ç-------
		tp_BipPelvis_pos=[mouse.screenpos.x-25,mouse.screenpos.y-10]
		-------×óÍÈ-------
		tp_BipLthigh_pos=[mouse.screenpos.x+5,mouse.screenpos.y+13]
		tp_BipLCalf_pos=[mouse.screenpos.x+5,mouse.screenpos.y+65]
		tp_BipLFoot_pos=[mouse.screenpos.x+5,mouse.screenpos.y+117]
		-------ÓÒÍÈ-------
		tp_BipRthigh_pos=[mouse.screenpos.x-25,mouse.screenpos.y+13]
		tp_BipRCalf_pos=[mouse.screenpos.x-25,mouse.screenpos.y+65]
		tp_BipRFoot_pos=[mouse.screenpos.x-34,mouse.screenpos.y+117]
		
		---------------½¨Á¢¶Ô»°¿ò----------------
		
		createdialog tp_BipHead_rol pos:tp_BipHead_Pos style:#()
		createdialog tp_BipNeck_rol pos:tp_BipNeck_Pos style:#()
		-------×óÉÏÖ«-------
		createdialog tp_BipLclavicle_rol pos:tp_BipLclavicle_Pos style:#()
		createdialog tp_BipLupperArm_rol pos:tp_BipLupperArm_Pos style:#()
		createdialog tp_BipLforearm_rol pos:tp_BipLforearm_pos style:#()
		createdialog tp_BipLhand_rol pos:tp_BipLhand_pos style:#()
		-------ÓÒÉÏÖ«-------
		createdialog tp_BipRclavicle_rol pos:tp_BipRclavicle_Pos style:#()
		createdialog tp_BipRupperArm_rol pos:tp_BipRupperArm_Pos style:#()
		createdialog tp_BipRforearm_rol pos:tp_BipRforearm_pos style:#()
		createdialog tp_BipRhand_rol pos:tp_BipRhand_pos style:#()	
		-------Çû¸É-------
		createdialog tp_BipSpine_rol pos:tp_BipSpine_Pos style:#()
		createdialog tp_BipSpine1_rol pos:tp_BipSpine1_Pos style:#()
		createdialog tp_BipSpine2_rol pos:tp_BipSpine2_Pos style:#()
		-------Åè¹Ç-------
		createdialog tp_BipPelvis_rol pos:tp_BipPelvis_pos style:#()
		
		-------ÖÃÐÄ-------
		createdialog tp_Bip_rol pos:tp_Bip_Pos style:#()
		
		-------×óÍÈ-------
		createdialog tp_BipLthigh_rol pos:tp_BipLthigh_pos style:#()
		createdialog tp_BipLCalf_rol pos:tp_BipLCalf_pos style:#()
		createdialog tp_BipLFoot_rol pos:tp_BipLFoot_pos style:#()
		-------ÓÒÍÈ-------
		createdialog tp_BipRthigh_rol pos:tp_BipRthigh_pos style:#()
		createdialog tp_BipRCalf_rol pos:tp_BipRCalf_pos style:#()
		createdialog tp_BipRFoot_rol pos:tp_BipRFoot_pos style:#()
		
	)catch()

)

global tp_DestroyCSrol_fn
fn tp_DestroyCSrol_fn=
(
	try(
		DestroyDialog tp_BipHead_rol
		DestroyDialog tp_BipNeck_rol
		-------×óÉÏÖ«-------
		DestroyDialog tp_BipLclavicle_rol
		DestroyDialog tp_BipLupperArm_rol
		DestroyDialog tp_BipLforearm_rol
		DestroyDialog tp_BipLhand_rol
		-------ÓÒÉÏÖ«-------
		DestroyDialog tp_BipRclavicle_rol
		DestroyDialog tp_BipRupperArm_rol
		DestroyDialog tp_BipRforearm_rol
		DestroyDialog tp_BipRhand_rol
		-------Çû¸É-------
		DestroyDialog tp_BipSpine_rol
		DestroyDialog tp_BipSpine1_rol
		DestroyDialog tp_BipSpine2_rol
		-------ÖÊÐÄ-------
		DestroyDialog tp_Bip_rol
		-------Åè¹Ç-------
		DestroyDialog tp_BipPelvis_rol
		-------×óÍÈ-------
		DestroyDialog tp_BipLthigh_rol
		DestroyDialog tp_BipLCalf_rol
		DestroyDialog tp_BipLFoot_rol
		-------ÓÒÍÈ-------
		DestroyDialog tp_BipRthigh_rol
		DestroyDialog tp_BipRCalf_rol
		DestroyDialog tp_BipRFoot_rol
		------------------------------------------------------------

	)catch()

)

tp_DestroyCSrol_fn()
------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-Í·-------------------------------------------------------------
	rollout tp_BipHead_rol "BipHead" width:40 height:40
	(
		imgTag tp_SelHead_btn "Í·"  pos:[0,0] bitmap:(bitmap 40 40 color:(color 166 202 240))  tooltip:"Í·"
		
		on tp_SelHead_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #Head )
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_SelHead_btn mouseover do
		( 	
			tp_SelHead_btn.bitmap=bitmap 40 40 color:white
		)
		
		on tp_SelHead_btn mouseout do
		( 	
			tp_SelHead_btn.bitmap=bitmap 40 40 color:(color 166 202 240)
		)	
	)	
	
	
------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-²±×Ó---------tp_BipNeck_rol------------------------------------
	rollout tp_BipNeck_rol "Neck" width:17 height:20
	(
		imgTag tp_SelNeck_btn "²±×Ó"  pos:[0,0] bitmap:(bitmap 17 20 color:(color 8 110 134))  tooltip:"Neck"
		
		on tp_SelNeck_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #Neck link:1)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_SelNeck_btn mouseover do
		( 	
			tp_SelNeck_btn.bitmap=bitmap 17 20 color:white
		)
		
		on tp_SelNeck_btn mouseout do
		( 	
			tp_SelNeck_btn.bitmap=bitmap 17 20 color:(color 8 110 134)
		)	
	)	

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-×ó¼ç---------tp_BipLclavicle_rol----------------------------
	rollout tp_BipLclavicle_rol "L_Clavicle" width:37 height:15
	(
		imgTag tp_BipLclavicle_btn "×ó¼ç"  pos:[0,0] bitmap:(bitmap 37 15 color:(color 28 28 177))  tooltip:"L_Clavicle"
		
		on tp_BipLclavicle_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #larm link:1)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipLclavicle_btn mouseover do
		( 	
			tp_BipLclavicle_btn.bitmap=bitmap 37 15 color:white
		)
		
		on tp_BipLclavicle_btn mouseout do
		( 	
			tp_BipLclavicle_btn.bitmap=bitmap 37 15 color:(color 28 28 177)
		)	
	)	

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-×ó´ó±Û---------tp_BipLupperArm_rol----------------------------
	rollout tp_BipLupperArm_rol "L_UpperArm" width:18 height:48
	(
		imgTag tp_BipLupperArm_btn "×ó´ó±Û"  pos:[0,0] bitmap:(bitmap 18 48 color:(color 28 28 177))  tooltip:"L_UpperArm"
		
		on tp_BipLupperArm_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #larm link:2)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipLupperArm_btn mouseover do
		( 	
			tp_BipLupperArm_btn.bitmap=bitmap 18 48 color:white
		)
		
		on tp_BipLupperArm_btn mouseout do
		( 	
			tp_BipLupperArm_btn.bitmap=bitmap 18 48 color:(color 28 28 177)
		)	
	)	

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-×óÐ¡±Û---------tp_BipLforearm_rol----------------------------
	rollout tp_BipLforearm_rol "L_Forearm" width:18 height:45
	(
		imgTag tp_BipLforearm_btn "×óÐ¡±Û"  pos:[0,0] bitmap:(bitmap 18 45 color:(color 28 28 177))  tooltip:"L_Forearm"
		
		on tp_BipLforearm_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #larm link:3)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipLforearm_btn mouseover do
		( 	
			tp_BipLforearm_btn.bitmap=bitmap 18 45 color:white
		)
		
		on tp_BipLforearm_btn mouseout do
		( 	
			tp_BipLforearm_btn.bitmap=bitmap 18 45 color:(color 28 28 177)
		)	
	)	
	
------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-×óÊÖ---------tp_BipLhand_rol----------------------------
	rollout tp_BipLhand_rol "L_hand" width:18 height:18
	(
		imgTag tp_BipLhand_btn "×óÊÖ"  pos:[0,0] bitmap:(bitmap 18 18 color:(color 28 28 177))  tooltip:"L_hand"
		
		on tp_BipLhand_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #larm link:4)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipLhand_btn mouseover do
		( 	
			tp_BipLhand_btn.bitmap=bitmap 18 18 color:white
		)
		
		on tp_BipLhand_btn mouseout do
		( 	
			tp_BipLhand_btn.bitmap=bitmap 18 18 color:(color 28 28 177)
		)	
	)	
		
	
------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-ÓÒ¼ç---------tp_BipRclavicle_rol----------------------------
	rollout tp_BipRclavicle_rol "R_Clavicle" width:37 height:15
	(
		imgTag tp_BipRclavicle_btn "ÓÒ¼ç"  pos:[0,0] bitmap:(bitmap 37 15 color:(color 6 134 6))  tooltip:"R_Clavicle"
		
		on tp_BipRclavicle_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #rarm link:1)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipRclavicle_btn mouseover do
		( 	
			tp_BipRclavicle_btn.bitmap=bitmap 37 15 color:white
		)
		
		on tp_BipRclavicle_btn mouseout do
		( 	
			tp_BipRclavicle_btn.bitmap=bitmap 37 15 color:(color 6 134 6)
		)	
	)	

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-ÓÒ´ó±Û---------tp_BipRupperArm_rol----------------------------
	rollout tp_BipRupperArm_rol "R_UpperArm" width:18 height:48
	(
		imgTag tp_BipRupperArm_btn "×ó´ó±Û"  pos:[0,0] bitmap:(bitmap 18 48 color:(color 6 134 6))  tooltip:"R_UpperArm"
		
		on tp_BipRupperArm_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #rarm link:2)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipRupperArm_btn mouseover do
		( 	
			tp_BipRupperArm_btn.bitmap=bitmap 18 48 color:white
		)
		
		on tp_BipRupperArm_btn mouseout do
		( 	
			tp_BipRupperArm_btn.bitmap=bitmap 18 48 color:(color 6 134 6)
		)	
	)	

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-ÓÒÐ¡±Û---------tp_BipRforearm_rol----------------------------
	rollout tp_BipRforearm_rol "R_Forearm" width:18 height:45
	(
		imgTag tp_BipRforearm_btn "×óÐ¡±Û"  pos:[0,0] bitmap:(bitmap 18 45 color:(color 6 134 6))  tooltip:"R_Forearm"
		
		on tp_BipRforearm_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #rarm link:3)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipRforearm_btn mouseover do
		( 	
			tp_BipRforearm_btn.bitmap=bitmap 18 45 color:white
		)
		
		on tp_BipRforearm_btn mouseout do
		( 	
			tp_BipRforearm_btn.bitmap=bitmap 18 45 color:(color 6 134 6)
		)	
	)	
	
------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-ÓÒÊÖ---------tp_BipRhand_rol----------------------------
	rollout tp_BipRhand_rol "R_hand" width:18 height:18
	(
		imgTag tp_BipRhand_btn "×óÊÖ"  pos:[0,0] bitmap:(bitmap 18 18 color:(color 6 134 6))  tooltip:"R_hand"
		
		on tp_BipRhand_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #rarm link:4)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipRhand_btn mouseover do
		( 	
			tp_BipRhand_btn.bitmap=bitmap 18 18 color:white
		)
		
		on tp_BipRhand_btn mouseout do
		( 	
			tp_BipRhand_btn.bitmap=bitmap 18 18 color:(color 6 134 6)
		)	
	)	
	
	------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-Çû¸É---------tp_BipSpine_rol----------------------------
	rollout tp_BipSpine_rol "Spine" width:51 height:20
	(
		imgTag tp_BipSpine_btn "Çû¸É"  pos:[0,0] bitmap:(bitmap 51 20 color:(color 8 110 134))  tooltip:"Spine"
		
		on tp_BipSpine_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #Spine link:1)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipSpine_btn mouseover do
		( 	
			tp_BipSpine_btn.bitmap=bitmap 51 20 color:white
		)
		
		on tp_BipSpine_btn mouseout do
		( 	
			tp_BipSpine_btn.bitmap=bitmap 51 20 color:(color 8 110 134)
		)	
	)
	------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-Çû¸É1---------tp_BipSpine1_rol----------------------------
	rollout tp_BipSpine1_rol "Spine1" width:51 height:20
	(
		imgTag tp_BipSpine1_btn "Çû¸É1"  pos:[0,0] bitmap:(bitmap 51 20 color:(color 8 110 134))  tooltip:"Spine1"
		
		on tp_BipSpine1_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					if (Biped.GetNode i #Spine link:2)!=undefined do
					Select (Biped.GetNode i #Spine link:2)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipSpine1_btn mouseover do
		( 	
			tp_BipSpine1_btn.bitmap=bitmap 51 20 color:white
		)
		
		on tp_BipSpine1_btn mouseout do
		( 	
			tp_BipSpine1_btn.bitmap=bitmap 51 20 color:(color 8 110 134)
		)	
	)
		------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-Çû¸É2---------tp_BipSpine1_rol----------------------------
	rollout tp_BipSpine2_rol "Spine2" width:51 height:20
	(
		imgTag tp_BipSpine2_btn "Çû¸É2"  pos:[0,0] bitmap:(bitmap 51 20 color:(color 8 110 134))  tooltip:"Spine2"
		
		on tp_BipSpine2_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					if (Biped.GetNode i #Spine link:3)!=undefined do
					Select (Biped.GetNode i #Spine link:3)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipSpine2_btn mouseover do
		( 	
			tp_BipSpine2_btn.bitmap=bitmap 51 20 color:white
		)
		
		on tp_BipSpine2_btn mouseout do
		( 	
			tp_BipSpine2_btn.bitmap=bitmap 51 20 color:(color 8 110 134)
		)	
	)

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-ÖÃÐÄ---------tp_Bip_rol----------------------------
	
	rollout tp_Bip_rol "Spine" width:29 height:20
	(
		imgTag tp_Bip_btn "ÖÃÐÄ"  pos:[0,0] bitmap:(bitmap 29 20 color:red)  tooltip:"Bip"
		
		on tp_Bip_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #turn)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_Bip_btn mouseover do 
		( 	
			tp_Bip_btn.bitmap=bitmap 29 20 color:white
		)
		
		on tp_Bip_btn mouseout do
		( 	
			tp_Bip_btn.bitmap=bitmap 29 20 color:red
		)	
	)	
	
------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-Åè¹Ç---------tp_BipPelvis_rol----------------------------
	
	rollout tp_BipPelvis_rol "Pelvis" width:20 height:20
		(
		imgTag tp_BipPelvis_btn "ÖÃÐÄ"  pos:[0,0] bitmap:(bitmap 20 20 color:(color 224 198 87))  tooltip:"Pelvis"
		
		on tp_BipPelvis_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #pelvis)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipPelvis_btn mouseover do
		( 	
			tp_BipPelvis_btn.bitmap=bitmap 20 20 color:white
		)
		
		on tp_BipPelvis_btn mouseout do
		( 	
			tp_BipPelvis_btn.bitmap=bitmap 20 20 color:(color 224 198 87)
		)	
	)	
	
------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-×ó´óÍÈ---------tp_BipLthigh_rol----------------------------
	rollout tp_BipLthigh_rol "L_Thigh" width:21 height:50
	(
		imgTag tp_BipLthigh_btn "×ó´óÍÈ"  pos:[0,0] bitmap:(bitmap 21 50 color:(color 28 28 177))  tooltip:"L_Thigh"
		
		on tp_BipLthigh_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #lleg link:1)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipLthigh_btn mouseover do
		( 	
			tp_BipLthigh_btn.bitmap=bitmap 21 50 color:white
		)
		
		on tp_BipLthigh_btn mouseout do
		( 	
			tp_BipLthigh_btn.bitmap=bitmap 21 50 color:(color 28 28 177)
		)	
	)	

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-×óÐ¡ÍÈ---------tp_BipLCalf_rol----------------------------
	rollout tp_BipLCalf_rol "L_Calf" width:21 height:50
	(
		imgTag tp_BipLCalf_btn "×óÐ¡ÍÈ"  pos:[0,0] bitmap:(bitmap 21 50 color:(color 28 28 177))  tooltip:"L_Calf"
		
		on tp_BipLCalf_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #lleg link:2)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipLCalf_btn mouseover do
		( 	
			tp_BipLCalf_btn.bitmap=bitmap 21 50 color:white
		)
		
		on tp_BipLCalf_btn mouseout do
		( 	
			tp_BipLCalf_btn.bitmap=bitmap 21 50 color:(color 28 28 177)
		)	
	)	

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-×ó½Å---------tp_BipLFoot_rol----------------------------
	rollout tp_BipLFoot_rol "L_foot" width:30 height:20
	(
		imgTag tp_BipLFoot_btn "×óÐ¡ÍÈ"  pos:[0,0] bitmap:(bitmap 30 20 color:(color 28 28 177))  tooltip:"L_foot"
		
		on tp_BipLFoot_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #lleg link:3)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipLFoot_btn mouseover do
		( 	
			tp_BipLFoot_btn.bitmap=bitmap 30 20 color:white
		)
		
		on tp_BipLFoot_btn mouseout do
		( 	
			tp_BipLFoot_btn.bitmap=bitmap 30 20 color:(color 28 28 177)
		)	
	)
	
------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-ÓÒ´óÍÈ---------tp_BipRthigh_rol----------------------------
	rollout tp_BipRthigh_rol "R_Thigh" width:21 height:50
	(
		imgTag tp_BipRthigh_btn "×ó´óÍÈ"  pos:[0,0] bitmap:(bitmap 21 50 color:(color 6 134 6))  tooltip:"R_Thigh"
		
		on tp_BipRthigh_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #rleg link:1)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipRthigh_btn mouseover do
		( 	
			tp_BipRthigh_btn.bitmap=bitmap 21 50 color:white
		)
		
		on tp_BipRthigh_btn mouseout do
		( 	
			tp_BipRthigh_btn.bitmap=bitmap 21 50 color:(color 6 134 6)
		)	
	)	

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-ÓÒÐ¡ÍÈ---------tp_BipRCalf_rol----------------------------
	rollout tp_BipRCalf_rol "R_Calf" width:21 height:50
	(
		imgTag tp_BipRCalf_btn "×óÐ¡ÍÈ"  pos:[0,0] bitmap:(bitmap 21 50 color:(color 6 134 6))  tooltip:"R_Calf"
		
		on tp_BipRCalf_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #rleg link:2)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipRCalf_btn mouseover do
		( 	
			tp_BipRCalf_btn.bitmap=bitmap 21 50 color:white
		)
		
		on tp_BipRCalf_btn mouseout do
		( 	
			tp_BipRCalf_btn.bitmap=bitmap 21 50 color:(color 6 134 6)
		)	
	)	

------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------rollout-ÓÒ½Å---------tp_BipRFoot_rol----------------------------
	rollout tp_BipRFoot_rol "R_foot" width:30 height:20
	(
		imgTag tp_BipRFoot_btn "×óÐ¡ÍÈ"  pos:[0,0] bitmap:(bitmap 30 20 color:(color 6 134 6))  tooltip:"R_foot"
		
		on tp_BipRFoot_btn mousedown do
		( 	
			for i in geometry do
			(
				if classof i==biped_object do	
				(
					Select (Biped.GetNode i #rleg link:3)
					max motion mode;exit
				)
			)
			tp_DestroyCSrol_fn()
		)
		
		on tp_BipRFoot_btn mouseover do
		( 	
			tp_BipRFoot_btn.bitmap=bitmap 30 20 color:white
		)
		
		on tp_BipRFoot_btn mouseout do
		( 	
			tp_BipRFoot_btn.bitmap=bitmap 30 20 color:(color 6 134 6)
		)	
	)
	

	tp_CreatCSrol_fn()	