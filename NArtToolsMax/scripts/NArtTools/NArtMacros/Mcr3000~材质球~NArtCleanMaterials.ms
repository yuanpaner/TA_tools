--整理材质球
macroscript NArtCleanMaterials
category:"_NArtTools"
buttontext:"整理材质球"
tooltip:"CleanMaterials"
(
	on execute do
	(
		_scriptsDir = GetDir #userScripts
		_path = _scriptsDir + @"\NArtTools\NArtAction\Ac3000_NArtCleanMaterials.ms"
		fileIn _path
	)
	
)