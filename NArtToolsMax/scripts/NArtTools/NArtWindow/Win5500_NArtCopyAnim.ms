print "NArt工具：复制动画"

undo on 
(
	if copyAnim == undefined then
	(
		rollout copyAnim "复制动画" width:376 height:297
			(
				fn ctrl_filt obj = (numkeys obj.pos.controller)!=0 or (numkeys obj.rotation.controller)!=0 or (numkeys obj.scale.controller)!=0

				pickButton btnSrc "选取源物体" pos:[216,24] width:80 height:24 --filter:ctrl_filt --filter function has sth wrong with Bip,will occur error to collapse
				pickButton btnDes "选取目标物体" pos:[216,64] width:80 height:24
				editText edtScr "" pos:[40,24] width:152 height:24 enabled:false
				editText edtDes "" pos:[40,64] width:152 height:24 enabled:false
				button btnCopy "开始拷贝" pos:[216,194] width:80 height:32
				editText edt_startK "" pos:[110,192] width:40 height:16
				editText edt_endK "" pos:[110,217] width:40 height:16
				label lbl2 "起始帧" pos:[54,191] width:48 height:24
				label lbl3 "结束帧" pos:[54,217] width:48 height:24
				groupBox grp2 "是否设置时间段" pos:[40,115] width:168 height:147
				checkbox chk_all "完全拷贝（满帧）" pos:[56,168] width:128 height:16
				checkbox chk_time "设置时间段" pos:[56,147] width:96 height:16
				checkbox chk_offset "保留位置偏移" pos:[216,115] width:96 height:16
				checkbox chk_scale "是否保留原缩放参数" pos:[216,140] width:182 height:16
				
				on btnSrc picked obj do
				(
					if obj !=undefined then
					(
			-- 			edtScr.enabled = true
						edtScr.text = obj.name
						)
					if (classof obj == Biped_Object) then 
					(
						chk_all.state = true	
						chk_all.enabled = false
						
						chk_offset.state = false
						chk_offset.enabled = false
						
						chk_scale.state=true
						)
						
					)
				on btnDes picked obj do
				(
					if obj !=undefined do
					(
			-- 			edtDes.enabled = true
						edtDes.text = obj.name
						)
						
					)
				on btnCopy pressed  do
				(
					strK=0
					endK=100
					
					 
					tR_ori = #()
					tR_flt=#()
					srcGo = getnodebyname edtScr.text
					desGo = getnodebyname edtDes.text
					print (classof srcGo)
					print (classof desGo)
					print chk_scale.state
					if chk_scale.state==true do 
					(
						oriScale = copy desGo.scale
						oriScaleController = copy desGo.scale.controller
						--print ("oriScale:\t"+ oriScale)
						--print ("oriScaleCtonroller:\t"+ oriScaleController)
					)
					
					if(classof desGo == Biped_Object) then
					(
						messagebox "选择的是bip骨骼，无法执行此操作"
					)
					else if(classof srcGo == Biped_Object) then
					(
						tr_ori = srcGo.controller.keys
						tr_ori = for i in tr_ori collect i.time
						strK = tR_ori[1]
						endK = tR_ori[tR_ori.count]
						if chk_time.state then
						(
							if  (edt_startK.text as float)==undefined or (edt_endK.text as float)==undefined then messagebox "请输入正确的起始结束帧数"
							else
								(
								if ((edt_startK.text as float)>=(edt_endK.text as float)) then messagebox "请输入正确顺序的起始结束帧数"
								else 
								(
									strK = int(edt_startK.text as float)
									endK = int(edt_endK.text as float)
									tR_flt = for i in tR_ori where (i>=strK and i<=endK) collect i
								)				
							)
						)
						else tr_flt = tr_ori
						
						with animate on 
						(
							if tR_flt.count>0 then
							(
								for i=strK to endK do
									(
										at time i 
										(
											desGo.transform=srcGo.transform
											)
										)

							)
							else print "no key frames to copy"
								
						)
		
					)
					else
					(
						NArtAnim.storeKeyTime srcGo &tR_ori
						strK = tR_ori[1]
						endK = tR_ori[tR_ori.count]
		-- 				offsetV3 = copy desGo.pos
		-- 				print ((srcGo.pos as point3) - (desGo.pos as point3))
						offs = copy(desGo.pos - srcGo.pos)
						if chk_time.state then
						(
							if  (edt_startK.text as float)==undefined or (edt_endK.text as float)==undefined then messagebox "请输入正确的起始结束帧数"
							else
								(
								if ((edt_startK.text as float)>=(edt_endK.text as float)) then messagebox "请输入正确顺序的起始结束帧数"
								else 
								(
									strK = int(edt_startK.text as float)
									endK = int(edt_endK.text as float)
									tR_flt = for i in tR_ori where (i>=strK and i<=endK) collect i
				-- 					print "ori"
				-- 					print tr_ori
				-- 					print "filter"
				-- 					print tr_flt
								)				
							)
						)
						else tr_flt = tr_ori

						with animate on 
						(
							k = numkeys srcGo.scale.controller
							if tR_flt.count>0 then
							(
								if not chk_all.state then
									for i=1 to tR_flt.count do
									(
										at time tR_flt[i]
										(						
											if k>0 do desGo.scale=srcGo.scale
											desGo.rotation=srcGo.rotation
											desGo.pos=srcGo.pos
		-- 									if i==1 do offsetV3 -= desGo.pos

										)
									)
								else
								(
									for i=strK to endK do
									(
										at time i 
										(
											if k>0 do desGo.scale=srcGo.scale
											desGo.rotation=srcGo.rotation
											desGo.pos=srcGo.pos		
		-- 									if i==1 do offsetV3 -= desGo.pos
											)
										)
									)
							)
							else print "no key frames to copy"
								
						)
						
						if chk_offset.state do
						(
							with animate off  desGo.pos = desGo.pos + offs						
							)
					)
					
					if chk_scale.state==true do
					(
							print ("start to reset scale data")
							desScaleCtr = desGo.scale.controller
							with animate off
							(
								deleteKeys desScaleCtr #allKeys
-- 									if(desScaleCtr.keys.count>0) do 
-- 									(
-- 										for i =1 to desScaleCtr.keys.count do 
-- 											(
-- 												selectKey desScaleCtr i
-- 												deleteKeys desScaleCtr #selection
-- 												)
-- 											)
								--delete as the same time with selecting, error
								print ("delete all the scale keys")
								if(oriScaleController.keys.count!=0) then desGo.scale.controller = oriScaleController
								else desGo.scale = oriScale
							)

						)
				)--end button
			)--end rollout
			-- destroyDialog copyAnim
			createDialog copyAnim 376 297 20 20
	)
	else 
	(
		if copyAnim.isDisplayed then
		 DestroyDialog copyAnim 
		else Createdialog copyAnim
	)
)	
	