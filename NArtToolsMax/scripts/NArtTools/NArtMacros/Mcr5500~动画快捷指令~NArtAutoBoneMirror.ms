--骨骼镜像并重命名R/L(骨骼命名时R与L表示左右，必须用"_"分隔开)--
macroscript NArtAutoBoneMirror
category:"_NArtTools"
buttontext:"骨骼镜像并重命名R/L"
tooltip:"骨骼镜像并重命名R/L"
(
	on execute do(
		NArtName.ScriptFileIn "Act5500_NArtAutoBoneMirror"	
	)
)