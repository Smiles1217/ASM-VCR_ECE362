	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter
	XDEF	SetLCD_DateTime

SetLCD_DateTime:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #'S',disp+18
           movb #'e',disp+19
           movb #'t',disp+20
           movb #' ',disp+21
           movb #'D',disp+22
           movb #'a',disp+23
           movb #'t',disp+24
           movb #'e',disp+25 
           movb #'/',disp+26 
           movb #'T',disp+27 
           movb #'i',disp+28
           movb #'m',disp+29
           movb #'e',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************
			
			LDD	#disp
			JSR display_string

		   	RTS