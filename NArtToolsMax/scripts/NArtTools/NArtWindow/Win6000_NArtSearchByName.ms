print "NArt工具：根据名称查找物体"

rollout searchObj "查找物体" width:206 height:204
(
		editText edtName "" pos:[17,38] width:168 height:19
	label lbl1 "输入要查找的名字：" pos:[20,17] width:108 height:14 enabled:true
	button startB "开始查找" pos:[20,162] width:65 height:22
	label lblNum "" pos:[72,64] width:36 height:19
	label lbl3 "一共有：" pos:[21,67] width:52 height:19
	label lbl4 "屏蔽字段：" pos:[24,92] width:108 height:14 enabled:true
	label lbl5 "一共有：" pos:[24,127] width:52 height:19
	spinner spn_del "" pos:[88,92] width:76 height:16 range:[0,5,0] type:#integer scale:1 
	label lbl_2 "" pos:[73,126] width:36 height:19
	
	
	fn search = 
	(
		clearListener()
		geoList=#()
		geoList2=#()
		if(edtName.text=="")then messagebox "请输入查找的名字"
		else
		(					
			searchN = "*" + edtName.text + "*"
			for i in objects do
				if(matchPattern i.name pattern:searchN) then append geoList i.name
			)
		if spn_del.value!=0 and geoList.count>0 then 
		(
			
			for i in geoList do
			(
				temp = filterstring i "_"
				if temp.count==1 then messagebox "场景物体没有_"
					else
					(
						tempN=""
						for j=1 to temp.count-spn_del.value do tempN += temp[j]+"_"
						tempN = substring tempN 1 (tempN.count-1)
						appendIfUnique geoList2 tempN
						)

				)--for
			actionMan.executeAction 0 "40472"
			print (sort geoList2)
			
			)
		else 
			(
				actionMan.executeAction 0 "40472"
				print (sort geoList)
			)
		lblNum.caption = geoList.count as string
		lbl_2.caption = geoList2.count as string
		)--function search
		
	on searchObj open  do
	(
		spn_del.value = 0
		setFocus edtName
		)
-- 			on edtName KeyUp evnt do
-- 			(
-- 				if evnt.KeyCode == (dotNetClass "System.Windows.Form.Keys").Enter do
-- 				(
-- 					search()
-- 					)
-- 				)
	on startB pressed  do
	(
-- 				clearListener()
-- 				geoList=#()
-- 				geoList2=#()
-- 				if(edtName.text=="")then messagebox "请输入查找的名字"
-- 				else
-- 				(					
-- 					searchN = "*" + edtName.text + "*"
-- 					for i in objects do
-- 						if(matchPattern i.name pattern:searchN) then append geoList i.name
-- 					)
-- 				if spn_del.value!=0 and geoList.count>0 then 
-- 				(
-- 					
-- 					for i in geoList do
-- 					(
-- 						temp = filterstring i "_"
-- 						if temp.count==1 then messagebox "场景物体没有_"
-- 							else
-- 							(
-- 								tempN=""
-- 								for j=1 to temp.count-spn_del.value do tempN += temp[j]
-- 								appendIfUnique geoList2 tempN
-- 								)

-- 						)--for
-- 					actionMan.executeAction 0 "40472"
-- 					print (sort geoList2)
-- 					
-- 					)
-- 				else 
-- 					(
-- 						actionMan.executeAction 0 "40472"
-- 						print (sort geoList)
-- 					)
-- 				lblNum.caption = geoList.count as string
-- 				lbl_2.caption = geoList2.count as string
		search()
		)--on button
)

		createDialog searchObj