macroscript TP_Del_ParticleView
	category:"²èºøÎ´ÍêÉÆ¹¤¾ß"
	buttontext:"TP Del ParticleView"
	tooltip:"TP Del ParticleView"
(
	tp_ParticleView=#()
	for i in objects do
	(
		if classof i==Particle_View do append tp_ParticleView i
	)
	delete tp_ParticleView	

)

