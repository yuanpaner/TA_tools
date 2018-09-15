----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_OneArmedBandit.mcr
-- Compatible:		Max 5, 6, 7 and 8
-- Version:			v1.2
-- Started:      	13 June 2001
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
----------------------------------------------------------------------------------------
-- v1.0  -- 2001.06.13 -- First release
-- v1.2  -- 2005.11.10 -- Added support for Max 8
----------------------------------------------------------------------------------------
macroScript JJTools8_OneArmedBandit
category:"JJTools 8" 
toolTip:"One Armed Bandit" 
buttontext:"Gamble" 
icon:#("JJTools", 13)

(
	global Game_pos
	if game_pos == undefined then game_pos = [0,0]
	cash = 50
	number11 = 1
	number12 = 1
	number13 = 1
	number21 = 1
	number22 = 1
	number23 = 1
	number31 = 1
	number32 = 1
	number33 = 1
	randomHold = 0
	randomNudge = 0
	Nudges = 0
	jackpot = 25
	didIWin = 0
	Difficulty = 9
	holdfrequency = 5
	nudgefrequency = 5
	nudgeamount = 5
	bet = 1
		
	rollout OneArmedBanditRollout "Gamble" width:168 height:192
	(
		group ""
		(	
			spinner BetAmount "Bet" range:[1,cash,Bet] type:#integer width:50
			label MoneyLabel "Bank" across:2
			label MoneyValue "50"
			label NudgeLabel "Nudges" across:2
			label NudgeValue "0"
		)
		
		group ""
		(	
			button Nudge1 "Nudge" across:3 enabled:false width:45
			button Nudge2 "Nudge" enabled:false width:45
			button Nudge3 "Nudge" enabled:false width:45

			label Wheel11 "X" across:3
			label Wheel12 "X"
			label Wheel13 "X"		

			label Wheel21 "X" across:3
			label Wheel22 "X"
			label Wheel23 "X"		

			label Wheel31 "X" across:3
			label Wheel32 "X"
			label Wheel33 "X"		
		
			checkbutton Hold1 "Hold" across:3 enabled:false width:45
			checkbutton Hold2 "Hold" enabled:false width:45
			checkbutton Hold3 "Hold" enabled:false width:45
		)
		
		group ""
		(
			label Winner ""
			label WinnerLabel "" across:2
			label WinnerValue ""
		)
		
		group ""
		(
			button GambleButton "Gamble" width:150
		)
		
		fn CheckNumbers =
		(
			if number21 == number22 AND number21 == number23 then
			(
				Cash += jackpot*BetAmount.value
				MoneyValue.caption = Cash as string
				winner.caption = "JACKPOT!"
				winnerlabel.caption = "Winnings"
				WinnerValue.caption = (jackpot*BetAmount.value) as string
				BetAmount.enabled = true	
				Nudges = 0
				BetAmount.range = [1,cash,BetAmount.value]
				return 1
			)
			else
			(
				winner.caption = ""
				WinnerLabel.caption = ""
				WinnerValue.caption = ""
				return 0
			)
		)
		
		fn CheckNudges =
		(
			if Nudges == 0 then
			(
				BetAmount.enabled = true			
			)
		)
	
		fn ResetNumbers num =
		(
			if num == difficulty+1 then
			(
				num = 0
			)
		)
		
		fn UpdateNumbers =
		(
				if number21 == difficulty+1 then (number21 = 0)
				if number21 == 0 then (number11 = difficulty) else (number11 = number21-1)
				if number21 == difficulty then (number31 = 0) else (number31 = number21+1)
				
				if number22 == difficulty+1 then (number22 = 0)
				if number22 == 0 then (number12 = difficulty) else (number12 = number22-1)
				if number22 == difficulty then (number32 = 0) else (number32 = number22+1)
				
				if number23 == difficulty+1 then (number23 = 0)
				if number23 == 0 then (number13 = difficulty) else (number13 = number23-1)
				if number23 == difficulty then (number33 = 0) else (number33 = number23+1)
				
				Wheel11.caption = number11 as string
				Wheel12.caption = number12 as string
				Wheel13.caption = number13 as string		
				Wheel21.caption = number21 as string
				Wheel22.caption = number22 as string
				Wheel23.caption = number23 as string
				Wheel31.caption = number31 as string
				Wheel32.caption = number32 as string
				Wheel33.caption = number33 as string
		)
		
		fn enableNudges =
		(
			Nudge1.enabled = true
			Nudge2.enabled = true
			Nudge3.enabled = true			
		)
		
		fn disableNudges =
		(
			Nudge1.enabled = false
			Nudge2.enabled = false
			Nudge3.enabled = false			
		)

		fn enableHold =
		(
			Hold1.enabled = true
			Hold2.enabled = true
			Hold3.enabled = true
		)

		fn disableHold =
		(
			Hold1.enabled = false
			Hold2.enabled = false
			Hold3.enabled = false
		)
		
		fn enableBet =
		(
			BetAmount.enabled = true
		)
		
		fn disableBet =
		(
			BetAmount.enabled = false
		)
		
		fn enableGamble =
		(
			GambleButton.enabled = true
		)
		
		fn disableGamble =
		(
			GambleButton.enabled = false
		)
		
		fn updatecash =
		(
			MoneyValue.caption = Cash as string		
		)
		
		on GambleButton pressed do
		(		
			if cash != 0 then
			(
				cash -= BetAmount.value
				updatecash()
				if BetAmount.value >= cash then
				(
					BetAmount.value = cash
				)
				BetAmount.range = [1,cash,BetAmount.value]
				MoneyValue.caption = Cash as string		
			
				randomnudge = random 0 nudgefrequency
				if randomnudge == 1 then
				(
					enableNudges()
					Nudges = random 1 nudgeamount
					NudgeValue.caption = Nudges as string
					disableBet()
					randomhold = 0
				)
				else
				(
					disableNudges()
					Nudges = 0
					NudgeValue.caption = "0"
					enableBet()
					randomhold = random 0 holdfrequency	
				)
				
				if randomhold == 1 then 
				(
					enableHold()
				)
				else
				(
					disableHold()
				)				
				
				if Hold1.checked == true then (Hold1.checked = false) else (number21 = random 0 difficulty)		
				if Hold2.checked == true then (Hold2.checked = false) else (number22 = random 0 difficulty)			
				if Hold3.checked == true then (Hold3.checked = false) else (number23 = random 0 difficulty)
				
				UpdateNumbers()				
				checknumbers()	
				
				if Cash == 0 then 
				(	
					winner.caption = "Looser!"	
					disableBet()
					disableGamble()
				)
			)
			else 
			(
				winner.caption = "Not Enough Cash!"
				disableBet()
				disableGamble()
			)
		)
			
		on Nudge1 pressed do
		(
			number21 += 1
			Nudges -= 1
			NudgeValue.caption = Nudges as string
			if Nudges == 0 then (disableNudges())
			UpdateNumbers()			
			didIWin = checknumbers()
			if didIwin == 1 then
			(
				disableNudges()
				Nudges = 0
				NudgeValue.caption = Nudges as string
			)	
			CheckNudges()		
		)			
		on Nudge2 pressed do
		(
			number22 += 1
			Nudges -= 1
			NudgeValue.caption = Nudges as string
			if Nudges == 0 then (disableNudges())
			UpdateNumbers()			
			didIWin = checknumbers()
			if didIwin == 1 then
			(
				disableNudges()
				Nudges = 0
				NudgeValue.caption = Nudges as string
			)			
			CheckNudges()		
		)			
		on Nudge3 pressed do
		(
			number23 += 1
			Nudges -= 1
			NudgeValue.caption = Nudges as string
			if Nudges == 0 then (disableNudges())
			UpdateNumbers()			
			didIWin = checknumbers()		
			if didIwin == 1 then
			(
				disableNudges()
				Nudges = 0
				NudgeValue.caption = Nudges as string
			)			
			CheckNudges()		
		)	
	)
	
	try
	(
		game_pos = game.pos
		closerolloutfloater game
	)
	catch()
	
	game = newrolloutfloater "One Armed Bandit" 200 365
	game.pos = game_pos
	addrollout OneArmedBanditRollout game
)
