--prj：opp
--panyuan 2015/12/26 @pwd
--functon:copy vertex normal from one geometry to another, one vertex by one


--version2.0 
macroScript NArtCopyVertexNormal
category:"_NArtTools"
toolTip:"Copy VertexNormal"
buttontext:"Copy VertexNormal"
(
	undo on 
	(
		if copyVertexNormal == undefined then
		(
			rollout copyVertexNormal "复制Vertex法线" width:248 height:140
			(
				fn ctrl_filt obj = classof obj == Geometry
				
				editText edtOri "" pos:[16,14] width:123 height:17 enabled:false
				editText edtTar "" pos:[16,42] width:123 height:17 enabled:false
				pickButton btnOri "选取源物体" pos:[152,15] width:72 height:17 --filter:ctrl_filt
				pickButton btnTar "选取目标物体" pos:[153,40] width:72 height:17
				button btnExe "复制定点法线信息" pos:[16,70] width:205 height:17
				label lbl1 "执行之后模型会有所修改，请提前保存好文件" pos:[16,95] width:205 height:35

					on btnOri picked obj do
					(
						if obj !=undefined then
						(
				-- 			edtScr.enabled = true
							edtOri.text = obj.name
							)							
						)
					on btnTar picked obj do
					(
						if obj !=undefined do
						(
				-- 			edtDes.enabled = true
							edtTar.text = obj.name
							)
							
						)
					on btnExe pressed  do
					(
						oriGeo = getnodebyname edtOri.text
						tarGeo = getnodebyname edtTar.text
						
						convertToMesh oriGeo
						convertToMesh tarGeo
						print "源物体定点数："
						print oriGeo.numVerts
						print "目标物体定点数："
						print tarGeo.numVerts
						--unify ori obj normal
						mody = EditNormals name:"AverageNormals" selectBy:3
						addModifier oriGeo mody						
						verts=#{}
						normals=#{}
						for v = oriGeo.numVerts to 1 by -1 do
						(
							append verts v
							)			
						mody.ConvertVertexSelection &verts &normals
						mody.unify selection:normals toAverage:true
						convertToMesh oriGeo
						--unify target obj normal	
						modyT = EditNormals name:"AverageNormals" selectBy:3
						addModifier tarGeo mody						
						verts=#{}
						normals=#{}
						for v = tarGeo.numVerts to 1 by -1 do
						(
							append verts v
							)			
						modyT.ConvertVertexSelection &verts &normals
						modyT.unify selection:normals toAverage:false
						convertToMesh tarGeo							
							
							
						--copy normal
						for v = oriGeo.numVerts to 1 by -1 do
						(
							print v
							setNormal tarGeo v (getNormal oriGeo v)
							)
						print "done!"
					
					)--end button
				)--end rollout
				-- destroyDialog copyVertexNormal
				createDialog copyVertexNormal 248 140 50 50
		)
		else 
		(
			if copyVertexNormal.isDisplayed then
			 DestroyDialog copyVertexNormal 
			else Createdialog copyVertexNormal
		)
	)	
	
)