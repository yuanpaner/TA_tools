macroscript TP_restanirange
category:"²èºøÎ´ÍêÉÆ¹¤¾ß"
buttontext:"TP reast animation range"
tooltip:"TP reast animation range"
(
	try
	(
		TP_Obj=for i in Objects where classof i!=Biped_Object and classof i.controller!=BipSlave_Control collect i
		TP_bipObj=for i in objects where classof i==Biped_Object collect i
		TP_allKeys=#()
		TP_allbipkeys=#()
		TP_bipkeys=#()
		for i in TP_obj do
		(
			try(
				TP_poskeys		=i.pos.controller.keys
				TP_rotationkeys	=i.rotation.controller.keys
				TP_scalekeys	=i.scale.controller.keys
				TP_allkeys+=TP_poskeys+TP_rotationkeys+TP_scalekeys
				)catch()
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
		TP_bipallTime=for i in TP_allbipkeys collect i.time
		TP_allObjTime=for i in TP_allKeys collect i.time
		TP_allTime=TP_bipallTime+TP_allObjTime
		TP_minTime=amin TP_allTime
		TP_maxTime=amax TP_allTime
		animationrange=(interval TP_minTime TP_maxTime)
	)
	catch()
)