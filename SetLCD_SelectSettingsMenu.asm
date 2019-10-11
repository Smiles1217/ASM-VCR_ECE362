	XREF	disp, SetLCD_MainMenuReturn, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, DelayCounter
	XDEF	SetLCD_SelectSettingsMenu

SetLCD_SelectSettingsMenu:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp+16 ;Line 2 Start
           movb #'S',disp+17
           movb #'e',disp+18
           movb #'t',disp+19
           movb #'t',disp+20
           movb #'i',disp+21
           movb #'n',disp+22
           movb #'g',disp+23
           movb #'s',disp+24
           movb #' ',disp+25 
           movb #'M',disp+26 
           movb #'e',disp+27 
           movb #'n',disp+28
           movb #'u',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************
			
			LDD	#disp
			JSR display_string

		   	RTS