macroScript NArtTexturePacker
category:"_NArtTools"
toolTip:"Texture Packer"
buttontext:"Texture Packer"
(
	rollout rol_NArtTexturePacker "贴图打图集工具" width:200 height:584
	(
		button btn_DetachByID "按ID detach模型" pos:[10,10] width:180 height:30 toolTip:"会自动删除空点物体"
		button btn_Calculate "计算数据" pos:[10,282] width:180 height:30
		label lbl_DataTitle "统计数据：" pos:[10,317] width:100 height:16
		label lbl_Data "请计算" pos:[15,340] width:170 height:120
		spinner spn_AtlasSize "图集大小" pos:[50,175] width:110 height:16 enabled:true range:[0,99999,0] type:#integer
		edittext edt_TexturePath "贴图路径" pos:[10,227] width:180 height:19 enabled:true
		edittext edt_TextureName "贴图名称" pos:[10,253] width:180 height:19 enabled:true
		button btn_startPack "开始合并" pos:[10,468] width:180 height:35
		button btn_AttachByMat "相同材质的物体合并" pos:[10,514] width:180 height:25 toolTip:"会自动删除空点物体"
		button btn_RenameStandardMat "材质球名改为贴图名" pos:[10,547] width:180 height:25 toolTip:"多维子材质父材质无效"
		button btn_512 "512" pos:[10,201] width:40 height:21			
			
			
			
			
			
		button btn_1024 "1024" pos:[56,201] width:40 height:21
		button btn_2048 "2048" pos:[103,201] width:40 height:21
		button btn_4096 "4096" pos:[151,201] width:40 height:21
		label lbl_tips "对所有物体操作" pos:[10,70] width:180 height:20
		button btn_select "选择模型" pos:[10,94] width:85 height:28
		button btn_all "全部模型" pos:[105,94] width:85 height:28
		Timer tmr1 "Timer" pos:[173,313] width:24 height:24 interval:100
		label lbl_GeoCount "文件内模型个数：0" pos:[10,45] width:180 height:20
		local m_texturePacker = undefined

		dropdownList ddl_Screenlist "筛选" pos:[10,127] width:180 height:41 items:#("不筛选", "有alpha通道", "无alpha通道")
			
			
		on rol_NArtTexturePacker open do
		(
			_texturePath = "Textures"
			_fileName = getfilenamefile maxfilename
			edt_TexturePath.text = _texturePath
			edt_TextureName.text = _fileName
			spn_AtlasSize.value = 1024
			m_texturePacker = NArtTexturePacker()
						
		)
		on btn_DetachByID pressed do
		(
			NArtNode.delEmpty geometry
			allgeo = for i in m_texturePacker.m_sourceGeometrys collect i
			for i in allgeo do
			(
				converttopoly i 
				if classof i.material == Multimaterial do
				(
					NArtGeometry.detachByID i
				)
			)
			
			allgeo = for i in geometry collect i
			NartNode.delEmpty geometry
			m_texturePacker.m_sourceGeometrys = #()
		)
		on btn_Calculate pressed do
		(
					_data = m_texturePacker.CalculateTexturePackerData spn_AtlasSize.value 
					_msg  = "模型:" + (_data.m_geoCount as string) + "\n\n"
					_msg  += "贴图:" + (_data.m_textureCount as string) + "\n\n"
					_msg  += "可计算模型:" + ((_data.m_geoCount - _data.m_wrongGeoCount) as string) + "\n\n"
					_msg  += "错误未计算模型:" + (_data.m_wrongGeoCount as string) + "\n\n"
					_msg += "合并后图集数:" + (_data.m_atlasCount as string) + "\n\n"
					lbl_Data.text = _msg
				)
		on btn_startPack pressed do
		(
			m_texturePacker.PackTexturesMain spn_AtlasSize.value edt_TexturePath.text edt_TextureName.text
		)
		on btn_AttachByMat pressed do
		(
			NArtGeometry.attachByMat geometry
		)
		on btn_RenameStandardMat pressed do
		(
			undo "Rename Materials as Diffusemap Texture" on
			(
				NArtMaterial.RenameStandardMat()
			)
		)
		on btn_512 pressed do
			spn_AtlasSize.value = 512
		on btn_1024 pressed do
			spn_AtlasSize.value = 1024
		on btn_2048 pressed do
			spn_AtlasSize.value = 2048
		on btn_4096 pressed do
			spn_AtlasSize.value = 4096
		on btn_select pressed do
		(
			_selGeos = #()
			for i in selection do(
				if superClassof i == GeometryClass do(
					append _selGeos i
				)
			)
			m_texturePacker.m_sourceGeometrys = _selGeos
		)
		on btn_all pressed do
		(
			m_texturePacker.m_sourceGeometrys = #()
		)
		on tmr1 tick do
		(
			m_texturePacker.m_sourceGeometrys = NArtNode.RemoveDelNodeFromArray m_texturePacker.m_sourceGeometrys
		
			_geoCount = Geometry.count 
			lbl_GeoCount.text = "全部模型数：" + (_geoCount as string)
			_count = m_texturePacker.m_sourceGeometrys.count
			if _count == 0 or _count >= _geoCount or m_new == true do(
				_selGeos = for i in geometry collect i
				m_texturePacker.m_sourceGeometrys = _selGeos
			)
			if _count == _geoCount then(
				lbl_tips.text = "对所有模型合并贴图"
			)else(
				lbl_tips.text = "对" + (_count as string) + "个模型合并贴图"
			)
		)
		on ddl_Screenlist selected sel do
		(
					_value = ddl_Screenlist.selection
					if _value == 2 do(
						m_texturePacker.m_sourceGeometrys = m_texturePacker.ScreenAlpha true
					)
					if _value == 3 do(
						m_texturePacker.m_sourceGeometrys = m_texturePacker.ScreenAlpha false
					)
				)
	)
	on execute do(
		try(DestroyDialog rol_NArtTexturePacker)catch()
		createDialog rol_NArtTexturePacker
	)--execute end

)--macroScript end