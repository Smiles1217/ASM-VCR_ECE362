	XREF	disp, SetLCD_StartMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter, PB_Testing, Port_P, PreviousMenu, RTI_Load_VHS, RTI_Eject_VHS, ResetVariables, VHSLoaded, SwitchMenu, ConfPW
	XREF	ConfirmPW, SSaverFlg, CurrSSSet, Wall_Clock, SECOND, CountMS, PlayPause, port_s, LEDVAL, RecordN, PlayT, RecordL
	XDEF	SetLCD_MainMenu

SetLCD_MainMenu:

;*********************string initializations*********************
           ;intializing string "disp" to be:
           ;"The value of the pot is:      ",0
           movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #' ',disp+2
           movb #'M',disp+3
           movb #'a',disp+4
           movb #'i',disp+5
           movb #'n',disp+6
           movb #' ',disp+7
           movb #'M',disp+8
           movb #'e',disp+9
           movb #'n',disp+10
           movb #'u',disp+11
           movb #':',disp+12
           movb #' ',disp+13
           movb #' ',disp+14
           movb #' ',disp+15
              
;*********************string initialization*********************
			
		        	MOVB	#2, Menu
		        	MOVB  #2, PreviousMenu
		        	
		        	LDD		#disp
	        		JSR		display_string
			
Loop:	      	LDAA 	ConfPW
		        	CMPA 	#1
		        	LBEQ 	ConfirmPss
			
		        	LDAA 	SSaverFlg
		        	CMPA 	#1
		        	LBEQ	PICKSS
			
	        		LDAA 	PlayPause			;If movie is playing, update the LEDs
	        		CMPA 	#1
	        		BEQ 	LOADLED
			        BRA 	PMS
			
LOADLED:    	LDAA 	LEDVAL
			        STAA 	port_s
						
PMS:        	MOVB	#32, Port_P
              LDAA	SwitchMenu			;Load A with the SwitchMenu Value
			        LBNE	GoToStart			;If not equal to 0, branch to GoToStart to go back to the StartMenu
              JSR		Pot_Menu_Selector
		        	LDAA	Option
		        	CMPA	#1
	        		BEQ		PlayMovie
        			CMPA	#2
        			BEQ		RecordNow				;May want to add Bonus Feature Menu?
        			CMPA	#3
        			BEQ		RecordLater
	        		CMPA	#4
	        		BEQ		EjectVHS
	        		CMPA	#5
	        		LBEQ	Settings
	        		LBRA	Error
			
PlayMovie:   	JSR		SetLCD_PlayMovie
	        		LDAA	Port_P
	        		JSR		DelayCounter			;Debouncing for PB
		        	STAA	PB_Testing
		        	CMPA	#0
		        	BEQ		Release   		 		;Branch to PlayingVHS
		        	BRA		Loop

Release:      LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release
              LBRA  PlayingVHS
			
RecordNow:	  JSR		SetLCD_RecordNow
		        	LDAA	Port_P
		        	JSR		DelayCounter
	        		STAA	PB_Testing
	        		CMPA 	#0
	        		LBEQ 	Release1
	        		LBRA	Loop

Release1:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release1
              LBRA  StartRecN
			
RecordLater:  JSR		SetLCD_RecordLater
	        		LDAA	Port_P
		        	JSR		DelayCounter
		        	STAA	PB_Testing
		        	CMPA 	#0
		        	LBEQ 	Release2
		        	LBRA	Loop

Release2:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release2
              LBRA  StartRecL
			
EjectVHS:   	JSR		SetLCD_EjectVHS
	        		LDAA	Port_P
	        		JSR		DelayCounter
	        		STAA	PB_Testing
	        		CMPA	#0
	        		BEQ		Release3
	        		LBRA	Loop

Release3:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release3
              BRA   EjectingVHS
			
Settings:   	JSR		SetLCD_SelectSettingsMenu
	        		LDAA	Port_P
	        		JSR		DelayCounter
	        		STAA	PB_Testing
	        		CMPA	#0
	        		BEQ		Release4
	        		LBRA	Loop

Release4:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release4
              BRA   GoToSetting
			
Error:	    	JSR		SetLCD_Error
		        	LBRA	Loop

PlayingVHS:	  MOVB  #0, SECOND
			        MOVB  #0, CountMS
              JSR		SetLCD_PlayMenu			;Jump to the PlayMenu Subroutine
			
GoToSetting:  MOVB #0, SECOND
			        MOVB #0, CountMS
              JSR		SetLCD_SettingsMenu

GoToStart:  	MOVB  #0, SECOND
			        MOVB  #0, CountMS
              MOVB	#0,SwitchMenu		;Reset SwitchMenu value to 0 (No switch needed)
	        		JSR		SetLCD_StartMenu

ConfirmPss: 	JSR 	ConfirmPW

EjectingVHS:  MOVB	#0, RTI_Load_VHS
		        	MOVB	#1, RTI_Eject_VHS
		        	MOVB  #0, SECOND
			        MOVB  #0, CountMS
			        MOVB  #0, PlayPause
			        MOVB  #$FF, LEDVAL
			        MOVB  #0, CurrSSSet
		        	JSR		SetLCD_StartMenu

		        	RTS
		        	
PICKSS:		    LDAA 	CurrSSSet
		        	CMPA 	#0
			        BEQ		WC
	        		CMPA 	#1
	        		BEQ		PSS
	        		CMPA 	#2
	        		BEQ		StartRecN
		        	LBRA	Loop
			
PSS:	      	JSR		PlayT
			
WC:		      	JSR 	Wall_Clock

StartRecN:    MOVB #2, CurrSSSet		;Set the recording screen saver
		        	MOVB #1, PlayPause
		        	JSR  RecordN
		        	LBRA SetLCD_MainMenu 
			
StartRecL:  	JSR RecordL