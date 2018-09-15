struct NArtBip(
	
	--检查是否选中bip
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
	
	--获取bip bendLink模式是否打开
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
	
	--获取bip Trajectories 模式是否打开
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