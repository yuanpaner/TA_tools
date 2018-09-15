macroScript NArtCheckUV2
category:"_NArtTools"
buttontext:"检查有无二套UV"
tooltip:"检查有无二套UV"
(	
	on execute do
	(
		clearListener()
		errorArray = #()
		objs;
		if selection.count==0 then objs = geometry else objs = selection
		for obj in objs where (not(NArtCheck.checkChannel obj 2)) do append errorArray obj
		print errorArray
		select errorArray
	)
)