	XREF	disp, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, DelayCounter, PB_Testing, Port_P, PreviousMenu, ResetVariables, MovieLength, Alternator, SetLCD_PlayButton, PreviousAlternate, Counter, SwitchMenu, StartPlaying, FForRewind, SetLCD_FastForwarding, SetLCD_Rewinding, Port_t, SongDone
	XREF 	ConfirmPW, SSaverFlg, CurrSSSet, Wall_Clock, SECOND, CountMS, PlayT, LEDVAL, PlayPause, port_s, ConfPW, MovieDone
	XDEF	SetLCD_PlayMenu

SetLCD_PlayMenu:

;*********************string initializations*********************
           ;intializing string "disp" to be:
           ;"The value of the pot is:      ",0
           movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #' ',disp+2
           movb #'P',disp+3
           movb #'l',disp+4
           movb #'a',disp+5
           movb #'y',disp+6
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

		        	MOVB	#3, Menu
		        	LDD		#disp
		          JSR		display_string

Loop:		      LDAA  MovieDone
              LBNE  GoToMain

              LDAA 	ConfPW
			        CMPA 	#1
			        LBEQ 	ConfirmPss
			
		        	LDAA 	SSaverFlg			        ;See if it's time to turn on the screen saver
			        CMPA 	#1
			        LBEQ	PICKSS
			
		        	LDAA 	PlayPause			        ;If movie is playing, update the LEDs
			        CMPA 	#1
		        	BEQ 	LOADLED
		        	BRA 	PMS
			
LOADLED:    	LDAA 	LEDVAL
			        STAA 	port_s
			
PMS:		      MOVB  #32, Port_P
              LDAA	SwitchMenu			      ;Load A with the SwitchMenu Value
			        LBNE	GoToStart			        ;If not equal to 0, branch to GoToStart to go back to the StartMenu
              JSR		Pot_Menu_Selector	    ;Chose menu selections
			        LDAA	Option 				        ;Load the option number into A
			        CMPA	#1					
		        	LBEQ	PlayM				          ;Option 1: Play movie.
        			CMPA	#2
        			LBEQ	FastF				          ;Option 2: Fast forward	
	        		CMPA	#3
	        		LBEQ 	ReWind				        ;Option 3: Rewind
	        		CMPA	#4
	        		LBEQ	PrevM				          ;Option 4: Previous Menu
	        		LBRA	Error
		
PlayM:	    	LDAA	Alternator			      ;Check the Alternator Value
			        BEQ		StartMovie			      ;If Equal to 0, show "Play Movie"
			        CMPA	#1					          ;Else, if Equal to 1, show "Play"
			        BEQ		PlayOption			      ;Else, branch to "Repeat" (Equal to 2 or 3)
			        BRA		CheckAlter			      ;Branch to Checking the Alternator before the PB (this is to fix LCD display issues)
			
StartMovie:	  MOVB	#1,Alternator		      ;Initially Set the Alternator to 1
			        JSR		SetLCD_PlayMovie	    ;Display "Play Movie" on the LCD
			        BRA		CheckAlter			      ;Branch to Checking the Alternator before the PB (this is to fix LCD display issues)

PlayOption:	  LDAA	Counter
			        BEQ		Length_M
			        JSR		SetLCD_PlayButton	    ;Display "Play" on the LCD
		        	BRA		CheckPB				        ;Branch to Checking the PB
			
CheckPB:    	LDAA	Port_P				        ;Check to see if the PB is Pressed
			        JSR		DelayCounter
		        	STAA	PB_Testing
Return:		    CMPA	#0					          ;If Pressed, look at the Alternator Value
			        BEQ		Release		
			        LBRA	Loop	

Release:      LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release
			
SwitchOpt:	  LDAA	Alternator			      ;Determine whether to show "Playing" or "Paused"
			        CMPA	#2
			        BEQ		SwitchPlay
		        	CMPA	#3
			        BEQ		SwitchPause
		        	MOVB	#2, Alternator
			        MOVB  #2, SongDone
			        MOVB  #0, SECOND
			        MOVB  #0, CountMS
			        MOVB  #$FF, LEDVAL	        ;Initalize LED value to start with all values on
			        MOVB  #1, CurrSSSet
			        LBRA	Loop

