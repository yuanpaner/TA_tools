macroScript NArtShowNoEnvelopes
Category:"_NArtTools" 
ButtonText:"Show No Envelopes"
Tooltip:"Show No Envelopes (Skin)" 
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (
		try(
			 $.skin.showNoEnvelopes
		)catch(false)
	)
	On Execute do
	(
		try(
			_foo = not selection[1].skin.showNoEnvelopes
			for i in selection do(
				i.skin.showNoEnvelopes = _foo
			)
		)catch()
	)
)
