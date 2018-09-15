MacroScript NArtAddSkinAndBones
Category:"_NArtTools" 
ButtonText:"Add Skin And Add One Bone"
Tooltip:"Add Skin And Add One Bone" 
(
    on isEnabled return (selection.count==1 and superclassof selection[1]==GeometryClass)
	On Execute do
	(
		modPanel.addModToSelection (Skin ()) ui:on	
		skinOps.AddBoneFromViewStart  (modPanel.GetcurrentObject())
	)
)