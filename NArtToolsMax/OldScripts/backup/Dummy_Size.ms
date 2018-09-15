macroscript tp_DummySize
category:"茶壶动作工具"
buttontext:"Dummy Size"
tooltip:"Dummy Size"
(
	rollout tp_DummySize_rol "Dummy Size" width:131 height:41
	(
		spinner tp_DummySize_spi "" pos:[21,11] width:84 height:16
		on tp_DummySize_spi changed val do
		(
			if selection.count==1 then
			(
				if classof $==Dummy then
				(
					$.boxsize=[tp_DummySize_spi.value,tp_DummySize_spi.value,tp_DummySize_spi.value]
				)
			)
		)
	)
	createdialog tp_DummySize_rol 
)