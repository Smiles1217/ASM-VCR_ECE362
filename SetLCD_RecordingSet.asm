	XREF	disp, init_LCD, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, PB_Testing, Port_P, DelayCounter, PreviousMenu, Action_LoadVHS, ResetVariables, RTI_Load_VHS, RTI_Eject_VHS
	XDEF	SetLCD_RecordingSet

SetLCD_RecordingSet:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #' ',disp+2
           movb #'R',disp+3
           movb #'e',disp+4
           movb #'c',disp+5
           movb #'o',disp+6
           movb #'r',disp+7
           movb #'d',disp+8
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
           movb #' ',disp+21 
           movb #'S',disp+22
           movb #'e',disp+23 
           movb #'t',disp+24 
           movb #' ',disp+25 
           movb #' ',disp+26 
           movb #' ',disp+27 
           movb #' ',disp+28 
           movb #' ',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'
    
;*********************string initialization*********************
		
			    LDD		#disp				      ;Load display.
			    JSR		display_string		;Display the string.
				  
				  
				  LDY   #60000
			    LDAA  #20

Loop:		  DEY
			    BEQ   Next 
			    BRA   Loop

Next:		  DECA 
			    BEQ   Return
			    BRA   Loop
			
Return:		JSR   SetLCD_MainMenu