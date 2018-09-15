macroscript TP_Bip_Bendlinksmode
	category:"²èºøÎ´ÍêÉÆ¹¤¾ß"
	buttontext:"TP BIP Bendlinks Mode"
	tooltip:"TP BIP Bendlinks Mode"
(
	global tp_biproot
	global tp_biprootcontroller
	global tp_bipBend
	fn tp_getBend =
	(
		for i in geometry do
		(
			if classof i==biped_object do	
			(
				tp_biproot=(Biped.GetNode i #turn)
				tp_biprootcontroller=tp_biproot.controller
				tp_bipBend=tp_biprootcontroller.bendLinksMode
				return tp_bipBend
			)
		)
	)
	fn tp_BendDisEnabled =
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
	on isEnabled return (tp_BendDisEnabled())
	on isVisible return (tp_BendDisEnabled())
	on isChecked return (tp_getBend())
	on execute do
	(	
		for i in geometry do
		(
			if classof i==biped_object do	
			(
				tp_biproot=(Biped.GetNode i #turn)
				tp_biprootcontroller=tp_biproot.controller
				tp_bipBend=tp_biprootcontroller.bendLinksMode
			)
		)
		if tp_bipBend==true then tp_biprootcontroller.bendLinksMode=false else tp_biprootcontroller.bendLinksMode=true
	)

)