struct NArtRect(
	atlasID = 0,
	x = 0,
	y = 0,
	width = 1,
	height = 1
)

struct NArtPackObject(
	m_geos = #(),
	m_oldMap = undefined,
	m_targetRect = undefined
)

struct AtlasMap(
	m_map = undefined,
	m_material = undefined,
	m_width,
	m_height,
	m_usedRects = #(),
	m_freeRects = #()
)

struct TexturePackerData(
	m_geoCount = 0,     		--模型总数
	m_textureCount = 0, 		--贴图总数
	m_wrongGeoCount = 0,		--错误未计算模型数
	m_atlasCount = 0   		--合并后图集数
)

struct NArtTexturePacker(
	m_sourceGeometrys = #(),
	m_packObjects = #(),
	m_freeRects = #(),
	m_wrongObjects = #(),
	m_atlasMaps = #(),
	
	m_tempSplitRect = #(),
	
	--按贴图宽度排列模型贴图
	fn QsortPackObjects =(
		fn SortPackObjects v1 v2=(
			_w1 = v1.m_oldMap.width
			_w2 = v2.m_oldMap.width
			local d = _w2 - _w1

			if d == 0 do(
				_w1 = v1.m_oldMap.height
				_w2 = v2.m_oldMap.height
				d = _w2 - _w1
			)
			case of
			(
				(d < 0.): -1
				(d > 0.): 1
				default: 0
			)
		)
		qsort m_packObjects SortPackObjects
	),
	
	--按面积排列所有空余空间
	fn QsortFreeRects =(
		
		fn SortFreeRects v1 v2=(
			_w1 = v1.width * v1.height
			_w2 = v2.width * v2.height
			
			local d = _w2 - _w1
			
			if d == 0 do(
				_w1 = v1.y
				_w2 = v2.y
				d = _w2 - _w1
			)
			
			if d == 0 do(
				_w1 = v1.x
				_w2 = v2.x
				d = _w2 - _w1
			)
			case of
			(
				(d > 0.): -1
				(d < 0.): 1
				default: 0
			)
		)
		
		qsort m_freeRects SortFreeRects
	),
	
	--检查UV
	fn CheckUV _geo=(
		uvNum = polyop.getNumMapVerts _geo 1
		for v=1 to uvNum do(
			_vert =  polyop.getMapVert _geo 1 v
			if _vert.x < 0 or _vert.x > 1 or _vert.y < 0 or _vert.y > 1 do(
				return false
			)
		) 
		return true
	),
	
	--根据指定空间写入贴图信息
	fn WritePicture _rect _sourceMap _targetMap=(
	
		_x = _sourceMap.width
		_y = _sourceMap.height
		
		for y=0 to _y do(
			_colors = getPixels _sourceMap [0,y] _x
			setPixels _targetMap [_rect.x, (_rect.y + y)] _colors
		)
		return _targetMap
	),
	
	--分割空间
	fn PartitionRect rect map =(
		_result = #()
		
		atlasID = rect.atlasID
		 
		_w = map.width
		_h = map.height
		
		_rX = rect.x
		_rY = rect.y
		_rW = rect.width
		_rH = rect.height
		
		
		_nX = _rX
		_nY = _rY
		_nW = _w
		_nH = _h
		_rect1 = NArtRect atlasID _nX _nY _nW _nH
		
		_nX = _rX + _w
		_nY = _rY
		_nW = _rW - _w
		_nH = _h

		_rect2 = NArtRect atlasID _nX _nY _nW _nH
		
		_nX = _rX
		_nY = _rY + _h
		_nW = _w
		_nH = _rH - _h
		
		_rect3 = NArtRect atlasID _nX _nY _nW _nH
		
		_nX = _rX + _w
		_nY = _rY + _h
		_nW = _rW - _w
		_nH = _rH - _h
		
		_rect4 = NArtRect atlasID _nX _nY _nW _nH
		
		_result = #(_rect1, _rect2, _rect3, _rect4)
		return _result
	),
	
	--插入到目标空间
	fn InsertToTargetRect _packObject _freeRectsIndex=(
		_currentRect =  m_freeRects[_freeRectsIndex] --用到的当前空间
		m_tempSplitRect = NArtTexturePacker.PartitionRect m_freeRects[_freeRectsIndex] _packObject.m_oldMap
		_tempUsedRect = m_tempSplitRect[1] --用到的区域
		_packObject.m_targetRect = _tempUsedRect 
		_atlasID = _tempUsedRect.atlasID 
		_targetAtlasMap = m_atlasMaps[_atlasID]
		append _targetAtlasMap.m_usedRects _tempUsedRect
		deleteItem m_tempSplitRect 1
		_delIndex = findItem _targetAtlasMap.m_freeRects _currentRect
		deleteItem _targetAtlasMap.m_freeRects _delIndex
		deleteItem m_freeRects _freeRectsIndex
		for i in m_tempSplitRect do(
			if i.width!=0 and i.height!=0 do(
				append _targetAtlasMap.m_freeRects i
				append m_freeRects i
			)
		)
		
		return _packObject
	),
	
	
	--创建一个新图集数据
	fn CreateAtlasMap atlasSize=(
		_newID = m_atlasMaps.count + 1
		_newRect = NArtRect _newID 0 0 atlasSize atlasSize
		_newAtlasMap = AtlasMap m_width:atlasSize m_height:atlasSize m_usedRects:#() m_freeRects:#()
		_newAtlasMap.m_freeRects = #(_newRect)
		append m_freeRects _newRect
		append m_atlasMaps _newAtlasMap
	),
	
	
	--计算空间
	fn PackRect packObject atlasSize=(
		m_tempSplitRect = #()
		_sourceMap = packObject.m_oldMap
		_loop = false
		do(
			_loop = true
			for i=1 to m_freeRects.count do(
				--完美插入
				if m_freeRects[i].width == _sourceMap.width and m_freeRects[i].height == _sourceMap.height do(
					_loop = false
					packObject = InsertToTargetRect packObject i
					exit
				)
			)
			
			if _loop then(
				for i=1 to m_freeRects.count do(
					if m_freeRects[i].width >= _sourceMap.width and m_freeRects[i].height >= _sourceMap.height do(
						_loop = false
						packObject = InsertToTargetRect packObject i
						exit
					)
				)
			)
			
			if _loop do CreateAtlasMap atlasSize

		)while _loop
		
		return undefined
	), 

	--收集打图集模型和数据
	fn CollectGeoMap _geometrys =(
		m_packObjects = #()
		m_wrongObjects = #()
		for i in _geometrys do(
			uvTest = CheckUV i
			if uvTest then(
				try(
					_map = i.material.diffusemap.bitmap
					_old = false
					for po in m_packObjects do(
						if _map.filename==po.m_oldMap.filename do(
							append po.m_geos i
							_old = true
						)
					)
					
					if not _old do(
						_geoMap = NArtPackObject m_geos:#(i) m_oldMap:_map
						append m_packObjects _geoMap
					)
					i.wirecolor = color 0 0 0
				)catch(
					append m_wrongObjects i
					i.wirecolor = color 138 8 110
				)
			)else(
				append m_wrongObjects i
				i.wirecolor = color 138 8 110
			)
		)
		
		for i in m_packObjects do print i
			print m_packObjects.count
			print "————————错误模型——————————"
		for i in m_wrongObjects do print i	
	),
	
	--收集Rect和UV信息
	fn CollectRectAndUV atlasSize=(
		m_atlasMaps = #()
		m_freeRects = #()
		CreateAtlasMap atlasSize
		for i in m_packObjects do(
			_sourceMap = i.m_oldMap
			if _sourceMap.width > atlasSize or _sourceMap.height > atlasSize then(
				for geo in i.m_geos do(
					append m_wrongObjects geo
					geo.wirecolor = color 138 8 110
				)
			)else(
				i = PackRect i atlasSize
				QsortFreeRects()
				if i==undefined do
					append m_wrongObjects i
			)
		)
	),
	
	--创建图集图片
	fn CreateAtlasMapFile _mapPath _fileName=(
		
		for i=1 to m_atlasMaps.count do(

			_tempFileName = _fileName + "_" + (i as string) + ".tga"
			_fullPath = _mapPath + _tempFileName
			_w = m_atlasMaps[i].m_width
			_h = m_atlasMaps[i].m_height
			_newMap = bitmap _w _h
			_newMap.filename = _fullPath
			m_atlasMaps[i].m_map = _newMap
			save _newMap
		)
	),
	
	--写入图片信息到图集文件
	fn WriteMapToAtlasMap =(
		for i in m_packObjects do(
			_rect = i.m_targetRect
			_sourceMap = i.m_oldMap
			_atlasID = _rect.atlasID
			_targetMap = m_atlasMaps[_atlasID].m_map
			_targetMap = WritePicture _rect _sourceMap _targetMap
			save _targetMap
		)
	),

	--根据atlas贴图生成新材质球
	fn CreateMaterialsForAtlasMap =(
		for i in m_atlasMaps do(
			_newMat = Standard()
			_newMat.diffusemap = BitmapTexture()
			_newMat.diffusemap.bitmap = i.m_map
			_newMat.showInViewport = true
			i.m_material = _newMat
		)
	),
	
	--Rect值转UV缩放值
	fn RectToUV _uv _rect atlasSize=(
		
		_x = (_uv.x * (_rect.width/atlasSize as float)) + (_rect.x/atlasSize as float)
		_y = (_uv.y * (_rect.height/atlasSize as float)) + (1 - (_rect.y/atlasSize as float)) - (_rect.height/atlasSize as float)

		_z = _uv.z
		_result = [_x, _y, _uv.z]
		return _result
	),
	
	
	--修改模型UV，并指认新贴图
	fn TransUV atlasSize =(
		CreateMaterialsForAtlasMap()
		for i in m_packObjects do(
			for _geo in i.m_geos do(
				print "计算UV:"
				print _geo
				converttopoly _geo
				--设置新UV
				uvNum = polyop.getNumMapVerts _geo 1
				for v=1 to uvNum do(
					_vert =  polyop.getMapVert _geo 1 v
					_newVert = RectToUV _vert i.m_targetRect atlasSize
					polyop.setMapVert _geo 1 v _newVert
				)
				
				--附上新材质球
				_ID = i.m_targetRect.atlasID
				_geo.material = m_atlasMaps[_ID].m_material

				addmodifier _geo (Unwrap_UVW())
				converttopoly _geo			
			)
		)
	),
	
	--检查重复的使用区域
	fn CheckSameRect =(
		_sameRectPicture = #()
		for i in m_packObjects do(
			for a in m_packObjects do(
				if i.m_targetRect.x == a.m_targetRect.x and i.m_targetRect.y == a.m_targetRect.y and i.m_targetRect.atlasID == a.m_targetRect.atlasID and i.m_oldMap != a.m_oldMap do(
					print "SameRect!!!!!!!!!!!!!!!!!"
					print i
					print a
					print "-------------------------"
				)
			)
		)
	),
	
	--获取HasAlpha
	fn HasAlpha _bitmap =(
		_xMax = _bitmap.width
		_yMax = _bitmap.height
		for y=0 to _yMax do(
			_colors = getPixels _bitmap [0,y] _xMax
			for i in _colors do(
				if i.a < 0.9999 do return true
			)
		)
		return false
	),
	
	--筛选alpha贴图物体
	fn ScreenAlpha _alpha =(
		_result = #()
		for i in m_sourceGeometrys do(
-- 			try(
				_bitmap = i.material.diffusemap.bitmap
				_type = getFilenameType _bitmap.filename
				if _type == ".dds" then
					_hasAlpha = HasAlpha _bitmap
				else
					_hasAlpha = _bitmap.hasAlpha

				if _hasAlpha == _alpha do(
					append _result i
				)
-- 			)catch(
-- 				print "_alpha wrong!"
-- 			)
		)
		return _result
	),	
	
	--计算数据
	fn CalculateTexturePackerData atlasSize=(
		CollectGeoMap m_sourceGeometrys
		QsortPackObjects()
		CollectRectAndUV atlasSize
		m_data = TexturePackerData()
		m_data.m_geoCount = m_sourceGeometrys.count
		m_data.m_textureCount = m_packObjects.count
		m_data.m_wrongGeoCount = m_wrongObjects.count	
		m_data.m_atlasCount = m_atlasMaps.count
		return m_data
	),
	
	
	----打图集总方法main
	fn PackTexturesMain atlasSize texturePath texutreName=(
		if m_atlasMaps.count == 0 do(
			CalculateTexturePackerData atlasSize
		)
		try(
			_path = maxfilepath +  texturePath + "\\"
			_fileName = texutreName
			makeDir _path
		)catch(
			_path = @"D:\NArtTempAtlas\"
			_fileName = "NArtPackTexture"
		)
		CheckSameRect()
		CreateAtlasMapFile _path _fileName
		WriteMapToAtlasMap()
		TransUV atlasSize
	)
	

)