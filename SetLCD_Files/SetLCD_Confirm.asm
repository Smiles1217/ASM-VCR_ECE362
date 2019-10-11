	XREF	disp, init_LCD, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, PB_Testing, Port_P, DelayCounter, PreviousMenu, Action_LoadVHS, ResetVariables, RTI_Load_VHS, RTI_Eject_VHS
	XDEF	SetLCD_Confirm

SetLCD_Confirm:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'C',disp	 ;Line 1 Start
           movb #'o',disp+1
           movb #'n',disp+2
           movb #'f',disp+3
           movb #'i',disp+4
           movb #'r',disp+5
           movb #'m',disp+6
           movb #' ',disp+7
           movb #'W',disp+8
           movb #'i',disp+9
           movb #'t',disp+10
           movb #'h',disp+11
           movb #' ',disp+12
           movb #'P',disp+13
           movb #'B',disp+14
           movb #':',disp+15
    
;*********************string initialization*********************
		
			LDD		#disp				;Load display.
			JSR		display_string		;Display the string.
			
			RTS