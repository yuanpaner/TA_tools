macroScript TP_BoneFollow
category:"茶壶动作工具"
tooltip:"TP Bone Follow"
buttontext:"TP Bone Follow"
(
		tp_ChildrenBoneArray=#()
		tp_BoneChildArray=#()
		
		
		fn tp_getChildArray_fn tp_selobj=
		(
			if tp_selobj.children.count==1 then
			(
				append tp_BoneChildArray tp_selobj.children[1] 
				tp_getChildArray_fn tp_selobj.children[1] 
			)
			else return tp_BoneChildArray
		)
		
		fn tp_createBFrol_fn tp_XX=
		(
			rollout tp_Bonefollow_rol "骨骼跟随" width:162 height:605
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
				HyperLink tp_cgjoy_hk "煮饺子的茶壶 2011.03.21" pos:[21,585] width:135 height:15 address:"http://www.cgjoy.com/viewthread.php?tid=12462&fromuid=3815" 
				
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
								tp_ChildrenBoneArray=tp_getChildArray_fn tp_AniBone
								
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
		
			
		)--fn end
		
		
		if tp_Bonefollow_rol!=undefined then
		(
			if tp_Bonefollow_rol.open==true then
			DestroyDialog tp_Bonefollow_rol
			else
			tp_createBFrol_fn 1
			
		)
		else
		(
			tp_createBFrol_fn 1
		)
)


