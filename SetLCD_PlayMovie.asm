	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter
	XDEF	SetLCD_PlayMovie

SetLCD_PlayMovie:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #'P',disp+19
           movb #'l',disp+20
           movb #'a',disp+21
           movb #'y',disp+22
           movb #' ',disp+23
           movb #'M',disp+24
           movb #'o',disp+25 
           movb #'v',disp+26 
           movb #'i',disp+27 
           movb #'e',disp+28
           movb #' ',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************

			LDD	#disp
			JSR display_string

		   	RTS