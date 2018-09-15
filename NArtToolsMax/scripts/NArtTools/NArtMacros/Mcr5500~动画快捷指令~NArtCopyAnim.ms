--prj£º
--panyuan 2015/5/25 @pwd
--1.copy the animation
--2.keep the offset

--version2.0 modified 2015/11/14
--function: adding keys copying from biped to bones
macroScript NArtCopyAnim
category:"_NArtTools"
toolTip:"Copy Animation"
buttontext:"¸´ÖÆ¶¯»­"
(
	on execute do
	(
		_scriptsDir = GetDir #userScripts
		_path = _scriptsDir + @"\NArtTools\NArtWindow\Win5500_NArtCopyAnim.ms"
		fileIn _path
	)
)