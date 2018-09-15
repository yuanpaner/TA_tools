macroScript NArtEasySpring
category:"_NArtTools"
buttontext:"Easy Spring"
toolTip:"Easy Spring"
(
	on execute do
	(
		Global Pw_tools
		rollout Spring_tools "ȹ�ڹ���" width:147 height:298
		(
			local FirstBoneArray = #()
			local LastBoneArray = #()
			local LastPointArray = #()
			local ChildArray = #()  --�����������
			local PosArray = #()  --���������ߵ���������
			local AddSpringPoints = #()  --�ӵ��ɵĵ�
			local LyLine          --�������Թ����õ���
			local MySpline
			local AllObj
			local PtTension = 1  --ԽСԽ�е���
			local PtInd = 1.8
			local PtMass = 300.0  --Խ��Խ�е���  Խ��Խ�е���
			local MassInd = 1.3
			local MyIks = #()
			local filename = ""
			local tp_BoneAndChild=#()
			local tp_BoneChildArray=#()
			local tp_BoneOldname=#()
			
			Global EC_OBJ, EC_TargetObj, EC_SplineOBJ, EC_HelperOBJ
			
			fn tp_getChildArray_fn tp_selobj=
			(
				if tp_selobj.children.count==1 then
				(
					append tp_BoneChildArray tp_selobj.children[1] 
					tp_getChildArray_fn tp_selobj.children[1] 
				)
				else return tp_BoneChildArray
			)
			
			fn GetChildren Obj =
			(
				if Obj.children.count != 0 then
				( 
					EC_TargetObj = Obj.children[1]
					if EC_TargetObj.children.count != 0 then (GetChildren EC_TargetObj)
				)
			)
			fn SplinIk =
			(
				
				IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
				-------------------------------------------------------------------------------------------
				-- Check for Groups and act accordingly
				-------------------------------------------------------------------------------------------
				EC_OBJ = selection[1]
				if selection.count > 1 do 
				(
					local h = EC_OBJ.parent 
					if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
				)
				Animate off
				(	
					-------------------------------------------------------------------------------------------
					-- Define Filter Functions for PickObject Selection
					-------------------------------------------------------------------------------------------			
					fn ChildFilt o = Filters.Is_Child EC_OBJ o or Filters.Is_Parent EC_OBJ o
					fn ShapeFilt o = superClassOf o == Shape and o != EC_OBJ
					-------------------------------------------------------------------------------------------
					GetChildren EC_OBJ
					--EC_TargetOBJ = PickObject count:1 select:true filter:ChildFilt count:#Multiple Message:"Pick Joint to complete IK Chain" Rubberband:EC_OBJ.pos ForceListenerFocus:False			
					If EC_TargetOBJ != #escape or EC_TargetOBJ != undefined then 
					(
						if Filters.Is_Child EC_OBJ EC_TargetOBJ then
						(
							NIK = iksys.IKChain  EC_OBJ EC_TargetOBJ "SplineIKSolver"
							append MyIks NIK 
						)
						Else
						(
							NIK = iksys.IKChain  EC_TargetOBJ EC_OBJ "SplineIKSolver"
							append MyIks NIK 
						)
					)
					EC_SplineOBJ = MySpline
					--EC_SplineOBJ = PickObject count:1 select:true filter:ShapeFilt count:#Multiple Message:"Pick Spline to assign SplineIK" Rubberband:EC_TargetOBJ.pos ForceListenerFo
					
					If EC_SplineOBJ != undefined and EC_SplineOBJ != "None" then
					(
						-------------------------------------------------------------------------------------------
						-- Make the Spline the goal shape of the SplineIK
						-------------------------------------------------------------------------------------------
						NIK.transform.controller.pickShape = EC_SplineOBJ				
						-------------------------------------------------------------------------------------------			
						-- Add SplinIKControl Modifier and Create Helpers
						-------------------------------------------------------------------------------------------		
						mod = Spline_IK_Control()
						AddModifier EC_SplineOBJ (mod)
						mod.createHelper(0)
						EC_HelperOBJ = mod.helper_list[1]
						-- Set the upnode to the first helper
						NIK.controller.upnode = EC_HelperObj
						-------------------------------------------------------------------------------------------
						-- Add List Controller and Path Constraint
						-------------------------------------------------------------------------------------------
						local cont
						if Filters.Is_Child EC_OBJ EC_TargetOBJ then
						(
							cont = AddListController EC_OBJ "Pos" Position_List
							If classof cont[listCtrl.GetActive cont].object != Path_Constraint then constraint = AddConstraint EC_OBJ "Pos" Path_Constraint true
							else constraint = cont[listCtrl.GetActive cont].object
						)
						else
						(
							cont = AddListController EC_TargetOBJ "Pos" Position_List
							If classof cont[listCtrl.GetActive cont].object != Path_Constraint then constraint = AddConstraint EC_TargetOBJ "Pos" Path_Constraint true
							else constraint = cont[listCtrl.GetActive cont].object
						)
						-------------------------------------------------------------------------------------------
						-- Add Path Constraint Object Target as the spline
						-------------------------------------------------------------------------------------------		
						constraint.AppendTarget EC_SplineObj 50
						DeleteKeys constraint.percent.controller
						constraint.percent = 0.0			
						-------------------------------------------------------------------------------------------
						-- Set Active Controller
						-------------------------------------------------------------------------------------------
						SetActiveController cont constraint
						--Format "%\n"  (EC_OBJ.name + " is Position Constrained to " + EC_HelperOBJ.name) to:Listener	
						Select EC_OBJ
					)	
					Max Motion Mode
				)
			)
			
			fn SaveOName Obj=
			(
				f = createFile filename 
				for o in Obj do
				(
					format "$%\n" o.name to:f -- output name in a pathname form
				)
				close f
			)
			fn deleteObj =
			(
				f = openFile filename 
				while not eof f do
				(
					o = readValue f -- read object
					try (delete o) catch ()
				)
				close f
			)
			fn SelChildren sel SelChilds =   --��������ӽ�ѡ�񼯺���
			(
				for i = 1 to sel.children.count do
				( 
					tempsel = sel.children[i]
					append SelChilds tempsel 
					if tempsel != undefined do SelChildren tempsel SelChilds
				)
				return  SelChilds
			)
			
			fn SelArrayToPosArray SelArray =  --ѡ��ת��������pos������
			(
				for i in SelArray do 
				(
					append PosArray i.pos
				)
				return  PosArray
			)
			
			fn drawLine ptArray =    ----���ߺ���
			(
				LyLine = SplineShape pos:ptArray[1]
				addNewSpline LyLine
				for i in 1 to ptArray.count do 
				( 
					addKnot LyLine 1 #corner #line ptArray[i] 
				)
				updateShape LyLine
				return  LyLine
			)
		
			fn copybones sel =           -- ��������������
			(
				FirstBoneArray  = #()        --����������
				append FirstBoneArray  sel   --���Լ��ӽ�ѡ��
				SelChildren sel FirstBoneArray    --���ӹ�����������
				
				LastBoneArray = #()
				for i in FirstBoneArray do
				(
					append LastBoneArray (copy i)
				)
				for i in 2 to LastBoneArray.count do 
				(
					LastBoneArray[i].parent = LastBoneArray[i-1]
				)
				hide FirstBoneArray 
				Select LastBoneArray[1]        --ѡ���¸��ƹ����ĸ�����
			)
			fn SetTension objs Tension Ind =  -- ���õ�������
			(
				for i in objs do
				(
					i.pos.controller.Spring.setTension 1 Tension 
					Tension = Tension / Ind 
				)
			)
			fn setMass objs Mass Ind =  -- ���õ�������
			(
				for i in objs do
				(
					i.pos.controller.Spring.setMass Mass
					Mass = Mass * Ind 
				)
			)
			fn bakeAnim sel =           -- �決�ؼ�֡
			(
				FirstBoneArray  = #()        --����������
				append FirstBoneArray  sel   --���Լ��ӽ�ѡ��
				SelChildren sel FirstBoneArray    --���ӹ�����������
				bakepoints = #()
				try(starttime = Spring_tools.tp_StartTime_spn.value)catch(starttime = animationrange.start)
				try(endtime =  	Spring_tools.tp_endtime_spn.value)catch(endtime = animationrange.end)
				try(tp_intervaltime=Spring_tools.tp_interval_spn.value)catch(tp_intervaltime=1)
				for i in 1 to (FirstBoneArray.count-1) do
				(
					bakepoint = Point transform:FirstBoneArray[i].transform isSelected:on
					append bakepoints bakepoint 
				)
				try(
					AllObj = AllObj + bakepoints
					SaveOName AllObj  --���������������Ƶ��ı��ļ�
				)catch()
				
				for t in starttime to endtime by 1 do 
				(
					sliderTime = t 
					with animate on
					(
						for i in 1 to bakepoints.count do  ----����Ź�����ؼ�֡
						(
							bakepoints[i].transform = FirstBoneArray[i].transform
						)
					)
				)
				if MyIks.count != 0 then (delete MyIks )else(delete  $'IK Chain*')
				
				for t in starttime to endtime by tp_intervaltime do 
				(
					sliderTime = t 
					with animate on
					(
						for i in 1 to bakepoints.count do  ----�����決�����ؼ�֡
						(
							FirstBoneArray[i].transform = bakepoints[i].transform
						)
					)
				)
				
			)
			
			fn tp_CreateEnd_fn tp_Bone=
			(
				if tp_Bone.children.count==1 then
				(
					append tp_BoneAndChild tp_Bone.children[1]
					tp_CreateEnd_fn tp_Bone.children[1]
				)
				else
				(
					if tp_Bone.children.count==0 then
					(
						Format "%\n"  (tp_BoneAndChild) to:Listener
						if tp_Bone.length==(tp_Bone.width+tp_Bone.height)/2 and tp_Bone.boxmode==off then
						(
						)
						else
						(
							with Animate Off   --with Animate Off bracket open
							(   
								local parentBone  = tp_Bone
								local parentTrans = parentBone.transform
								local parentPos   = parentTrans.translation
								Global tp_EndBoneHelper
								with redraw off 					
								(
									tp_EndBoneHelper=BoneSys.createBone parentPos (parentPos+6) parentBone.dir
									tp_EndBoneHelper.transform = parentTrans
									in coordSys Local move tp_EndBoneHelper [parentBone.length,0,0]

									tp_EndBoneHelper.parent    = parentBone
									tp_EndBoneHelper.name	  = "tp_EndBoneHelper"
									tp_EndBoneHelper.width     = parentBone.width
									tp_EndBoneHelper.height    = parentBone.height
									tp_EndBoneHelper.taper     = 90
									tp_EndBoneHelper.length    = (parentBone.width+parentBone.height)/2
									tp_EndBoneHelper.wirecolor = red
								)
							)
							redrawViews()
						)
					)
				)
			)
			
			fn tp_DelChildAni_fn=
			(
				if selection.count==1 then
					(
						tp_parentObj=$
						sliderTime=Spring_tools.tp_StartTime_spn.value
						if Spring_tools.tp_keepoldani_chk.checked==false do
						(
							actionMan.executeAction 0 "40180"  -- Selection: Select Children
							maxOps.deleteSelectedAnimation()
						)
						select tp_parentObj
					)
			)
			
			fn tp_CreatIK_fn= 		--����������
			(
				if selection.count == 1 then 
				(
					FirstBoneArray = #()   --��ձ���
					LastBoneArray = #()    --��ձ���
					MyIks = #()        --��ձ���
					filename = maxFilePath + (getFilenameFile maxFileName) + "_" + $.name + ".dat"
					copybones $        --��������  ������ԭ���Ĺ���
					PosArray = #()     --�����õ�����
					AddSpringPoints = #()     --��ձ���  �ӵ��ɿ��Ƶĵ�
					
					SelArrayToPosArray  LastBoneArray
					MySpline = drawLine PosArray
					SplinIk ()  -- �ҵĴ���spline ik�ĺ�������������ik��������������е����������
					--macros.run "Inverse Kinematics" "SPLINE_IK"
					LyLine.modifiers[#Spline_IK_Control].linkTypes = 1
					--�����Ǹ�ÿ�����Ƶ���ϵ���
					for i in 2 to LyLine.modifiers[#Spline_IK_Control].helper_list.count do
					(
						TempPoint = LyLine.modifiers[#Spline_IK_Control].helper_list[i]
						append AddSpringPoints TempPoint
						TempPoint.pos.controller = SpringPositionController ()
					)
					AddSpringPoints[1].parent.parent = LastBoneArray[1].parent
					completeRedraw()  --ˢ��һ�³�������Ȼ�����������ò��ϡ�
					SetTension AddSpringPoints PtTension PtInd  --���õ���
					setMass AddSpringPoints PtMass MassInd --���õ�����
					
					for i in 1 to (FirstBoneArray.count-1) do
					(
						myik = IKSys.ikChain FirstBoneArray[i] FirstBoneArray[i+1] "IKHiSolver"
						append MyIks myik 
						myik.parent = LastBoneArray[i]
						hide myik
					)
					select FirstBoneArray[1]
					
					
					
					Allpoints = #()  -- ��������ikʱ�������point�㼯��
					for i in 1 to LyLine.modifiers[#Spline_IK_Control].helper_list.count do
					(
						TempPoint = LyLine.modifiers[#Spline_IK_Control].helper_list[i]
						append Allpoints TempPoint
					)
					
					------------------------���汣������---------------------------------------
					local mysplines = #()
					append mysplines MySpline 
					AllObj =  mysplines + Allpoints + LastBoneArray
					SaveOName AllObj  --���������������Ƶ��ı��ļ�
				)
				else
				(
					messageBox "��ѡ��Ҫ����������ĸ�����"
				)	
			)
			
			fn tp_bakeAnim_fn=      --�決�ؼ�֡
			(
				try (select FirstBoneArray[1]) catch ()
				animButtonState = off
				if selection.count == 1 and classof $ == BoneGeometry then 
				(
					bakeAnim $
					unhide FirstBoneArray
					select FirstBoneArray[1]
				)
				else
				(
					messageBox "��ѡ�����ݹؼ�֡�����ĸ�����"
				)
			)
			
			fn tp_clearscene_fn=	--������
			(
				filename = maxFilePath + (getFilenameFile maxFileName) + "_" + $.name + ".dat"
				f = openFile filename
				if f != undefined then 
				(
					deleteObj ()
					--delete AllObj
				)
				else 
				(
					messageBox "��ѡ��������ĸ�����"
				)
			)
			
			fn tp_rangeValue_fn =
			(
				tp_rangeTools.tp_startTime_btn.value=(animationrange.start/160) as integer
				tp_rangeTools.tp_endTime_btn.value=(animationrange.end/160) as integer
			)
			
			button btn_verysoft "��" pos:[5,13] width:20 height:20
			button btn_veryhard "Ӳ" pos:[120,13] width:20 height:20
			
			button btn_soft "��" pos:[29,13] width:20 height:20
			button btn_yiban "һ��" pos:[53,13] width:38 height:20
			button btn_hard "Ӳ" pos:[96,13] width:20 height:20
			spinner tp_Tension_SPI "Tension" pos:[33,40] width:87 height:16
			spinner tp_Mass_SPI "Mass   " pos:[33,62] width:88 height:16 enabled:true range:[0,1000,0] type:#integer
 
			button tp_batch_btn "��ʼ����" pos:[78,167] width:60 height:20
			button tp_selPBone_btn "ѡ������" pos:[6,167] width:70 height:20
			progressBar tp_pb1 "ProgressBar" pos:[6,3] width:132 height:7 orient:#horizontal visible:false
			
			spinner tp_interval_spn "֡���   " pos:[13,87] width:110 height:16 range:[1,100,1] type:#integer
			spinner tp_StartTime_spn "��ʼ֡   " pos:[13,108] width:110 height:16 enabled:true range:[-1000,1000,0] type:#integer
			spinner tp_endtime_spn "����֡   " pos:[13,129] width:110 height:16 enabled:true range:[-1000,1000,120] type:#integer
			button tp_interval_btn "R" pos:[126,87] width:16 height:16
			
			button tp_startTime_btn "R" pos:[126,108] width:16 height:16
			button tp_endTime_btn "R" pos:[126,129] width:16 height:16
			checkbox tp_keepoldani_chk "������������" pos:[24,149] width:101 height:15
			
			on Spring_tools open do
			(
				animButtonState = off
				tp_Tension_SPI.value = PtTension = 1  --ԽСԽ�е���
				tp_Mass_SPI.value = ptMass = 300  --Խ��Խ�е���  Խ��Խ�е���
				tp_StartTime_spn.value=(animationrange.start/160) as integer
				tp_endtime_spn.value=(animationrange.end/160) as integer
			)
			on btn_verysoft pressed do
			(
				tp_Tension_SPI.value=PtTension = 0.45  --ԽСԽ�е���
				tp_Mass_SPI.value = PtMass = 675  --Խ��Խ�е���  Խ��Խ�е���
			)
			on btn_veryhard pressed do
			(
				tp_Tension_SPI.value = PtTension = 2.25  --ԽСԽ�е���
				tp_Mass_SPI.value = PtMass = 134  --Խ��Խ�е���  Խ��Խ�е���
			
			)
			on btn_soft pressed do
			(
				tp_Tension_SPI.value = PtTension = 0.667  --ԽСԽ�е���
				tp_Mass_SPI.value = PtMass = 450  --Խ��Խ�е���  Խ��Խ�е���
			
			)
			on btn_yiban pressed do
			(
				tp_Tension_SPI.value = PtTension = 1  --ԽСԽ�е���
				tp_Mass_SPI.value = ptMass = 300  --Խ��Խ�е���  Խ��Խ�е���
			
			)
			on btn_hard pressed do
			(
				tp_Tension_SPI.value = PtTension = 1.5  --ԽСԽ�е���
				tp_Mass_SPI.value=PtMass = 200  --Խ��Խ�е���  Խ��Խ�е���
			)
			on tp_Tension_SPI changed val do
				ptTension=tp_tension_SPI.value
			on tp_Mass_SPI changed val do
				PtMass=tp_Mass_SPI.value
			on tp_batch_btn pressed do
			(
				tp_BoneChildArray=#()
				tp_BoneOldname=#()
				tp_SelectionBone=#()
				tp_foo=0
				tp_pb1.value=0
				tp_pb1.visible=true
				for i in selection do append tp_SelectionBone i
				for tp_SelpBone in tp_selectionBone do
				(
					select tp_SelpBone
					if selection.count==1 and classof selection[1]==bonegeometry then
					(
						append tp_BoneChildArray $
						tp_getChildArray_fn $
						
						for i in tp_BoneChildArray do
						(
							append tp_BoneOldname i.name
							for a=1 to i.name.count do
							(
								tp_findNameWord=findstring i.name " "
								if tp_findNameWord!=undefined then	i.name=replace i.name tp_findNameWord 1 "___"
							)
						)
				
						tp_CreateEnd_fn $
						tp_DelChildAni_fn()
						try(sliderTime=Spring_tools.tp_StartTime_spn.value)catch()
						tp_CreatIK_fn()
							
						setTension AddSpringPoints PtTension PtInd  --���õ���
						setMass AddSpringPoints PtMass MassInd
						with redraw off
						( 
							tp_bakeAnim_fn()
							tp_clearscene_fn()
						)--redrawoff end
						completeRedraw() 	
						
						try(delete tp_EndBoneHelper)catch()
							
						for i in tp_BoneChildArray do 
							(
								for a=1 to i.name.count do
								(
									tp_findNameWord=findstring i.name "___"
									if tp_findNameWord!=undefined then i.name=replace i.name tp_findNameWord 3 " "
								)
							)
					tp_foo+=1
					tp_pb1.value=100.*tp_foo/tp_selectionBone.count
					)
					
				)
				completeRedraw()
				tp_pb1.value=0
				tp_pb1.visible=false
				select tp_SelectionBone
			)
			on tp_selPBone_btn pressed do
			(
				if selection.count>0 then
					(
						tp_BoneArray=for i in selection where classof i==BoneGeometry collect i
					)
					else
					(
						tp_BoneArray=for i in objects where classof i==BoneGeometry collect i
					)
					tp_BoneParent=for i in tp_BoneArray where classof i.parent!=BoneGeometry and classof i.transform.controller==prs collect i
					select tp_BoneParent
			
			)
			on tp_interval_spn changed val do
				ptTension=tp_tension_SPI.value
			on tp_StartTime_spn changed val do
				PtMass=tp_Mass_SPI.value
			on tp_endtime_spn changed val do
				PtMass=tp_Mass_SPI.value
			on tp_interval_btn pressed do
				tp_interval_spn.value=1
			on tp_startTime_btn pressed do
				tp_StartTime_spn.value=(animationrange.start/160) as integer
			on tp_endTime_btn pressed do
				tp_EndTime_spn.value=(animationrange.end/160) as integer
		)
		--
		--
		--
		rollout tp_boneTools "BONE����" width:147 height:298
		(
			button tp_FreezeExceptBone_btn "��������" pos:[5,3] width:65 height:20
			button tp_addRLayer_btn "Rotation" pos:[10,41] width:56 height:20
			button tp_addPLayer_btn "Potation" pos:[70,41] width:64 height:20
			GroupBox tp_grp1 "Add Bone Layer" pos:[6,24] width:135 height:42
			button tp_HideExceptBone_btn "��������" pos:[73,3] width:66 height:20
			
			button tp_keyPose_btn "��β֡���" pos:[79,69] width:63 height:20
			
			button tp_Kstart_btn "K��֡" pos:[5,69] width:35 height:20
			button tp_Kend_btn "Kβ֡" pos:[42,69] width:35 height:20
			on tp_FreezeExceptBone_btn pressed do
			(
				tp_ExceptBoneArray=#()
				for i in objects do
				if classof i!=BoneGeometry do append tp_ExceptBoneArray i
				if tp_ExceptBoneArray[1].isFrozen==false then freeze tp_ExceptBoneArray else unfreeze tp_ExceptBoneArray
			)--on btn pressed do
			on tp_addRLayer_btn pressed do
			(
				for i in selection do
					(
						try(
						i.rotation.controller.Available.controller = Euler_XYZ ()
						controllercount=i.rotation.controller.count
						i.rotation.controller.setactive controllercount
						)catch(messagebox "����¿�����������������Ƿ���㡣-Zero Euler XYZ" Title:"���ʧ��")
					)
			)--on btn pressed do
			on tp_addPLayer_btn pressed do
			(
				for i in selection do
					(
						try(
						i.Position.controller.Available.controller = Position_XYZ ()
						Pctrlcount=i.Position.controller.count
						i.Position.controller.setactive Pctrlcount
						)catch(messagebox "����¿�����������������Ƿ���㡣-Keyframe XYZ" Title:"���ʧ��")
				
					)
			)--on btn pressed do
			on tp_HideExceptBone_btn pressed do
			(
				tp_ExceptBoneGeoArray=#()
				tp_GeometryArray=for i in objects where classof i==Editable_Poly or classof i==Editable_mesh or classof i!=PolyMeshObject collect i
				freeze tp_GeometryArray
				for i in objects do
				if classof i!=BoneGeometry and classof i!=Editable_Poly and classof i!=Editable_mesh and classof i!=PolyMeshObject do append tp_ExceptBoneGeoArray i
				if tp_ExceptBoneGeoArray[1].isHidden==false then hide tp_ExceptBoneGeoArray else unhide tp_ExceptBoneGeoArray
			)--on btn pressed do
			on tp_keyPose_btn pressed do
			(
				try
				(
					local tp_Posefoo=true
					local tp_selBone=selection as array
					for i in selection do
					(
					try(
							i.rotation.controller.Available.controller = Euler_XYZ ()
							controllercount=i.rotation.controller.count
							i.rotation.controller.setactive controllercount
						)catch(tp_Posefoo=false)
					try(
							i.Position.controller.Available.controller = Position_XYZ ()
							Pctrlcount=i.Position.controller.count
							i.Position.controller.setactive Pctrlcount
						)catch(tp_Posefoo=false)
					)--for end
					
					select tp_selBone
					
					if tp_Posefoo==true then
					(
						max time start
						for s in Selection do
						(
							s.setSkinPose()
							if (classof s == CharacterAssembly) do for c in s.children do
								(
									c.setSkinPose()
								)
						)
						redrawViews()
						max time end
						animate on
						(
							for s in Selection do
							(
								s.assumeSkinPose()
								if (classof s == CharacterAssembly) do for c in s.children do
									(
										c.assumeSkinPose()
									)
							)	
						)--animate on
					)
					else
					(
						messagebox "����¿�����������������Ƿ���㡣-Zero Euler XYZ / -Keyframe XYZ" Title:"���ʧ��"
						exit				
					)--if end
				)catch(messagebox "δ֪����" Title:"ʧ��")
			)--on press end
			on tp_Kstart_btn pressed do
			(
				try(
					max time start
					max set key keys
				)catch()
			
			)
			on tp_Kend_btn pressed do
			(
				try(
					max time end
					max set key keys
				)catch()
				
			)
		)
--
--
--
--
--
--
		rollout tp_rangeTools "ʱ���Ṥ��" width:147 height:298
		(
			global tp_RangeStartData=animationrange.start
			global tp_RangeEndData=animationrange.end
			global tp_rangeDataText="RangeData: "+tp_RangeStartData as string+"--"+tp_RangeEndData as string

			
			
			spinner tp_startTime_btn "start time:" pos:[18,4] width:112 height:16 range:[-99999,99999,0] type:#integer scale:0 
 
 
 
 
 
			spinner tp_endTime_btn "end time :" pos:[17,23] width:114 height:16 range:[-99999,99999,100] type:#integer scale:1 
 
 
 
 
 
			
			
			button tp_anirangeA_btn "��3" pos:[8,45] width:20 height:20
			button tp_anirangeB_btn "��3" pos:[30,45] width:20 height:20
	
			
			button tp_anirangeC_btn "��2" pos:[97,45] width:20 height:20
			button tp_anirangeD_btn "��2" pos:[119,45] width:20 height:20
			
			
			button tp_saveRange_btn "save range" pos:[8,68] width:63 height:20 
 
 
 
 
 
			button tp_loadRange_btn "load range" pos:[75,68] width:63 height:20 
 
 
 
 
 
			label tp_rangeData_lab "--" pos:[10,90] width:123 height:18 
 
 
 
 
			
			
			
			
			
			
			
			button tp_AsInteger_btn "ȡ��" pos:[52,45] width:43 height:20
			button tp_delKeysTime_btn "����ѭ������һ��" pos:[10,111] width:122 height:22
			on tp_rangeTools open do
			(
				tp_rangeData_lab.caption=tp_rangeDataText
			)--on rollout open do
			on tp_startTime_btn changed val do
			(
				if tp_startTime_btn.value<tp_endtime_btn.value then
				(
					animationrange = (interval tp_startTime_btn.value tp_endtime_btn.value)
				)
				else
				(
					tp_starttimeValue=tp_endtime_btn.value-1
					animationrange = (interval tp_starttimeValue tp_endtime_btn.value)
				)
				
			)
			on tp_endTime_btn changed val do
			(
				if tp_startTime_btn.value<tp_endtime_btn.value then
				(
					animationrange = (interval tp_startTime_btn.value tp_endtime_btn.value)
				)
				else
				(
					tp_endtimeValue=tp_startTime_btn.value+1
					animationrange = (interval tp_startTime_btn.value tp_endtimeValue)
				)
			)
			on tp_anirangeA_btn pressed do
			(
				undo "annimationrange end ��3" on
				(
					tp_aniend=animationrange.end*3 as integer
					animationrange = (interval 0f tp_aniend)
				)
			)--on btn pressed do
			on tp_anirangeB_btn pressed do
			(
				undo "annimationrange end ��3" on
				(
					tp_aniend=animationrange.end/3 as integer
					animationrange = (interval 0f tp_aniend)
				)
			)--on btn pressed do
			on tp_anirangeC_btn pressed do
			(
				undo "annimationrange end ��2" on
				(
					tp_aniend=animationrange.end*2 as integer
					animationrange = (interval 0f tp_aniend)
				)
			)--on btn pressed do
			on tp_anirangeD_btn pressed do
			(
				undo "annimationrange end ��2" on
				(
					tp_aniend=animationrange.end/2 as integer
					animationrange = (interval 0f tp_aniend)
				)
			)--on btn pressed do
			on tp_saveRange_btn pressed do
			(
				tp_RangeStartData=animationrange.start
				tp_RangeEndData=animationrange.end
				tp_rangeDataText="RangeData: "+tp_RangeStartData as string+"--"+tp_RangeEndData as string
				tp_rangeData_lab.caption=tp_rangeDataText
			
			)
			on tp_loadRange_btn pressed do
			(	
				undo "Load range" on
				(
					animationrange=(interval tp_RangeStartData tp_RangeEndData)
				)
			)
			on tp_AsInteger_btn pressed do
			(
				try
				(
					tp_aniStart=(animationrange.start/160) as integer
					tp_aniend=(animationrange.end/160) as integer
					animationrange = (interval tp_anistart tp_aniend)
				)catch()
			)--on btn pressed do
			on tp_delKeysTime_btn pressed do
			(
				undo "tp del keys" on 
				(
					tp_EndTimeZ=((animationrange.end/160) as integer)/3*2
					for i in selection do
					(
						for a=0 to tp_EndTimeZ-1 do
						(
							selectkeys i.controller a
						)
						deletekeys i.controller #selection
						
						movekeys i.controller -tp_EndTimeZ
					)
					tp_EndTimeY=tp_EndTimeZ/2
					animationrange = (interval 0f tp_EndTimeY)
				)
				
			)
		)
		
		
		rollout tp_limitController_rol "��ת��������" width:147 height:290
		(
			spinner tp_Xupper_spn "���ֵ" pos:[47,43] width:83 height:16 range:[-10000,10000,180]
			
			spinner tp_Xlower_spn "��Сֵ" pos:[47,63] width:83 height:16 range:[-10000,10000,-180]
			checkbox tp_X_chk "Checkbox" pos:[17,43] width:17 height:15 checked:true
			GroupBox tp_X_grp "X����" pos:[5,23] width:132 height:65
			spinner tp_Yupper_spn "���ֵ" pos:[47,109] width:83 height:16 range:[-10000,10000,180]
			
			spinner tp_Ylower_spn "��Сֵ" pos:[47,129] width:83 height:16 range:[-10000,10000,-180]
			checkbox tp_Y_chk "Checkbox" pos:[17,109] width:17 height:15 checked:true
			GroupBox tp_Y_grp "Y����" pos:[5,91] width:132 height:65
			spinner tp_Zupper_spn "���ֵ" pos:[47,176] width:83 height:16 range:[-10000,10000,180]
			
			spinner tp_Zlower_spn "��Сֵ" pos:[47,196] width:83 height:16 range:[-10000,10000,-180]
			checkbox tp_Z_chk "Checkbox" pos:[17,176] width:17 height:15 checked:true
			GroupBox tp_Z_grp "Z����" pos:[5,158] width:132 height:65
			button tp_setXlower_btn "S" pos:[16,63] width:15 height:15
			button tp_setYlower_btn "S" pos:[16,129] width:15 height:15
			button tp_setZlower_btn "S" pos:[16,196] width:15 height:15
			button tp_addcontroller_btn "��ӿ�����" pos:[6,248] width:73 height:25
			button tp_setNum_btn "������ֵ" pos:[81,248] width:56 height:25
			button tp_freezeTransform_btn "Freeze Transform" pos:[6,2] width:93 height:20
			spinner tp_unify_spn "ͳһ��ֵ" pos:[17,228] width:99 height:16 range:[-10000,10000,90]
			button tp_setunifyNum_btn "S" pos:[119,227] width:18 height:18
			button TP_renovateNum_btn "ˢ��" pos:[102,2] width:35 height:20
			
			
			on tp_Xupper_spn changed val do
			(
				if tp_Xlower_spn.value>tp_Xupper_spn.value do tp_Xlower_spn.value=tp_Xupper_spn.value
			)
			on tp_Xlower_spn changed val do
			(
				if tp_Xupper_spn.value<tp_Xlower_spn.value do tp_Xupper_spn.value=tp_Xlower_spn.value
			)
			on tp_X_chk changed state do
			(
				tp_Xupper_spn.enabled=tp_X_chk.checked
				tp_Xlower_spn.enabled=tp_X_chk.checked
			)
			on tp_Yupper_spn changed val do
			(
				if tp_Ylower_spn.value>tp_Yupper_spn.value do tp_Ylower_spn.value=tp_Yupper_spn.value
			)
			on tp_Ylower_spn changed val do
			(
				if tp_Yupper_spn.value<tp_Ylower_spn.value do tp_Yupper_spn.value=tp_Ylower_spn.value
			)
			on tp_Y_chk changed state do
			(
				tp_Yupper_spn.enabled=tp_Y_chk.checked
				tp_Ylower_spn.enabled=tp_Y_chk.checked
			)
			on tp_Zupper_spn changed val do
			(
				if tp_Zlower_spn.value>tp_Zupper_spn.value do tp_Zlower_spn.value=tp_Zupper_spn.value
			)
			on tp_Zlower_spn changed val do
			(
				if tp_Zupper_spn.value<tp_Zlower_spn.value do tp_Zupper_spn.value=tp_Zlower_spn.value
			)
			on tp_Z_chk changed state do
			(
				tp_Zupper_spn.enabled=tp_Z_chk.checked
				tp_Zlower_spn.enabled=tp_Z_chk.checked
			)
			on tp_setXlower_btn pressed do
			(
				if tp_Xupper_spn.value>0 do
				tp_Xlower_spn.value=-tp_Xupper_spn.value
			)
			on tp_setYlower_btn pressed do
			(
				if tp_Yupper_spn.value>0 do
					tp_Ylower_spn.value=-tp_Yupper_spn.value
			)
			on tp_setZlower_btn pressed do
			(
				if tp_Zupper_spn.value>0 do
					tp_Zlower_spn.value=-tp_Zupper_spn.value
			)
			on tp_addcontroller_btn pressed do
			(
				undo on
				(
					for i in selection do
					(
						try
						(
							if tp_X_chk.checked==true do
							(
								i.rotation.controller.Zero_Euler_XYZ.controller.X_Rotation.controller = float_limit ()
								tp_XupperNum=tp_Xupper_spn.value/(180/pi)
								tp_XlowerNum=tp_Xlower_spn.value/(180/pi)
								i.rotation.controller.Zero_Euler_XYZ.controller.X_Rotation.controller.upper_limit = tp_XupperNum
								i.rotation.controller.Zero_Euler_XYZ.controller.X_Rotation.controller.lower_limit = tp_XlowerNum
							)
						)catch()
						
						try
						(
							if tp_Y_chk.checked==true do
							(
								i.rotation.controller.Zero_Euler_XYZ.controller.Y_Rotation.controller = float_limit ()
								tp_YupperNum=tp_Yupper_spn.value/(180/pi)
								tp_YlowerNum=tp_Ylower_spn.value/(180/pi)
								i.rotation.controller.Zero_Euler_XYZ.controller.Y_Rotation.controller.upper_limit = tp_YupperNum
								i.rotation.controller.Zero_Euler_XYZ.controller.Y_Rotation.controller.lower_limit = tp_YlowerNum
							)
						)catch()
						
						try
						(
							if tp_Z_chk.checked==true do
							(
								i.rotation.controller.Zero_Euler_XYZ.controller.Z_Rotation.controller = float_limit ()
								tp_ZupperNum=tp_Zupper_spn.value/(180/pi)
								tp_ZlowerNum=tp_Zlower_spn.value/(180/pi)
								i.rotation.controller.Zero_Euler_XYZ.controller.Z_Rotation.controller.upper_limit = tp_ZupperNum
								i.rotation.controller.Zero_Euler_XYZ.controller.Z_Rotation.controller.lower_limit = tp_ZlowerNum
							)
						)catch()
					)
				)
			)
			on tp_setNum_btn pressed do
			(
				undo on
				(
					for i in selection do
					(
						
						try
						(
							if tp_X_chk.checked==true do
							(
								tp_XupperNum=tp_Xupper_spn.value/(180/pi)
								tp_XlowerNum=tp_Xlower_spn.value/(180/pi)
								i.rotation.controller.Zero_Euler_XYZ.controller.X_Rotation.controller.upper_limit = tp_XupperNum
								i.rotation.controller.Zero_Euler_XYZ.controller.X_Rotation.controller.lower_limit = tp_XlowerNum
								
							)
						)catch()
							
						try
						(
							if tp_Y_chk.checked==true do
							(
								tp_YupperNum=tp_Yupper_spn.value/(180/pi)
								tp_YlowerNum=tp_Ylower_spn.value/(180/pi)
								i.rotation.controller.Zero_Euler_XYZ.controller.Y_Rotation.controller.upper_limit = tp_YupperNum
								i.rotation.controller.Zero_Euler_XYZ.controller.Y_Rotation.controller.lower_limit = tp_YlowerNum
							)
						)catch()
						
						try
						(
							if tp_Z_chk.checked==true do
							(
								tp_ZupperNum=tp_Zupper_spn.value/(180/pi)
								tp_ZlowerNum=tp_Zlower_spn.value/(180/pi)
								i.rotation.controller.Zero_Euler_XYZ.controller.Z_Rotation.controller.upper_limit = tp_ZupperNum
								i.rotation.controller.Zero_Euler_XYZ.controller.Z_Rotation.controller.lower_limit = tp_ZlowerNum
							)
						)catch()
					)
				)
			)
			on tp_freezeTransform_btn pressed do
			(
				macros.run "Animation Tools" "FreezeTransform"
			)
			on tp_setunifyNum_btn pressed do
			(
				tp_Xupper_spn.value=tp_unify_spn.value
				tp_Xlower_spn.value=-tp_unify_spn.value
				
				tp_Yupper_spn.value=tp_unify_spn.value
				tp_Ylower_spn.value=-tp_unify_spn.value
				
				tp_Zupper_spn.value=tp_unify_spn.value
				tp_Zlower_spn.value=-tp_unify_spn.value
			)
			on TP_renovateNum_btn pressed  do
			(
				if selection.count==1 do
				(
					try
					(
						
-- 						tp_XupperNum=tp_Xupper_spn.value/(180/pi)
-- 						tp_XlowerNum=tp_Xlower_spn.value/(180/pi)
						
						tp_XupperNum=$.rotation.controller.Zero_Euler_XYZ.controller.X_Rotation.controller.upper_limit*(180/pi)
						tp_XlowerNum=$.rotation.controller.Zero_Euler_XYZ.controller.X_Rotation.controller.lower_limit*(180/pi)
						tp_Xupper_spn.value=tp_XupperNum
						tp_Xlower_spn.value=tp_XlowerNum

					)catch()
						
					try
					(
-- 						tp_YupperNum=tp_Yupper_spn.value/(180/pi)
-- 						tp_YlowerNum=tp_Ylower_spn.value/(180/pi)
-- 						i.rotation.controller.Zero_Euler_XYZ.controller.Y_Rotation.controller.upper_limit = tp_YupperNum
-- 						i.rotation.controller.Zero_Euler_XYZ.controller.Y_Rotation.controller.lower_limit = tp_YlowerNum
						tp_YupperNum=$.rotation.controller.Zero_Euler_XYZ.controller.Y_Rotation.controller.upper_limit*(180/pi)
						tp_YlowerNum=$.rotation.controller.Zero_Euler_XYZ.controller.Y_Rotation.controller.lower_limit*(180/pi)
						tp_Yupper_spn.value=tp_YupperNum
						tp_Ylower_spn.value=tp_YlowerNum
					)catch()
					
					try
					(
-- 						tp_ZupperNum=tp_Zupper_spn.value/(180/pi)
-- 						tp_ZlowerNum=tp_Zlower_spn.value/(180/pi)
-- 						i.rotation.controller.Zero_Euler_XYZ.controller.Z_Rotation.controller.upper_limit = tp_ZupperNum
-- 						i.rotation.controller.Zero_Euler_XYZ.controller.Z_Rotation.controller.lower_limit = tp_ZlowerNum
						tp_ZupperNum=$.rotation.controller.Zero_Euler_XYZ.controller.Z_Rotation.controller.upper_limit*(180/pi)
						tp_ZlowerNum=$.rotation.controller.Zero_Euler_XYZ.controller.Z_Rotation.controller.lower_limit*(180/pi)
						tp_Zupper_spn.value=tp_ZupperNum
						tp_Zlower_spn.value=tp_ZlowerNum

					)catch()
				)
			)
		)
		
--
--
--
--

----------------������--------
	
		----RolloutFloater-----
		
		if Pw_tools!=undefined then 
		(
			if Pw_tools.open==true then 
			(	
				closeRolloutFloater Pw_tools 
			)
			else 
			(
				Pw_tools=newrolloutfloater "easy springtool" 158 820 10 90
				addrollout Spring_tools Pw_tools
				addrollout tp_boneTools Pw_tools
				addrollout tp_rangeTools Pw_tools
				addrollout tp_limitController_rol Pw_tools
				
					
			)
		)
		else
		(
			Pw_tools=newrolloutfloater "cgjoy springtool" 158 820 10 90
			addrollout Spring_tools Pw_tools
			addrollout tp_boneTools Pw_tools
			addrollout tp_rangeTools Pw_tools
			addrollout tp_limitController_rol Pw_tools
			
		)
	)--on execute do

) 