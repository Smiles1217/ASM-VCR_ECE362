	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter, PreviousMenu, MovieLength
	XDEF	SetLCD_RequestPassword

SetLCD_RequestPassword:

;*********************string initializations*********************
           ;intializing string "disp" to be:

		       movb #'E',disp	 ;Line 1 Start
           movb #'n',disp+1
           movb #'t',disp+2
           movb #'e',disp+3
           movb #'r',disp+4
           movb #' ',disp+5
           movb #'P',disp+6
           movb #'a',disp+7
           movb #'s',disp+8
           movb #'s',disp+9
           movb #'w',disp+10
           movb #'o',disp+11
           movb #'r',disp+12
           movb #'d',disp+13
           movb #':',disp+14
           movb #' ',disp+15
           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #' ',disp+19
           movb #' ',disp+20 
           movb #' ',disp+21 ;The next 4 will be the passcode input digits (if we make it show **** instead of the code)
           movb #' ',disp+22 ;*									  (we could have it show the input as an extra feature?)
           movb #' ',disp+23 ;*
           movb #' ',disp+24 ;*
           movb #' ',disp+25 ;*
           movb #' ',disp+26 
           movb #' ',disp+27 
           movb #' ',disp+28 
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
		
		;Need to implement the part where the DC motor varies in speed based on the potentiometer
		   
		RTS