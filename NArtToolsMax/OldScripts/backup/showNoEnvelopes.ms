macroScript showNoEnvelopes
ButtonText:"show No Envelopes"
Category:"�Զ��幤��" 
Tooltip:"show No Envelopes (Skin)" 
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
			try(
			if $.skin.showNoEnvelopes==true then
				(
				$.skin.showNoEnvelopes=false 
				)
				else 
				(
				$.skin.showNoEnvelopes=true
				)
			)catch()
		)
)