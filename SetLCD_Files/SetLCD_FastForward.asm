	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter, PreviousMenu, MovieLength
	XDEF	SetLCD_FastForward

SetLCD_FastForward:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #'F',disp+18
           movb #'a',disp+19
           movb #'s',disp+20
           movb #'t',disp+21
           movb #' ',disp+22
           movb #'F',disp+23
           movb #'o',disp+24
           movb #'r',disp+25 
           movb #'w',disp+26 
           movb #'a',disp+27 
           movb #'r',disp+28
           movb #'d',disp+29
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