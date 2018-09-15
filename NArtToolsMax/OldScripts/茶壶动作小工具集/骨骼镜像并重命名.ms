	fn ResetScaleOfSelectedBones ask =
	(
		-- define the bone structure that contains the bone and its level in the hierarchy
		struct BoneLevel (index, level)
		local bones     = #()

		-- fill the array of bone structures. intialize the hierarchy level with 0
		for i = 1 to selection.count do
		(
			bones[i] = BoneLevel i 0		
		)

		-- calculate the hierarchy level for each bone in bones array. the hierarchy level
		-- is the number of ancestors between the current bone and the root node
		for i = 1 to bones.count do
		(
		  local node = selection[bones[i].index]
		  local n    = 0
		  do
		  (
			n    = n + 1
			node = node.parent
		  ) while (node != undefined)
		  bones[i].level = n
		)

		-- sort the bones array by the hierarchy level
		qsort bones (fn myLevel v1 v2 = (v1.level - v2.level))

		-- reset scale for all bones in the bones array
		--print "***resetting***"
		for i = 1 to bones.count do
		(
		    --print "----"
			--print bones[i]
			--print selection[bones[i].index]
			ResetScale selection[bones[i].index]
			if ask do correctNegativeStretch selection[bones[i].index] false
		)

	)




tp_getCoordCenter=getCoordCenter()
tp_getRefCoordSys=getRefCoordSys()

setRefCoordSys #world
setCoordCenter #system 

tp_OldSelArray=for i in selection collect i
tp_SelBones=for i in selection where classof i==BoneGeometry collect i
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

-------------------realign---------------
for i in selection do
(
	i.realignBoneToChild()
)


-------------------Reset Stretch--------------


-------------------ResetScale--------------

setRefCoordSys tp_getRefCoordSys
setCoordCenter tp_getCoordCenter

