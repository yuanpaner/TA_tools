print "Ñ¡ÔñbipedÖÊÐÄ"

tp_boneroot=#()
for i in objects do
(
	tp_getRootData=getappdata i 20110328
	if tp_getRootData=="Root" do append tp_boneroot i
)
select tp_boneroot
if tp_ignoreBip!=true do
(
	for i in geometry do
	(
		if classof i==biped_object do	
		(
			Select (Biped.GetNode i #turn)
			if getCommandPanelTaskMode()!=#motion do setCommandPanelTaskMode #motion
			Exit
		)
	)
)