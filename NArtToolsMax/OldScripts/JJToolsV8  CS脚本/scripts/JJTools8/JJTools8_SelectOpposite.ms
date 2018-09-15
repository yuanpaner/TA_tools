try
(
	with redraw off
	(
		-- create blank arrays
		global biped_array = #()
		global non_biped_array = #()
		global opposite_biped_array =#()
		global rootbone
	
		-- Functions
		-- Function to find the biped's root and split the selected objects into arrays based on 
		--  whether or not they are biped objects
		fn get_biped =
		(
			temparray = #()
			tempvar
			for i in selection do
			(
				if classOf i == Biped_Object then
				(	
					append biped_array i
					tempvar = i
				)
				else
				(
					append non_biped_array i
				)
			)
			RootBone = tempvar.controller.rootnode
			/*for i = 1 to 30 do
			(
				append temparray $.name
				tempparent = $.parent
				try(select tempparent)catch()
			)			
			RootBone = $*/
		)
		
		-- A hacky function to mirror any biped_array with the opposing objects
		fn mirror_biped_selection biped_bone =
		(
			case of
			(
				(biped_bone == (biped.getNode RootBone #rarm link:1)): (append opposite_biped_array (biped.getNode RootBone #larm link:1))
				(biped_bone == (biped.getNode RootBone #larm link:1)): (append opposite_biped_array (biped.getNode RootBone #rarm link:1))
				(biped_bone == (biped.getNode RootBone #rarm link:2)): (append opposite_biped_array (biped.getNode RootBone #larm link:2))
				(biped_bone == (biped.getNode RootBone #larm link:2)): (append opposite_biped_array (biped.getNode RootBone #rarm link:2))
				(biped_bone == (biped.getNode RootBone #rarm link:3)): (append opposite_biped_array (biped.getNode RootBone #larm link:3))
				(biped_bone == (biped.getNode RootBone #larm link:3)): (append opposite_biped_array (biped.getNode RootBone #rarm link:3))
				(biped_bone == (biped.getNode RootBone #rarm link:4)): (append opposite_biped_array (biped.getNode RootBone #larm link:4))
				(biped_bone == (biped.getNode RootBone #larm link:4)): (append opposite_biped_array (biped.getNode RootBone #rarm link:4))

				(biped_bone == (biped.getNode RootBone #rfingers link:1)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:1))
				(biped_bone == (biped.getNode RootBone #lfingers link:1)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:1))
				(biped_bone == (biped.getNode RootBone #rfingers link:2)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:2))
				(biped_bone == (biped.getNode RootBone #lfingers link:2)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:2))
				(biped_bone == (biped.getNode RootBone #rfingers link:3)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:3))
				(biped_bone == (biped.getNode RootBone #lfingers link:3)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:3))
				(biped_bone == (biped.getNode RootBone #rfingers link:4)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:4))
				(biped_bone == (biped.getNode RootBone #lfingers link:4)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:4))
				(biped_bone == (biped.getNode RootBone #rfingers link:5)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:5))
				(biped_bone == (biped.getNode RootBone #lfingers link:5)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:5))
				(biped_bone == (biped.getNode RootBone #rfingers link:6)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:6))
				(biped_bone == (biped.getNode RootBone #lfingers link:6)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:6))
				(biped_bone == (biped.getNode RootBone #rfingers link:7)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:7))
				(biped_bone == (biped.getNode RootBone #lfingers link:7)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:7))
				(biped_bone == (biped.getNode RootBone #rfingers link:8)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:8))
				(biped_bone == (biped.getNode RootBone #lfingers link:8)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:8))
				(biped_bone == (biped.getNode RootBone #rfingers link:9)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:9))
				(biped_bone == (biped.getNode RootBone #lfingers link:9)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:9))
				(biped_bone == (biped.getNode RootBone #rfingers link:10)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:10))
				(biped_bone == (biped.getNode RootBone #lfingers link:10)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:10))
				(biped_bone == (biped.getNode RootBone #rfingers link:11)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:11))
				(biped_bone == (biped.getNode RootBone #lfingers link:11)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:11))
				(biped_bone == (biped.getNode RootBone #rfingers link:12)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:12))
				(biped_bone == (biped.getNode RootBone #lfingers link:12)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:12))
				(biped_bone == (biped.getNode RootBone #rfingers link:13)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:13))
				(biped_bone == (biped.getNode RootBone #lfingers link:13)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:13))
				(biped_bone == (biped.getNode RootBone #rfingers link:14)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:14))
				(biped_bone == (biped.getNode RootBone #lfingers link:14)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:14))
				(biped_bone == (biped.getNode RootBone #rfingers link:15)): (append opposite_biped_array (biped.getNode RootBone #lfingers link:15))
				(biped_bone == (biped.getNode RootBone #lfingers link:15)): (append opposite_biped_array (biped.getNode RootBone #rfingers link:15))

				(biped_bone == (biped.getNode RootBone #rleg link:1)): (append opposite_biped_array (biped.getNode RootBone #lleg link:1))
				(biped_bone == (biped.getNode RootBone #lleg link:1)): (append opposite_biped_array (biped.getNode RootBone #rleg link:1))
				(biped_bone == (biped.getNode RootBone #rleg link:2)): (append opposite_biped_array (biped.getNode RootBone #lleg link:2))
				(biped_bone == (biped.getNode RootBone #lleg link:2)): (append opposite_biped_array (biped.getNode RootBone #rleg link:2))
				(biped_bone == (biped.getNode RootBone #rleg link:3)): (append opposite_biped_array (biped.getNode RootBone #lleg link:3))
				(biped_bone == (biped.getNode RootBone #lleg link:3)): (append opposite_biped_array (biped.getNode RootBone #rleg link:3))
				(biped_bone == (biped.getNode RootBone #rleg link:4)): (append opposite_biped_array (biped.getNode RootBone #lleg link:4))
				(biped_bone == (biped.getNode RootBone #lleg link:4)): (append opposite_biped_array (biped.getNode RootBone #rleg link:4))

				(biped_bone == (biped.getNode RootBone #rtoes link:1)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:1))
				(biped_bone == (biped.getNode RootBone #ltoes link:1)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:1))
				(biped_bone == (biped.getNode RootBone #rtoes link:2)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:2))
				(biped_bone == (biped.getNode RootBone #ltoes link:2)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:2))
				(biped_bone == (biped.getNode RootBone #rtoes link:3)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:3))
				(biped_bone == (biped.getNode RootBone #ltoes link:3)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:3))
				(biped_bone == (biped.getNode RootBone #rtoes link:4)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:4))
				(biped_bone == (biped.getNode RootBone #ltoes link:4)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:4))
				(biped_bone == (biped.getNode RootBone #rtoes link:5)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:5))
				(biped_bone == (biped.getNode RootBone #ltoes link:5)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:5))
				(biped_bone == (biped.getNode RootBone #rtoes link:6)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:6))
				(biped_bone == (biped.getNode RootBone #ltoes link:6)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:6))
				(biped_bone == (biped.getNode RootBone #rtoes link:7)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:7))
				(biped_bone == (biped.getNode RootBone #ltoes link:7)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:7))
				(biped_bone == (biped.getNode RootBone #rtoes link:8)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:8))
				(biped_bone == (biped.getNode RootBone #ltoes link:8)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:8))
				(biped_bone == (biped.getNode RootBone #rtoes link:9)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:9))
				(biped_bone == (biped.getNode RootBone #ltoes link:9)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:9))
				(biped_bone == (biped.getNode RootBone #rtoes link:10)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:10))
				(biped_bone == (biped.getNode RootBone #ltoes link:10)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:10))
				(biped_bone == (biped.getNode RootBone #rtoes link:11)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:11))
				(biped_bone == (biped.getNode RootBone #ltoes link:11)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:11))
				(biped_bone == (biped.getNode RootBone #rtoes link:12)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:12))
				(biped_bone == (biped.getNode RootBone #ltoes link:12)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:12))
				(biped_bone == (biped.getNode RootBone #rtoes link:13)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:13))
				(biped_bone == (biped.getNode RootBone #ltoes link:13)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:13))
				(biped_bone == (biped.getNode RootBone #rtoes link:14)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:14))
				(biped_bone == (biped.getNode RootBone #ltoes link:14)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:14))
				(biped_bone == (biped.getNode RootBone #rtoes link:15)): (append opposite_biped_array (biped.getNode RootBone #ltoes link:15))
				(biped_bone == (biped.getNode RootBone #ltoes link:15)): (append opposite_biped_array (biped.getNode RootBone #rtoes link:15))

				(biped_bone == (biped.getNode RootBone #spine link:1)): (append opposite_biped_array (biped.getNode RootBone #spine link:1))
				(biped_bone == (biped.getNode RootBone #spine link:2)): (append opposite_biped_array (biped.getNode RootBone #spine link:2))
				(biped_bone == (biped.getNode RootBone #spine link:3)): (append opposite_biped_array (biped.getNode RootBone #spine link:3))
				(biped_bone == (biped.getNode RootBone #spine link:4)): (append opposite_biped_array (biped.getNode RootBone #spine link:4))
				(biped_bone == (biped.getNode RootBone #spine link:5)): (append opposite_biped_array (biped.getNode RootBone #spine link:5))

				(biped_bone == (biped.getNode RootBone #tail link:1)): (append opposite_biped_array (biped.getNode RootBone #tail link:1))
				(biped_bone == (biped.getNode RootBone #tail link:2)): (append opposite_biped_array (biped.getNode RootBone #tail link:2))
				(biped_bone == (biped.getNode RootBone #tail link:3)): (append opposite_biped_array (biped.getNode RootBone #tail link:3))
				(biped_bone == (biped.getNode RootBone #tail link:4)): (append opposite_biped_array (biped.getNode RootBone #tail link:4))
				(biped_bone == (biped.getNode RootBone #tail link:5)): (append opposite_biped_array (biped.getNode RootBone #tail link:5))

				(biped_bone == (biped.getNode RootBone #head link:1)): (append opposite_biped_array (biped.getNode RootBone #head link:1))

				(biped_bone == (biped.getNode RootBone #pelvis link:1)): (append opposite_biped_array (biped.getNode RootBone #pelvis link:1))

				(biped_bone == (biped.getNode RootBone #neck link:1)): (append opposite_biped_array (biped.getNode RootBone #neck link:1))
				(biped_bone == (biped.getNode RootBone #neck link:2)): (append opposite_biped_array (biped.getNode RootBone #neck link:2))
				(biped_bone == (biped.getNode RootBone #neck link:3)): (append opposite_biped_array (biped.getNode RootBone #neck link:3))
				(biped_bone == (biped.getNode RootBone #neck link:4)): (append opposite_biped_array (biped.getNode RootBone #neck link:4))
				(biped_bone == (biped.getNode RootBone #neck link:5)): (append opposite_biped_array (biped.getNode RootBone #neck link:5))

				(biped_bone == (biped.getNode RootBone #pony1 link:1)): (append opposite_biped_array (biped.getNode RootBone #pony1 link:1))
				(biped_bone == (biped.getNode RootBone #pony2 link:1)): (append opposite_biped_array (biped.getNode RootBone #pony2 link:1))
				(biped_bone == (biped.getNode RootBone #pony1 link:2)): (append opposite_biped_array (biped.getNode RootBone #pony1 link:2))
				(biped_bone == (biped.getNode RootBone #pony2 link:2)): (append opposite_biped_array (biped.getNode RootBone #pony2 link:2))
				(biped_bone == (biped.getNode RootBone #pony1 link:3)): (append opposite_biped_array (biped.getNode RootBone #pony1 link:3))
				(biped_bone == (biped.getNode RootBone #pony2 link:3)): (append opposite_biped_array (biped.getNode RootBone #pony2 link:3))
				(biped_bone == (biped.getNode RootBone #pony1 link:4)): (append opposite_biped_array (biped.getNode RootBone #pony1 link:4))
				(biped_bone == (biped.getNode RootBone #pony2 link:4)): (append opposite_biped_array (biped.getNode RootBone #pony2 link:4))
				(biped_bone == (biped.getNode RootBone #pony1 link:5)): (append opposite_biped_array (biped.getNode RootBone #pony1 link:5))
				(biped_bone == (biped.getNode RootBone #pony2 link:5)): (append opposite_biped_array (biped.getNode RootBone #pony2 link:5))
				
				(biped_bone == (biped.getNode RootBone #prop1 link:1)): (append opposite_biped_array (biped.getNode RootBone #prop1 link:1))
				(biped_bone == (biped.getNode RootBone #prop2 link:1)): (append opposite_biped_array (biped.getNode RootBone #prop2 link:1))
				(biped_bone == (biped.getNode RootBone #prop3 link:1)): (append opposite_biped_array (biped.getNode RootBone #prop3 link:1))
				
			)	
		)
		get_biped()				
--				deselect $
		
		-- creates an array of all opposing biped bones
		for i = 1 to biped_array.count do
		(
			mirror_biped_selection(biped_array[i])	
		)
		
		-- adds the original non biped bones to the opposing array
		for i = 1 to non_biped_array.count do
		(
			append opposite_biped_array non_biped_array[i]
		)
		select opposite_biped_array
	)-- end redraw
)
catch(format"Could not mirror selection\n")
