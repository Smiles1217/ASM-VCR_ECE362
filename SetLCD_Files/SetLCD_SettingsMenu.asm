	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter, PB_Testing, Port_P, PreviousMenu, ResetVariables, Enter_Date
	XREF 	Parent_Control_Disp, ConfPW, ConfirmPW, SSaverFlg, CurrSSSet, Wall_Clock, SECOND, CountMS, PlayPause, port_s, LEDVAL, PlayT
	XDEF	SetLCD_SettingsMenu

SetLCD_SettingsMenu:

;*********************string initializations*********************
           ;intializing string "disp" to be:
           ;"The value of the pot is:      ",0
           movb #' ',disp	 ;Line 1 Start
           movb #'S',disp+1
           movb #'e',disp+2
           movb #'t',disp+3
           movb #'t',disp+4
           movb #'i',disp+5
           movb #'n',disp+6
           movb #'g',disp+7
           movb #'s',disp+8
           movb #' ',disp+9
           movb #'M',disp+10
           movb #'e',disp+11
           movb #'n',disp+12
           movb #'u',disp+13
           movb #':',disp+14
           movb #' ',disp+15
              
;*********************string initialization*********************

        			MOVB	#4, Menu
	        		LDD		#disp
	        		JSR		display_string
			
Loop:	        LDAA 	ConfPW
		        	CMPA 	#1
		        	LBEQ 	ConfirmPss
			
		        	LDAA 	SSaverFlg
		        	CMPA 	#1
		        	LBEQ	PICKSS
			
		        	LDAA 	PlayPause			;If movie is playing, update the LEDs
		        	CMPA 	#1
		        	BEQ 	LOADLED
		        	BRA 	PMS
			
LOADLED:	    LDAA 	LEDVAL
		        	STAA 	port_s
			
PMS:		      MOVB  #32, Port_P
              JSR		Pot_Menu_Selector
			        LDAA	Option
			        CMPA	#1
			        BEQ		Parental
			        CMPA	#2
			        BEQ		SetDT
			        CMPA	#3
		        	BEQ		PrevMenu
			        BRA		Error
			
Parental:	    JSR		SetLCD_ParentPswrdSet
			        LDAA	Port_P
			        JSR		DelayCounter
			        CMPA	#0		;Bre 11/26/2018 If selected, 
			        BEQ		SetParCon	;Branch to jump to Parent_Control Display menu
			        BRA		Loop
			
SetDT:		    JSR		SetLCD_DateTime
		        	LDAA	Port_P
			        JSR		DelayCounter
		        	CMPA	#0
			        BEQ 	DTSet
		        	BRA		Loop
			
PrevMenu:	    JSR		SetLCD_PreviousMenu
			        LDAA	Port_P
			        JSR		DelayCounter
			        STAA	PB_Testing
			        CMPA	#0
			        BEQ		MenuSwitch
			        BRA		Loop
			
Error:		    JSR		SetLCD_Error
			        BRA		Loop
			
MenuSwitch:	  MOVB #0, SECOND
			        MOVB #0, CountMS
              LDAA	PreviousMenu
			        CMPA	#2
			        BEQ		GoMainMenu
			        JSR		SetLCD_StartMenu
			
GoMainMenu:	  JSR		SetLCD_MainMenu
			
SetParCon:	  MOVB #0, SECOND
			        MOVB #0, CountMS
			        JSR 	Parent_Control_Disp

ConfirmPss:	  JSR 	ConfirmPW

DTSet	        MOVB #0, SECOND
			        MOVB #0, CountMS
			        JSR 	Enter_Date
			
			        RTS
			
PICKSS:		    LDAA 	CurrSSSet
			        CMPA 	#0
			        BEQ		WC
			        CMPA 	#1
			        BEQ		PSS
			        LBRA	Loop
			
PSS:		      JSR		PlayT
			
WC:			      JSR 	Wall_Clock