macroScript NArtMirrorMorpher
category:"_NArtTools"
buttontext:"Mirror Morpher"
tooltip:"Mirro rMorpher"
(	
	on execute do
	(
		_scriptsDir = GetDir #userScripts
		_path = _scriptsDir + @"\NArtTools\NArtWindow\Win0110_NArtMirrorMorpher.ms"
		fileIn _path
	)
)