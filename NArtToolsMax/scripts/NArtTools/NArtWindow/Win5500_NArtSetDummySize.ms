print "NArtπ§æﬂ£∫…Ë÷√Dummy≥ﬂ¥Á"

rollout tp_DummySize_rol "Dummy Size" width:131 height:37
(
	spinner tp_DummySize_spi "" pos:[29,11] width:76 height:16
	Timer m_timer "Timer" pos:[1,8] width:24 height:24


	local m_targetDummyArray = #()
	
	fn UpdateSelection = (
		m_targetDummyArray = for i in Selection where classof i == Dummy collect i
		if m_targetDummyArray.count != 0 then(
			tp_DummySize_spi.enabled = true
			tp_DummySize_spi.value = m_targetDummyArray[1].boxsize.x
			
		)else(
			
			tp_DummySize_spi.enabled = false
		)
	)
	
	on tp_DummySize_rol open do
	(
		UpdateSelection()
		m_timer.interval = 200
	)
	
	on tp_DummySize_spi changed val do
	(
		for i in m_targetDummyArray do(
			
			i.boxsize = [tp_DummySize_spi.value, tp_DummySize_spi.value, tp_DummySize_spi.value]
			
		)
	)

	on m_timer tick do
	(
		UpdateSelection()		
	)
)
createdialog tp_DummySize_rol 