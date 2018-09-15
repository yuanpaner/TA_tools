/*****************************************************************
Convert Biped to Bones

Tool by: Jason Labbé
E-mail: info@jasonlabbe3d.com
Website: www.jasonlabbe3d.com

Tool Version: v1.0
Max Version: 2008 (32 bit)

Description: 
 - After posing a biped to a character's base pose, you can use this tool to create a base skeleton rig from the biped
 
Wish List:
 - Have the tool guess what the bone size should be
 
Bugs:

History:
 v1.0 - Tool is created
****************************************************************/

(
	if dialog_convertBiped != undefined do try(destroyDialog dialog_convertBiped) catch()
	
	rollout dialog_convertBiped "Convert Biped to Bones v1.0"
	(
		global dialog_convertBiped
		local roots = #()
		local points = #()
		local	leftBn = #()
		local rightBn = #()
		local centerBn = #()
		local leftBn_small = #()
		local rightBn_small = #()
		
		group "Available Bipeds"
		(
			listBox lb_bipeds
			button bt_refreshList "Refrest List" height:15 width:225
		)
		group "Color Settings"
		(
			colorPicker cp_left "Left" height:15 width:50 across:3 color:red align:#left
			colorPicker cp_center "Center:" height:15 width:70 color:[0,200,255] align:#center
			colorPicker cp_right "Right" height:15 width:60 color:green align:#right
		)
		group "Naming Settings"
		(
			editText txt_prefix "Prefix:" text:"Character" width:170 across:2 align:#left enabled:false
			checkBox cb_name "" align:#right offset:[0,1]
		)
		group "Other Settings"
		(
			label lab_delBip "Delete Biped:" across:2 align:#left
			checkBox cb_delBip "" checked:true align:#right offset:[0,1]
		)
		button bt_convertBiped "Convert Biped" height:15 width:225
		
		/***********************************************************
		Description:		Refreshes list of bipeds in the scene
		Returns:			availableBipeds <array>	:		Array of nodes
		************************************************************/
		fn refreshList =
		(
			availableBipeds = #()
			roots = #()
			
			for o in objects where (classOf o) == biped_object do 
			(
				root = o.controller.rootNode
				
				if (findItem availableBipeds root.name) == 0 do 
				(
					append availableBipeds root.name
					append roots root
				)
			)
			
			return availableBipeds
		)
		
		/***********************************************************
		Description:		Creates a bone chain based off points in space
		Parameters:		Points <array>		:		Array of nodes
							xAxis <point3>	:		Up direction of bones
		Returns:			boneChain <array>	:		Array of nodes
		************************************************************/
		fn createBoneChain points:undefined boneSize:0.75 dir:undefined arr:undefined =
		(
			boneChain = #()
			tm; boneObject
			if points != undefined do
			(
				if points.count > 0 do
				(
					for o = 1 to (points.count-1) do
					(
						tm = undefined
						objTm = points[o].transform
						boneObject = (bonesys.createBone objTm.pos points[o+1].transform.pos points[o].dir)
						case dir of
						(
							#r_arm: tm = (matrix3 objTm.row1 -objTm.row2 -objTm.row3 objTm.pos)
							#hand: tm = (matrix3 objTm.row1 objTm.row3 -objTm.row2 objTm.pos)	
							#l_leg: tm = (matrix3 objTm.row1 -objTm.row2 -objTm.row3 objTm.pos)
							#l_foot: tm = (matrix3 boneObject.transform.row1 -boneObject.transform.row2 -boneObject.transform.row3 boneObject.transform.pos)
							#l_toes: tm = (matrix3 objTm.row1 -objTm.row2 -objTm.row3 objTm.pos)
							#r_fingers: tm = (matrix3 objTm.row1 -objTm.row2 -objTm.row3 objTm.pos)
						)
						if tm != undefined and dir != #hand do boneObject.transform = tm
						
						boneObject.height = boneSize; boneObject.width = boneSize
						boneObject.frontFin = false; boneObject.backFin = false; boneObject.sideFins = false
						append boneChain boneObject
						append arr boneObject
					)
					
				-- Nub Bone
					vec = ( normalize (points[points.count].transform.pos - points[points.count-1].transform.pos) ) * boneSize
					boneNub = (bonesys.createBone points[points.count].transform.pos (points[points.count].transform.pos + vec) boneChain[boneChain.count].dir)
					boneNub.height = boneSize; boneNub.width = boneSize
					boneNub.frontFin = false; boneNub.backFin = false; boneNub.sideFins = false
					append boneChain boneNub
					append arr boneNub
						
				-- Root point helper	
					root = point wireColor:red size:(boneSize*2) box:true cross:false axisTripod:false centerMarker:false
					root.transform = boneChain[1].transform
					insertItem root boneChain 1
					append arr root
					
				-- Link parts up
					for o = boneChain.count to 2 by -1 do boneChain[o].parent = boneChain[o-1]
						
				-- The hand is a special case to do later on, or else its nub will be offset		
					if dir == #hand do boneObject.transform = tm
				)
			)
			return boneChain
		)
		
		/***************************************************************************************************************
		Description:		Since biped's structure can be altered, this dynamically gathers a series of nodes specified by its limb
		Parameters:		bipedObj <node>		:		Array of nodes
							part <property>		:		Check 'Biped Node Hierarchy' reference
		Returns:			bipedChain <array>	:		Array of nodes
		***************************************************************************************************************/
		fn getBipedChain bipedObj:undefined part:undefined getDummyNub:false =
		(
			bipedChain = #()
			val = 1
			while (biped.getNode bipedObj part link:val) != undefined do
			(
				append bipedChain (biped.getNode bipedObj part link:val)
				val += 1
			)
			
			if getDummyNub != false do
			(
				if bipedChain.count > 0 do
				(
					endBone = bipedChain[bipedChain.count]
					if endBone.children.count > 0 do
					(
					-- Biped uses dummies for some of their nubs, so we'll search for these. Even if more than one are found, we'll just use the first one. This is a bad hack to use for now.	
						dummyNubs = for o in endBone.children where (classOf o) == dummy collect o
						if dummyNubs.count > 0 do append bipedChain dummyNubs[1]
					)
				)
			)
			
			return bipedChain
		)
		
		/***************************************************************************************************************
		Description:		Grabs procedurally biped joints (fingers, toes)
		Parameters:		fingers <integer>		:		Number of joints on biped
							links <integer>		:		Number of joint links on biped
							bipedRoot <node>		:		Biped root node
							type <property>		:		The type of limb to search under (#rFingers, rToes)
		Returns:			bipedChain <array>	:		Array of nodes
		***************************************************************************************************************/
		fn getBipedFingers fingers:0 links:0 bipedRoot:undefined type:#undefined =
		(
			bipedChain = #()
			for x = 1 to (fingers*links) by links do
			(
				joints = for n = x to (x+links-1) collect (biped.getNode bipedRoot.controller type link:n)
				dummyNubs = for a in joints[joints.count].children where (classOf a) == dummy collect a
				if dummyNubs.count > 0 do append joints dummyNubs[1]
				append bipedChain joints
			)
			
			return bipedChain
		)
		
		/******************************************************************************************************************
		Description:		Some objects don't have a solid end position to use (hands, feet). So we have to calculate our own end pos.
		Parameters:		bipedObj <node>		:		Biped object to gather transform data from
							toes <boolean>			:		If set to true, it tries to find the end position of the toe
							root <node>			:		Biped root
							type <property>		:		This basically is either #rtoes or #ltoes, to determine what side to use
		Returns:			bipedChain <array>	:		Array of nodes
		******************************************************************************************************************/
		fn getBipedHands bipedObj:undefined toes:false root:undefined type:#undefined =
		(
			bipedChain = #()
			
			startPos = bipedObj.transform.position
			centerPos = bipedObj.center
			dir = ((centerPos-startPos) )
			endPos = startPos + (dir*2)
			tm = bipedObj.transform
			tm.pos = endPos
			pt = point()
			pt.transform = tm
			
			append bipedChain bipedObj
			append bipedChain pt
			append points pt
			
		-- Getting end position for the toe.	
			if toes == true do
			(
				toeNum = root.controller.toes
				toeLinkNum = root.controller.toeLinks
				
				case toeNum of
				(
					1: 
					(
						helperNub = (biped.getNode root.controller type link:toeLinkNum).children[1]
						toePos = helperNub.transform.pos
					)
					2: 
					(
						helperNub_01 = (biped.getNode root.controller type link:toeLinkNum).children[1]
						helperNub_02 = (biped.getNode root.controller type link:toeLinkNum*2).children[1]
						toePos = ((helperNub_01.transform.pos + helperNub_02.transform.pos)/2)
					)
					3: 
					(
						helperNub = (biped.getNode root.controller type link:toeLinkNum*2).children[1]
						toePos = helperNub.transform.pos
					)
					4:
					(
						helperNub_01 = (biped.getNode root.controller type link:toeLinkNum*2).children[1]
						helperNub_02 = (biped.getNode root.controller type link:toeLinkNum*3).children[1]
						toePos = ((helperNub_01.transform.pos + helperNub_02.transform.pos/2))
					)
					5: 
					(
						helperNub = (biped.getNode root.controller type link:(toeLinkNum*3)).children[1]
						toePos = helperNub.transform.pos
					)
				)
				
				toeHelper = point()
				toeHelper.pos = toePos
				append bipedChain toeHelper
				append points toeHelper
			)
			
			return bipedChain
		)
		
		
		
		/******************************************************************************************************************
		Description:		Properly applies naming conventions to objects
		Parameters:		nodes <array>			:		Collection of nodes
							prefix <string>		:		Name's prefix
							theObject <string>	:		The type of object it should be named
		Returns:			OK
		******************************************************************************************************************/		
		fn setName nodes:#() prefix:"" theObject:"" =
		(
			if nodes.count > 0 do
			(
				nodes[1].name = (prefix + "_DM_" + theObject)
				
				for o = 2 to nodes.count-1 do 
				(
					if o >= 10 then theNumber = ("_" + ((o-1) as string))
					else theNumber = ("_0" + ((o-1) as string))
					
					nodes[o].name = (prefix + "_BN_" + theObject + theNumber)
				)
				
				nodes[nodes.count].name = (prefix + "_BN_" + theObject + "_Nub")
			)
			
			return OK
		)
		
		/******************************************************************************************************************
		Description:		Creates a new dialog, which gives the user the ability to set the size of the new rig
		Returns:			OK
		******************************************************************************************************************/		
		fn openSizeDialog =
		(
			rollout dialog_setSize "Set Size"
			(
				slider sl_size "" across:3 range:[-999, 999, 0] width:450 align:#left
				spinner sp_size fieldWidth:40 range:[-999, 999, 0] offset:[135,10]
				button bt_done "OK" align:#right height:40 width:40
				
				fn setValue nodes:#() val:0 small:false =
				(
					if small == true then v = val * 0.25
					else v = val
					
					for o in nodes do 
					(
						if (classOf o) == boneGeometry do
						(
							o.width = (v * 0.01)
							o.height = (v * 0.01)
						)
						
						if (classOf o) == point do o.size = (v * 0.02)
					)
				)
				
				on sl_size changed val do 
				(
					sp_size.value = val
					setValue nodes:(leftBn + rightBn + centerBn) val:val
					setValue nodes:(leftBn_small + rightBn_small) val:val small:true
				)
				on sp_size changed val do
				(
					sl_size.value = val
					setValue nodes:(leftBn + rightBn + centerBn) val:val
					setValue nodes:(leftBn_small + rightBn_small) val:val small:true
				)
				on bt_done pressed do destroyDialog dialog_setSize
			)
			createDialog dialog_setSize 600 50 style:#() modal:true
			
			return OK
		)
		
		/******************************************************************************************************************
		Description:		The main function
		Returns:			OK
		******************************************************************************************************************/		
		fn convertBiped =
		(
			root = roots[lb_bipeds.selection]
			points = #()
			leftBn = #()
			rightBn = #()
			centerBn = #()
			
		-- Gather all the biped bones in proper order	
			r_arm = getBipedChain bipedObj:root part:#rarm
			l_arm = getBipedChain bipedObj:root part:#larm
			r_leg = getBipedChain bipedObj:root part:#rleg
			l_leg = getBipedChain bipedObj:root part:#lleg
			spine = (getBipedChain bipedObj:root part:#spine) 
			append spine (biped.getNode root.controller #neck link:1)
			neck = ( (getBipedChain bipedObj:root part:#neck) + (getBipedChain bipedObj:root part:#head getDummyNub:true) )
			pelvis = #( (biped.getNode root.controller #spine link:1), (biped.getNode root.controller #pelvis link:1) )
			r_hand = getBipedHands bipedObj:(biped.getNode root.controller #rarm link:4)
			l_hand = getBipedHands bipedObj:(biped.getNode root.controller #larm link:4)
			r_foot = getBipedHands bipedObj:(biped.getNode root.controller #rleg link:3) toes:true root:root type:#rtoes
			l_foot = getBipedHands bipedObj:(biped.getNode root.controller #lleg link:3) toes:true root:root type:#ltoes
			tail = getBipedChain bipedObj:root part:#tail getDummyNub:true
			pony1 = getBipedChain bipedObj:root part:#pony1 getDummyNub:true
			pony2 = getBipedChain bipedObj:root part:#pony2 getDummyNub:true
			
		-- Fingers and toes are multi-arrays	
			r_fingers = getBipedFingers fingers:root.controller.fingers links:root.controller.fingerLinks bipedRoot:root type:#rFingers
			l_fingers = getBipedFingers fingers:root.controller.fingers links:root.controller.fingerLinks bipedRoot:root type:#lFingers
			if root.controller.toes > 1 do
			(
				r_toes = getBipedFingers fingers:root.controller.toes links:root.controller.toeLinks bipedRoot:root type:#rToes
				l_toes = getBipedFingers fingers:root.controller.toes links:root.controller.toeLinks bipedRoot:root type:#lToes 
			)
			
		-- Create bones
			bn_r_arm = (createBoneChain points:r_arm dir:#r_arm arr:rightBn)
			bn_l_arm = (createBoneChain points:l_arm arr:leftBn)
			bn_r_leg = (createBoneChain points:r_leg arr:rightBn)
			bn_l_leg = (createBoneChain points:l_leg dir:#l_leg arr:leftBn)
			bn_spine = (createBoneChain points:spine arr:centerBn)
			bn_neck = (createBoneChain points:neck arr:centerBn)
			bn_pelvis = (createBoneChain points:pelvis arr:centerBn)
			bn_r_hand = (createBoneChain points:r_hand dir:#hand arr:rightBn)
			bn_l_hand = (createBoneChain points:l_hand dir:#hand arr:leftBn)
			bn_r_foot = (createBoneChain points:r_foot arr:rightBn)
			bn_l_foot = (createBoneChain points:l_foot  dir:#l_foot arr:leftBn)
			bn_tail = (createBoneChain points:tail arr:centerBn)
			bn_pony1 = (createBoneChain points:pony1 arr:centerBn)
			bn_pony2 = (createBoneChain points:pony2 arr:centerBn)
			
			bn_r_fingers = #(); bn_l_fingers = #(); bn_r_toes = #(); bn_l_toes = #()
			
			for o in r_fingers do 
			(
				fingers = (createBoneChain points:o boneSize:0.25 dir:#r_fingers arr:rightBn_small)
				append bn_r_fingers fingers
			)
			for o in l_fingers do 
			(	
				fingers = (createBoneChain points:o boneSize:0.25 arr:leftBn_small)
				append bn_l_fingers fingers
			)
			
			if root.controller.toes > 1 do
			(
				for o in r_toes do 
				(
					toes = (createBoneChain points:o boneSize:0.25 arr:rightBn_small)
					append bn_r_toes toes
				)
				for o in l_toes do 
				(	
					toes = (createBoneChain points:o boneSize:0.25 dir:#l_toes arr:leftBn_small)
					append bn_l_toes toes
				)
			)
			
		-- Link joints up
			bn_r_arm[1].parent = bn_spine[bn_spine.count-1]
			bn_l_arm[1].parent = bn_spine[bn_spine.count-1]
			bn_r_leg[1].parent = bn_pelvis[2]
			bn_l_leg[1].parent = bn_pelvis[2]
			bn_neck[1].parent = bn_spine[bn_spine.count-1]
			bn_r_hand[1].parent = bn_r_arm[bn_r_arm.count-1]
			bn_l_hand[1].parent = bn_l_arm[bn_l_arm.count-1]
			bn_r_foot[1].parent = bn_r_leg[bn_r_leg.count-1]
			bn_l_foot[1].parent = bn_l_leg[bn_l_leg.count-1]
			if bn_tail.count > 0 do bn_tail[1].parent = bn_pelvis[2]
			if bn_pony1.count > 0 do bn_pony1[1].parent = bn_neck[bn_neck.count-1]
			if bn_pony2.count > 0 do bn_pony2[1].parent = bn_neck[bn_neck.count-1]
			for o in bn_r_fingers do o[1].parent = bn_r_hand[2]
			for o in bn_l_fingers do o[1].parent = bn_l_hand[2]
			if root.controller.toes > 1 do
			(
				for o in bn_r_toes do o[1].parent = bn_r_foot[2]	
				for o in bn_l_toes do o[1].parent = bn_l_foot[2]
			)
				
		-- Delete excess objects, and biped rig
			delete points
			if cb_delBip.checked == true do delete root
			
		-- Color objects
			for o in (rightBn + rightBn_small) do o.wireColor = cp_right.color
			for o in (leftBn + leftBn_small) do o.wireColor = cp_left.color
			for o in centerBn do o.wireColor = cp_center.color	

		-- Set object names
			if cb_name.checked != false do
			(
				setName nodes:bn_r_arm prefix:txt_prefix.text theObject:"R_Arm"
				setName nodes:bn_l_arm prefix:txt_prefix.text theObject:"L_Arm"
				setName nodes:bn_r_leg prefix:txt_prefix.text theObject:"R_Leg"
				setName nodes:bn_l_leg prefix:txt_prefix.text theObject:"L_Leg"
				setName nodes:bn_spine prefix:txt_prefix.text theObject:"Spine"
				setName nodes:bn_neck prefix:txt_prefix.text theObject:"Neck"
				setName nodes:bn_spine prefix:txt_prefix.text theObject:"Spine"
				setName nodes:bn_pelvis prefix:txt_prefix.text theObject:"Pelvis"
				setName nodes:bn_r_hand prefix:txt_prefix.text theObject:"R_Hand"
				setName nodes:bn_l_hand prefix:txt_prefix.text theObject:"L_Hand"
				setName nodes:bn_r_foot prefix:txt_prefix.text theObject:"R_Foot"
				setName nodes:bn_l_foot prefix:txt_prefix.text theObject:"L_Foot"
				setName nodes:bn_tail prefix:txt_prefix.text theObject:"Tail"
				setName nodes:bn_pony1 prefix:txt_prefix.text theObject:"Pony1"
				setName nodes:bn_pony2 prefix:txt_prefix.text theObject:"Pony2"
				for o = 1 to bn_r_fingers.count do setName nodes:bn_r_fingers[o] prefix:txt_prefix.text theObject:("R_Finger" + o as string)
				for o = 1 to bn_l_fingers.count do setName nodes:bn_l_fingers[o] prefix:txt_prefix.text theObject:("L_Finger" + o as string)
				if root.controller.toes > 1 do
				(
					for o = 1 to bn_r_toes.count do setName nodes:bn_r_toes[o] prefix:txt_prefix.text theObject:("R_Toes" + o as string)
					for o = 1 to bn_l_toes.count do setName nodes:bn_l_toes[o] prefix:txt_prefix.text theObject:("L_Toes" + o as string)
				)
			)
			
		-- Set size of the objects	
			openSizeDialog()
		
			return OK
		)
		
		on dialog_convertBiped open do lb_bipeds.items = refreshList()
		on dialog_convertBiped close do dialog_convertBiped = undefined	
		on bt_refreshList pressed do lb_bipeds.items = refreshList()
		on cb_name changed state do txt_prefix.enabled = state
		on bt_convertBiped pressed do 
		(
			if lb_bipeds.items.count > 0 do 
			(
				convertBiped()
				if cb_delBip.checked == true do lb_bipeds.items = (deleteItem lb_bipeds.items lb_bipeds.selection)
			)
		)
		
	)
	createDialog dialog_convertBiped 250 355
)