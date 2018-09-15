macroScript NArtShowNoEnvelopes
Category:"_NArtTools" 
ButtonText:"£¨skin£©Òþ²ØEnvelopes"
Tooltip:"£¨skin£©Òþ²ØEnvelopes" 
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
