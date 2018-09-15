--�������ַ����Ĵ���

struct NArtName(
	
	--��ȡ�ϲ��ļ�������
	fn GetParentFloder _num= (
		
		if maxfilepath == "" do return ""
		
		_num -= 1
		
		filterNameArray = filterString maxfilepath "\\"
		
		if (_num < 0) or (_num > filterNameArray.count-1) do(
			return filterNameArray[filterNameArray.count]
		)
		
		_result = filterNameArray[filterNameArray.count - _num]
		
		return _result
	),
	 
	--����NArt�����淶��ȡID����
	fn GetParentFloderName = (
		return NArtName.GetParentFloder 0
	),
	
	--��ȡ��������
	fn GetCategoryName =(
		return NArtName.GetParentFloder 1
	),
	
	--��ȡ��Ŀ����
	fn GetProjectName =(
		return NArtName.GetParentFloder 2
	),
	
	--���ݴ��������ų�ǰ׺��ȡ����
	fn GetRealName _str = (
		
		if _str == "" do return ""
			
		_nameFile = getFileNameFile _str
		
		return subString _nameFile 1 -1
		
	),
	
	--����MAX�ļ������ų�ǰ׺��ȡ����
	fn GetMaxRealName = (
		
		if maxfilename == "" do return ""
			
		_nameFile = getFileNameFile maxfilename	
		
		_firstName = subString _nameFile 1 1
		if _firstName == "X" do(
			return subString _nameFile 1 -1
		)
		return _nameFile
	),
	
	--����ǰ׺
	fn AddPrefix _name _prefixStr = (
		if _prefixStr.count != 1 do return _name
		_firstName = subString _name 1 1
		if _firstName != _prefixStr do(
			_name = _prefixStr + _name
		)
		return _name
	),
	
	--����ģ��ǰ׺
	fn AddPrefix_G _name =(
		return NArtName.AddPrefix _name "G"
	),
	
	--�޸�ǰ׺ΪF
	fn ReplacePrefix _name = (
		_name = subString _name 2 -1

		_name = "F" + _name

		return _name
	),
	
	-------------------------------------------------------------------------------------------------------------
	--���������
	fn fn_GetKeyWord _Num _postStr= (
		m_strNum = _Num as string
		
		while  m_strNum.count< 4 do(
			m_strNum = "0"+m_strNum
		) 
		_newNameWord = m_strNum
		
		if _postStr !=undefined  then(
			_newNameWord = _newNameWord + _postStr	
		)
		return  _newNameWord
	),

	--����´洢·��
	fn fn_getNewPath _newNameWord =(
		_oldParentFileName = NArtName.GetParentFloderName()
		_oldPath = maxfilepath
		_newPath = substituteString _oldPath _oldParentFileName _newNameWord		
		return _newPath
	),
	
	-- ����������������
	fn fn_ReMaterialName _Obj _newNameWord=
	(
		if _Obj.Material != undefined do
			_Obj.Material.name="M"+_newNameWord
	),

	-- ������Bitmap����	
	fn fn_ReBitmapName _Obj _newNameWord=
	(
		if classof _Obj.Material == Standardmaterial do(
			if _Obj.Material.diffusemap != undefined  do
				_Obj.Material.diffusemap.name="B"+_newNameWord			
		)
		if classof _Obj.Material == Multimaterial do (
			if _Obj.Material[1].diffusemap != undefined  do
				_Obj.Material[1].diffusemap.name="B"+_newNameWord				
		)
	),

	-- ��������ͼ����		
	fn fn_ReTextureName _Obj  _newNameWord _newpath=
	(
		if classof _Obj.Material == Standardmaterial do(
			oldFilestr = _Obj.material.diffusemap.filename	
			_typestr =  getfilenameType oldFilestr
			_newPath= _newpath +"Textures\\"
			_filename = getfilenamefile oldFilestr
			_copyoldFilestr = _newPath + _filename + _typestr
			
			if not doesfileExist _copyoldFilestr do (
				_copyoldFilestr = oldFilestr
			)
			makedir _newPath 
			newTextureName=_newPath + "T"+_newNameWord + _typestr		

			renameFile _copyoldFilestr newTextureName
			_Obj.material.diffusemap.filename=newTextureName
		)	
		if classof _Obj.Material == Multimaterial do(
			oldFilestr = _Obj.material[1].diffusemap.filename	
			_typestr =  getfilenameType oldFilestr

			_newPath= _newpath +"Textures\\"
			_filename = getfilenamefile oldFilestr
			_copyoldFilestr = _newPath + _filename + _typestr
			
			if not doesfileExist _copyoldFilestr do (
				_copyoldFilestr = oldFilestr
			)
			makedir _newPath 
			newTextureName=_newPath + "T"+_newNameWord + _typestr		

			renameFile _copyoldFilestr newTextureName
			_Obj.material[1].diffusemap.filename=newTextureName
		)

		
	),	

	--������max�ļ�����	
	fn fn_ReMaxName _newNameWord _newpath=
	(
		oldMaxName = maxfilepath+maxfileName
		_Postfix2 = "" 
		_bool
		_strArray = maxfileName

		_newMaxName =""
		_newMaxName = _newpath+"X"+ _newNameWord+".max"			
		renameFile oldMaxName _newMaxName
		saveMaxFile _newMaxName
	),

	--��ȡ�ļ����	
	fn fn_GetNum = (
		_GetNum = ""
		_str = maxfilename
		_Next
		if _str != "" do(
			for i=1 to _str.count do(	
				
				_num =  bit.charAsInt _str[i]			
				if _num > 47 and _num < 58 then (					
					_GetNum = _GetNum + _str[i]
					_Next = true
				)else(
					if _Next == true do _Next = false						
				)
				if _Next == false do exit
			)
		)
		_number = _GetNum as number

		return _number
	),

	--��ȡ�ļ���׺	
	fn fn_GetPostfix = (
		_Postfix = ""
		_str = maxfilename
		_Next

		for i=1 to _str.count do(				
			_chr =  bit.charAsInt  _str[i]	
			if _Next == undefined   then(
				if _chr > 47 and _chr < 58 do _Next = false	
					
			)else(
				if _chr < 47 or _chr > 58 do _Next = true
				if _str[i] == "@" do exit	
				if _str[i] == "." do exit					
				if _Next == true do _Postfix += _str[i]
			)
		)
		_Postfix = substituteString _Postfix "_G" "" 
		return _Postfix
	),
	
	--ȥ����׺
	fn fn_RemovePostfix _name =(
		_splitName = filterString _name "_"
		_result = ""
		for i=1 to _splitName.count-1 do(
			_result += _splitName[i]
			if i!= _splitName.count-1 do _result+="_"				
		) 
		return _result
	),
	
	--���max�ļ���������
	fn fn_genAnimName _str = (
		_animstr = ""
		_Next = false
		for i=1 to _str.count do(	
				if _str[i] == "@"  do _Next = true
				if _Next == true do _animstr += _str[i]
				if _str[i] == "." do exit	
		)
		if (matchPattern _str pattern:"*_G") do (
			_animstr = "_G"
		)		
		return _animstr		
	),
	
	--�������ļ�	
	fn fn_ReNameFile _keword _animName  _newpath= (
		m_Geo=for i in objects where (classof i== PolyMeshObject or classof i== Editable_Poly) collect i
		for i in m_Geo do
		(				
			i.name="G"+_KeWord	
			try(
				NArtName.fn_ReMaterialName i _KeWord
				NArtName.fn_ReBitmapName i _KeWord
				NArtName.fn_ReTextureName i  _KeWord	_newpath	
			)catch(
				
			)
		)
		_maxname = _KeWord+_animName 
		NArtName.fn_ReMaxName _maxname  _newpath
	),	
	
-- ��������ļ�����
	fn fn_getDocumentsName =(
		_listOldName = #()
		_Documents =  getfiles (maxfilepath +"*.max")
		for _D in _Documents do (
			_namestr =filterstring _D "/\\"
			_filename =substituteString _namestr[_namestr.count] ".max" ""
			append _listOldName _filename
		)
		return _listOldName
	),
--  ������ɾ�� ���� 	
	fn fn_DelItem  _allList _delList=(
		_tempList = #()
		for _j=1 to _allList.count do(
			append _tempList ""
			_tempList[_j] = _allList[_j]			
		)		
		
		for i in _delList do (
			_m = finditem _tempList i
			if _m > 0 do deleteitem _tempList _m			
		)
		return _templist
	),

--�ı��ַ����еĿո�Ϊ���ַ�
	fn ChangeStrSpace _str _newChar = (
		
		_result =""
		
		for i = 1 to _str.count do(
			if _str[i]==" " then(			
				_str[i]=_newChar
			)
			_result += _str[i]
		)
		
		return _result
	),
	
--�ı䳡�����������������еĿո�Ϊ��_��
	fn ChangeAllNameSpace = (
		
		for i in objects do(
			_name = i.name
			
			_newChar = "_"
			
			_newName = NArtName.ChangeStrSpace _name _newChar
			
			i.name = _newName
		)
	),
	
-- ��Ų���λ��
	fn fn_GetStringIndex _index _Count =(
		_index = _index as string
			for  j =_index.count + 1 to _Count do(
				_index = "0"+ _index				
			)	
		return _index
	),
	
--�����ļ���·�����ض��ļ����滻�����Ʒ�����·��
--�磺������·���滻�ɽ�ɫ��·��
	fn ChangeFolderName _fullPath _oldFolder _newFolder =(
		_splitPath = filterstring _fullPath "\\"
		_length = _splitPath.count
		_result = ""
		for i = 1 to _length do(
			if _splitPath[i] == _oldFolder do(
				_splitPath[i] = _newFolder
			)
			_result += _splitPath[i]
			_result += "\\"
		)
		return _result
	),
	--panyuan
	--2015-4-9
	--standard name
	fn standardName oriname type = (
			 case type of
			 (
			  "G":(
				if(oriname[1]=="G") then (
				 newname = oriname
-- 				 print "standard name"
-- 				 print oriname
				 )
				else  
				 (
				 newname = "G" + oriname
				 )
			   )
			  "F":(
				 newname = subString oriname 2 -1
				 newname = "F" + newname
			   )
			  "P":(
				 newname = subString oriname 2 -1
				 newname = "P" + newname
			   )
			   "X":(
				--newname = subString oriname 2 -1
				--newname = "X" + newname
				if(oriname[1]=="X") then (
				 newname = oriname
				 print "standard name"
				 print oriname
				 )
				else 
				 (
				 newname = "X" + oriname
				 )
			   )
			   
			   "delFirstLetter":(
					newname = subString oriname 2 -1
			   )
			 
			  default:(
			   newname = oriname
			   )
			  )
			 return newname
	 
	 ),
	 /* ------------------------
	 delete stringName's last word by splitStr and add addStr in the end
	 eg.
	 splitname x "_" ".prefab"
	 input name :sceneA_buildA_typeA_01_07
	 output  : sceneA_buildA_typeA_01.prefab
	 
	------------------------*/
 
	fn splitname x splitStr addStr=
	(
		 tmpArray = filterString x splitStr
		 tmpStr = ""
		 j=1
		 for i in tmpArray where (j<tmpArray.count) do
		 (
		  tmpStr+=i
		  if(j!=(tmpArray.count-1))then
		  (
		   tmpStr=tmpStr+splitStr
			)
		  j+=1
		 
		  )
		 return ((tmpStr+addStr) as string)
	 
	 )
)
print "Load NArtName"