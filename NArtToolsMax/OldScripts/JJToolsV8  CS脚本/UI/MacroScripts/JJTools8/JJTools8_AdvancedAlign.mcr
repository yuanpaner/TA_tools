----------------------------------------------------------------------------------------
-- Script Name:		JJTools8-AdvancedAlign.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v2.2
-- Started:      	13 June 2001
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v2.0  -- 2001.06.13 -- Second release
-- v2.1  -- 2004.10.29 -- First release
-- v1.3  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------

macroScript JJTools8_AdvancedAlign
category:"JJTools 8" 
toolTip:"Advanced Align" 
buttontext:"Advanced Align"  
icon:#("JJTools", 15)
( 

	global advancedAlign_floater
	global advancedAlign_pos = [790,0]

	rollout advancedAlign "Advanced Align" 
	( 	
		local cobj,
			  tobj 
		
		-- creates buttons
	   	group "Align" 
		(
	 		pickbutton firstobj  "First Object" toolTip:"Pick Object to be Aligned" width:100
	 		pickbutton secondobj "Target Object" toolTip:"Pick Object to Align to" width:100
	 		button localAlign "Align"
	 	)

 	 	on firstobj picked obj do 
		( 
			cobj = obj
			firstobj.text = obj.name 	
		) 

	 	on secondobj picked obj do 	
		(
	 		tobj = obj 
			secondobj.text = obj.name 
		) 
		
		-- aligns object 1 with object 2
	 	on localAlign pressed do 	
		( 
			try
			(
				cobj.rotation = tobj.rotation 		
				cobj.pos = tobj.pos 
			)
			catch
			(
				messageBox "The Objects could not be aligned!" title:"JJTools Error" beep:true
			)			
		) 
	)
	
	rollout AX2_about "About"
	(
		activeXControl ax2 "http://jimjagger.com/JPages/JJTools8_AdvancedAlign.htm" height:75 width:130 align:#center 
	)

	try
	(
		closerolloutfloater advancedAlign_floater
		advancedAlign_pos = advancedAlign_floater.pos
	)catch()
	advancedAlign_floater = newrolloutfloater "Advanced Align 1.1" 150 162
	advancedAlign_floater.pos = advancedAlign_pos
	addrollout advancedAlign advancedAlign_floater 
	addrollout AX2_about advancedAlign_floater rolledup:true
) 

