print "NArt工具：自动重命名"

_listName  = #()
	
_oldListName = #()

_listAnim = #("", "_G", "@skin", "@stand01", "@stand02", "@idle01", "@idle02", "@run01", "@run02","@run03",
				"@walk01", "@attack01","@attack02", "@attack03","@attack04","@attack05","@attack06","@attack07","@skill01","@skill02",	"@skill03",
				"@hit01","@hit02","@hit03","@hitDown","@hitUp","@floatDown", "@floating","@getUp","@evolution","@dead01","@dead02","_fx")
				
_listProject = #("","DADemo","TK3D_Demo","Digimon")
				
_listType = #("monster", "orpc" , "pc", "npc", "enemy", "pet", "player","boss", "ride", "weapon")
				
_listgroup = #("Character", "WorldEntities", "FX", "UI")

_strpath = ""
				
_KeWord = ""
				
_newAnimStrList = #()

try(DestoryDialog autoRename)catch()

rollout autoRename "AutoReName" width:534 height:542
(

GroupBox grp1 "ReName" pos:[11,23] width:511 height:51	


label lbl2 "number" pos:[19,54] width:52 height:17				
		

button btn_ReName "ReName" pos:[187,512] width:165 height:22
 
spinner m_num "" pos:[74,52] width:100 height:16 range:[0,9999,0] type:#integer scale:0.1							
					

GroupBox grp3 "SavePath" pos:[10,80] width:511 height:100

dropdownList list_Project "Project" pos:[18,100] width:160 height:41

dropdownList list_group "group" pos:[185,100] width:160 height:41
 
dropdownList list_type "type" pos:[350,100] width:160 height:41			
	

edittext txt_Path "" pos:[16,151] width:446 height:18
button btn_path "GetPath" pos:[465,151] width:46 height:18	


checkbox chk_copyOtherFiles "Copy Other Files" pos:[12,491] width:160 height:17 checked:false

subRollout s_ListDocuments "ListDocuments" pos:[10,189] width:510 height:300

--计算存储路径
fn fn_getnewPah = (
	if list_type.selected != undefined do(				
		_KeWord = NArtName.fn_GetKeyWord m_num.value ("_"+list_type.selected)
	)

	_strpath = txt_Path.text
	_strpath = "E:\\"
	if list_group.selected !=undefined  do(
		_strpath += list_group.selected + "\\"			
	)
	
	if list_Project.selected !=undefined  do(
		_strpath += list_Project.selected +"\\"					
	)
	
	if list_type.text != "" do (
		_strpath += list_type.selected+"\\"
	)
	_strpath += _KeWord + "\\"
	txt_Path.text = _strpath			
)
--匹配列表
fn fn_matchList _strpath=(
	_strArray = filterstring _strpath "//\\"
	if _strArray.count > 2 do(
		_num = finditem list_Project.items 	_strArray[3]
		if _num <1 do _num =1
		list_Project.selection = _num
		
		_num = finditem list_group.items _strArray[2]
		if _num <1 do _num =1
		list_group.selection = _num
	) 
	if _strArray.count > 3 then(	
		_index = finditem list_type.items _strArray[4]
		if _index <1 do _index=1

		list_type.selection = _index	
		
	)else(
		list_type.selection = 1	

	)	
)		


-- 重命名列表文件

fn fn_RenameAllfile  _exportAllfile= (
	_KeWord = NArtName.fn_GetKeyWord m_num.value ("_"+list_type.selected)
	_oldpath = maxfilepath as string

	if _strpath != _oldpath then(
		_Dostr = ""
		if _exportAllfile then(
			_Dostr = "xcopy " + _oldpath+"* "+ _strpath +" /e "					
		)else(					
			_Dostr = "xcopy " + _oldpath+"* "+ _strpath
		)

		
		DOSCommand _Dostr			
	)
	_Documents =  getfiles (_strpath +"*.max")
	
	for i=1 to _Documents.count do(
			_oldListName[i]
			_newfullname = _strpath +"~"+_oldListName[i]+".max" 
			renamefile _Documents[i] _newfullname				
	)			
	_Documents =  getfiles (_strpath +"*.max")
	for i=1 to _Documents.count do(
		loadMaxFile _Documents[i] useFileUnits:true quiet:true					
		NArtName.fn_ReNameFile _KeWord _newAnimStrList[i] _strpath				
	)	
	
)



--工具开启初始化	



on autoRename open do
(
	
	list_Project.items = _listProject
	list_type.items = _listType
	list_group.items = _listgroup			
	chk_copyOtherFiles.state  =true
	m_num.value = NArtName.fn_GetNum()			
	fn_matchList maxfilepath			
	txt_Path.text  = fn_getnewPah()
	_strpath = fn_getnewPah()	
	_KeWord = NArtName.fn_GetKeyWord m_num.value ("_"+list_type.items[1])		
	
)

--修改所有文件名	
on btn_ReName pressed do
(
	_maxfile = getfiles (_strpath +"*.max")
	
	if(_strpath != maxfilepath and _maxfile.count != 0 ) then(				
			messageBox  "目标编号已使用，请先处理! " title:"warning"
	)else(
		
		if  (makeUniqueArray  _newAnimStrList).count != _oldListName.count then (				
			messageBox  "请为所有文件选择文件类型! " title:"warning"
		)else(
			fn_RenameAllfile chk_copyOtherFiles.state
		)
	)

)
on m_num changed val do
(
	fn_getnewPah ()		
)
on list_Project selected sel do
(
	fn_getnewPah ()			
)
on list_group selected sel do
(
	fn_getnewPah ()		
)
on list_type selected sel do
(
	fn_getnewPah ()		
)
on btn_path pressed do
(
	try(
		txt_Path.text  = getSavePath caption:"my title" initialDir:(maxfilepath)
		if  txt_Path.text !=undefined and  txt_Path.text != "" do(
			_strpath = txt_Path.text 
			fn_matchList _strpath					
		)
	)catch(				
		
	)
)
)
rollout rollout_Waining "Waining" width:249 height:128
(
label lbl1 "This name is used!!" pos:[73,52] width:111 height:21
button btn1 "OK" pos:[61,91] width:128 height:27
GroupBox grp1 "Warning" pos:[18,21] width:215 height:64

on btn1 pressed  do
(		
	destroydialog rollout_Waining
)
)
rollout rollout_listDocuments "listDocuments" width:376 height:200
(	
label lbl01 "Label" pos:[15,0] width:129 height:14
label lbl02 "Label" pos:[15,0] width:129 height:14
label lbl03 "Label" pos:[15,0] width:129 height:14			
label lbl04 "Label" pos:[15,0] width:129 height:14
label lbl05 "Label" pos:[15,0] width:129 height:14
label lbl06 "Label" pos:[15,0] width:129 height:14
label lbl07 "Label" pos:[15,0] width:129 height:14
label lbl08 "Label" pos:[15,0] width:129 height:14
label lbl09 "Label" pos:[15,0] width:129 height:14
label lbl10 "Label" pos:[15,0] width:129 height:14
label lbl11 "Label" pos:[15,0] width:129 height:14
label lbl12 "Label" pos:[15,0] width:129 height:14
label lbl13 "Label" pos:[15,0] width:129 height:14
label lbl14 "Label" pos:[15,0] width:129 height:14
label lbl15 "Label" pos:[15,0] width:129 height:14
label lbl16 "Label" pos:[15,0] width:129 height:14
label lbl17 "Label" pos:[15,0] width:129 height:14
label lbl18 "Label" pos:[15,0] width:129 height:14
label lbl19 "Label" pos:[15,0] width:129 height:14
label lbl20 "Label" pos:[15,0] width:129 height:14			
label lbl21 "Label" pos:[15,0] width:129 height:14
label lbl22 "Label" pos:[15,0] width:129 height:14
label lbl23 "Label" pos:[15,0] width:129 height:14			
label lbl24 "Label" pos:[15,0] width:129 height:14
label lbl25 "Label" pos:[15,0] width:129 height:14
label lbl26 "Label" pos:[15,0] width:129 height:14
label lbl27 "Label" pos:[15,0] width:129 height:14
label lbl28 "Label" pos:[15,0] width:129 height:14
label lbl29 "Label" pos:[15,0] width:129 height:14
label lbl30 "Label" pos:[15,0] width:129 height:14
label lbl31 "Label" pos:[15,0] width:129 height:14
label lbl32 "Label" pos:[15,0] width:129 height:14
label lbl33 "Label" pos:[15,0] width:129 height:14
label lbl34 "Label" pos:[15,0] width:129 height:14
label lbl35 "Label" pos:[15,0] width:129 height:14
label lbl36 "Label" pos:[15,0] width:129 height:14
label lbl37 "Label" pos:[15,0] width:129 height:14
label lbl38 "Label" pos:[15,0] width:129 height:14
label lbl39 "Label" pos:[15,0] width:129 height:14
label lbl40 "Label" pos:[15,0] width:129 height:14
label lbl41 "Label" pos:[15,0] width:129 height:14
label lbl42 "Label" pos:[15,0] width:129 height:14
label lbl43 "Label" pos:[15,0] width:129 height:14
label lbl44 "Label" pos:[15,0] width:129 height:14
label lbl45 "Label" pos:[15,0] width:129 height:14
label lbl46 "Label" pos:[15,0] width:129 height:14
label lbl47 "Label" pos:[15,0] width:129 height:14
label lbl48 "Label" pos:[15,0] width:129 height:14
label lbl49 "Label" pos:[15,0] width:129 height:14
label lbl50 "Label" pos:[15,0] width:129 height:14		

dropdownList ddl01 "" pos:[200,0] width:129 height:22
dropdownList ddl02 "" pos:[200,0] width:129 height:22
dropdownList ddl03 "" pos:[200,0] width:129 height:22			
dropdownList ddl04 "" pos:[200,0] width:129 height:22
dropdownList ddl05 "" pos:[200,0] width:129 height:22
dropdownList ddl06 "" pos:[200,0] width:129 height:22
dropdownList ddl07 "" pos:[200,0] width:129 height:22
dropdownList ddl08 "" pos:[200,0] width:129 height:22
dropdownList ddl09 "" pos:[200,0] width:129 height:22
dropdownList ddl10 "" pos:[200,0] width:129 height:22
dropdownList ddl11 "" pos:[200,0] width:129 height:22
dropdownList ddl12 "" pos:[200,0] width:129 height:22
dropdownList ddl13 "" pos:[200,0] width:129 height:22
dropdownList ddl14 "" pos:[200,0] width:129 height:22
dropdownList ddl15 "" pos:[200,0] width:129 height:22
dropdownList ddl16 "" pos:[200,0] width:129 height:22
dropdownList ddl17 "" pos:[200,0] width:129 height:22
dropdownList ddl18 "" pos:[200,0] width:129 height:22
dropdownList ddl19 "" pos:[200,0] width:129 height:22
dropdownList ddl20 "" pos:[200,0] width:129 height:22			
dropdownList ddl21 "" pos:[200,0] width:129 height:22
dropdownList ddl22 "" pos:[200,0] width:129 height:22
dropdownList ddl23 "" pos:[200,0] width:129 height:22			
dropdownList ddl24 "" pos:[200,0] width:129 height:22
dropdownList ddl25 "" pos:[200,0] width:129 height:22
dropdownList ddl26 "" pos:[200,0] width:129 height:22
dropdownList ddl27 "" pos:[200,0] width:129 height:22
dropdownList ddl28 "" pos:[200,0] width:129 height:22
dropdownList ddl29 "" pos:[200,0] width:129 height:22
dropdownList ddl30 "" pos:[200,0] width:129 height:22
dropdownList ddl31 "" pos:[200,0] width:129 height:22
dropdownList ddl32 "" pos:[200,0] width:129 height:22
dropdownList ddl33 "" pos:[200,0] width:129 height:22
dropdownList ddl34 "" pos:[200,0] width:129 height:22
dropdownList ddl35 "" pos:[200,0] width:129 height:22
dropdownList ddl36 "" pos:[200,0] width:129 height:22
dropdownList ddl37 "" pos:[200,0] width:129 height:22
dropdownList ddl38 "" pos:[200,0] width:129 height:22
dropdownList ddl39 "" pos:[200,0] width:129 height:22
dropdownList ddl40 "" pos:[200,0] width:129 height:22
dropdownList ddl41 "" pos:[200,0] width:129 height:22
dropdownList ddl42 "" pos:[200,0] width:129 height:22
dropdownList ddl43 "" pos:[200,0] width:129 height:22
dropdownList ddl44 "" pos:[200,0] width:129 height:22
dropdownList ddl45 "" pos:[200,0] width:129 height:22
dropdownList ddl46 "" pos:[200,0] width:129 height:22
dropdownList ddl47 "" pos:[200,0] width:129 height:22
dropdownList ddl48 "" pos:[200,0] width:129 height:22
dropdownList ddl49 "" pos:[200,0] width:129 height:22
dropdownList ddl50 "" pos:[200,0] width:129 height:22 		

label pth01 "Label" pos:[15,0] width:350 height:14
label pth02 "Label" pos:[15,0] width:350 height:14
label pth03 "Label" pos:[15,0] width:350 height:14			
label pth04 "Label" pos:[15,0] width:350 height:14
label pth05 "Label" pos:[15,0] width:350 height:14
label pth06 "Label" pos:[15,0] width:350 height:14
label pth07 "Label" pos:[15,0] width:350 height:14
label pth08 "Label" pos:[15,0] width:350 height:14
label pth09 "Label" pos:[15,0] width:350 height:14
label pth10 "Label" pos:[15,0] width:350 height:14
label pth11 "Label" pos:[15,0] width:350 height:14
label pth12 "Label" pos:[15,0] width:350 height:14
label pth13 "Label" pos:[15,0] width:350 height:14
label pth14 "Label" pos:[15,0] width:350 height:14
label pth15 "Label" pos:[15,0] width:350 height:14
label pth16 "Label" pos:[15,0] width:350 height:14
label pth17 "Label" pos:[15,0] width:350 height:14
label pth18 "Label" pos:[15,0] width:350 height:14
label pth19 "Label" pos:[15,0] width:350 height:14
label pth20 "Label" pos:[15,0] width:350 height:14			
label pth21 "Label" pos:[15,0] width:350 height:14
label pth22 "Label" pos:[15,0] width:350 height:14
label pth23 "Label" pos:[15,0] width:350 height:14			
label pth24 "Label" pos:[15,0] width:350 height:14
label pth25 "Label" pos:[15,0] width:350 height:14
label pth26 "Label" pos:[15,0] width:350 height:14
label pth27 "Label" pos:[15,0] width:350 height:14
label pth28 "Label" pos:[15,0] width:350 height:14
label pth29 "Label" pos:[15,0] width:350 height:14
label pth30 "Label" pos:[15,0] width:350 height:14
label pth31 "Label" pos:[15,0] width:350 height:14
label pth32 "Label" pos:[15,0] width:350 height:14
label pth33 "Label" pos:[15,0] width:350 height:14
label pth34 "Label" pos:[15,0] width:350 height:14
label pth35 "Label" pos:[15,0] width:350 height:14
label pth36 "Label" pos:[15,0] width:350 height:14
label pth37 "Label" pos:[15,0] width:350 height:14
label pth38 "Label" pos:[15,0] width:350 height:14
label pth39 "Label" pos:[15,0] width:350 height:14
label pth40 "Label" pos:[15,0] width:350 height:14
label pth41 "Label" pos:[15,0] width:350 height:14
label pth42 "Label" pos:[15,0] width:350 height:14
label pth43 "Label" pos:[15,0] width:350 height:14
label pth44 "Label" pos:[15,0] width:350 height:14
label pth45 "Label" pos:[15,0] width:350 height:14
label pth46 "Label" pos:[15,0] width:350 height:14
label pth47 "Label" pos:[15,0] width:350 height:14
label pth48 "Label" pos:[15,0] width:350 height:14
label pth49 "Label" pos:[15,0] width:350 height:14
label pth50 "Label" pos:[15,0] width:350 height:14	


timer tmr1 "Timer" pos:[0,0] width:24 height:24
	
	

local _listlbl = #(lbl01,lbl02,lbl03,lbl04,lbl05,lbl06,lbl07,lbl08,lbl09,lbl10,lbl11,lbl12,lbl13,lbl14,lbl15,lbl16,lbl17,lbl18,lbl19,lbl20,
					lbl21,lbl22,lbl23,lbl24,lbl25,lbl26,lbl27,lbl28,lbl29,lbl30,lbl31,lbl32,lbl33,lbl34,lbl35,lbl36,lbl37,lbl38,lbl39,lbl40,
					lbl41,lbl42,lbl43,lbl44,lbl45,lbl46,lbl47,lbl48,lbl49,lbl50)
