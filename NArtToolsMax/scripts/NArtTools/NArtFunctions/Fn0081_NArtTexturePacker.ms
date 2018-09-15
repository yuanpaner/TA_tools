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
	m_geoCount = 0,     		--ģ������
	m_textureCount = 0, 		--��ͼ����
	m_wrongGeoCount = 0,		--����δ����ģ����
	m_atlasCount = 0   		--�ϲ���ͼ����
)

struct NArtTexturePacker(
	m_sourceGeometrys = #(),
	m_packObjects = #(),
	m_freeRects = #(),
	m_wrongObjects = #(),
	m_atlasMaps = #(),
	
	m_tempSplitRect = #(),
	
	--����ͼ��������ģ����ͼ
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
	
	--������������п���ռ�
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
	
	--���UV
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
	
	--����ָ���ռ�д����ͼ��Ϣ
	fn WritePicture _rect _sourceMap _targetMap=(
	
		_x = _sourceMap.width
		_y = _sourceMap.height
		
		for y=0 to _y do(
			_colors = getPixels _sourceMap [0,y] _x
			setPixels _targetMap [_rect.x, (_rect.y + y)] _colors
		)
		return _targetMap
	),
	
	--�ָ�ռ�
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
	
	--���뵽Ŀ��ռ�
	fn InsertToTargetRect _packObject _freeRectsIndex=(
		_currentRect =  m_freeRects[_freeRectsIndex] --�õ��ĵ�ǰ�ռ�
		m_tempSplitRect = NArtTexturePacker.PartitionRect m_freeRects[_freeRectsIndex] _packObject.m_oldMap
		_tempUsedRect = m_tempSplitRect[1] --�õ�������
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
	
	
	--����һ����ͼ������
	fn CreateAtlasMap atlasSize=(
		_newID = m_atlasMaps.count + 1
		_newRect = NArtRect _newID 0 0 atlasSize atlasSize
		_newAtlasMap = AtlasMap m_width:atlasSize m_height:atlasSize m_usedRects:#() m_freeRects:#()
		_newAtlasMap.m_freeRects = #(_newRect)
		append m_freeRects _newRect
		append m_atlasMaps _newAtlasMap
	),
	
	
	--����ռ�
	fn PackRect packObject atlasSize=(
		m_tempSplitRect = #()
		_sourceMap = packObject.m_oldMap
		_loop = false
		do(
			_loop = true
			for i=1 to m_freeRects.count do(
				--��������
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

	--�ռ���ͼ��ģ�ͺ�����
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
			print "��������������������ģ�͡�������������������"
		for i in m_wrongObjects do print i	
	),
	
	--�ռ�Rect��UV��Ϣ
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
	
	--����ͼ��ͼƬ
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
	
	--д��ͼƬ��Ϣ��ͼ���ļ�
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

	--����atlas��ͼ�����²�����
	fn CreateMaterialsForAtlasMap =(
		for i in m_atlasMaps do(
			_newMat = Standard()
			_newMat.diffusemap = BitmapTexture()
			_newMat.diffusemap.bitmap = i.m_map
			_newMat.showInViewport = true
			i.m_material = _newMat
		)
	),
	
	--RectֵתUV����ֵ
	fn RectToUV _uv _rect atlasSize=(
		
		_x = (_uv.x * (_rect.width/atlasSize as float)) + (_rect.x/atlasSize as float)
		_y = (_uv.y * (_rect.height/atlasSize as float)) + (1 - (_rect.y/atlasSize as float)) - (_rect.height/atlasSize as float)

		_z = _uv.z
		_result = [_x, _y, _uv.z]
		return _result
	),
	
	
	--�޸�ģ��UV����ָ������ͼ
	fn TransUV atlasSize =(
		CreateMaterialsForAtlasMap()
		for i in m_packObjects do(
			for _geo in i.m_geos do(
				print "����UV:"
				print _geo
				converttopoly _geo
				--������UV
				uvNum = polyop.getNumMapVerts _geo 1
				for v=1 to uvNum do(
					_vert =  polyop.getMapVert _geo 1 v
					_newVert = RectToUV _vert i.m_targetRect atlasSize
					polyop.setMapVert _geo 1 v _newVert
				)
				
				--�����²�����
				_ID = i.m_targetRect.atlasID
				_geo.material = m_atlasMaps[_ID].m_material

				addmodifier _geo (Unwrap_UVW())
				converttopoly _geo			
			)
		)
	),
	
	--����ظ���ʹ������
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
	
	--��ȡHasAlpha
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
	
	--ɸѡalpha��ͼ����
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
	
	--��������
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
	
	
	----��ͼ���ܷ���main
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