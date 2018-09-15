macroscript TP_Bip_displayTrajectories
	category:"²èºøÎ´ÍêÉÆ¹¤¾ß"
	buttontext:"TP BIP Trajectories"
	tooltip:"TP BIP Trajectories"
(
	global tp_biproot
	global tp_biprootcontroller
	global tp_bipTra
	fn tp_getrootTra =
	(
		for i in geometry do
		(
			if classof i==biped_object do	
			(
				tp_biproot=(Biped.GetNode i #turn)
				tp_biprootcontroller=tp_biproot.controller
				tp_bipTra=tp_biprootcontroller.displayTrajectories
				return tp_bipTra
			)
		)
	)
	fn tp_TraDisEnabled =
	(
		tp_foo=true
		if selection.count>0 then
		(
			for i in selection do
			(
				if classof i!=biped_object do
				(
					tp_foo=false
					exit
				)
			)
		)
		else tp_foo=false
		return tp_foo
	)
	on isEnabled return (tp_TraDisEnabled())
	on isVisible return (tp_TraDisEnabled())
	on isChecked return (tp_getrootTra())
	on execute do
	(	
		for i in geometry do
		(
			if classof i==biped_object do	
			(
				tp_biproot=(Biped.GetNode i #turn)
				tp_biprootcontroller=tp_biproot.controller
				tp_bipTra=tp_biprootcontroller.displayTrajectories
			)
		)
		if tp_bipTra==true then tp_biprootcontroller.displayTrajectories=false else tp_biprootcontroller.displayTrajectories=true
	)

)