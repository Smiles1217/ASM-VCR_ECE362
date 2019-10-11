	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter
	XDEF	SetLCD_LoadVHS

SetLCD_LoadVHS:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #'L',disp+19
           movb #'o',disp+20
           movb #'a',disp+21
           movb #'d',disp+22
           movb #' ',disp+23
           movb #'a',disp+24
           movb #' ',disp+25 
           movb #'T',disp+26 
           movb #'a',disp+27 
           movb #'p',disp+28
           movb #'e',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************
			
			LDD	#disp
			JSR display_string

		   	RTS