macroScript TP_easy_springtools
category:"茶壶动作工具"
buttontext:"TP easy spring"
toolTip:"TP easy spring"
(
	on execute do
	(
		Global Pw_tools
		rollout Spring_tools "裙摆工具" width:147 height:298
		(
			local FirstBoneArray = #()
			local LastBoneArray = #()
			local LastPointArray = #()
			local ChildArray = #()  --子物体的数组
			local PosArray = #()  --用来创建线的坐标数组
			local AddSpringPoints = #()  --加弹簧的点
			local LyLine          --创建线性骨骼用的线
			local MySpline
			local AllObj
			local PtTension = 1  --越小越有弹性
			local PtInd = 1.8
			local PtMass = 300.0  --越重越有弹性  越大越有弹性
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
			fn SelChildren sel SelChilds =   --把子物体加进选择集函数
			(
				for i = 1 to sel.children.count do
				( 
					tempsel = sel.children[i]
					append SelChilds tempsel 
					if tempsel != undefined do SelChildren tempsel SelChilds
				)
				return  SelChilds
			)
			
			fn SelArrayToPosArray SelArray =  --选择集转换成坐标pos集函数
			(
				for i in SelArray do 
				(
					append PosArray i.pos
				)
				return  PosArray
			)
			
			fn drawLine ptArray =    ----画线函数
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
		
			fn copybones sel =           -- 拷贝骨骼并隐藏
			(
				FirstBoneArray  = #()        --子物体数组
				append FirstBoneArray  sel   --把自己加进选择集
				SelChildren sel FirstBoneArray    --把子骨骼加入数组
				
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
				Select LastBoneArray[1]        --选择新复制骨骼的跟骨骼
			)
			fn SetTension objs Tension Ind =  -- 设置弹簧拉力
			(
				for i in objs do
				(
					i.pos.controller.Spring.setTension 1 Tension 
					Tension = Tension / Ind 
				)
			)
			fn setMass objs Mass Ind =  -- 设置弹簧重力
			(
				for i in objs do
				(
					i.pos.controller.Spring.setMass Mass
					Mass = Mass * Ind 
				)
			)
			fn bakeAnim sel =           -- 烘焙关键帧
			(
				FirstBoneArray  = #()        --子物体数组
				append FirstBoneArray  sel   --把自己加进选择集
				SelChildren sel FirstBoneArray    --把子骨骼加入数组
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
					SaveOName AllObj  --保存所有物体名称到文本文件
				)catch()
				
				for t in starttime to endtime by 1 do 
				(
					sliderTime = t 
					with animate on
					(
						for i in 1 to bakepoints.count do  ----点跟着骨骼打关键帧
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
						for i in 1 to bakepoints.count do  ----真正烘焙骨骼关键帧
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
						sliderTime = 0f
						actionMan.executeAction 0 "40180"  -- Selection: Select Children
						maxOps.deleteSelectedAnimation()
						select tp_parentObj
					)
			)
			
			fn tp_CreatIK_fn= 		--创建软物体
			(
				if selection.count == 1 then 
				(
					FirstBoneArray = #()   --清空变量
					LastBoneArray = #()    --清空变量
					MyIks = #()        --清空变量
					filename = maxFilePath + (getFilenameFile maxFileName) + "_" + $.name + ".dat"
					copybones $        --拷贝骨骼  并隐藏原来的骨骼
					PosArray = #()     --画线用的坐标
					AddSpringPoints = #()     --清空变量  加弹簧控制的点
					
					SelArrayToPosArray  LastBoneArray
					MySpline = drawLine PosArray
					SplinIk ()  -- 我的创建spline ik的函数，创建线性ik，替代了下面这行的命令，哈哈！
					--macros.run "Inverse Kinematics" "SPLINE_IK"
					LyLine.modifiers[#Spline_IK_Control].linkTypes = 1
					--下面是给每个控制点加上弹簧
					for i in 2 to LyLine.modifiers[#Spline_IK_Control].helper_list.count do
					(
						TempPoint = LyLine.modifiers[#Spline_IK_Control].helper_list[i]
						append AddSpringPoints TempPoint
						TempPoint.pos.controller = SpringPositionController ()
					)
					AddSpringPoints[1].parent.parent = LastBoneArray[1].parent
					completeRedraw()  --刷新一下场景，不然弹簧拉力设置不上。
					SetTension AddSpringPoints PtTension PtInd  --设置弹性
					setMass AddSpringPoints PtMass MassInd --设置点重量
					
					for i in 1 to (FirstBoneArray.count-1) do
					(
						myik = IKSys.ikChain FirstBoneArray[i] FirstBoneArray[i+1] "IKHiSolver"
						append MyIks myik 
						myik.parent = LastBoneArray[i]
						hide myik
					)
					select FirstBoneArray[1]
					
					
					
					Allpoints = #()  -- 创建线性ik时候产生的point点集合
					for i in 1 to LyLine.modifiers[#Spline_IK_Control].helper_list.count do
					(
						TempPoint = LyLine.modifiers[#Spline_IK_Control].helper_list[i]
						append Allpoints TempPoint
					)
					
					------------------------下面保存数据---------------------------------------
					local mysplines = #()
					append mysplines MySpline 
					AllObj =  mysplines + Allpoints + LastBoneArray
					SaveOName AllObj  --保存所有物体名称到文本文件
				)
				else
				(
					messageBox "请选择要创建软物体的跟骨骼"
				)	
			)
			
			fn tp_bakeAnim_fn=      --烘焙关键帧
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
					messageBox "请选择塌陷关键帧骨骼的跟骨骼"
				)
			)
			
			fn tp_clearscene_fn=	--清理场景
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
					messageBox "请选择软物体的跟骨骼"
				)
			)
			
			fn tp_rangeValue_fn =
			(
				tp_rangeTools.tp_startTime_btn.value=(animationrange.start/160) as integer
				tp_rangeTools.tp_endTime_btn.value=(animationrange.end/160) as integer
			)
			
			button btn_verysoft "软" pos:[5,13] width:20 height:20
			button btn_veryhard "硬" pos:[120,13] width:20 height:20
			
			button btn_soft "软" pos:[29,13] width:20 height:20
			button btn_yiban "一般" pos:[53,13] width:38 height:20
			button btn_hard "硬" pos:[96,13] width:20 height:20
			spinner tp_Tension_SPI "Tension" pos:[33,40] width:87 height:16
			spinner tp_Mass_SPI "Mass   " pos:[33,62] width:88 height:16 enabled:true range:[0,1000,0] type:#integer
 
			button tp_batch_btn "开始计算" pos:[78,153] width:60 height:20
			button tp_selPBone_btn "选择父物体" pos:[6,153] width:70 height:20
			progressBar tp_pb1 "ProgressBar" pos:[6,3] width:132 height:7 orient:#horizontal visible:false
			
			spinner tp_interval_spn "帧间隔   " pos:[15,87] width:110 height:16 range:[1,100,1] type:#integer
			spinner tp_StartTime_spn "起始帧   " pos:[15,108] width:110 height:16 enabled:true range:[-1000,1000,0] type:#integer
			spinner tp_endtime_spn "结束帧   " pos:[15,129] width:110 height:16 enabled:true range:[-1000,1000,120] type:#integer
			button tp_interval_btn "R" pos:[128,87] width:16 height:16
			
			button tp_StartTime_btn "R" pos:[128,108] width:16 height:16
			button tp_endtime_btn "R" pos:[128,129] width:16 height:16
			on Spring_tools open do
			(
				animButtonState = off
				tp_Tension_SPI.value = PtTension = 1  --越小越有弹性
				tp_Mass_SPI.value = ptMass = 300  --越重越有弹性  越大越有弹性
				tp_StartTime_spn.value=(animationrange.start/160) as integer
				tp_endtime_spn.value=(animationrange.end/160) as integer
			)
			on btn_verysoft pressed do
			(
				tp_Tension_SPI.value=PtTension = 0.45  --越小越有弹性
				tp_Mass_SPI.value = PtMass = 675  --越重越有弹性  越大越有弹性
			)
			on btn_veryhard pressed do
			(
				tp_Tension_SPI.value = PtTension = 2.25  --越小越有弹性
				tp_Mass_SPI.value = PtMass = 134  --越重越有弹性  越大越有弹性
			
			)
			on btn_soft pressed do
			(
				tp_Tension_SPI.value = PtTension = 0.667  --越小越有弹性
				tp_Mass_SPI.value = PtMass = 450  --越重越有弹性  越大越有弹性
			
			)
			on btn_yiban pressed do
			(
				tp_Tension_SPI.value = PtTension = 1  --越小越有弹性
				tp_Mass_SPI.value = ptMass = 300  --越重越有弹性  越大越有弹性
			
			)
			on btn_hard pressed do
			(
				tp_Tension_SPI.value = PtTension = 1.5  --越小越有弹性
				tp_Mass_SPI.value=PtMass = 200  --越重越有弹性  越大越有弹性
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
							
						setTension AddSpringPoints PtTension PtInd  --设置弹性
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
			on tp_interval_btn pressed  do
				tp_interval_spn.value=1
			on tp_StartTime_btn pressed  do
				tp_StartTime_spn.value=(animationrange.start/160) as integer
			on tp_endtime_btn pressed  do
				tp_EndTime_spn.value=(animationrange.end/160) as integer
		)
		--
		--
		--
rollout tp_boneTools "BONE工具" width:147 height:298
(
	button tp_FreezeExceptBone_btn "冻结其他" pos:[5,9] width:65 height:20
	button tp_addRLayer_btn "Add Rotation layer" pos:[21,50] width:105 height:20
	button tp_addPLayer_btn "Add Potation layer" pos:[21,73] width:105 height:20
	GroupBox tp_grp1 "Add Bone Layer" pos:[6,33] width:135 height:66
	button tp_HideExceptBone_btn "隐藏其他" pos:[73,9] width:66 height:20
	
	button tp_keyPose_btn "首尾帧相接" pos:[79,102] width:63 height:20
	
	button tp_Kstart_btn "K首帧" pos:[5,102] width:35 height:20
	button tp_Kend_btn "K尾帧" pos:[42,102] width:35 height:20
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
				)catch(messagebox "添加新控制器错误，请检查骨骼是否归零。-Zero Euler XYZ" Title:"添加失败")
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
				)catch(messagebox "添加新控制器错误，请检查骨骼是否归零。-Keyframe XYZ" Title:"添加失败")
		
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
				messagebox "添加新控制器错误，请检查骨骼是否归零。-Zero Euler XYZ / -Keyframe XYZ" Title:"添加失败"
				exit				
			)--if end
		)catch(messagebox "未知错误" Title:"失败")
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
		rollout tp_rangeTools "时间轴工具" width:147 height:298
		(
			global tp_RangeStartData=animationrange.start
			global tp_RangeEndData=animationrange.end
			global tp_rangeDataText="RangeData: "+tp_RangeStartData as string+"--"+tp_RangeEndData as string

			
			
			spinner tp_startTime_btn "start time:" pos:[18,11] width:112 height:16 range:[-99999,99999,0] type:#integer scale:0 
 
 
 
 
			spinner tp_endTime_btn "end time :" pos:[17,32] width:114 height:16 range:[-99999,99999,100] type:#integer scale:1 
 
 
 
 
			
			
			button tp_anirangeA_btn "×3" pos:[8,59] width:20 height:20
			button tp_anirangeB_btn "÷3" pos:[30,59] width:20 height:20
	
			
			button tp_anirangeC_btn "×2" pos:[97,59] width:20 height:20
			button tp_anirangeD_btn "÷2" pos:[119,59] width:20 height:20
			
			
			button tp_saveRange_btn "save range" pos:[8,82] width:63 height:20 
 
 
 
 
			button tp_loadRange_btn "load range" pos:[75,82] width:63 height:20 
 
 
 
 
			label tp_rangeData_lab "--" pos:[10,108] width:123 height:18 
 
 
 
			
			
			
			
			
			
			
			button tp_AsInteger_btn "取整" pos:[52,59] width:43 height:20
			button tp_delKeysTime_btn "三段循环保留一段" pos:[10,129] width:122 height:22
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
				undo "annimationrange end ×3" on
				(
					tp_aniend=animationrange.end*3 as integer
					animationrange = (interval 0f tp_aniend)
				)
			)--on btn pressed do
			on tp_anirangeB_btn pressed do
			(
				undo "annimationrange end ÷3" on
				(
					tp_aniend=animationrange.end/3 as integer
					animationrange = (interval 0f tp_aniend)
				)
			)--on btn pressed do
			on tp_anirangeC_btn pressed do
			(
				undo "annimationrange end ×2" on
				(
					tp_aniend=animationrange.end*2 as integer
					animationrange = (interval 0f tp_aniend)
				)
			)--on btn pressed do
			on tp_anirangeD_btn pressed do
			(
				undo "annimationrange end ÷2" on
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
			on tp_delKeysTime_btn pressed  do
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

----------------主程序--------
	
		----RolloutFloater-----
		
		if Pw_tools!=undefined then 
		(
			if Pw_tools.open==true then 
			(	
				closeRolloutFloater Pw_tools 
			)
			else 
			(
				Pw_tools=newrolloutfloater "easy springtool" 160 600 10 90
				addrollout Spring_tools Pw_tools
				addrollout tp_boneTools Pw_tools
				addrollout tp_rangeTools Pw_tools
				
					
			)
		)
		else
		(
			Pw_tools=newrolloutfloater "cgjoy springtool" 160 600 10 90
			addrollout Spring_tools Pw_tools
			addrollout tp_boneTools Pw_tools
			addrollout tp_rangeTools Pw_tools
			
		)
	)--on execute do

)
