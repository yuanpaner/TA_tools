MacroScript tp_Skin_and_Add_Bones
ButtonText:"TP Skin and Add Bones"
Category:"自定义工具" 
Tooltip:"TP Skin and Add Bones" 
(
    on isEnabled return (selection.count==1 and superclassof selection[1]==GeometryClass)
	On Execute do
	(
		modPanel.addModToSelection (Skin ()) ui:on	
		skinOps.AddBoneFromViewStart  (modPanel.GetcurrentObject())
	)
)
