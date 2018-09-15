macroScript BoneSpring
category:"BBTools"
tooltip:"Bone Spring1.5"
buttonText:"Bone Spring1.5" 
(
	--------------------BB
	Group_Spr =#()
	Group_Spr_N = #()
	Group_Spr_Upnode = #()	
	--------------------BB
	mapped fn freezeTM obj mode:#{1..2} =
	(
			if mode[1] then
			(
				local lstCnt = position_List()
				obj.position.controller = lstCnt
				lstCnt[1].controller = position_xyz()
				lstCnt[2].controller = position_xyz()
				lstCnt.active = 2
				lstCnt.setName 1 "Frozen Position"
				lstCnt.setName 2 "Zero Position"
			)
			if mode[2] then
			(
				local lstCnt = rotation_List()
				obj.rotation.controller = lstCnt
				lstCnt[1].controller = euler_xyz()
				lstCnt[2].controller = euler_xyz()
				lstCnt.active = 2
				lstCnt.setName 1 "Frozen Rotation"
				lstCnt.setName 2 "Zero Rotation"
			)
			if mode[3] then
			(
				local lstCnt = scale_List()
				obj.scale.controller = lstCnt
				lstCnt[1].controller = bezier_scale()
				lstCnt[2].controller = bezier_scale()
				lstCnt.active = 2
				lstCnt.setName 1 "Frozen Scale"
				lstCnt.setName 2 "Zero Scale"
			)
			return true
	)
	fn makepoint mode pname pcolor psize father=(
			local tempoint
			case mode of
				(
					"axis": (tempoint=Point pos:[0,0,0] isSelected:off box:off cross:off axisTripod:on centerMarker:off;)
					"boxcrossaxis": (tempoint=Point pos:[0,0,0] isSelected:off box:on cross:on axisTripod:on centerMarker:off;)
					"cross":	(tempoint=Point pos:[0,0,0] isSelected:off box:off cross:on axisTripod:off centerMarker:off;)
					"marker":	(tempoint=Point pos:[0,0,0] isSelected:off box:off cross:off axisTripod:off centerMarker:on;)
					"markerbox":	(tempoint=Point pos:[0,0,0] isSelected:off box:on cross:off axisTripod:off centerMarker:on;)				
					"box":	(tempoint=Point pos:[0,0,0] isSelected:off box:on cross:off axisTripod:off centerMarker:off;)				
				)
			if tempoint!=undefined do(
				tempoint.name=pname
				tempoint.wirecolor=pcolor 
				tempoint.size=psize
				if father!=undefined do tempoint.parent=father
			)
			return tempoint
	)
	RTSpringCA = attributes RTSpring
	(
		parameters main
		(
			seageoRTS	type:#integer default:1
			sf 			type:#float	default:0.5
			df 			type:#float default:0.1
			v 			type:#point3 default:[0,0,0]
			cValue		type:#point3 default:[0,0,0]
			oldTime 	type:#float default:0.0
			comment		type:#string default:"no Comment ..."
			enabled		type:#boolean default:true
		)
	)
	rollout RTSRO "Realtime Spring V1.5 by Harrison Yu(harrisyu@tom.com/seageo.com) BaseOn Zhangy's sample scene(www.zhangy.com)" width:720 height:350
	(
		ActiveXControl SpringList "MSComctlLib.ListViewCtrl" pos:[8,64] width:704 height:200 
		button btnAddPos "Make" pos:[16,16] width:80 height:20
		edittext edtComment "" pos:[264,16] width:136 height:16
		spinner spnSprFac "" pos:[152,16] width:56 height:16 range:[0,10,4] scale:0.01
		spinner spnDmpFac "" pos:[152,40] width:56 height:16 range:[0,1,0.1] scale:0.01
		spinner spnHelperSize "" pos:[48,40] width:48 height:16 range:[0.1,100,15] scale:0.1
		GroupBox grp1 "Make Spring At First Selected Node Position" pos:[8,0] width:400 height:64
		label lbl2 "Comment" pos:[216,16] width:48 height:16
		label lbl3 "Spring" pos:[104,16] width:40 height:16
		label lbl4 "Damping" pos:[104,40] width:48 height:16
		label lbl5 "Size" pos:[16,40] width:32 height:16
		checkbox chklink "link" pos:[216,40] width:40 height:16 checked:true
		button btnRescan "Rescan" pos:[624,40] width:88 height:20
		button btnMakeChain "Build Chain" pos:[268,40] width:80 height:20
		checkbox chkDriver "Driv" pos:[359,40] width:40 height:16 checked:false
		button btnSelDrv "Select Driver" pos:[400,296] width:80 height:20
		button btnSelBone "Select Bone" pos:[488,296] width:64 height:20
		button btnSelSpr "Select Spring" pos:[400,272] width:80 height:20
		spinner spnIncV "" pos:[208,272] width:40 height:16 range:[0.01,1,0.1] scale:0.01
		button btnDecSpr "-" pos:[88,272] width:16 height:20
		button btnIncSpr "+" pos:[104,272] width:16 height:20
		button btnDecDmp "-" pos:[168,272] width:16 height:20
		button btnIncDmp "+" pos:[184,272] width:16 height:20
		label lbl65 "Spring" pos:[40,272] width:40 height:16
		label lbl66 "Damping" pos:[120,272] width:48 height:16
		spinner spnSprValue "" pos:[40,296] width:56 height:16 range:[0.01,10,0]
		spinner spnDmpValue "" pos:[120,296] width:56 height:16 range:[0.01,1,0] scale:0.1
		button btnOn "ON" pos:[8,272] width:24 height:20
		button btnOff "OFF" pos:[8,296] width:24 height:20
		button btnBakeAni "烘培动画" pos:[624,272] width:88 height:20
		button btnUseBaked "Use Baked" pos:[560,272] width:64 height:20
		button btnUseSpr "Use Spring" pos:[560,296] width:64 height:20
		edittext edtNewComment "Comment" pos:[184,296] width:208 height:16
		button btnselall "Select All" pos:[488,272] width:64 height:20
		edittext edtSelNode "" pos:[256,272] width:136 height:16 enabled:false
		button btnDelAni "Delete Animation" pos:[624,296] width:88 height:20	
		checkbutton ckbForceUpd "Force Update" pos:[624,8] width:88 height:20
		Timer tmr25fps "Timer" pos:[256,40] width:24 height:24 interval:40 active:false
		spinner spnXTime "bake animation speed:1/" pos:[128,328] width:40 height:16 range:[1,100,1] type:#integer scale:1
		spinner spnloop "Loops Before Bake" pos:[272,328] width:40 height:16 range:[0,9,2] type:#integer scale:1
		spinner spnSubF "Subsample" pos:[368,328] width:40 height:16 range:[1,100,1] type:#integer scale:1
		GroupBox grp11 "" pos:[3,264] width:397 height:56
		button btnABake "Bake With Subsample Frame" pos:[485,328] width:155 height:16
		button btnACollapse "塌陷动画" pos:[642,328] width:70 height:16 		--BB
		dropdownList ddlComm "" pos:[424,24] width:128 height:22
		button btnfilter "Filter" pos:[560,24] width:48 height:20
		GroupBox grp9 "Filter List By Comment" pos:[416,0] width:200 height:64
		label lbl25 "ESC to exit" pos:[420,328] width:60 height:16
		
		local nodeTab=#()
		local lastselitem
		local commList=#()
		
		
		
		fn getherComm comm=(
			local newcomm=true
			for c in commList do if comm==c then (newcomm=false;exit;)
			if newcomm then
			(
			append commList comm	
			ddlComm.items=commList
			)
		)
		fn initListView lv =
		(
			lv.backcolor = color 50 120 60
			lv.forecolor = color 255 255 255
			lv.gridLines = true  
			lv.View = #lvwReport  
			lv.MultiSelect =true
			lv.fullRowSelect = true 
			lv.sorted = false --true 
			lv.LabelEdit=  #lvwManual	
			lv.AllowColumnReorder =false
			lv.Checkboxes = false --true 	
			lv.HideSelection = false
				layout_def = #(#("-",28),#("Comment",60), #("Spring Node",120),#("Driver Node",120),#("Bone Upnode",150), #("Spring",50), #("Damp",50), #("Enabled",54),#("weight",54), #("Keys",50), #("Weight",50),#("Motion Parent",100),#("Value",160), #("Speed",160), #("-",32))
				for i in layout_def do
				(
				--增加列
					column = lv.ColumnHeaders.add() 
					column.text = i[1]
				)
				 LV_FIRST = 0x1000
				 LV_SETCOLUMNWIDTH = (LV_FIRST + 30) 
				 for i = 0 to layout_def.count-1 do 
				  windows.sendMessage lv.hwnd LV_SETCOLUMNWIDTH i layout_def[1+i][2]
		
		) 
		fn fillInSpreadSheet_RW lv =
		(
			try
			(
				for i in lv.ListItems do
				(
					drv = i.ListSubItems[3].Text 
					--print drv 
					drv = execute( "$" + drv)
					if drv.isselected == true then i.Selected = true
					else i.Selected = false
				)
			)
			catch()
		)
		fn fillInSpreadSheet lv cleanselected filter:false=
		(
			--------------------BB
			Group_Spr =#()
			Group_Spr_N = #()
			
			--------------------BB
			if filter==false  then (ddlComm.items=#();commList=#())
		 	lv.ListItems.clear()
		     nodeTab =#()
			lastselitem=undefined	
			edtSelNode.text=""
			edtNewComment.text=""
			spnSprValue.value=0
			spnDmpValue.value=0
			
			local index=1
			for o in objects do (

				if classof  o.controller ==  prs then --would cause problem on max8
				(
					if classof o.position.controller==position_list then
				(
					local con=o.position.controller[1].controller			
					if (isProperty  con "seageoRTS")  do (
						if filter and con.comment!=ddlComm.selected then 
						(
						--do nothing
						)
						else
						(
							if filter==false then getherComm con.comment
					append nodeTab o
					--序号
					li = lv.ListItems.add()
					li.text = index as string
					--备注
					sub_li = li.ListSubItems.add()
					sub_li.text = con.comment as string	
					--绿色虚拟体
					sub_li = li.ListSubItems.add()
					sub_li.text = o.name as string	
					--蓝色虚拟体
					local drvnode=con.GetNode "DrvNode"
					sub_li = li.ListSubItems.add()
					sub_li.text = drvnode.name as string
					--红色虚拟体
					local bonenode=con.GetNode "BoneNode"
					--local BoneUpnode  = getNodeByName (bonenode.name+"_Spr01_Upnode")
					local BoneUpnode = con.GetNode "UpNode" --Sky
					sub_li = li.ListSubItems.add()
					--sub_li.text = bonenode.parent.name as string	--BB
					sub_li.text = BoneUpnode.name as string	--BB
					
					sub_li = li.ListSubItems.add()
						sub_li.text = con.sf as string					
					sub_li = li.ListSubItems.add()
						sub_li.text = con.df as string	
					sub_li = li.ListSubItems.add()
					sub_li.text = con.enabled as string	
					sub_li = li.ListSubItems.add()
						sub_li.text = o.position.controller.weight[1] as string					
					sub_li = li.ListSubItems.add()				
						sub_li.text = o.position.controller[3].controller.keys.count as string					
					sub_li = li.ListSubItems.add()				
						sub_li.text = o.position.controller.weight[3] as string					
					sub_li = li.ListSubItems.add()
						local parName=""
						if  drvnode.parent!=undefined then parName=drvnode.parent.name
						sub_li.text = parName					
					sub_li = li.ListSubItems.add()
						sub_li.text = con.cValue as string					
					sub_li = li.ListSubItems.add()
						sub_li.text = con.v as string						
					if cleanselected then li.selected=false
					index+=1
			--===============================WBBBB		
					
					if (findItem (selection as array) drvnode > 0) then li.Selected = true
					--when select drvnode  changes obj do fillInSpreadSheet_RW SpringList 
					
			--===============================wbbbb
					)--end check filter
					)--end if
			if drvnode != undefined do append Group_Spr drvnode
			if o != undefined do append Group_Spr_N o	
			
			--if bonenode.parent	!= undefined do append Group_Spr_Upnode bonenode.parent--BB
			
			if BoneUpnode != undefined do append Group_Spr_Upnode BoneUpnode
				)--end if 	position_list		
		)	
		)--end for o
		------------------BB
		if Group_Spr[1] !=undefined do selectionSets["Group_Spr"] = Group_Spr
		if Group_Spr_N[1] !=undefined do 
			(
			selectionSets["Group_Spr_N"] = Group_Spr_N
			hide Group_Spr_N
			)
			--print Group_Spr_Upnode

		if Group_Spr_Upnode[1] !=undefined do 
			(
			selectionSets["Group_Spr_Upnode"] = Group_Spr_Upnode
			hide Group_Spr_Upnode
			)
		------------------BB
		)	
		fn getFirstSelected =
		(
			if selection.count<=0 then return undefined
			else return selection[1]
		)
		fn makeSpring drvnode springnode Up_node bonenode enabled:true =  --wb --Sky 添加 UP_node 参数输入
		(
				springnode.transform=drvnode.transform
				freezeTM springnode mode:#{1,2}
				springnode.position.controller[3].controller= Position_XYZ()
				springnode.position.controller.weight[3]=0
				local newScriptController=position_script ()
				springnode.position.controller[1].controller= newScriptController
				custAttributes.add springnode.position.controller[1].controller RTSpringCA
				newScriptController.AddNode "DrvNode" drvnode      
				newScriptController.AddNode "BoneNode" bonenode	 --wb
				newScriptController.AddNode "UpNode" Up_node	      --Sky 
				newScriptController.cValue.controller=bezier_point3 ()
				newScriptController.cValue.controller.keyable=false
				newScriptController.v.controller=bezier_point3 ()			
				newScriptController.v.controller.keyable=false			
				newScriptController.cValue=drvnode.pos
				newScriptController.oldTime.controller=bezier_float ()			
				newScriptController.oldTime.controller.keyable=false						
				newScriptController.oldTime=timestamp()/320 as float
				newScriptController.sf=spnSprFac.value
				newScriptController.df=spnDmpFac.value*spnSprFac.value --damp值不要超过spring值
				newScriptController.enabled=enabled
				newScriptController.comment=edtComment.text
				local	sscript="animate off(\n"
						sscript+="if this.enabled then (\n"
						sscript+="this.v=-this.v*this.df+(DrvNode.pos-this.cValue)*this.sf\n"
						sscript+="if abs(this.cValue.x)>=10000 then\n"
						sscript+="(\nthis.v=[0,0,0]\n"
						sscript+="this.cValue=[0,0,0]\n)\n"
						sscript+="cTime=timestamp()/320 as float\n"
						sscript+="diff=cTime-this.oldTime\n"
						sscript+="this.oldTime=cTime\n"
						sscript+="if diff>0.1 then diff=0.1\n"
						sscript+="if diff<0 then this.cValue\n"
						sscript+="else this.cValue+=this.v*diff\n"
						sscript+=")else(DrvNode.pos))"
				newScriptController.script=sscript	
		)
		fn QuickLookAtUpAxis target Up taxis saxis uaxis =
		(
			local mycontroller
					mycontroller=LookAt_Constraint()		
					if	target!=undefined then	mycontroller.appendTarget target 50
					mycontroller.viewline_Length_abs = off
					mycontroller.lookat_vector_length = 0				
					if Up!=undefined then
					(
					mycontroller.upnode_world = off
					mycontroller.pickUpnode = Up
					)
					mycontroller.target_axis =taxis 
					mycontroller.StoUp_axis =saxis 
					mycontroller.upnode_axis =uaxis	
					--mycontroller.relative = true		--WB	
			return mycontroller
		)
		fn menus_bake =
		(
			max create mode
			boneArr=#()
			sprArr=#()
			drvArr=#()
			dataArr=#()
			upnodeArr = #() --Sky
			
			struct animData
			(
				time,obj,rota
			)
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local bonenode = nodeTab[idx].position.controller[1].controller.GetNode "BoneNode"
				--append UpnodeArr bonenode
				if (findItem boneArr bonenode) == 0 then append boneArr bonenode 
				append sprArr nodeTab[idx]
				local drvnode = nodeTab[idx].position.controller[1].controller.GetNode "DrvNode"
				append drvArr drvnode
				local upnode  = nodeTab[idx].position.controller[1].controller.GetNode "UpNode" --Sky
				append upnodeArr upnode
			)
			for t = animationRange.start to animationRange.end do
			(
				for i in boneArr do
				(
					tempData =  animData()
					tempData.time = t
					tempData.obj = i
					at time t tempData.rota = i.transform
					append dataArr tempData 
				)
			)
			select sprArr
			max delete
			delete drvArr
			delete UpnodeArr --Sky
			
			for tempbone in boneArr do tempbone.rotation.controller = Euler_XYZ () --Sky
			
			/*
			for tempbone in boneArr do
			(
				tempbone.rotation.controller = Euler_XYZ ()
				tempParent = tempbone.parent
				tempbone.parent =tempParent.parent
				delete tempParent 
				
			)
			*/ --Sky
			with animate on
			(
				for d in dataArr do
				(
					d.obj.pos.controller = Position_Expression()
					d.obj.scale.controller = Scale_Expression ()
					at time d.time d.obj.transform=d.rota
					d.obj.pos.controller = position_xyz()
					d.obj.scale.controller = bezier_scale ()
				)
			)
			Group_Spr =#()
			Group_Spr_N = #()
			Group_Spr_Upnode = #()	--Sky
			fillInSpreadSheet SpringList  true 	
		)
		fn makeChain_fn  N  =
		(
			animate off
			(
				NP = N.parent
				for NC in N.children do
				(
					if NC !=undefined then
					(
						local pointname = uniqueName (N.name+"_Spr")
						local pointsize = spnHelperSize.value
						local springParent = NP
						local drvpoint = makepoint "markerbox" pointname blue pointsize springParent
						
						local newpoint = makepoint "cross" (pointname+"N") green (pointsize+8) undefined
						newpoint.isHidden = true
						
						local temppoint = makepoint "box" (pointname+"_Upnode") red (pointsize-5) NP
						temppoint.transform = N.transform
						temppoint.isHidden = true
						/*
						--if (classof N.rotation.controller) != LookAt_Constraint then 
						--(
							local temppoint= makepoint "box" (pointname+"_Upnode") red (pointsize-5) NP
							
							temppoint.transform = N.transform
							temppoint.isHidden = true
							--N.parent = temppoint --Sky 解除LookAT控制器 Upnode与bone的连接关系 
						--)
						--*/ --Sky

						drvpoint.transform = NC.transform
						makeSpring drvpoint newpoint temppoint N enabled:false --turn off first fix for max8	--Sky 添加 temppoint 参数输入
						--append sprnode newpoint --fix for max8
						--N.rotation.controller= Euler_XYZ ()
						if (classof N.rotation.controller) == LookAt_Constraint then ()
						--else N.rotation.controller= QuickLookAtUpAxis newpoint N.parent 0 1 1
						else N.rotation.controller= QuickLookAtUpAxis newpoint temppoint 0 1 1 --Sky 将LookAT控制器的Upnode指向临时点 而不是父物体
						newpoint.position.controller[1].enabled=true
						makeChain_fn NC
					)
				)
			)
		)
		
		
		fn updateRoll = 
		(
			fillInSpreadSheet_RW SpringList
		)
		on RTSRO open do
		(
			initListView SpringList 
			fillInSpreadSheet SpringList  true 		
			registerRedrawViewsCallback updateRoll
		)
		on RTSRO close do
		(
			unRegisterRedrawViewsCallback updateRoll
		)
		on SpringList ItemClick Item do
		(
			lastselitem=Item 
			idx=item.text as integer
			local con=nodeTab[idx].position.controller[1].controller	
			edtSelNode.text=nodeTab[idx].name
			edtNewComment.text=item.listSubItems[1].text
			spnSprValue.value=con.sf
			spnDmpValue.value=con.df
			clearselection()	
			tempNode = #()
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local drvnode=nodeTab[idx].position.controller[1].controller.GetNode "DrvNode"
				append tempNode drvnode
			)
			select tempNode 
		)
		on btnAddPos pressed do
		(
			local selnode= getFirstSelected ()
			if selnode!=undefined do
			(
				local pointname=uniqueName (selnode.name+"_Spr")
				local pointsize=spnHelperSize.value
				local springParent=undefined
				if chklink.checked then springParent=selnode
				local drvpoint= makepoint "markerbox" pointname blue pointsize springParent
				local newpoint= makepoint "cross" (pointname+"N") green pointsize undefined
				local temppoint= makepoint "box" (pointname+"_Upnode") red (pointsize-5) NP --Sky
				drvpoint.transform=selnode.transform
				makeSpring drvpoint newpoint temppoint selnode --Sky 添加 temppoint 参数输入
				fillInSpreadSheet SpringList  true 			
			)
		)
		on btnRescan pressed do
		(
			fillInSpreadSheet SpringList  true 
		)
		on btnMakeChain pressed do
		(
			with undo label: "make chain" on
			(
				max create mode
				tempArr = selection as array
				for i in tempArr do
				(
				 	makeChain_fn i
				)
				
				fillInSpreadSheet SpringList  true 
			)
		)
		on btnSelDrv pressed do
		(
			clearselection()	
			for item in SpringList.listItems do if item.selected then (
				idx=item.text as integer
				local drvnode=nodeTab[idx].position.controller[1].controller.GetNode "DrvNode"
				selectmore drvnode
			)
		)
		on btnSelBone pressed do
		(
			clearselection()	
			for item in SpringList.listItems do if item.selected then
			(
				idx=item.text as integer
				local bonenode = nodeTab[idx].position.controller[1].controller.GetNode "BoneNode"
				selectmore bonenode 
			)
		)
		on btnSelSpr pressed do
		(
			clearselection()	
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				selectmore nodeTab[idx]
			)	
		)
		on btnDecSpr pressed do
		(
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local con=nodeTab[idx].position.controller[1].controller
				con.sf-=spnIncV.value
				item.listSubItems[4].text=con.sf as string
			)	
		)
		on btnIncSpr pressed do
		(
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local con=nodeTab[idx].position.controller[1].controller
				con.sf+=spnIncV.value
				item.listSubItems[4].text=con.sf as string
			)	
		)
		on btnDecDmp pressed do
		(
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local con=nodeTab[idx].position.controller[1].controller
				con.df-=spnIncV.value
				item.listSubItems[5].text=con.df as string
			)	
		)
		on btnIncDmp pressed do
		(
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local con=nodeTab[idx].position.controller[1].controller
				con.df+=spnIncV.value
				item.listSubItems[5].text=con.df as string
			)		
		)
		on spnSprValue changed val do
		(
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local con=nodeTab[idx].position.controller[1].controller
				con.sf=val 
				item.listSubItems[5].text=val as string
			)		
		)
		on spnDmpValue changed val do
		(
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local con=nodeTab[idx].position.controller[1].controller
				con.df=val 
				item.listSubItems[6].text=val as string
			)	
		)
		on btnOn pressed do
		(
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local drvnode=nodeTab[idx].position.controller[1].controller.GetNode "DrvNode"
				
				local con=nodeTab[idx].position.controller[1].controller
				con.enabled=true
				item.listSubItems[7].text=con.enabled as string
			)		
		)
		on btnOff pressed do
		(
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local con=nodeTab[idx].position.controller[1].controller
				con.enabled=false
				item.listSubItems[7].text=con.enabled as string			
			)				
		)
		on btnBakeAni pressed do
		(
			animate off
			(
			timeSlider.setVisible false
			disableSceneRedraw(); 
			actionMan.executeAction 0 "407" 
			
			--local fps=4800.0/ticksPerFrame
			local tps=1000.0/frameRate
			local diff=tps/320.0		
			--设置初始位置
			for item in SpringList.listItems do if item.selected then (
				idx=item.text as integer
				local obj=nodeTab[idx]		
				local con=nodeTab[idx].position.controller[1].controller	
				local anicon=nodeTab[idx].position.controller[3].controller	
				obj.position.controller.weight[1]=0
				obj.position.controller.weight[3]=100
				anicon.value=con.value
		--			con.v=[0,0,0]
				con.cValue=anicon.value
			)	
			for loop=1 to spnloop.value do --空运行，寻找稳定状态
			(
								for currFrame=animationRange.start to animationRange.end do
								(
									if keyboard.escPressed then exit									
									for l=1 to spnXTime.value do --多计算几次
									for item in SpringList.listItems do if item.selected then (		
										idx=item.text as integer
										local obj=nodeTab[idx]		
										local con=nodeTab[idx].position.controller[1].controller	
										local anicon=nodeTab[idx].position.controller[3].controller			
										slidertime=currFrame
											DrvNode=con.GetNode "DrvNode"
											con.v=-con.v*con.df+(DrvNode.pos-con.cValue)*con.sf
											if abs(con.cValue.x)>=10000 then
											(
											con.v=[0,0,0]
											con.cValue=[0,0,0]
											)
											con.cValue+=con.v*diff
											anicon.value=con.cValue --不记录
									)
								)		
			)
			for currFrame=animationRange.start to animationRange.end do
			(
				if keyboard.escPressed then exit		
				for l=1 to spnXTime.value do --多计算几次
				for item in SpringList.listItems do if item.selected then (		
					idx=item.text as integer
					local obj=nodeTab[idx]		
					local con=nodeTab[idx].position.controller[1].controller	
					local anicon=nodeTab[idx].position.controller[3].controller			
					slidertime=currFrame
						DrvNode=con.GetNode "DrvNode"
						con.v=-con.v*con.df+(DrvNode.pos-con.cValue)*con.sf
						if abs(con.cValue.x)>=10000 then
						(
						con.v=[0,0,0]
						con.cValue=[0,0,0]
						)
						con.cValue+=con.v*diff
					with animate on (
						anicon.value=con.cValue
		
					)
				)
			)
			timeSlider.setVisible true
			enableSceneRedraw()
			completeRedraw()
			actionMan.executeAction 0 "407" 
		
			fillInSpreadSheet SpringList  false		
			)
		)
		on btnUseBaked pressed do
		(
			for item in SpringList.listItems do if item.selected then (
				idx=item.text as integer
				local con=nodeTab[idx].position.controller[1].controller
				local obj=nodeTab[idx]
				local listcon=obj.position.controller
				listcon.weight[1]=0
				listcon.weight[3]=100
				item.listSubItems[8].text=listcon.weight[1] as string
				item.listSubItems[10].text=listcon.weight[3] as string			
			)		
		)
		on btnUseSpr pressed do
		(
			for item in SpringList.listItems do if item.selected then (
				idx=item.text as integer
				local con=nodeTab[idx].position.controller[1].controller
				local obj=nodeTab[idx]
				local listcon=obj.position.controller
				listcon.weight[1]=100
				listcon.weight[3]=0
				item.listSubItems[8].text=listcon.weight[1] as string
				item.listSubItems[10].text=listcon.weight[3] as string			
			)		
		)
		on edtNewComment entered text do
		(
			if	lastselitem!=undefined then
			(	
				idx=lastselitem.text as integer
				local con=nodeTab[idx].position.controller[1].controller	
				con.Comment=text 
				lastselitem.listSubItems[1].text=text
			)
		)
		on btnselall pressed do
		(
			for item in SpringList.listItems do item.selected=true
			clearselection()	
				tempNode = #()
				for item in SpringList.listItems do if item.selected then 
				(
				idx=item.text as integer
				local drvnode=nodeTab[idx].position.controller[1].controller.GetNode "DrvNode"
				append tempNode drvnode
				)
				select tempNode 
		)
		on btnDelAni pressed do
		(
			for item in SpringList.listItems do if item.selected then (
				idx=item.text as integer
				local obj=nodeTab[idx]		
		--			local con=nodeTab[idx].position.controller[1].controller	
				local anicon=nodeTab[idx].position.controller[3].controller	
				deleteKeys anicon #allKeys
			)
			fillInSpreadSheet SpringList  true 				
		)
		on ckbForceUpd changed state do
		(
			tmr25fps.active=state
		)
		on tmr25fps tick do
		(
			for o in nodeTab do o.pos.controller[1].Update()
		)
		on btnABake pressed do
		(
			local tps=1000.0/frameRate
			local diff=tps/320.0		
			for item in SpringList.listItems do if item.selected then 
			(
				idx=item.text as integer
				local obj=nodeTab[idx]		
				local con=nodeTab[idx].position.controller[1].controller	
				local anicon=nodeTab[idx].position.controller[3].controller	
				obj.position.controller.weight[1]=0
				obj.position.controller.weight[3]=100
				anicon.value=con.value
				con.cValue=anicon.value
			)	
			for loop=1 to spnloop.value do --空运行，寻找稳定状态
			(
								for currFrame=animationRange.start to animationRange.end do
								(
										if keyboard.escPressed then exit																	
									for l=1 to spnXTime.value do --多计算几次
									(
									for item in SpringList.listItems do if item.selected then (		
										idx=item.text as integer
										local obj=nodeTab[idx]		
										local con=nodeTab[idx].position.controller[1].controller	
										local anicon=nodeTab[idx].position.controller[3].controller			
										slidertime=currFrame
											DrvNode=con.GetNode "DrvNode"
											con.v=-con.v*con.df+(DrvNode.pos-con.cValue)*con.sf
											if abs(con.cValue.x)>=10000 then
											(
											con.v=[0,0,0]
											con.cValue=[0,0,0]
											)
											con.cValue+=con.v*diff
											anicon.value=con.cValue --不记录
										)
									)
								)		
			)
			local subframe=1/spnSubF.value as time
			local diff=diff/spnSubF.value as float
			for currFrame=animationRange.start to animationRange.end do
			(
				if keyboard.escPressed then exit		
				for l=1 to spnXTime.value do --多计算几次
				for sl=0 to (spnSubF.value-1) do --subframe
				for item in SpringList.listItems do if item.selected then (		
					idx=item.text as integer
					local obj=nodeTab[idx]		
					local con=nodeTab[idx].position.controller[1].controller	
					local anicon=nodeTab[idx].position.controller[3].controller			
					slidertime=currFrame
						DrvNode=con.GetNode "DrvNode"
						DrvNodepos=at time (currFrame+subframe*sl as time) DrvNode.pos
						con.v=-con.v*con.df+(DrvNodepos-con.cValue)*con.sf
						if abs(con.cValue.x)>=10000 then
						(
						con.v=[0,0,0]
						con.cValue=[0,0,0]
						)
						con.cValue+=con.v*diff
					with animate on (	anicon.value=con.cValue		)
				)
			)
			fillInSpreadSheet SpringList  false			
		)
		on btnACollapse pressed do
		(
			undo on 	menus_Bake()
		)--BB
		on btnfilter pressed do
		(
			fillInSpreadSheet SpringList  true filter:true
		)
	)
	createdialog RTSRO 
)
