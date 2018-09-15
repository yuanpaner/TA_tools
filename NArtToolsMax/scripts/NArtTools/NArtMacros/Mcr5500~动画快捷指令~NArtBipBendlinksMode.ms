macroscript NArtBipBendlinksMode
category:"_NArtTools"
buttontext:"Bip Bendlinks ģʽ"
tooltip:"Bip Bendlinks ģʽ"
(
	on isEnabled return (NArtBip.CheckSelectBip())
	on isVisible return (NArtBip.CheckSelectBip())
	on isChecked return (NArtBip.CheckBipBendLinksMode())
	on execute do(	
		local tp_biproot
		local tp_bipBend
		local tp_biprootcontroller
		for i in geometry do(
			if classof i == biped_object do	
			(
				tp_biproot = (Biped.GetNode i #turn)
				tp_biprootcontroller = tp_biproot.controller
				tp_bipBend = tp_biprootcontroller.bendLinksMode
			)
		)
		tp_biprootcontroller.bendLinksMode = not tp_bipBend
		max motion mode
	)

)