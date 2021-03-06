	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter, PreviousMenu, MovieLength, DC_Speed, Port_P, FForRewind, PB_Testing, SwitchMenu, StartPlaying, LoadingDots
	XDEF	SetLCD_EjectingVHS

SetLCD_EjectingVHS:

;*********************string initializations*********************
           ;intializing string "disp" to be:

		       movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #' ',disp+2
           movb #' ',disp+3
           movb #'E',disp+4
           movb #'j',disp+5
           movb #'e',disp+6
           movb #'c',disp+7
           movb #'t',disp+8
           movb #'i',disp+9
           movb #'n',disp+10
           movb #'g',disp+11
           movb #' ',disp+12
           movb #' ',disp+13
           movb #' ',disp+14
           movb #' ',disp+15
           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #' ',disp+19
           movb #' ',disp+20 
           movb #'V',disp+21 
           movb #'H',disp+22
           movb #'S',disp+23 
           movb #' ',disp+24 ;.
           movb #' ',disp+25 ;.
           movb #' ',disp+26 ;.
           movb #' ',disp+27 
           movb #' ',disp+28 
           movb #' ',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************

		;Get disp to display.
		
		       LDAA   LoadingDots       ;Based on whether or not LoadingDots is 1, 2, or 3
		       BEQ    EDisplay          ;This section of code will show 1, 2, or 3 dots on the LCD
		       MOVB   #'.',disp+24
		       CMPA   #1
		       BEQ    EDisplay
		       MOVB   #'.',disp+25
		       CMPA   #2
		       BEQ    EDisplay
		       MOVB   #'.',disp+26		       
		
EDisplay:	 LDD		#disp				      ;Load display.
	         JSR		display_string		;Display the string.
	         
	         RTS