struct NArtBip(
	
	--����Ƿ�ѡ��bip
	fn CheckSelectBip =
	(
		_result = true
		if selection.count > 0 then(
			for i in selection do	(
				if classof i != biped_object do(
					_result = false
					exit
				)
			)
		)else(
			_result = false
		)
		
		return _result
	),
	
	--��ȡbip bendLinkģʽ�Ƿ��
	fn CheckBipBendLinksMode =
	(
		for i in geometry do
		(
			if classof i==biped_object do	
			(
				tp_biproot = (Biped.GetNode i #turn)
				tp_biprootcontroller = tp_biproot.controller
				_result = tp_biprootcontroller.bendLinksMode
				return _result
			)
		)
	),
	
	--��ȡbip Trajectories ģʽ�Ƿ��
	fn CheckBipDisplayTrajectories =
	(
		for i in geometry do
		(
			if classof i==biped_object do	
			(
				tp_biproot = (Biped.GetNode i #turn)
				tp_biprootcontroller = tp_biproot.controller
				_result = tp_biprootcontroller.DisplayTrajectories
				return _result
			)
		)
	)
)