local _listddl = #(ddl01,ddl02,ddl03,ddl04,ddl05,ddl06,ddl07,ddl08,ddl09,ddl10,ddl11,ddl12,ddl13,ddl14,ddl15,ddl16,ddl17,ddl18,ddl19,ddl20,
					ddl21,ddl22,ddl23,ddl24,ddl25,ddl26,ddl27,ddl28,ddl29,ddl30,ddl31,ddl32,ddl33,ddl34,ddl35,ddl36,ddl37,ddl38,ddl39,ddl40,
					ddl41,ddl42,ddl43,ddl44,ddl45,ddl46,ddl47,ddl48,ddl49,ddl50)
					
local _listpth = #(pth01,pth02,pth03,pth04,pth05,pth06,pth07,pth08,pth09,pth10,pth11,pth12,pth13,pth14,pth15,pth16,pth17,pth18,pth19,pth20,
					pth21,pth22,pth23,pth24,pth25,pth26,pth27,pth28,pth29,pth30,pth31,pth32,pth33,pth34,pth35,pth36,pth37,pth38,pth39,pth40,
					pth41,pth42,pth43,pth44,pth45,pth46,pth47,pth48,pth49,pth50)


fn fn_methd  _index _sel= (
	if(_listddl[_index].items[_sel] != "") then(
		for i=1 to _newAnimStrList.count do (
			if  i != _index then(	
				if _listddl[_index].selected == _newAnimStrList[i] do (	
					_listddl[_index].selection = 1
					_sel = 1
					messageBox  "Type name is used!" title:"warning"
				)	
			)
		)
	
	)
	_newAnimStrList[_index] = _listddl[_index].items[_sel] 
	_listpth[_index].text = _strpath+"X"+ _KeWord + _newAnimStrList[_index]		
)

