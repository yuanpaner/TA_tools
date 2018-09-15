print "NArt工具：烘培工具"

	try(DestroyDialog(BakeTools))catch()
	rollout BakeTools "BakeTools" width:142 height:295
	(

		edittext _lowKey01 "" pos:[69,18] width:60 height:19
		edittext _highKey01 "" pos:[69,39] width:60 height:19
		edittext _lowKey02 "" pos:[69,71] width:60 height:19
		
		pickbutton select_Low01 "LowObj01" pos:[13,18] width:55 height:20
		pickbutton select_high01 "HighObj" pos:[13,40] width:55 height:20
		pickbutton select_low02 "LowObj02" pos:[13,71] width:55 height:20	

		checkbox chk_normal "" pos:[15,107] width:23 height:21		
		checkbox chk_ao "" pos:[15,134] width:23 height:21
		checkbox chk_shadow "" pos:[15,159] width:23 height:21
		checkbox chk_Griantra "" pos:[15,187] width:23 height:21
		checkbox chk_light "" pos:[15,212] width:23 height:21
		
		button btn_normal "normalsMap" pos:[40,106] width:90 height:25
		button btn_AO "AOMap" pos:[40,132] width:90 height:25
		button btn_shadow "shadowMap" pos:[40,158] width:90 height:25
		button btn_light "lightMap" pos:[40,210] width:90 height:25
		button btn_Griantra "GriantraMap" pos:[40,184] width:90 height:25
		button btn_bakeAll "bakeAll" pos:[11,248] width:120 height:35	
		
		local size = 512	
		local	m_nDilations = 4
		local	m_path = maxfilepath+"textures"
		local	m_filename = substituteString maxfilename ".max" ""
		local	m_lowKey01 = "*_low01"
		local	m_lowKey02 ="*_low02"
		local	m_highKey01 ="*_high01"
		local	m_message = "  cann't find target"
			
		fn GetOBj m_name =(
			_obj =undefined
			for  i in objects do(
				if matchPattern i.name pattern: m_name then(
					_obj = i
				)		
			)
			return _obj
		) 

		fn BakeNormal =(
			obj = GetOBJ m_lowKey01
			highObj = GetOBJ m_highKey01
			hideArray = #()
			
			if obj != undefined  then (	
				delete lights
				for i in objects do(
					if i!=obj and i!=highObj then(
						hide i
						append hideArray i
					)
					else unhide i
				)
				
				obj.autoSmoothThreshold  = 1
				polyOp.setFaceSmoothGroup obj #{1..obj.numfaces} 1
				
				if obj.modifiers[#projection] == undefined then(
		-- 			if obj.Modifiers[#push] == undefined then(
		-- 				m_push = push() 
		-- 				addModifier obj m_push
		-- 				m_push.Push_Value = 2
		-- 			)
					m_projection = projection()
					addModifier obj m_projection			
					m_projection.pushCage 2
					obj.modifiers[#projection].addObjectNode highObj			
				)
				
				renderers.production = Default_Scanline_Renderer ()
				obj.INodeBakeProperties.removeAllBakeElements() 	
				m_bake = normalsMap() 
				m_bake.outputSzX = m_bake.outputSzY = size 
				makeDir m_path all:true
				m_bake.fileType = (m_path + "/" + m_filename + "_normalsMap.tga")
				m_bake.fileName = filenameFromPath m_bake.fileType
				m_bake.filterOn = true 
				m_bake.enabled = true 
				m_bake.backgroundColor =color 255 255 255 100
				obj.INodeBakeProperties.addBakeElement m_bake 
				obj.INodeBakeProperties.bakeEnabled = true 
				obj.INodeBakeProperties.bakeChannel = 1 
				obj.INodeBakeProperties.nDilations  = 4 
				obj.INodeBakeProjProperties.enabled = true 
				m_projection = obj.Modifiers[#projection]
				obj.INodeBakeProjProperties.projectionMod = m_projection
				select obj 
				render rendertype:#bakeSelected vfb:on progressBar:true outputSize:[size,size]
				unhide hideArray
			)else(
				m_tellyou = "BakeNormalmap"+m_message
				messagebox m_tellyou
			)
		)
		
		fn bakeShadow =(
			obj = GetOBj m_lowKey02
			hideArray = #()	
			print obj
			if obj != undefined  then (	
				delete lights
				for i in objects do(
					if i !=obj then(
						hide i
						append hideArray i
					)
					else unhide i
				)
				theLight = skylight pos:[100,100,0] rgb:white 	 
				theLight.Cast_Shadows = on
				backgroundcolor = color 150 150 150
				ambientColor = color 150 150 150
				obj.material = standard diffuseMap: undefined
				showTextureMap  obj.material on
				renderers.production = Default_Scanline_Renderer ()
				obj.INodeBakeProperties.removeAllBakeElements() 		
				m_bake = CompleteMap() 
				m_bake.outputSzX = m_bake.outputSzY = size 

				makeDir m_path all:true
				m_bake.fileType = (m_path + "/" + m_filename + "_shadersMap.tga")
				m_bake.fileName = filenameFromPath m_bake.fileType
				m_bake.filterOn = true 
				m_bake.enabled = true 
				m_bake.backgroundColor =color 255 255 255 100
				obj.INodeBakeProperties.addBakeElement m_bake 
				obj.INodeBakeProperties.bakeEnabled = true 
				obj.INodeBakeProperties.bakeChannel = 1 
				obj.INodeBakeProperties.nDilations  = 4 
				obj.INodeBakeProjProperties.enabled = false 
				select obj 		
				render rendertype:#bakeSelected vfb:on progressBar:true outputSize:[size,size]
			)else	(
				m_tellyou = "bakeShadowMap"+m_message
				messagebox  m_tellyou
			)
			unhide hideArray
		)
		
		fn BakeAO =(
			obj = GetOBj m_lowKey01
			highObj = GetOBJ m_highKey01
			hideArray = #()

			if obj != undefined  then (
				delete lights
				for i in objects do(
					if i !=obj and i!=highObj then(
						hide i
						append hideArray i
					)
					else unhide i
				)	
				renderers.production = mental_ray_Renderer ()
				if obj.modifiers[#projection] == undefined then(
					m_projection = projection()
					addModifier obj m_projection			
					m_projection.pushCage 2	
					obj.modifiers[#projection].addObjectNode highObj			
				)

				obj.INodeBakeProperties.removeAllBakeElements() 		
				m_bake = Ambient_Occlusion() 
				m_bake.outputSzX = m_bake.outputSzY = size 	
				m_bake.samples = 200
				m_bake.spread  = 3
				makeDir m_path all:true
				m_bake.fileType = (m_path+"/" + m_filename + "_AOMap.tga")
				m_bake.fileName = filenameFromPath m_bake.fileType
				m_bake.filterOn = true 
				m_bake.enabled = true 
				m_bake.backgroundColor =color 255 255 255 100
				obj.INodeBakeProperties.addBakeElement m_bake 
				obj.INodeBakeProperties.bakeEnabled = true 
				obj.INodeBakeProperties.bakeChannel = 1 
				obj.INodeBakeProperties.nDilations  = 4 
				obj.INodeBakeProjProperties.enabled = true 
				m_projection = obj.Modifiers[#projection]
				obj.INodeBakeProjProperties.projectionMod = m_projection	
				select obj 
				render rendertype:#bakeSelected vfb:on progressBar:true outputSize:[size,size]
				unhide hideArray
			)
			else	(
				m_tellyou = "bakeAOMap"+m_message
				messagebox m_tellyou
			
			)
		)
		
		fn BakeLight =(
			obj = GetOBj m_lowKey02
			hideArray = #()
			
			if obj != undefined  then (
				delete lights
				for i in objects do(
					if i !=obj then(
						hide i
						append hideArray i
					)	
					else unhide i
				)
				backgroundcolor = color 140 140 140
				ambientColor = color 140 140 140
				theLight = skylight pos:[100,-100,0] rgb:white 	 
				theLight.Cast_Shadows = on
				m_plane = plane length:400 width:400
				m_position = obj.position - [0,0,10]
				m_plane.position = m_position
				m_plane.material = standard diffuseMap: undefined		

				makeDir m_path all:true
				_bitmapPath = m_path + "/" + m_filename + "_normalsMap.tga"
				if openBitMap  _bitmapPath != undefined then(
					m_textrue = Bitmaptexture()
					m_textrue.fileName = m_path + "/" + m_filename + "_normalsMap.tga"
					m_normalMap = Normal_Bump()
					m_normalMap.normal_map = m_textrue
					obj.material = standard Bumpmap:m_normalMap
					obj.material.bumpMapAmount = 120
					showTextureMap obj.material on
				)

				renderers.production = Default_Scanline_Renderer ()
				obj.INodeBakeProperties.removeAllBakeElements() 		
				m_bake = CompleteMap() 
				m_bake.outputSzX = m_bake.outputSzY = size 	
				
				m_bake.fileType = (m_path + "/" + m_filename + "_lightMap.tga")
				m_bake.fileName = filenameFromPath m_bake.fileType
				m_bake.filterOn = true 
				m_bake.enabled = true 
				m_bake.backgroundColor =color 255 255 255 100
				obj.INodeBakeProperties.addBakeElement m_bake 
				obj.INodeBakeProperties.bakeEnabled = true 
				obj.INodeBakeProperties.bakeChannel = 1 
				obj.INodeBakeProperties.nDilations  = m_nDilations 
				obj.INodeBakeProjProperties.enabled = false 	
				select obj 
				render rendertype:#bakeSelected vfb:on progressBar:true outputSize:[size,size]
				delete m_plane
				print hideArray
				unhide hideArray
				)
			else (
				m_tellyou ="bakeLightMap"+m_message
				messagebox m_tellyou
				
			)
		)

		fn BakeGriantra =(
			obj = GetOBj m_lowKey02	
			m_copy = GetOBj "G_copy"
			hideArray = #()
			
			if obj != undefined  then (	
				delete lights
				for i in objects do(
					if i !=obj and i!=m_copy then(
						hide i
						append hideArray i
					)
					else unhide i
				)
				convertToPoly obj
				obj.autoSmoothThreshold  = 1
				polyOp.setFaceSmoothGroup obj #{1..obj.numfaces} 1
				
				if obj.modifiers[#projection] == undefined then(
					if m_copy == undefined then(
						m_copy = copy obj name:"G_copy"
						m_UVWMap= UVWMap ()
						addModifier m_copy m_UVWMap
						m_UVWMap.maptype = 0
						m_UVWMap.axis = 0	      
						_with =(obj.max.z-obj.min.z)*1.1
						m_UVWMap.width = _with
						_length =(obj.max.y-obj.min.y)*1.1
						m_UVWMap.length = _length
						m_gradientRamp = gradient_Ramp ()
						m_copy.material	= standard diffuseMap:m_gradientRamp
						showTextureMap m_copy.material on				
					)	
					if obj.Modifiers[#push] == undefined then(
						m_push = push() 
						addModifier obj m_push
						m_push.Push_Value = 1
					)
					m_projection = projection()
					addModifier obj m_projection		
					m_projection.pushCage 2	
					obj.modifiers[#projection].addObjectNode m_copy			
				)
				obj.INodeBakeProperties.removeAllBakeElements() 	
				m_bake = DiffuseMap() 
				m_bake.outputSzX = m_bake.outputSzY = size 
				makeDir m_path
				m_bake.fileType = (m_path+"/" + m_filename + "_gradientRampMap.tga")
				m_bake.fileName = filenameFromPath m_bake.fileType
				m_bake.filterOn = true 
				m_bake.enabled = true 
				m_bake.backgroundColor =color 255 255 255 0
				obj.INodeBakeProperties.addBakeElement m_bake 
				obj.INodeBakeProperties.bakeEnabled = true 
				obj.INodeBakeProperties.bakeChannel = 1 
				obj.INodeBakeProperties.nDilations  = 4 
				obj.INodeBakeProjProperties.enabled = true 
				m_projection = obj.Modifiers[#projection]
				obj.INodeBakeProjProperties.projectionMod = m_projection
				select obj 
				render rendertype:#bakeSelected vfb:on progressBar:true outputSize:[size,size]
				unhide hideArray
			)	
			else(
				m_tellyou = "BakeGriantraMap"+m_message
				messagebox m_tellyou
			)
		)

		fn  RestXForm obj =(
			if not obj.scale ==[1,1,1]then(		
				addModifier obj.baseObject (xform())
			)

		)
		
		on BakeTools open do
		(
			_lowKey01.text = "*_low01"
			_lowKey02.text ="*_low02"
			_highKey01.text ="*_high01"		
		)
		
		on _lowKey01 entered text do
			m_lowKey01 = _lowKey01.text
		on _highKey01 entered text do
			m_highKey01 = _highKey01.text
		on _lowKey02 entered text do
			m_lowKey02 = _lowKey02.text
		
		on btn_normal pressed do
		(		
			bakeNormal()
		)
		on btn_AO pressed do
		(	
			bakeAO()
		)
		on btn_shadow pressed do
		(	
			bakeShadow()
		)
		on btn_light pressed do
		(
			bakeLight()		
		)
		on btn_Griantra pressed do
		(
			bakeGriantra()
		)
		on btn_bakeAll pressed do
		(
			if chk_normal.state  do bakeNormal()
			if chk_shadow.state  do bakeShadow()
			if chk_ao.state  do bakeAO()
			if chk_light.state  do bakeLight()
			if chk_Griantra.state  do bakeGriantra()
		)

		on select_Low01 picked obj do
		(
			_select = select_Low01.object 
			if not matchPattern _select.name pattern: m_lowKey01 then(			
				_str = substituteString m_lowKey01 "*" ""
				_select.name = _select.name + _str	
			)
		)
		on select_high01 picked obj do
		(
			_select = select_high01.object 
			if not matchPattern _select.name pattern: m_highKey01 then(			
				_str = substituteString m_highKey01 "*" ""
				_select.name = _select.name + _str	
			)
		)
		on select_low02 picked obj do
		(
			_select = select_Low02.object 
			if not matchPattern _select.name pattern: m_lowKey02 then(	
				_str = substituteString m_lowKey02 "*" ""
				_select.name = _select.name + _str	
			)
		)
	)	
	createDialog BakeTools
