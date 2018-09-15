print "NArt执行：添加多通道VertexPaint修改器"

_obj = for i in selection where classof i == Editable_Poly collect i
	
for i in _obj do(
	_vertexPaintMod = VertexPaint()
	addModifier i _vertexPaintMod
	converttopoly i
	
	_vertexPaintMod_alpha = VertexPaint()
	_vertexPaintMod_alpha.name = "VertexPaint_alpha"
	_vertexPaintMod_alpha.mapChannel = -2
	addModifier i _vertexPaintMod_alpha

	_vertexPaintMod_color = VertexPaint()
	_vertexPaintMod_color.name = "VertexPaint_Color"
	addModifier i _vertexPaintMod_color
	RedrawViews()
	max modify mode
	
)