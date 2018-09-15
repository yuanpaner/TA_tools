-- panyuan 2015-4
-- export each geo to a max file
-- delete all the files in the path
-- exportSetting

struct NArtElse(

	/* Gbhys_jz_qiangti03_0001  -- Xbhys_jz_qiangti03.max */
	 fn singleGeoMax sel filepath = 
	 (
		 if(sel) then
		 (
			 _geometry = selection		 
			 )
		else
			 (
				 _geometry = geometry
				 messageBox "所有物体都要导出成单独的max文件哦！！！\n请务必先规范好名称！！！"
				 )
		for x in _geometry do 
		(
			n = x.name
			xname = NArtName.splitname x.name "_" ".max"
			xname = "X" + (substring xname 2 -1)
			xname = filepath + xname
			if (NArtName.noExistFile xname) then  
			(
				p = x.position 
				r = x.rotation 
				x.position = [0,0,0]
				x.rotation = quat 0 0 0 1
				x.name = NArtName.splitname x.name "_" ""
				saveNodes x xname
				
				x.rotation = r
				x.pos = p
				)
			x.name = n
			)
			
	 ),

	 
	 /* ------------------------
	delete the file in the  filePath folder OR not
	 ------------------------*/
		
	fn deleteOriFile filePath TF type = 
	(
		case TF of(
			true : 
			(
				delFileFolder = filePath + type
				file = getFiles delFileFolder
				for i in file do deleteFile i	
				)
			false :()
			default:(print "do nothing")
		
			)
		
		
	),
	
	
	fn exportSetting type =
	 (
		  case type of
			  (
			   "Geometry" : (
-- 					FbxExporterSetParam "Geometries" true
				   FbxExporterSetParam "NormalsPerpoly" false

				   FbxExporterSetParam "Animation" false
				   --FbxExporterSetParam "Resampling" false
				   FbxExporterSetParam "Skin" false
				   FbxExporterSetParam "Shape" false

				   FbxExporterSetParam "ShowWarnings" true
				   FbxExporterSetParam "EmbedTextures" false
				   FBXExporterSetParam "Cameras" false
				   FbxExporterSetParam "Lights" false

				   FbxExporterSetParam "GeomAsBone" false

				   print "geometry"
				)
			  "Animation" :
				(
					FbxExporterSetParam "Geometries" false
					FbxExporterSetParam "NormalsPerpoly" false

					FbxExporterSetParam "Animation" true
				   --FbxExporterSetParam "Resampling" false
					FbxExporterSetParam "Skin" false
					FbxExporterSetParam "Shape" false

					FbxExporterSetParam "ShowWarnings" true
					FbxExporterSetParam "EmbedTextures" false
					FBXExporterSetParam "Cameras" false
					FbxExporterSetParam "Lights" false
				 
					FbxExporterSetParam "GeomAsBone" false
					print "animation"
				)
			  default: FbxExporterSetParam "GeomAsBone" false
			 )
	),
	fn noExistFile fname = (getfiles fname).count == 0,
	/* geo export as a new max file - > import as XRef in the scene*/
-- 	fn geo2XRef sel filepath = 
-- 	 (
-- 		 if(sel) then
-- 			(
-- 				_geometry = selection		 
-- 			 )
-- 		else
-- 			 (
-- 				 _geometry = geometry
-- 				 )
-- 		for x in _geometry do 
-- 		(
-- 			_n = x.name;print _n
-- 			_r = x.rotation
-- 			_p = x.position
-- 			_s = x.scale
-- 			xname = NArtName.splitname _n "_" ".max"
-- 			xname = "X" + (substring xname 2 -1)
-- 			xname = filepath + xname
-- 			if (NArtElse.noExistFile xname) then  
-- 			(
-- 				x.position = [0,0,0]
-- 				x.rotation = quat 0 0 0 1
-- 				x.name = NArtName.splitname x.name "_" ""
-- 				saveNodes x xname
-- 				)
-- 			delete x
-- 			_obj = xrefs.addNewXRefObject xname (getMAXFileObjectNames xname)[1] dupMtlNameAction: #useScene modifiers: #xref  manipulators: #xref
-- 			rotate _obj _r
-- 			move _obj _p
-- 			_obj.name = _n
-- 		)
-- 			
-- 	 ),
	 fn saveNode geo filepath = 
	 (
			_n = geo.name;print _n
			_r = geo.rotation
			_p = geo.position
			_s = geo.scale
			xname = NArtName.splitname _n "_" ".max"
			xname = "X" + (substring xname 2 -1)
			xname = filepath + xname
			if (NArtElse.noExistFile xname) then  
				(
					geo.position = [0,0,0]
					geo.rotation = quat 0 0 0 1
					geo.name = NArtName.splitname _n "_" ""
					saveNodes geo xname
				)
			else 
				(
					print ("there has already been max file --" + xname )		
					
					
					)
			geo.rotation = _r
			geo.pos = _p
			geo.scale = _s
			geo.name = _n
	
	 ),
	 fn geo2XRef geo filepath = 
	 (
			_n = geo.name;print _n
			_r = geo.rotation
			_p = geo.position
			_s = geo.scale
			xname = NArtName.splitname _n "_" ".max"
			xname = "X" + (substring xname 2 -1)
			xname = filepath + xname
			if (NArtElse.noExistFile xname) then  
			(
				geo.position = [0,0,0]
				geo.rotation = quat 0 0 0 1
				geo.name = NArtName.splitname _n "_" ""
				saveNodes geo xname
				
				delete geo
				_obj = xrefs.addNewXRefObject xname (getMAXFileObjectNames xname)[1] dupMtlNameAction: #useScene modifiers: #xref  manipulators: #xref
				rotate _obj _r
				move _obj _p
				_obj.name = _n
				)
			else
				(
					delete geo
					_obj = xrefs.addNewXRefObject xname (getMAXFileObjectNames xname)[1] dupMtlNameAction: #useScene modifiers: #xref  manipulators: #xref
					rotate _obj _r
					move _obj _p
					_obj.name = _n
					
					)
-- 			delete geo
-- 			_obj = xrefs.addNewXRefObject xname (getMAXFileObjectNames xname)[1] dupMtlNameAction: #useScene modifiers: #xref  manipulators: #xref
-- 			rotate _obj _r
-- 			move _obj _p
-- 			_obj.name = _n
-- 	
	 )
	
)

print "Load NArtElse"