fn fn_UpdateLabel = (
	for i=1 to _newAnimStrList.count do(				
		_listpth[i].text = _strpath+"X"+ _KeWord + _newAnimStrList[i]
	) 
)

on rollout_listDocuments open do
(	
	_oldListName = NArtName.fn_getDocumentsName()	
	
	rollout_listDocuments.height = (_oldListName.count*40)+30
	for i=1  to _oldListName.count do(
		_listlbl[i].pos = [15,10+(i-1)*50]
		_listddl[i].pos = [200,10+(i-1)*50]
		_listpth[i].pos = [15,30+(i-1)*50]
	)
	for i= (_oldListName.count+1) to _listddl.count do(
		_listlbl[i].pos = [0,0]
		_listddl[i].pos = [0,0]
		_listpth[i].pos = [0,0]
		_listlbl[i].visible = false		
		_listddl[i].visible = false	
		_listpth[i].visible = false	
	)

	for i in _listddl do(
		i.items = _listAnim
	)	
	
	for z=1 to  _oldListName.count do(
		if z <= _listlbl.count do(
			_listlbl[z].text = _oldListName[z]
			_anmName = NartName.fn_genAnimName _oldListName[z]
			append _newAnimStrList ""
			_num = 1
			for _i=1 to _listAnim.count do(					
				if (findString _listAnim[_i]  _anmName) != undefined do(						
					_num = _i	
					exit							
				)				
			) 
			
			if(_num >0) do (
				print _num
				_index = finditem  _newAnimStrList _listAnim[_num]
				if _index <= 0 do(	
					print	_listddl[z].selection					
					_listddl[z].selection = _num
					_newAnimStrList[z] = _listAnim[_num]				
				)	
			)				
			_listpth[z].text = ""				
			_listpth[z].text = _strpath+"X"+ _KeWord + _newAnimStrList[z]					
		)

	)		
)
on ddl01 selected sel do
(
			fn_methd 1 sel
		)
