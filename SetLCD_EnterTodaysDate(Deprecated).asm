	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter, PreviousMenu, MovieLength
	XDEF	SetLCD_EnterTodaysDate

SetLCD_EnterTodaysDate:

;*********************string initializations*********************
           ;intializing string "disp" to be:

		   movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #'T',disp+2
           movb #'o',disp+3
           movb #'d',disp+4
           movb #'a',disp+5
           movb #'y',disp+6
           movb #'s',disp+7
           movb #' ',disp+8
           movb #'D',disp+9
           movb #'a',disp+10
           movb #'t',disp+11
           movb #'e',disp+12
           movb #':',disp+13
           movb #' ',disp+14
           movb #' ',disp+15
           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #' ',disp+19 ;#
           movb #' ',disp+20 ;#
           movb #'/',disp+21 ;/
           movb #' ',disp+22 ;#
           movb #' ',disp+23 ;#
           movb #'/',disp+24 ;/
           movb #' ',disp+25 ;#
           movb #' ',disp+26 ;#
           movb #' ',disp+27 ;#
           movb #' ',disp+28 ;#
           movb #' ',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************

		;Get disp to display.
		
		LDAA	Menu				;Loads the value of the previous menu into A.
		STAA	PreviousMenu		;Stores it as the previous menu
		LDD		#disp				;Load display.
		JSR		display_string		;Display the string.
		
		
		   
		RTS