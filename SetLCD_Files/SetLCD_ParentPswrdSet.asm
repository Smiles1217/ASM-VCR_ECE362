	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter
	XDEF	SetLCD_ParentPswrdSet

SetLCD_ParentPswrdSet:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'P',disp+16 ;Line 2 Start
           movb #'a',disp+17
           movb #'r',disp+18
           movb #'e',disp+19
           movb #'n',disp+20
           movb #'t',disp+21
           movb #'a',disp+22
           movb #'l',disp+23
           movb #' ',disp+24
           movb #'C',disp+25 
           movb #'o',disp+26 
           movb #'n',disp+27 
           movb #'t',disp+28
           movb #'r',disp+29
           movb #'o',disp+30
           movb #'l',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************
			
			LDD	#disp
			JSR display_string

		   	RTS