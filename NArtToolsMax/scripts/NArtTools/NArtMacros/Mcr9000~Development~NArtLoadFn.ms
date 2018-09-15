macroscript NArtLoadFN
category:"_NArtTools"
tooltip:"Load Functions"
buttontext:"Load Functions"
(
	
	on execute do(
		try
		(
			filepath = getDir #userStartupScripts
			files = getFiles (filepath+@"\*.ms")
			if files.count==1 and (filenamefrompath files[1]=="NArtStart.ms") then
			(
				filein files[1]
				
				)
			)catch (print " \"NArtStart.ms\" Load failed!")
	)

)