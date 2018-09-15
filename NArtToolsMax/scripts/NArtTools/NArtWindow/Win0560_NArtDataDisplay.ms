--prj：
--panyuan 2015/5/25 @pwd
--display the data of the scene
--场景信息

print "NArt工具：场景信息"

undo on 
	(
			
		global matSta=#()
		global matMuti=#()
		global matSub=#()
		global geoList=#()	
			
		fn data_fn =
		(
			matSta=#()
			matMuti=#()
			matSub=#()
			geoList=#()
			--standardmaterial number
			for m in sceneMaterials do
			 (
				
				if classof m == Standardmaterial then
				(
					append matSta m
					)
				else if classof m == Multimaterial then 
				(
					tmp=#()
					subm=#()
					for idcount = 1 to m.count do
					(
						append subm m[idcount]
						append matSub m[idcount]
						)
					append tmp m
					append tmp m.count
					append tmp subm
					append matMuti tmp
					
				)
				
			 )
			 for m in objects do
			 (
				 if superclassof m == GeometryClass do append geoList m
				 
				)
		)
		
		if dataCheck == undefined then
		(
			rollout dataCheck "数据统计" width:228 height:300
			(
				label lbl2 "模型数：" pos:[24,32] width:51 height:21
				label lbl3 "标准材质球数：" pos:[48,96] width:104 height:21
				groupBox grp1 "材质统计" pos:[24,64] width:182 height:168
				label lbl4 "多维子材质球数：" pos:[48,123] width:112 height:21
				label lbl5 "子材质球数：" pos:[72,152] width:80 height:21
				label staN "111" pos:[146,96] width:48 height:21
				label mutN "111" pos:[146,122] width:48 height:21
				label mutSN "111" pos:[147,152] width:40 height:21
				label lbl6 "重复数：" pos:[72,176] width:80 height:21
				label mutSN_uniq "111" pos:[148,176] width:40 height:21
				label geoN "111" pos:[144,32] width:48 height:21
				button freshB "刷新" pos:[137,255] width:69 height:26
				
				fn freshCap = 
				(
					data_fn()
					staN.caption = matSta.count as string
					mutN.caption = matMuti.count as string
					mutSN.caption = matSub.count as string
					mutSN_uniq.caption = (matSub.count - (makeUniqueArray matSub).count) as string
					geoN.caption = geoList.count as string
					
					)
					
				on freshB pressed  do
				(
					freshCap()
				)
				
				
				on dataCheck open do
				(
					freshCap()
			-- 		callbacks.addScript #nodeCreated "freshCap()" id:#blabla

			-- 		callbackItem = NodeEventCallback mouseUp:true delay:10 all:freshCap
			-- 		registerRedrawViewsCallback freshCap
					)
					
				on dataCheck close do
				(
			-- 		unRegisterRedrawViewsCallback freshCap
					DestroyDialog dataCheck
			-- 		callbacks.removeScripts #nodeCreated id:#blabla
					)
					

			)--end rollout
			Createdialog dataCheck [20,50]
		)
		else 
		(
			if dataCheck.isDisplayed then DestroyDialog dataCheck 
			else Createdialog dataCheck [20,50]
		)
	)	