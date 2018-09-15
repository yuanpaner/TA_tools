macroScript NArtBoneFollow
category:"_NArtTools"
tooltip:"Bone Follow"
buttontext:"Bone Follow"
(
	on execute do
	(
		try(DestroyDialog tp_Bonefollow_rol)catch()
		rollout tp_Bonefollow_rol "骨骼跟随" width:162 height:500
		(
			checkbox tp_Z_chk "" pos:[17,487] width:16 height:17 checked:true
			checkbox tp_X_chk "" pos:[17,444] width:18 height:17 checked:true
			checkbox tp_Y_chk "" pos:[17,465] width:17 height:17 checked:true
			spinner tp_offset_spn "帧偏移" pos:[23,421] width:70 height:16 range:[0,1000,5] type:#integer
			button tp_Go_btn "计算子物体跟随" pos:[17,509] width:122 height:24
			GroupBox tp_AniBone_grp "根骨骼动画生成" pos:[1,27] width:159 height:368
			GroupBox grp3 "X轴旋转" pos:[4,43] width:152 height:46
			spinner tp_rotXmin_spn "min" pos:[26,64] width:49 height:16 range:[-360,360,0]
			
			
			spinner tp_rotXmax_spn "max" pos:[95,64] width:49 height:16 range:[-360,360,0] type:#float
			
			spinner tp_rotYmin_spn "min" pos:[26,111] width:49 height:16 range:[-360,360,0]
			GroupBox grp4 "Y轴旋转" pos:[4,90] width:152 height:46
			spinner tp_rotYmax_spn "max" pos:[95,111] width:49 height:16 range:[-360,360,0]
			spinner tp_rotZmin_spn "min" pos:[26,158] width:49 height:16 range:[-360,360,0]
			GroupBox grp5 "Z轴旋转" pos:[4,137] width:152 height:46
			spinner tp_rotZmax_spn "max" pos:[95,158] width:49 height:16 range:[-360,360,0]
			
			spinner tp_keyOffsetmin_spn "min" pos:[27,205] width:49 height:16 range:[-9999,9999,0] type:#integer
			GroupBox grp6 "帧偏移" pos:[4,184] width:152 height:46
			spinner tp_keyOffsetmax_spn "max" pos:[95,205] width:49 height:16 range:[-9999,9999,0] type:#integer
			button tp_AniRun_btn "生成动画" pos:[85,363] width:72 height:26
			GroupBox grp22 "子骨骼动画生成" pos:[2,398] width:158 height:139
			button tp_selBone_btn "选择父骨骼" pos:[4,363] width:80 height:26
			button tp_deloop_btn "撤销循环" pos:[2,541] width:58 height:26
			button tp_DelAni_btn "删除动画" pos:[62,541] width:57 height:26
			spinner tp_increaseX_spn "X-增幅" pos:[48,444] width:90 height:16 range:[0,1000,0] type:#integer
			spinner tp_increaseY_spn "Y-增幅" pos:[48,465] width:90 height:16 range:[0,1000,0] type:#integer
			spinner tp_increaseZ_spn "Z-增幅" pos:[48,487] width:90 height:16 range:[0,1000,0] type:#integer
			button tp_freezeTran_btn "Freeze Transform" pos:[5,4] width:150 height:21
			
			button tp_toZero_btn "归零" pos:[121,541] width:38 height:26
			progressBar tp_pb "ProgressBar" pos:[6,571] width:150 height:10 value:0 visible:false
			
			
			checkbox tp_loop_chk "循环" pos:[103,420] width:54 height:17 checked:false
			
			checkbox tp_relative_chk "计算起始帧相对值" pos:[10,337] width:139 height:21 checked:true
			spinner tp_wavelengthMin_spn "min" pos:[28,252] width:49 height:16 range:[-9999,9999,0] type:#integer
			GroupBox tp_wavelength_grp "波长" pos:[4,232] width:152 height:46
			spinner tp_wavelengthMax_spn "max" pos:[99,251] width:49 height:16 range:[-9999,9999,0] type:#integer
			
			spinner tp_LoopFrequency_spn "循环数" pos:[19,286] width:71 height:16 range:[1,99,5] type:#integer
			spinner tp_StartTime_spn "起始帧" pos:[19,312] width:77 height:16 range:[-9999,9999,0] type:#integer
			checkbox tp_lockTime_chk "锁定" pos:[101,312] width:50 height:16
			checkbox tp_OnlyBackward_chk "只向后" pos:[97,287] width:62 height:16
-- 			HyperLink tp_cgjoy_hk "煮饺子的茶壶 2011.03.21" pos:[21,585] width:135 height:15 address:"http://www.cgjoy.com/viewthread.php?tid=12462&fromuid=3815" 
			
			
			local tp_ChildrenBoneArray=#()
			local tp_BoneChildArray=#()
		
			on tp_Z_chk changed state do
			(
				if tp_Z_chk.checked==true then
				(
					tp_increaseZ_spn.Enabled=true
				)
				else
				(
					tp_increaseZ_spn.Enabled=false
				)
			
			)
			
			on tp_X_chk changed state do
			(
				if tp_X_chk.checked==true then
				(
					tp_increaseX_spn.Enabled=true
				)
				else
				(
					tp_increaseX_spn.Enabled=false
				)
			
			)
			
			on tp_Y_chk changed state do
			(
				if tp_Y_chk.checked==true then
				(
					tp_increaseY_spn.Enabled=true
				)
				else
				(
					tp_increaseY_spn.Enabled=false
				)
			
			)
			
			on tp_Go_btn pressed do
			(
				with redraw off
				(
					tp_PboneArray=#()
					tp_AniCtrllerX=tp_AniCtrllerY=tp_AniCtrllerZ=undefined
					tp_copyControllerX=tp_copyControllerY=tp_copyControllerZ=undefined
					tp_PboneArray=for i in selection collect i					
					tp_foo=0
					tp_pb.value=0
					tp_pb.visible=true
					
					for tp_Pbone in tp_PboneArray do
					(
						
						if tp_Pbone.transform.controller.rotation.controller.Zero_Euler_XYZ.controller!=undefined then
						(
							tp_AniBone=tp_Pbone
							tp_increaseX=tp_increaseX_spn.value
							tp_increaseY=tp_increaseY_spn.value
							tp_increaseZ=tp_increaseZ_spn.value
							tp_movekeyTime=tp_offset_spn.value
							
							tp_AniCtrllerX=tp_AniBone.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller
							tp_AniCtrllerY=tp_AniBone.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller
							tp_AniCtrllerZ=tp_AniBone.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller
							
							if tp_loop_chk.checked==true then
							(
								tp_AniBortX=getBeforeORT tp_AniCtrllerX
								tp_AniBortY=getBeforeORT tp_AniCtrllerY
								tp_AniBortZ=getBeforeORT tp_AniCtrllerZ
								
								tp_AniAortX=getAfterORT tp_AniCtrllerX
								tp_AniAortY=getAfterORT tp_AniCtrllerY
								tp_AniAortZ=getAfterORT tp_AniCtrllerZ
							
								setBeforeORT tp_AniCtrllerX #loop
								setBeforeORT tp_AniCtrllerY #loop
								setBeforeORT tp_AniCtrllerZ #loop
								
								setAfterORT tp_AniCtrllerX #loop
								setAfterORT tp_AniCtrllerY #loop
								setAfterORT tp_AniCtrllerZ #loop
							)
							
							tp_copyControllerX=copy tp_AniCtrllerX
							tp_copyControllerY=copy tp_AniCtrllerY
							tp_copyControllerZ=copy tp_AniCtrllerZ
							
							if tp_loop_chk.checked==true then
							(
								setBeforeORT tp_AniCtrllerX tp_AniBortX
								setBeforeORT tp_AniCtrllerY tp_AniBortY
								setBeforeORT tp_AniCtrllerZ tp_AniBortZ
								
								setAfterORT tp_AniCtrllerX tp_AniAortX
								setAfterORT tp_AniCtrllerY tp_AniAortY
								setAfterORT tp_AniCtrllerZ tp_AniAortZ
							)
							tp_ChildrenBoneArray = NArtNode.GetSingleChildNodes tp_AniBone
							
							for i in tp_ChildrenBoneArray do
							(
								select i
								
								if tp_X_chk.checked==true do
								(
									i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller=tp_copyControllerX
									tp_PasteCtrllerX=i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller
									
									animate on
									(			
										for a=1 to tp_PasteCtrllerX.keys.count do
										(
											at time tp_PasteCtrllerX.keys[a].time
											(
												if a<tp_PasteCtrllerX.keys.count then
												(
													if tp_PasteCtrllerX.keys[a].value>tp_PasteCtrllerX.keys[a+1].value then
													(
														tp_PasteCtrllerX.keys[a].value+=tp_increaseX
													)
													else
													(
															tp_PasteCtrllerX.keys[a].value-=tp_increaseX
													)--if end
												)
												else
												(
													if tp_PasteCtrllerX.keys[a].value>tp_PasteCtrllerX.keys[a-1].value then
													(
														tp_PasteCtrllerX.keys[a].value+=tp_increaseX
													)
													else
													(
														tp_PasteCtrllerX.keys[a].value-=tp_increaseX
													)--if end
												)--if i count end
											)--at time end
										)--for end
									)--animate end
									movekeys tp_PasteCtrllerX tp_movekeyTime
									tp_copyControllerX=copy tp_PasteCtrllerX
								)--if checked end
								
								if tp_Y_chk.checked==true do
								(
									i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller=tp_copyControllerY
									tp_PasteCtrllerY=i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller
									
									animate on
									(			
										for a=1 to tp_PasteCtrllerY.keys.count do
										(
											at time tp_PasteCtrllerY.keys[a].time
											(
												if a<tp_PasteCtrllerY.keys.count then
												(
													if tp_PasteCtrllerY.keys[a].value>tp_PasteCtrllerY.keys[a+1].value then
													(
														tp_PasteCtrllerY.keys[a].value+=tp_increaseY
													)
													else
													(
															tp_PasteCtrllerY.keys[a].value-=tp_increaseY
													)--if end
												)
												else
												(
													if tp_PasteCtrllerY.keys[a].value>tp_PasteCtrllerY.keys[a-1].value then
													(
														tp_PasteCtrllerY.keys[a].value+=tp_increaseY
													)
													else
													(
														tp_PasteCtrllerY.keys[a].value-=tp_increaseY
													)--if end
												)--if i count end
											)--at time end
										)--for end
									)--animate end
									movekeys tp_PasteCtrllerY tp_movekeyTime
									tp_copyControllerY=copy tp_PasteCtrllerY
								)--if checked end
								
								if tp_Z_chk.checked==true do
								(
									i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller=tp_copyControllerZ
									tp_PasteCtrllerZ=i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller
									
									animate on
									(			
										for a=1 to tp_PasteCtrllerZ.keys.count do
										(
											at time tp_PasteCtrllerZ.keys[a].time
											(
												if a<tp_PasteCtrllerZ.keys.count then
												(
													if tp_PasteCtrllerZ.keys[a].value>tp_PasteCtrllerZ.keys[a+1].value then
													(
														tp_PasteCtrllerZ.keys[a].value+=tp_increaseZ
													)
													else
													(
															tp_PasteCtrllerZ.keys[a].value-=tp_increaseZ
													)--if end
												)
												else
												(
													if tp_PasteCtrllerZ.keys[a].value>tp_PasteCtrllerZ.keys[a-1].value then
													(
														tp_PasteCtrllerZ.keys[a].value+=tp_increaseZ
													)
													else
													(
														tp_PasteCtrllerZ.keys[a].value-=tp_increaseZ
													)--if end
												)--if i count end
											)--at time end
										)--for end
									)--animate end
									movekeys tp_PasteCtrllerZ tp_movekeyTime
									tp_copyControllerZ=copy tp_PasteCtrllerZ
								)--if checked end
			
							)--for end
							tp_ChildrenBoneArray=#()
							tp_BoneChildArray=#()
						)--if end
						else
						(
							messagebox"需要骨骼归零" title:"错误"
						)
						tp_foo+=1
						tp_pb.value=100.*tp_foo/tp_PboneArray.count
					)--for end
					tp_foo=0
					tp_pb.value=0
					tp_pb.visible=false
				)--redraw off
				select tp_PboneArray
				redrawViews()
			)--on pressed do end
			on tp_rotXmin_spn changed val do
				if tp_rotXmin_spn.value>tp_rotXmax_spn.value do tp_rotXmax_spn.value=tp_rotXmin_spn.value
			on tp_rotXmax_spn changed val do
				if tp_rotXmin_spn.value>tp_rotXmax_spn.value do tp_rotXmin_spn.value=tp_rotXmax_spn.value
			on tp_rotYmin_spn changed val do
				if tp_rotYmin_spn.value>tp_rotYmax_spn.value do tp_rotYmax_spn.value=tp_rotYmin_spn.value
			on tp_rotYmax_spn changed val do
				if tp_rotYmin_spn.value>tp_rotYmax_spn.value do tp_rotYmin_spn.value=tp_rotYmax_spn.value
			on tp_rotZmin_spn changed val do
				if tp_rotZmin_spn.value>tp_rotZmax_spn.value do tp_rotZmax_spn.value=tp_rotZmin_spn.value
			on tp_rotZmax_spn changed val do
				if tp_rotZmin_spn.value>tp_rotZmax_spn.value do tp_rotZmin_spn.value=tp_rotZmax_spn.value
			on tp_keyOffsetmin_spn changed val do
				if tp_keyOffsetmin_spn.value>tp_keyOffsetmax_spn.value do tp_keyOffsetmax_spn.value=tp_keyOffsetmin_spn.value
			on tp_keyOffsetmax_spn changed val do
				if tp_keyOffsetmin_spn.value>tp_keyOffsetmax_spn.value do tp_keyOffsetmin_spn.value=tp_keyOffsetmax_spn.value
			on tp_AniRun_btn pressed do
			(
				try(
					with redraw off
					(
						tp_SelParentBone=for i in selection collect i
						tp_foo=0
						tp_pb.value=0
						tp_pb.visible=true						
						
						for i in tp_SelParentBone do
						(
							
							select i
							tp_rotX=random tp_rotXmin_spn.value tp_rotXmax_spn.value
							tp_rotY=random tp_rotYmin_spn.value tp_rotYmax_spn.value
							tp_rotZ=random tp_rotZmin_spn.value tp_rotZmax_spn.value
							tp_keyOffset=random tp_keyOffsetmin_spn.value tp_keyOffsetmax_spn.value
							tp_keylength=random tp_wavelengthMin_spn.value tp_wavelengthMax_spn.value
							
							tp_StartTime=tp_StartTimeB=tp_StartTime_spn.value
							tp_EndTime=tp_EndTimeB=tp_StartTime+tp_keylength
							tp_CentreTime=tp_CentreTimeB=(tp_StartTime+tp_EndTime)/2 as integer
							
							at time tp_StartTime
							(
								tp_XctrlValue=copy i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value
								tp_YctrlValue=copy i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value
								tp_ZctrlValue=copy i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value
							)
							animate on
							(
								for tp_LoopFoo=1 to tp_LoopFrequency_spn.value do
								(
										at time tp_StartTime
										(
											if tp_relative_chk.checked==false then
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=-tp_rotX/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=-tp_rotY/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=-tp_rotZ/2
											)
											else
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=-tp_rotX/2+tp_XctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=-tp_rotY/2+tp_YctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=-tp_rotZ/2+tp_ZctrlValue
											)
										)
										at time tp_EndTime
										(
											if tp_relative_chk.checked==false then
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=-tp_rotX/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=-tp_rotY/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=-tp_rotZ/2
											)
											else
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=-tp_rotX/2+tp_XctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=-tp_rotY/2+tp_YctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=-tp_rotZ/2+tp_ZctrlValue
											)
										)
										
										at time tp_CentreTime
										(
											if tp_relative_chk.checked==false then
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=tp_rotX/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=tp_rotY/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=tp_rotZ/2
											)
											else
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=tp_rotX/2+tp_XctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=tp_rotY/2+tp_YctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=tp_rotZ/2+tp_ZctrlValue
											)
										)
										
										
									if tp_LoopFoo>1 and tp_OnlyBackward_chk.checked==false then
									(
										at time tp_StartTimeB
										(
											if tp_relative_chk.checked==false then
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=-tp_rotX/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=-tp_rotY/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=-tp_rotZ/2
											)
											else
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=-tp_rotX/2+tp_XctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=-tp_rotY/2+tp_YctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=-tp_rotZ/2+tp_ZctrlValue
											)
										)
										at time tp_EndTimeB
										(
											if tp_relative_chk.checked==false then
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=-tp_rotX/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=-tp_rotY/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=-tp_rotZ/2
											)
											else
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=-tp_rotX/2+tp_XctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=-tp_rotY/2+tp_YctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=-tp_rotZ/2+tp_ZctrlValue
											)
										)
										
										at time tp_CentreTimeB
										(
											if tp_relative_chk.checked==false then
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=tp_rotX/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=tp_rotY/2
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=tp_rotZ/2
											)
											else
											(
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller.value=tp_rotX/2+tp_XctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller.value=tp_rotY/2+tp_YctrlValue
												i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller.value=tp_rotZ/2+tp_ZctrlValue
											)
										)
										
									)--if end
										
									tp_StartTime+=tp_keylength
									tp_EndTime+=tp_KeyLength
									tp_CentreTime=(tp_StartTime+tp_EndTime)/2 as integer
									
									tp_StartTimeB-=tp_keylength
									tp_EndTimeB-=tp_keylength
									tp_CentreTimeB=(tp_StartTimeB+tp_EndTimeB)/2 as integer
									
									
								)--for end
							)--animate end	
								
								tp_CtrllerX=i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller
								tp_CtrllerY=i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller
								tp_CtrllerZ=i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller
							
								
								movekeys tp_CtrllerX tp_keyOffset
								movekeys tp_CtrllerY tp_keyOffset
								movekeys tp_CtrllerZ tp_keyOffset
								
							tp_foo+=1
							tp_pb.value=100.*tp_foo/tp_SelParentBone.count
						)---for end
						select tp_SelParentBone
					)--redraw off
				)catch()
				redrawViews()
				tp_foo=0
				tp_pb.value=0
				tp_pb.visible=false
			)
			on tp_selBone_btn pressed do
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
			on tp_deloop_btn pressed do
			(
				undo "deloop" on
				(
					for i in selection do
					(
						try
						(
						
							tp_AniCtrllerX=i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.X_rotation.controller
							tp_AniCtrllerY=i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller
							tp_AniCtrllerZ=i.transform.controller.rotation.controller.Zero_Euler_XYZ.controller.Z_rotation.controller
							setBeforeORT tp_AniCtrllerX #constant
							setBeforeORT tp_AniCtrllerY #constant
							setBeforeORT tp_AniCtrllerZ #constant
							
							setAfterORT tp_AniCtrllerX #constant
							setAfterORT tp_AniCtrllerY #constant
							setAfterORT tp_AniCtrllerZ #constant
							)catch()
					)--for end
				)--undo end
			)
			on tp_DelAni_btn pressed do
			(
				try
				(
					macros.run "Animation Tools" "DeleteSelectedAnimation"
					
				)catch()
					
			)
			on tp_freezeTran_btn pressed do
			(
				try
				(
					macros.run "Animation Tools" "FreezeTransform"
				)catch(messagebox"骨骼归零失败" title:"错误")
			)
			on tp_toZero_btn pressed do
			(
				try
				(
					macros.run "Animation Tools" "TransformToZero"
				)catch(messagebox"骨骼归零失败" title:"错误")
			)
			on tp_wavelengthMin_spn changed val do
				if tp_wavelengthmin_spn.value>tp_wavelengthmax_spn.value do tp_wavelengthmax_spn.value=tp_wavelengthmin_spn.value
			on tp_wavelengthMax_spn changed val do
				if tp_wavelengthmin_spn.value>tp_wavelengthmax_spn.value do tp_wavelengthmin_spn.value=tp_wavelengthmax_spn.value
			on tp_lockTime_chk changed state do
			(
				if tp_lockTime_chk.checked==true then
				(
					tp_keyOffsetmin_spn.value=0
					tp_keyOffsetmax_spn.value=0
					tp_keyOffsetmin_spn.Enabled=false
					tp_keyOffsetmax_spn.Enabled=false
				)
				else
				(
					tp_keyOffsetmin_spn.Enabled=true
					tp_keyOffsetmax_spn.Enabled=true
				)
			)
		)			--
		--
		createdialog tp_Bonefollow_rol 162 605 90 120

		
-- 		if tp_Bonefollow_rol!=undefined then
-- 		(
-- 			if tp_Bonefollow_rol.open==true then
-- 				DestroyDialog tp_Bonefollow_rol
-- 			else
-- 				createdialog tp_Bonefollow_rol 162 605 90 120
-- 			
-- 		)
-- 		else
-- 		(
-- 			createdialog tp_Bonefollow_rol 162 605 90 120
-- 		)
	)
) 