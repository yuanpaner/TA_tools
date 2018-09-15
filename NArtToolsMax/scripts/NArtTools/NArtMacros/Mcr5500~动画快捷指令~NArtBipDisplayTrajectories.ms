macroscript NArtBipDisplayTrajectories
category:"_NArtTools"
buttontext:"Bipœ‘ æTrajectories"
tooltip:"Bipœ‘ æTrajectories"
(
	on isEnabled return (NArtBip.CheckSelectBip())
	on isVisible return (NArtBip.CheckSelectBip())
	on isChecked return (NArtBip.CheckBipDisplayTrajectories())
	on execute do
	(	
		global tp_biproot
		global tp_biprootcontroller
		global tp_bipTra
		for i in geometry do
		(
			if classof i==biped_object do	
			(
				tp_biproot=(Biped.GetNode i #turn)
				tp_biprootcontroller=tp_biproot.controller
				tp_bipTra=tp_biprootcontroller.displayTrajectories
			)
		)
		tp_biprootcontroller.displayTrajectories = not tp_bipTra
		max motion mode
	)

)