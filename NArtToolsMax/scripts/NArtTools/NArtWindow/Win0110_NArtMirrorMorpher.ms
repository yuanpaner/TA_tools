
rollout MirrorFace "�����ԳƱ��� - ��ȶ���" width:200 height:320
(
	pickbutton getFaceBt "Pick" pos:[19,65] width:50 height:20 enabled:true
	pickbutton getTargetFacebt "Pick" pos:[19,94] width:50 height:20
	button getMirrorBt "Creat" pos:[19,122] width:50 height:19 toolTip:""
	label faceTag "+ʰȡͷ��ģ��+" pos:[81,69] width:108 height:17
	label targetFaceTag "+ʰȡ����ģ��+" pos:[80,96] width:108 height:17
	label MirrorFaceTag "+�����������+" pos:[80,125] width:108 height:17
	--label lbl10 "ʯ��ׯ��ȶ���
--www.deepcg.com" pos:[85,153] width:104 height:31
	dropdownList wraptype "" pos:[19,36] width:50 height:22 items:#("��", "��")
	label lbl5 "+����Ԫ������+" pos:[81,42] width:108 height:17
	dropdownList mirror_axis "" pos:[19,10] width:50 height:22 items:#("X��", "Y��", "Z��")
	label lbl18 "+���龵������+" pos:[81,16] width:108 height:17
	button getDouble_bt "Creat" pos:[19,150] width:50 height:19 toolTip:""
	label lbl6 "+�����ԳƱ���+" pos:[80,152] width:108 height:17
	groupBox grp1 "" pos:[13,183] width:174 height:100
	label lbl7 "˵����" pos:[25,183] width:49 height:21
	label lbl8 "ʰȡͷ��ģ�ͣ�" pos:[23,202] width:158 height:18
		

	label lbl9 "ʰȡû�б����ԭģ��" pos:[50,221] width:134 height:18
	label lbl10 "ʰȡ����ģ�ͣ�" pos:[23,239] width:158 height:18
	label lbl11 "ʰȡ��Ҫ�����Ŀ����" pos:[50,260] width:134 height:18
	hyperlink linkk "�ӱ���ȶ��� www.deepcg.com" color:(color 80 80 80) pos:[19,290] address:"http://www.deepcg.com"
	on getFaceBt picked obj do
	(
		Global AA = obj	;faceTag.caption = obj.name
	)
	on getTargetFacebt picked obj do
	(
		Global TT = obj;	targetFaceTag.caption = obj.name
	)
	on getMirrorBt pressed do
	(
	modflag_morpher = false
	
			try
			(
				A2 = snapshot AA
				A2.name = "A2"
				A3 = snapshot AA
				A3.name = "A3"
				addmodifier A2 (Morpher ())
				addmodifier A3 (Skin_Wrap ())
				A2.isselected = true
				wm3_mc_buildfromnode A2.morpher 1 TT
				case mirror_axis.selection of
				(
					1: (scale A2 [-1,1,1])
					2: (scale A2 [1,-1,1])
					3: (scale A3 [1,1,-1])
				)
				A3.skin_wrap.meshlist[1] = $A2
				if wraptype.selection==1 then A3.skin_wrap.engine = 1 else A3.skin_wrap.engine = 0
				A3.skin_wrap.falloff = 10
				slidertime+=10f	
				wm3_mc_setvalue A2.morpher 1 100.00			
				converttomesh A3
				delete A2
				A3.position = TT.position + [(TT.max.x-TT.min.x)*1.2,0,0]
				TempName = TT.name+"_����"
				A3.name = TempName
				if modflag_morpher then A1.modifiers[#morpher].enabled = true
				mirrorface.MirrorFaceTag.caption = TempName
				slidertime-=10f
			)
			catch 
			(messagebox "������֪���������飡" title:"ע��")
		
		
	)
	on getDouble_bt pressed do
	(
		modflag_morpher = false
		try(
			A2 = snapshot AA
			A2.name = "A2"
			A3 = snapshot AA
			A3.name = "A3"
			addmodifier A2 (Morpher ())
			addmodifier A3 (Skin_Wrap ())
			A2.isselected = true
			wm3_mc_buildfromnode A2.morpher 99 TT
			case mirror_axis.selection of
			(
				1: (scale A2 [-1,1,1])
				2: (scale A2 [1,-1,1])
				3: (scale A3 [1,1,-1])
			)
			A3.skin_wrap.meshlist[1] = $A2
			if wraptype.selection==1 then A3.skin_wrap.engine = 1 else A3.skin_wrap.engine = 0
			A3.skin_wrap.falloff = 10
			slidertime+=10f
			wm3_mc_setvalue A2.morpher 99 100.00			
			converttomesh A3
			wm3_mc_buildfromnode A2.morpher 99 TT
			wm3_mc_buildfromnode A2.morpher 98 A3
			wm3_mc_setvalue A2.morpher 99 100.00
			wm3_mc_setvalue A2.morpher 98 100.00
			converttomesh A2
			delete A3
			A2.position = TT.position + [(TT.max.x-TT.min.x)*1.2,0,0]
			TempName = TT.name+"_�Գ�"
			A2.name = TempName
			slidertime+=10f
			)catch()
		)
)
createdialog MirrorFace