on ddl02 selected sel do
(
			fn_methd 2 sel
		)
on ddl03 selected sel do
(
			fn_methd 3 sel
		)
on ddl04 selected sel do
(
			fn_methd 4 sel
		)
on ddl05 selected sel do
(
			fn_methd 5 sel
		)
on ddl06 selected sel do
(
			fn_methd 6 sel
		)
on ddl07 selected sel do
(
			fn_methd 7 sel
		)
on ddl08 selected sel do
(
			fn_methd 8 sel
		)
on ddl09 selected sel do
(
			fn_methd 9 sel
		)
on ddl10 selected sel do
(
			fn_methd 10 sel
		)
on ddl11 selected sel do
(
			fn_methd 11 sel
		)
on ddl12 selected sel do
(
			fn_methd 12 sel
		)
on ddl13 selected sel do
(
			fn_methd 13 sel
		)
on ddl14 selected sel do
(
			fn_methd 14 sel
		)
on ddl15 selected sel do
(
			fn_methd 15 sel
		)
on ddl16 selected sel do
(
			fn_methd 16 sel
		)
on ddl17 selected sel do
(
			fn_methd 17 sel
		)
on ddl18 selected sel do
(
			fn_methd 18 sel
		)
on ddl19 selected sel do
(
			fn_methd 19 sel
		)
