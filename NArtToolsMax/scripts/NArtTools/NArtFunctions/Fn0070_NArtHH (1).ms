
struct NArtHH(
	--创建HH
	fn CreateNewHH _name _pos=(
		_newHH = point pos:_pos wirecolor:orange size:10 centermarker:false box:true cross:true
		_newHH.name = "HH_" + _name
		return _newHH
	),
	
	--创建常用HH
	fn CteateCommonHH =(
		
		_topHH = undefined
		
		_middleHH = undefined
		_middle0HH = undefined
		
		_shootHH =undefined	
		_shoot0HH =undefined
		
		_weaponHH = undefined
		_rotValue = eulerangles 90 0 0

		for i in Helpers do(
			i.name
			if i.name =="HH_top" do (
				_topHH = i
			)
			
			if i.name =="HH_middle" do (
				_middleHH = i
			)			
			if i.name =="HH_middle0" do (
				_middle0HH = i
			)			
				
			if i.name =="HH_shoot" do (
				_shootHH = i				
			)				
			if i.name =="HH_shoot0" do (
				_shoot0HH = i				
			)
			
			if i.name =="HH_weapon" do (
				_weaponHH = i				
			)
			
		)

		
		if _topHH == undefined do
			_topHH = NArtHH.CreateNewHH "top" [0, 0, 200]
		
		if _middleHH == undefined do(
			_middleHH = NArtHH.CreateNewHH "middle" [0, 0, 100]
			rotate _middleHH _rotValue
		)

		
		if _middle0HH == undefined do(
			_middle0HH = NArtHH.CreateNewHH "middle0" [0, 0, 100]
			rotate _middle0HH _rotValue
		)
		
		if _shootHH == undefined do(
			_shootHH = NArtHH.CreateNewHH "shoot" [0, -100, 100]
			rotate _shootHH _rotValue
		)
		
		if _shoot0HH == undefined do(
			_shoot0HH = NArtHH.CreateNewHH "shoot0" [0, -100, 100]
			rotate _shoot0HH _rotValue
		)
		
		
		if matchpattern maxfilename pattern: "*_pc_*"do(
			if _weaponHH == undefined do
				_weaponHH = NArtHH.CreateNewHH "weapon" [-28, 0, 72]
			
			_Rhand = undefined
			for i in objects  where matchpattern i.name pattern: "*_R_Hand" do  _Rhand = i
			
			if _Rhand != undefined do(
				_weaponHH.transform = _Rhand.transform
				_weaponHH.parent = _Rhand
			)			
		)

		
		
		_middleBone = $Bip001_Spine1
		
		if _middleBone == undefined then(
			_middleBone = $Bip001_Spine 
		)
		
		if _middleBone != undefined do(
			_middleHH.transform = _middleBone.transform
			_middleHH.parent = _middleBone
		)
		
	)
	
)

print "Load NArtHH"

