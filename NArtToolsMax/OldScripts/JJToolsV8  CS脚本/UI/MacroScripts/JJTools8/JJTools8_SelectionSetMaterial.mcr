----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_SelectionSetMaterial.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v2.1
-- Started:      	13 June 2001
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v2.0  -- 2004.06.02 -- Re-release
-- v2.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroscript JJTools8_SelectionSetMaterial
category:"JJTools 8"
toolTip:"Organise Material Selection Sets"
buttontext:"Material Set"
icon:#("JJTools", 35)
(	
	fn reset_selection_sets =
	(
		try
		(
			for i = 1 to 50 do
			(
				deleteItem selectionSets 1
				i += 1
			)
		)
		catch()
	)	
	
	fn init_material_selection_sets =
	(		
		for m in sceneMaterials do
		(
			collect_objects = #()
				
			for i in Geometry do
			(
				if i.material == m then
				(
					append collect_objects i
				)
			)
			selectionSets["!Material: "+m.name] = collect_objects
		)
	)
	
	max unhide all
	init_material_selection_sets()
)

