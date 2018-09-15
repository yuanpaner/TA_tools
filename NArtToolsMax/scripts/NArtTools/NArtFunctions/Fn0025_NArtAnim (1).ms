struct NArtAnim(
	
	--根据动画范围重置时间轴范围
	fn ResetAniRange =(
		TP_Obj=for i in Objects where classof i!=Biped_Object and classof i.controller!=BipSlave_Control collect i
		TP_bipObj=for i in objects where classof i==Biped_Object collect i
		TP_allKeys=#()
		TP_allbipkeys=#()
		TP_bipkeys=#()
		for i in TP_obj do
		(

			TP_poskeys		=i.pos.controller.keys
			TP_rotationkeys	=i.rotation.controller.keys
			TP_scalekeys	=i.scale.controller.keys
			
			for i in TP_poskeys do(
				append TP_allkeys i
			)
			
			for i in TP_rotationkeys do(
				append TP_allkeys i
			)
			
			for i in TP_scalekeys do(
				append TP_allkeys i
			)
			
			-- TP_allkeys += TP_poskeys + TP_rotationkeys + TP_scalekeys

		)
		for i in TP_bipObj do
		(
			if classof i.controller==Vertical_Horizontal_Turn then
			(
				TP_bipVerticalkeys		=i.controller.vertical.controller.keys
				TP_biphorizontalkeys	=i.controller.horizontal.controller.keys
				TP_bipturningkeys		=i.controller.turning.controller.keys
				for a in TP_bipVerticalkeys do append TP_allbipkeys a
				for a in TP_biphorizontalkeys do append TP_allbipkeys a
				for a in TP_bipturningkeys do append TP_allbipkeys a
			)
			else
			(
				TP_bipkeys=i.controller.keys
				for a in TP_bipkeys do append TP_allbipkeys a
			)
		)
		
		TP_bipallTime = for i in TP_allbipkeys collect i.time
		TP_allObjTime = for i in TP_allKeys collect i.time
			
		TP_allTime = TP_bipallTime + TP_allObjTime
		
		TP_minTime = amin TP_allTime
		TP_maxTime = amax TP_allTime
		
		if TP_minTime == undefined or TP_maxTime == undefined then(
			TP_minTime = 0f
			TP_maxTime = 5f
		)
		
		animationrange = interval TP_minTime TP_maxTime
		
		_log = "NArtLog: animationrange [" + (TP_minTime as string) + ", " + (TP_maxTime as string) + "]"
		print _log

	),
	-- return the KeyTime of obj
	-- 2015/5/26 by panyuan @pwd
	fn storeKeyTime obj &timeArr = 
	(	
	timeRc = #()
	if (numkeys obj.pos.controller)!=0 then
	(
		for i=1 to numkeys obj.pos.controller do
		(
			format "pos:%\n" (getKeyTime obj.pos.controller i)
			append timeRc (getKeyTime obj.pos.controller i)
			)
		)
	if (numkeys obj.rotation.controller)!=0 then
	(
		for i=1 to numkeys obj.rotation.controller do
		(
			format "rot:%\n" (getKeyTime obj.rotation.controller i)
			append timeRc (getKeyTime obj.rotation.controller i)
			)
		)
	if (numkeys obj.scale.controller)!=0 then
	(
		for i=1 to numkeys obj.scale.controller do
		(
			format "scale:%\n" (getKeyTime obj.scale.controller i)
			append timeRc (getKeyTime obj.scale.controller i)
			)
		)
	timeArr = sort (makeUniqueArray  timeRc)
	)
)