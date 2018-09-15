--根据diffusemap贴图的名称 重命名材质球
macroscript NArtRenameStandardMat
category:"_NArtTools"
buttontext:"根据贴图名重命名材质球"
tooltip:"Rename Materials as Diffusemap"
(
	on execute do
	(
		_scriptsDir = GetDir #userScripts
		_path = _scriptsDir + @"\NArtTools\NArtAction\Ac3000_NArtRenameStandardMat.ms"
		fileIn _path
	)
	
)