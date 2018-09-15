--prj：
--panyuan 2015/5/25 @pwd
--1.copy the animation
--2.keep the offset

macroScript NArtCopyAnim
category:"_NArtTools"
toolTip:"Copy Animation"
buttontext:"Copy Animation"
(
	undo on 
	(
		if copyAnim == undefined then
		(
			rollout copyAnim "复制动画" width:376 height:297
				(
					fn ctrl_filt obj = (numkeys obj.pos.controller)!=0 or (numkeys obj.rotation.controller)!=0 or (numkeys obj.scale.controller)!=0

					pickButton btnSrc "选取源物体" pos:[216,24] width:80 height:24 filter:ctrl_filt
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
					
					on btnSrc picked obj do
					(
						if obj !=undefined then
						(
				-- 			edtScr.enabled = true
							edtScr.text = obj.name
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
						
						if chk_offset.state then
						(
							with animate off  desGo.pos = desGo.pos + offs						
							)
						
					)
				)--end rollout
				-- destroyDialog copyAnim
				createDialog copyAnim
		)
		else 
		(
			if copyAnim.isDisplayed then
			 DestroyDialog copyAnim 
			else Createdialog copyAnim
		)
	)	
	
)