on ddl20 selected sel do
(
			fn_methd 20 sel
		)
on ddl21 selected sel do
(
			fn_methd 21 sel
		)
on ddl22 selected sel do
(
			fn_methd 22 sel
		)
on ddl23 selected sel do
(
			fn_methd 23 sel
		)
on ddl24 selected sel do
(
			fn_methd 24 sel
		)
on ddl25 selected sel do
(
			fn_methd 25 sel
		)
on ddl26 selected sel do
(
			fn_methd 26 sel
		)
on ddl27 selected sel do
(
			fn_methd 27 sel
		)
on ddl28 selected sel do
(
			fn_methd 28 sel
		)
on ddl29 selected sel do
(
			fn_methd 29 sel
		)
on ddl30 selected sel do
(
			fn_methd 30 sel
		)
on ddl31 selected sel do
(
			fn_methd 31 sel
		)
on ddl32 selected sel do
(
			fn_methd 32 sel
		)
on ddl33 selected sel do
(
			fn_methd 33 sel
		)
on ddl34 selected sel do
(
			fn_methd 34 sel
		)
on ddl35 selected sel do
(
			fn_methd 35 sel
		)
on ddl36 selected sel do
(
			fn_methd 36 sel
		)
on ddl37 selected sel do
(
			fn_methd 37 sel
		)
on ddl38 selected sel do
(
			fn_methd 38 sel
		)
on ddl39 selected sel do
(
			fn_methd 39 sel
		)
on ddl40 selected sel do
(
	fn_methd 40 sel
)
on ddl41 selected sel do
(
			fn_methd 41 sel
		)
on ddl42 selected sel do
(
			fn_methd 42 sel
		)
on ddl43 selected sel do
(
			fn_methd 43 sel
		)
on ddl44 selected sel do
(
			fn_methd 44 sel
		)
on ddl45 selected sel do
(
			fn_methd 45 sel
		)
on ddl46 selected sel do
(
			fn_methd 46 sel
		)
on ddl47 selected sel do
(
			fn_methd 47 sel
		)
on ddl48 selected sel do
(
			fn_methd 48 sel
		)
on ddl49 selected sel do
(
			fn_methd 49 sel
		)
on ddl50 selected sel do
(
			fn_methd 50 sel
)


on tmr1 tick  do
(
	fn_UpdateLabel()
)		
)

createdialog autoRename	
addsubRollout autoRename.s_ListDocuments rollout_listDocuments
