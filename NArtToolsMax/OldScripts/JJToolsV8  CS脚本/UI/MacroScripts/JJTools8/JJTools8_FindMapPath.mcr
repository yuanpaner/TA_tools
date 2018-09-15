----------------------------------------------------------------------------------------
-- Script Name:		JJTools8-FindMapPath.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v2.1
-- Started:      	13 June 2001
-- Last Modified: 	10 November 2005
-- Code by:			Borislav Petrov
--				Jim Jagger
-- Modified by:		Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v2.0  -- 2001.06.13 -- Second release
-- v2.1  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroscript JJTools8_FindMapPath
category:"JJTools 8"
toolTip:"Find Map Path"
buttontext:"Find Path"
icon:#("JJTools", 30)

(
global fmp_floater 

rollout fmp_roll "Find Map Path"
(
	group "Initialise"
	(
		radiobuttons sub_search labels:#("Full Search", "Substring Search", "Starts With Substring")
		edittext search_path "Find:" text:"C:\\" fieldwidth:240 align:#left
		button assign_path "Configure Path" offset:[-80,10] 
		button go_find_it "Search Texture Paths" offset:[50,-30] height:30 width:150
	)
	
	group "Results"
	(
		radiobuttons do_what labels:#("Nothing","Select", "Hide", "Freeze")
		radiobuttons affect_who labels:#("Matching", "Mismatching")
		radiobuttons verbose_output labels:#("Display All","Display Matches","Display Errors")
	)
	
	on assign_path pressed do
	(
		new_path = getSavePath()
		if new_path != undefined then search_path.text = (new_path + "\\")
	)
	
	on go_find_it pressed do
	(
		fn subanim_collect mnode =
		(
			return_array = #()
			for i = 1 to mnode.numsubs do 
			(
				append return_array mnode[i]
			)
			return_array
		)

		found_objects = #()
		case sub_search.state of
		(
			1: format "FULL SEARCH FOR MAP PATH [%]\n" search_path.text
			2: format "SUBSTRING SEARCH FOR MAP PATH [%]\n" search_path.text
			3: format "STARTING SEARCH FOR MAP PATH [%]\n" search_path.text
		)
		
		for o in $* do
		(
			if o.material != undefined then
			(
				subanims_array = #(o.material)
				num_mats = subanims_array.count + 1

				i = 0
				while i < subanims_array.count do
				(
					i += 1
					r_array = subanim_collect (subanims_array[i])
					join subanims_array r_array
				)

				found_it = false
				for i = num_mats to subanims_array.count do
				(
					try
					(
						if classof (subanims_array[i].object) == Bitmaptexture then 
						(
							found_path = getfilenamepath (subanims_array[i].object.filename) 
		
							if sub_search.state == 1 and search_path.text == found_path then
							(
								if verbose_output.state < 3 then format "Object '%' uses the full specified path.\n" o.name
								found_it = true
							)
							if sub_search.state == 2 and (findstring found_path search_path.text) != undefined then
							(
								if verbose_output.state < 3 then format "Object '%' uses the specified substring in its path.\n" o.name
								found_it = true
							)
							if sub_search.state == 3 and (substring found_path 1 search_path.text.count == search_path.text) then
							(
								if verbose_output.state < 3 then format "Object '%' uses the specified substring as start of its path.\n" o.name
								found_it = true
							)		
						)
					)
					catch()--(format "%\n" "An Error has occured.")	
				)--end i loop
				if not found_it then 
				(
					if verbose_output.state == 1 or verbose_output.state == 3 then format "'%' does not use the specified path.\n" o.name
					if affect_who.state == 2 then append found_objects o
				)
				else
				(
					if affect_who.state == 1 then append found_objects o
				)
			)
			else
			(
				if affect_who.state == 2 then append found_objects o
				if verbose_output.state == 1 or verbose_output.state == 3 then format "Material: '%' does not have a material!\n" o.name
			)
		)--end o loop
		case do_what.state of
		(
			1: ()
			2: select found_objects
			3: (
					max select none
					hide found_objects 
				)
			4: (
					max select none
					freeze found_objects 
				)
		)
			format "\n"
	)--end on
)--end roll
	
rollout AX2_about "About"
(
	activeXControl ax2 "http://jimjagger.com/JPages/JJTools/JJTools8_FindMapPath.htm" height:75 width:130 align:#center 
)
	
try(closerolloutfloater fmp_floater)catch()
fmp_floater = newrolloutfloater "FindMapPath 1.0" 320 292
addrollout fmp_roll fmp_floater
addrollout AX2_about fmp_floater rolledup:true
)

