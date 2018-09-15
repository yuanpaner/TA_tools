MacroScript NArtAddSkinAndBones
Category:"_NArtTools" 
ButtonText:"添加skin修改器并添加单一骨骼"
Tooltip:"添加skin修改器并添加单一骨骼" 
(
    on isEnabled return (selection.count==1 and superclassof selection[1]==GeometryClass)
	On Execute do
	(
		modPanel.addModToSelection (Skin ()) ui:on	
		skinOps.AddBoneFromViewStart  (modPanel.GetcurrentObject())
	)
)