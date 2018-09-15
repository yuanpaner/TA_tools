
struct NArtCheck(

	--���ParticleView
	fn DelParticleView = (
		_particleViews = for i in objects where classof i==Particle_View collect i
		
		if _particleViews.count != 0 then(
			_log = "NArtLog: ɾ��ParticleViews:"+ (_particleViews.count as string) + "��"
		)else(
			_log = "NArtLog: û�з����������� ParticleView"
		)
		print _log
		delete _particleViews
	),
	
	--�����������
	fn CheckSameName = (
		
		tp_allObj=for i in objects collect i
		tp_contrastArray
		_result=#()
		for tp_contrastObj in tp_allObj do
		(
			tp_contrastArray=for i in tp_allObj where i!=tp_contrastObj collect i
			for i in tp_contrastArray do
			(
				if i.name==tp_contrastObj.name do 
				(
					tp_CheckNamefoo=false
					for a in _result do
					(
						if i.name==a.name do tp_CheckNamefoo=true
					)
					if tp_CheckNamefoo==false do append _result i
				)
			)
		)
		return _result
	),
	--�����淶����
	fn fn_checkSceneFile =(
		NArtCheck.DelParticleView()		
		_keyword  =substituteString  maxfilename ".max" ""
		_keyword  =replace _keyword 1 1 ""	
		for i in objects do(
			addmodifier i (XForm())
			maxOps.CollapseNode i true
			try(
				if classof i.material != Multimaterial then (
					i.material.name = "M"+_keyword+"_0001" 
					i.Material.diffusemap.name = "B"+_keyword+"_0001"				
				)else(					
					for j=1 to i.material.count do(
						_index = NArtName.fn_GetStringIndex j 4
						i.material[j].name = "M" + _keyword + "_"+_index
						i.material[j].diffusemap.name = "B"+_keyword +"_"+ _index
					)					
				)				
			)catch(
				
			)		
		)		
		_fileName 
		for i=1 to objects.count do (
			clearSelection()
			select objects[i]	
			_index = NArtName.fn_GetStringIndex i 4
			_fileName = _keyword +"_"+ _index			
			objects[i].name = "G"+_fileName
		)		
	)
)

print "Load NArtExport"