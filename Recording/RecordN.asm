	XDEF RecordN
	XREF PlayPause, MTime, disp, display_string, SetLCD_PlayMenu, SetLCD_SettingsMenu, SSaverFlg, MRating, Parent_Control_Disp, SECOND
	XREF Menu, SetLCD_MainMenu, CountMS, StoreIND, CurrSSSet, SetLCD_StartMenu, Keypad, SSKeypad, PreviousMenu, port_s, LEDVAL
	XREF PB_Testing, DelayCounter, Port_P, RECNH, RECNTM, RECNOM, RECNTS, RECNOS, PlayT, SongDone, StartPlaying, RSongDone, End_Record_Date
	
My_Constants 	SECTION
DISP			dc.b 	'   Recording         :  :       0'
DISP1			dc.b	'    Paused           :  :       0'
My_Variables	SECTION

	
RecordN:
    
    ;JSR  End_Record_Date
    
    LDAA RSongDone
    BEQ  RGo
    MOVB #3, SongDone   ;Set the SongDone variable to 3 so that the RTI knows to play the Record Song
    MOVB #1, RSongDone 

RGo:LDAA Menu
		STAA PreviousMenu
		LDAA PlayPause
		CMPA #1					;Recording
		BEQ RecS
		
PauseS:	LDX #DISP1
		LDY #disp
		BRA Init
		
RecS:	LDX	#DISP				;Load the address of what needs to be displayed
		  LDY #disp				;Load the disp variable		

		
Init:	LDAA 1,X+				;Load first variable of DISP. initalize the string.
		CMPA #$30					;See if last value
		BEQ Next				;Move to the next thing.
		STAA 1,Y+				;Save it to the address in disp
		BRA Init				;Keep looping until string is populated.
	



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!DISPLAY PLAY TIME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Next:	MOVB #1, SSKeypad
		JSR Keypad 
		LDAA StoreIND
		CMPA #$FF
		BNE	Wakeup
	
		LDAA 	LEDVAL			;Update LEDs as time goes on
		STAA 	port_s
		
		LDAA	Port_P
		JSR		DelayCounter		;Debouncing for PB
		STAA	PB_Testing
		CMPA	#0
		BEQ		Release
		
		LDD #disp
		JSR display_string
		
		LDAA RECNH
		STAA disp+20
		LDAA RECNTM
		STAA disp+22
		LDAA RECNOM
		STAA disp+23
		LDAA RECNTS
		STAA disp+25
		LDAA RECNOS
		STAA disp+26
		BRA Next
		
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Release:      LDAA  Port_P            ;This Section waits for the PB to be released
              JSR		DelayCounter			;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release
              BRA   Pause
		
Pause:	      LDAA PlayPause
		          CMPA #1
		          BEQ  NowPause
		          MOVB #1, PlayPause
		          MOVB #1,StartPlaying		;Set StartPlaying to 1, so that the RTI knows to start the DC Motor
		          JSR  RecordN
		
NowPause:		  MOVB #2, PlayPause
              MOVB #0,StartPlaying		;Set StartPlaying to 0, so that the RTI knows to start the DC Motor
				      JSR  RecordN


Wakeup:	      MOVB #0, SSaverFlg
		          MOVB #0, SECOND
		          MOVB #0, CountMS
	          	MOVB #0, SSKeypad
	          	LDAA PreviousMenu
	          	CMPA #1						;Start Menu
	          	BEQ  StartM
	          	CMPA #2						;Main Menu
	          	BEQ  MainM				
	          	CMPA #3						;Play Menu
          		BEQ  PlayM 
	          	CMPA #4						;Settings Menu
	          	BEQ  SetM
	          	CMPA #5						;Rating Menu
	          	BEQ  RatingM						
	          	BRA  ParentM

StartM:			JSR SetLCD_StartMenu			;Branch to the start menu
				
PlayM:			JSR SetLCD_PlayMenu

ParentM:		JSR Parent_Control_Disp			

MainM:			JSR SetLCD_MainMenu

SetM:			  JSR SetLCD_SettingsMenu

RatingM:		JSR MRating