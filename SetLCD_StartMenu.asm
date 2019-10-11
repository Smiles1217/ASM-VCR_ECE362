	XREF	disp, init_LCD, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_MainMenuReturn, Option, Pot_Menu_Selector, Menu, SetLCD_Error
	XREF	display_string, SetLCD_SelectSettingsMenu, PB_Testing, Port_P, DelayCounter, PreviousMenu, Action_LoadVHS, ResetVariables, RTI_Load_VHS, RTI_Eject_VHS, ConfPW, ConfirmPW
	XREF	SSaverFlg, CurrSSSet, Wall_Clock, SECOND, CountMS, PlayPause, port_s, LEDVAL, PlayT, RecordN, RecLSet, STRec, VHSLoaded, SkipBo, SetLCD_EjectingVHS
	XDEF	SetLCD_StartMenu

SetLCD_StartMenu:
      
			        MOVB	#1, Menu          ;Then update the current menu value to 1 for Start Menu
			        MOVB  #1, PreviousMenu
			        
SMBegin:			LDAA  SkipBo            ;Check SkipBo to see if a Tape is Loaded
			        BEQ   SStart            ;If SkipBo is 0 a Tape is NOT Loaded, branch to SStart
			        JSR   SetLCD_EjectingVHS                  
			        BRA   SMBegin           ;And then branch back to the SMBegin and Loop until SkipBo is 0
			        			        
SStart:			  

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #'S',disp+2
           movb #'t',disp+3
           movb #'a',disp+4
           movb #'r',disp+5
           movb #'t',disp+6
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

              LDD		#disp             ;If a VHS is NOT Loaded, load the address of disp into D
			        JSR		display_string    ;And then call the display_string routine to show the Start Menu Header
			
			        JSR		ResetVariables    ;Reset all General Purpose Variables
			
Loop:		      LDAA 	ConfPW
			        CMPA 	#1
			        BEQ 	ConfirmPss
			        MOVB	#1, Menu
			
			        LDAA 	SSaverFlg
			        CMPA 	#1
			        LBEQ	PICKSS
			
			        LDAA 	PlayPause			;If movie is playing, update the LEDs
			        CMPA 	#1
			        BEQ 	LOADLED
			        BRA 	PMS
			
LOADLED:	    LDAA 	LEDVAL
			        STAA 	port_s
			
PMS:		      LDAA	RecLSet
			        CMPA 	#1
			        LBEQ 	ChkCurrDT

PMS1:		      MOVB	#32, Port_P
              JSR		Pot_Menu_Selector
			        LDAA	Option
			        CMPA	#1
			        BEQ		LoadVHS
			        CMPA	#2
		        	BEQ		Settings
		        	BRA		Error
			
LoadVHS:	    JSR		SetLCD_LoadVHS
			        LDAA	Port_P
		        	JSR		DelayCounter
			        STAA	PB_Testing
			        CMPA	#0
			        BEQ		Release
			        BRA		Loop

Release:      LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release
              BRA   LoadingVHS
			
Settings:	    JSR		SetLCD_SelectSettingsMenu
			        LDAA	Port_P
			        JSR		DelayCounter
			        STAA	PB_Testing
			        CMPA	#0
		        	BEQ		Release1
			        BRA		Loop

Release1:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release1
              BRA   GoToSetting
			
Error:	    	JSR		SetLCD_Error
			        LBRA	Loop

ConfirmPss:	  JSR 	ConfirmPW
			
GoToSetting:  MOVB  #0, SECOND
			        MOVB  #0, CountMS
              JSR		SetLCD_SettingsMenu

LoadingVHS:	  MOVB  #0, SECOND
			        MOVB  #0, CountMS
              MOVB	#1, RTI_Load_VHS
			        MOVB	#0, RTI_Eject_VHS
			        JSR		SetLCD_MainMenu
			
			        RTS
			        
PICKSS:	    	LDAA 	CurrSSSet
			        CMPA 	#0
		        	BEQ		WC
	        		CMPA 	#1
	        		BEQ		PSS
	        		LBRA	Loop
			
PSS:      		JSR		PlayT
			
WC:	      		JSR 	Wall_Clock

ChkCurrDT:  	JSR 	STRec		;See if we need to start recording
		        	LBRA	PMS1			        