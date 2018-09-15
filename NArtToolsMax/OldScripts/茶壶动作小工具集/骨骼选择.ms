macroScript boneend
	category:"ZZM动作工具"
	toolTip:"boneend"
(
Global BoneArray=#()
Global b=0
for i in objects do
	(
		BoneArray=for i in selection collect i
	)

rollout bon "骨骼选择" width:152 height:37
(
	button btn1 "下一个" pos:[5,5] width:52 height:26
	button btn2 "上一个" pos:[60,5] width:52 height:26
	button btn3 "刷新" pos:[115,5] width:34 height:26

	on btn1 pressed do
	(
	b+=1
	if b>bonearray.count then b=1
	select BoneArray[b]
	)
	on btn2 pressed do
	(
	b-=1
	if b<1 then b=bonearray.count
	select BoneArray[b]
	)
on btn3 pressed do
	(
BoneArray=#()
for i in objects do
	(
	if classof i==BoneGeometry and i.children.count==0 then append BoneArray i
	)
	b=0
	
	)	
)
createdialog bon
)