SwitchPlay:   MOVB	#3,Alternator		      ;Switch the Alternator Value and then run through normally to display to LCD
		        	BRA		CheckAlter

SwitchPause:  MOVB	#2,Alternator		      ;Switch the Alternator Value and then run through normally to display to LCD
		        	BRA		CheckAlter
			
CheckAlter:	  LDAA	Alternator			      ;Check the Alternator Value
		        	CMPA	#1
			        BEQ		PlayOption			      ;Else, if Equal to 1, Branch to "PlayOption"
		        	CMPA	#2					          ;Else, if Equal to 2, Branch to "Playing"
		        	BEQ		Playing				        ;Else, Branch to "Paused" (Equal to 3)
		        	BRA		Paused
			
Length_M:	    INC		Counter
		        	JSR		MovieLength			      ;Ask the user to enter the length of the movie
			
Playing:    	MOVB	#1,StartPlaying		    ;Set StartPlaying to 1, so that the RTI knows to start the DC Motor
              MOVB	#1,PlayPause
              BSET	Port_t, #$8		        ;Set bit 3 of Port_t_DCMotor
			        JSR 	SetLCD_Playing		    ;Display "Playing" on the LCD
		        	BRA		CheckPB				        ;Once the Option is Displayed, branch to Check the PB
			
Paused:	    	MOVB	#0,StartPlaying		    ;Set StartPlaying to 0, so that the RTI knows to stop the DC Motor
              MOVB	#2,PlayPause
              BCLR	Port_t, #$8		        ;Clear bit 3 of Port_t_DCMotor
			        JSR		SetLCD_Paused		      ;Display "Paused" on the LCD
			        LBRA	CheckPB				        ;Once the Option is Displayed, branch to Check the PB
			
			
FastF:		    MOVB  #0,SECOND
		          MOVB  #0,CountMS
              JSR		SetLCD_FastForward
			        LDAA	Port_P
			        JSR		DelayCounter
			        STAA	PB_Testing
			        CMPA	#0
			        BEQ   Release1
			        LBRA	Loop
			        
GoFastF:			MOVB	#1,FForRewind
		        	JSR		SetLCD_FastForwarding
		        	
Release1:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release1
              BRA   GoFastF
			
			
ReWind:		    MOVB  #0,SECOND
		          MOVB  #0,CountMS
              JSR		SetLCD_Rewind
			        LDAA	Port_P
			        JSR		DelayCounter
			        STAA	PB_Testing
			        CMPA	#0
			        BEQ   Release2
			        LBRA	Loop
			        			        
GoReWind:    	MOVB	#2,FForRewind
			        JSR		SetLCD_Rewinding
			
Release2:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release2
              BRA   GoReWind			
			
PrevM:		    JSR		SetLCD_PreviousMenu
			        LDAA	Port_P
			        JSR		DelayCounter
			        STAA	PB_Testing
		        	CMPA	#0
			        BEQ		Release3
			        LBRA	Loop
			        
Release3:     LDAA  Alternator            
              CMPA  #1                    ;Stops the user from going to the previous menu while a movie is playing
              BHI   Error                 ;And display an error message
              
ReleaseBack:  LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release3

GoToMain:	    MOVB  #0, MovieDone
              MOVB 	#0, SECOND
			        MOVB 	#0, CountMS
              JSR		SetLCD_MainMenu

GoToStart:	  MOVB  #0,SECOND
		          MOVB  #0,CountMS
              MOVB	#0,SwitchMenu		      ;Reset SwitchMenu value to 0 (No switch needed)
			        JSR		SetLCD_StartMenu	    ;Go back to the StartMenu

ConfirmPss:	  JSR 	ConfirmPW

Error:		    MOVB  #0, SECOND
			        MOVB  #0, CountMS
              JSR		SetLCD_Error          ;Set an error screen as long as the PB is held
              LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0
              BEQ   Error
			        LBRA	SetLCD_PlayMenu       ;Then it will reset back to the Play Menu Screen (Hopefully)

		          RTS
		          
PICKSS:	    	LDAA 	CurrSSSet
			        CMPA 	#0
			        BEQ		WC			
		        	CMPA 	#1
		        	BEQ		PSS
		        	LBRA	Loop
			
PSS:	      	JSR		PlayT
			
WC:		      	JSR 	Wall_Clock