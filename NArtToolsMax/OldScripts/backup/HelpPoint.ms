macroScript TP_Help_Point
category:"���δ���ƹ���"
toolTip:"TP Help Point"
(
	tp_pickobject=pickobject()
	tp_NewPoint=Point isSelected:on size:0.2 box:on axistripod:on centermarker:on wirecolor:orange
	try(tp_NewPoint.transform=tp_pickobject.transform)catch()
)