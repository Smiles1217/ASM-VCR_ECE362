	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter
	XDEF	SetLCD_MainMenuReturn

SetLCD_MainMenuReturn:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'R',disp+16 ;Line 2 Start
           movb #'e',disp+17
           movb #'t',disp+18
           movb #'u',disp+19
           movb #'r',disp+20
           movb #'n',disp+21
           movb #'>',disp+22
           movb #'M',disp+23
           movb #'a',disp+24
           movb #'i',disp+25 
           movb #'n',disp+26 
           movb #' ',disp+27 
           movb #'M',disp+28
           movb #'e',disp+29
           movb #'n',disp+30
           movb #'u',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************

		   RTS