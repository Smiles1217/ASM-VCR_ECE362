	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter
	XDEF	SetLCD_Error

SetLCD_Error:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp	 ;Line 1 Start
           movb #'C',disp+1
           movb #'a',disp+2
           movb #'n',disp+3
           movb #'n',disp+4
           movb #'o',disp+5
           movb #'t',disp+6
           movb #' ',disp+7
           movb #'G',disp+8
           movb #'o',disp+9
           movb #' ',disp+10
           movb #'B',disp+11
           movb #'a',disp+12
           movb #'c',disp+13
           movb #'k',disp+14
           movb #' ',disp+15
           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #'W',disp+18
           movb #'h',disp+19
           movb #'i',disp+20
           movb #'l',disp+21
           movb #'e',disp+22
           movb #' ',disp+23
           movb #'P',disp+24
           movb #'l',disp+25 
           movb #'a',disp+26 
           movb #'y',disp+27 
           movb #'i',disp+28
           movb #'n',disp+29
           movb #'g',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************

			LDD	#disp
			JSR display_string

		   	RTS