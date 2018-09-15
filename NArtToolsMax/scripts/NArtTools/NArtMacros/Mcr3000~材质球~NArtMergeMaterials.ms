--合并相同贴图的材质球
macroscript NArtMergeMaterials
category:"_NArtTools"
buttontext:"合并相同贴图的材质球"
tooltip:"Merge Same Materials"
(
	on execute do
	(
		_scriptsDir = GetDir #userScripts
		_path = _scriptsDir + @"\NArtTools\NArtAction\Ac3000_NArtMergeMaterials.ms"
		fileIn _path
	)
	
)