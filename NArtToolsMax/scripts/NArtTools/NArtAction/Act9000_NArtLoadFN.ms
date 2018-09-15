print "重新加载NArt工具"

try
(
	filepath = getDir #userStartupScripts
	files = getFiles (filepath + @"\*.ms")
	if files.count==1 and (filenamefrompath files[1]=="NArtStart.ms") then
	(
		filein files[1]
	)
)catch (print " \"NArtStart.ms\" Load failed!")