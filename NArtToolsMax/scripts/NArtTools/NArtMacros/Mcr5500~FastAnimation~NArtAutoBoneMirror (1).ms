--骨骼镜像并重命名R/L(骨骼命名时R与L表示左右，必须用"_"分隔开)--
macroscript NArtAutoBoneMirror
category:"_NArtTools"
buttontext:"Auto Bone Mirror"
tooltip:"Auto Bone Mirror"
(
	on execute do(
		tp_getCoordCenter=getCoordCenter()
		tp_getRefCoordSys=getRefCoordSys()
		
		setRefCoordSys #world
		setCoordCenter #system 
		
		tp_OldSelArray=for i in selection collect i
		tp_SelBones=for i in selection collect i
		select tp_SelBones
		
		max mirror
		tp_MirrorBone=for i in selection collect i
		
		for i=1 to tp_MirrorBone.count do 
		(
			tp_namefilterArray=filterString tp_SelBones[i].name "_"	
			tp_foo=1
			for a=1 to tp_namefilterArray.count do
			(
				if tp_namefilterArray[a]=="L" then 
				(
				tp_namefilterArray[a]="R"
				tp_foo=2
				)
				else
				(
					if tp_namefilterArray[a]=="R" then
					(
						 tp_namefilterArray[a]="L"
						 tp_foo=2
					)
				)
			)
			if tp_foo==2 then
			(
				tp_NewBonename=tp_namefilterArray[1]
				for b=2 to tp_namefilterArray.count do tp_NewBonename=tp_NewBonename+"_"+tp_namefilterArray[b]
				tp_MirrorBone[i].name=tp_NewBonename
			)
		)
		
		setRefCoordSys tp_getRefCoordSys
		setCoordCenter tp_getCoordCenter
	)
)