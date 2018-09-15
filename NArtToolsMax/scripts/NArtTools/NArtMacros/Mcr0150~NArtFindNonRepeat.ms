-- 2015/6/25 by py @pwd
-- function:select single obj

macroScript NArtFindNonRepeat
category:"_NArtTools"
ButtonText:"FF_Map Search single obj"
toolTip:"FF_Map Search single obj"
(
	on execute do(

		clearListener()
		
		for i in objects where (isGroupHead i) do setgroupopen i true

		geoname = for i in geometry collect (NArtName.fn_RemovePostfix i.name)
		geoNonRe = #()
			
		nonRepeat = #()
		for i in geoname do
		(
			_exe = "$"+i+"* as array"
			temparr = execute _exe
			if temparr.count<=1 then (append nonRepeat i;append geoNonRe temparr[1])
			
			)
		print nonRepeat.count
			
		for i in nonRepeat do print i
		select geoNonRe

	)
)
