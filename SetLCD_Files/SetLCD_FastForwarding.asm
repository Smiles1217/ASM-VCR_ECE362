	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter, PreviousMenu, MovieLength, DC_Speed, Port_P, FForRewind, PB_Testing, StartPlaying, SwitchMenu, SECOND, CountMS
	XDEF	SetLCD_FastForwarding

SetLCD_FastForwarding:

;*********************string initializations*********************
           ;intializing string "disp" to be:

		   movb #' ',disp	 ;Line 1 Start
           movb #'F',disp+1
           movb #'a',disp+2
           movb #'s',disp+3
           movb #'t',disp+4
           movb #' ',disp+5
           movb #'F',disp+6
           movb #'o',disp+7
           movb #'r',disp+8
           movb #'w',disp+9
           movb #'a',disp+10
           movb #'r',disp+11
           movb #'d',disp+12
           movb #'i',disp+13
           movb #'n',disp+14
           movb #'g',disp+15
           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #' ',disp+19
           movb #' ',disp+20 
           movb #' ',disp+21 
           movb #' ',disp+22 ;The next two indicate the speed (Extra Feature?)
           movb #'X',disp+23 ;X
           movb #' ',disp+24 ;2, 4, 8, or 16
           movb #' ',disp+25 
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
		
Loop:	MOVB  #0,SECOND
		  MOVB  #0,CountMS
      MOVB	#32, Port_P
			LDAA	SwitchMenu			;Load A with the SwitchMenu Value
			LBNE	GoToStart			;If not equal to 0, branch to GoToStart to go back to the StartMenu

      LDAA	Port_P            ;Check the PB to see if we need to stop rewinding
			JSR		DelayCounter			;Debouncing for PB
			STAA	PB_Testing
			CMPA	#0
			BEQ		PlayVHS		 		;If equal to 0, branch to PlayVHS

			MOVB	#6,Menu
			JSR		Pot_Menu_Selector	;Load the Menu options for Rating display
			LDAA	Option
			MOVB	#9, DC_Speed
			CMPA	#1
			BEQ		FF2X
			MOVB	#11, DC_Speed
			CMPA	#2
			BEQ		FF4X
			MOVB	#13, DC_Speed
			CMPA	#3
			BEQ		FF8X
			MOVB	#15, DC_Speed
			BRA		FF16X
			
FF2X:	MOVB	#'2',disp+24
      MOVB	#' ',disp+25
			LDD		#disp
			JSR		display_string
			BRA		Loop

FF4X:	MOVB	#'4',disp+24
			MOVB	#' ',disp+25
			LDD		#disp
			JSR		display_string
			BRA		Loop

FF8X:	MOVB	#'8',disp+24
			MOVB	#' ',disp+25
			LDD		#disp
			JSR		display_string
			LBRA	Loop

FF16X:MOVB	#'1',disp+24
			MOVB	#'6',disp+25
			LDD		#disp
			JSR		display_string
			LBRA	Loop
		   
PlayVHS:    MOVB  #0,FForRewind
            JSR   SetLCD_PlayMenu
          
GoToStart:	MOVB	#0,SwitchMenu		;Reset SwitchMenu value to 0 (No switch needed)
            MOVB  #0,FForRewind
            MOVB  #0,StartPlaying
			      JSR		SetLCD_StartMenu
			RTS