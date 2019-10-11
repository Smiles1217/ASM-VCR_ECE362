	XREF	RTICounter1, RTICounter2, RTI_Load_VHS, RTI_Eject_VHS, RTI_Flag, StepperSpeed, PreviousSpeed, SkipBo, LoadingDots
	XREF	StepperForward, StepperBackward, Counter, ScreenSaverSeconds, Port_P, StepperSpeedFWD, StepperSpeedBCK
	XREF	SpeedSwitch, Num_Repeats, Repeats, SpeedSetting, StepperTesting, AccellerateDone, Run3SecDone, HalfTurnCounter
	XREF	SlowDownDone, Repeats2, RTI_Interval, VHSLoaded, DutyCycle,  t_on, t_off, StartPlaying, Menu, DC_Speed
	XREF	Option, FForRewind, Song_Eject, SecondsCounter, SongDone, Song_Play, Song_Record, PlaySpeed, HalfTurnDone
	XREF  Port_t, PCON, ConfPW	;For switches
	XREF  HH, MM, SS, DAY, MO, YEAR, CountMS, countMS, SSaverFlg, SECOND, CurrSSSet ;For wall clock
	XREF  PlayPause, MTime, COUNTMS, VALFLG, Alternator, MovieDone	;For play time screen saver 
	XREF  LEDVAL, countMS1, CounterLED, DivVal ;For LEDs
	XREF  RECNH, RECNTM, RECNOM, RECNTS, RECNOS, RECNMS	;For record now
	XREF  RMM, ERDAY, RMO, RYEAR, ERHH, RHH, ERSS, RSS, ERYEAR, RDAY, ERMM, ERMO, port_s  ;For Record Later
	XDEF	RTI_ISR, RTICALL

Variables:			SECTION
RTICALL				ds.b	1		;To tell functions that the RTI is calling it.	

Constants: 			SECTION	
RTIFLG				equ 	$0037

RTI_ISR:	
          JSR   SecondsCounter
      
;!!!!!!!!!!!!!!!!!USE IF PARENT CONTROL IS ENABLED!!!!!!!!!!!!!!
			    LDAA PCON                     ;Load the parental control flag
		     	CMPA #0                       
			    BEQ ChkHi                     ;If it's low, check if it went high
			    CMPA #1
			    BEQ ChkLo                     ;Else, check if it went low
			    BRA SSFlg
			
ChkHi:		BRSET Port_t, #$01, Set1      ;Check if dip switch one is high
			    BRA SSFlg                     ;If not, continue
			
Set1:	  	MOVB #1, PCON                 ;If it goes high, set the parental control flag.
		    	BRA SSFlg

ChkLo:		BRCLR Port_t, #$01, SetPW     ;Check if the dip siwtch one is low
			    BRA SSFlg
			
SetPW:		MOVB #1, ConfPW               ;If the dip switch goes low after it was high
		    	MOVB #0, PCON                 ;Reset the parental control flag to 0 and set flag to load confirm pw page
			    BRA SSFlg
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;!!!!!!!!!!!!!!!!!!!!!SCREEN SAVER FLAG!!!!!!!!!!!!!!!!!!!!!!!!!!
SSFlg:		LDX CountMS                   ;Counts to a second
		     	INX
	     		STX CountMS
	     		
	     		LDAA  DC_Speed
	     		LBEQ  SSNorm
	     		CMPA  #6
	     		BEQ   SS2XR
	     		CMPA  #5
	     		BEQ   SS4XR
	     		CMPA  #4
	     		BEQ   SS8XR
	     		CMPA  #3
	     		BEQ   SS16XR
	     		CMPA  #9
	     		BEQ   SS2XFF
	     		CMPA  #11
	     		BEQ   SS4XFF
	     		CMPA  #13
	     		BEQ   SS8XFF
	     		CMPA  #15
	     		BEQ   SS16XFF
	     		BRA   SSNorm

SS2XR:    CPX #10000
    			LBNE DateTime
    			MOVW #0, CountMS
    			BRA  SSCont

SS4XR:    CPX #12000
    			LBNE DateTime
    			MOVW #0, CountMS
    			BRA  SSCont

SS8XR:    CPX #14000
    			LBNE DateTime
    			MOVW #0, CountMS
    			BRA  SSCont

SS16XR:   CPX #18000
    			LBNE DateTime
    			MOVW #0, CountMS
    			BRA  SSCont

SS2XFF:   CPX #6000
    			LBNE DateTime
    			MOVW #0, CountMS
    			BRA  SSCont

SS4XFF:   CPX #4000
    			LBNE DateTime
    			MOVW #0, CountMS
    			BRA  SSCont

SS8XFF:   CPX #2000
    			LBNE DateTime
    			MOVW #0, CountMS
    			BRA  SSCont

SS16XFF:  CPX #1000
    			LBNE DateTime
    			MOVW #0, CountMS
    			BRA  SSCont
	     		
SSNorm:   CPX #8000
    			LBNE DateTime
    			MOVW #0, CountMS
    			BRA  SSCont
			                                  
SSCont:   LDAA SECOND                   ;Counts to 30 seconds and sets the flag that causes a screen saver to load
    			INCA
    			STAA SECOND
    			CMPA #30                			;Flag will be set after 30 seconds of idleing
    			BNE DateTime                  
    			MOVB #0, SECOND               ;After it hits 30, reset seconds to 0

        	MOVB #1, SSaverFlg            ;Set the flag to load the screen saver 
			    BRA DateTime

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;!!!!!!!!!!!!!!!!!!!!!!!!!!!WALL CLOCK!!!!!!!!!!!!!!!!!!!!!!!!!!!

DateTime:	LDX countMS			;Counts to one second
		    	INX					
    			STX	countMS			
     			CPX #8000			
    			LBNE PlaySS			
    			MOVW #0, countMS
		
    			LDX #SS        ;Increments the one's place of the seconds value until it hits 9
    			LDAA 1,X		 	; then resets it
	     		INCA				
    			STAA 1,X
    			CMPA #58			  ;ASKII value for 9
    			LBNE PlaySS			
    			MOVB #48, SS+1		
			
			    LDAA X          ;Increments the 10s place of the seconds value until it hits 6, then resets it
		    	INCA
	    		STAA X
	    		CMPA #54		   	;ASKII value for 6
	    		LBNE PlaySS
      		MOVB #48, SS
			
	    		LDX #MM         ;Increments the 1s place of the minutes value unitl it hits 9, then resets it
	    		LDAA 1,X
	    		INCA
	    		STAA 1,X
			    CMPA #58
    			LBNE PlaySS
    			MOVB #48, MM+1
			
    			LDAA X          ;Increments the 10s place of the minutes value until it hits 6, then restes it
    			INCA
    			STAA X
    			CMPA #54
    			LBNE PlaySS
    			MOVB #48, MM
			
    			LDX #HH          ;Increments the 1s place of the hours until it hits 4, then resets it
    			LDAA 1,X         ;Note that it loads until 4 because it's stored as military time.
    			INCA
    			STAA 1,X
    			CMPA #52
    			LBNE PlaySS
    			MOVB #48, HH+1
			
    			LDX #HH          ;Increments the 10s place of the hours until it hits 3, then resets it
    			LDAA X           ;Note that it loads until 3 becasue it's stored as military time
    			INCA
    			STAA X
    			CMPA #51
    			LBNE PlaySS
    			MOVB #48, HH
			
    			LDX #DAY           ;This loads the 10s value of the date entered for the wall clock
    			LDAA X             ;If the value is 3, it resets the day to 0 for the next month.
    			BEQ DayRest        ;Otherwise it continues counting up.
    			LDAA 1,X
    			INCA
    			STAA 1,X
    			CMPA #58
    			LBNE PlaySS
    			MOVB #48, DAY+1
    			LDAA X
    			INCA
    			STAA X
    			CMPA #52
    			LBNE PlaySS
		    	MOVB #48, DAY

DayRest:	MOVB #48, DAY
    			MOVB #49, DAY+1
			
		    	LDX #MO
    			LDAA X
    			CMPA #49		      ;Increases the month until it gets to 12, then resets the counter for month.
    			BEQ ChkMO2

ContMO:		LDAA 1,X
    			INCA
    			STAA 1,X
    			CMPA #58
    			BNE PlaySS
    			MOVB #48, MO+1
    			LDAA X
    			INCA
    			STAA X
     			CMPA #50
    			BNE PlaySS
    			MOVB #48, MO
    			BRA Year

ChkMO2:		LDAA 1,X
    			CMPA #50		;ASKII value for 2
    			BEQ ResetMO
    			BRA ContMO

ResetMO		MOVB #49, MO+1
    			MOVB #48, MO
			
Year: 		LDX #YEAR          ;Increases the year.
    			LDAA 3,X
	    		INCA
    			STAA 3,X
    			CMPA #58
    			BNE PlaySS
    			MOVB #48, YEAR+3			
    			LDX #YEAR
    			LDAA 2,X
    			INCA
    			STAA 2,X
    			CMPA #58
    			BNE PlaySS
    			MOVB #48, YEAR+2			
    			LDAA 1,X
    			INCA
    			STAA 1,X
    			CMPA #58
    			BNE PlaySS
    			MOVB #48, YEAR+1			
    			LDAA X
    			INCA
    			STAA X
    			CMPA #58
    			BNE PlaySS
    			MOVB #48, YEAR


;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;!!!!!!!!!!!!!!!!!!!!!Play Screen Saver!!!!!!!!!!!!!!!!!!!!!!!!!

PlaySS: 	LDAA CurrSSSet		;See if play menu screen saver is set
		    	CMPA #1
    			LBNE LED
			
    			LDAA PlayPause        ;Only increment through the Playing timer inserted here
    			CMPA #1               ;If a movie is currently playing
    			LBNE LED
			
    			LDX COUNTMS			      ;Counts to 1s, then resets.
    			INX					
    			STX	COUNTMS		
    			CPX #8000		
    			LBNE LED		
    			MOVW #48, COUNTMS	
			
		    	LDX #MTime
    			LDAA 4,X			;Loads the ones place of seconds that was entered by the user as the movie length
    			DECA				  ;If it hits 0, it checks all the values stored to its self to see if it should 
    			STAA 4,X		  ;Reset (one of the values isn't 0), or it should reset to the Wall Clock Screen Saver
    			CMPA #47			
    			LBNE LED		
    			BEQ ChkRst1			

CntV1:		MOVB #57, MTime+4
    			BRA Nxt1

ChkRst1:	LDAA X
    			CMPA #48
		    	BNE CntV1
    			LDAA 1,X
    			CMPA #48
    			BNE CntV1
    			LDAA 2,X
    			CMPA #48
    			BNE CntV1
    			LDAA 3,X
    			CMPA #48
    			BNE CntV1
    			BRA Done
			
Nxt1: 		LDAA 3,X			;Does the same thing for the 10s place of the seconds value.
    			DECA			
    			STAA 3,X			
    			CMPA #47		
    			LBNE LED		
    			BEQ ChkRst2			

CntV2:		MOVB #53, MTime+3
    			BRA Nxt2

ChkRst2:	LDAA X
	    		CMPA #47
    			BNE CntV2
    			LDAA 1,X
    			CMPA #47
    			BNE CntV2
    			LDAA 2,X
    			CMPA #47
    			BNE CntV2
    			BRA LED
						
Nxt2:		  LDAA 2,X			;Does the same for the 1s place of the minute value 
    			DECA				
    			STAA 2,X		
    			CMPA #47			
    			LBNE LED		
    			BEQ ChkRst3			

CntV3:		MOVB #57, MTime+2
     			BRA Nxt3

ChkRst3:	LDAA X
    			CMPA #47
    			BNE CntV3
    			LDAA 1,X
    			CMPA #47
    			BNE CntV3
    			BRA LED

Nxt3:	  	LDAA 1,X			;Does the same for the 10s place of the minute value
		  	  DECA			
		    	STAA 1,X		
    			CMPA #47			
    			LBNE LED		
    			BEQ ChkRst4			

CntV4:		MOVB #53, MTime+1
    			BRA Nxt4

ChkRst4:	LDAA X
    			CMPA #47
    			BNE CntV4
    			BRA LED
			
Nxt4: 		LDAA X			;Does the same for the hours place
    			DECA			
    			STAA X		
    			CMPA #47		
		    	LBNE LED		
		
Done:		  MOVB #0, CurrSSSet	;When all values are 0, the movie is over, and the screen saver is set back to
          MOVB #0, StartPlaying		;Set StartPlaying to 0, so that the RTI knows to start the DC Motor
          MOVB #0, DC_Speed      ;Set the DC Motor Speed to 0
          BCLR Port_t, #$8		    ;Clear bit 3 of Port_t_DCMotor
          MOVB #0, Alternator
          MOVB #1, MovieDone
          MOVB #0, Counter
    			BRA LED               ;The world clock
			
			
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;!!!!!!!!!!!!!!!!!!!!Send LED Value Calculation!!!!!!!!!!!!!!!!!!!!!

LED:		  LDAA CurrSSSet		;The LEDs will only change values when the Screen Saver is set 
			    CMPA #1             ;to show that a movie is playing
			    LBNE RecN
			
    			LDAA PlayPause		  ;And won't move if it's paused.
    			CMPA #1
    			LBNE RecN
			
    			LDX countMS1			;Counts to a second to keep track of when the lights need to change.
    			INX					
    			STX	countMS1		
    			CPX #8000			
    			LBNE RecN			
    			MOVW #0, countMS1	
			                      
    			LDX CounterLED        ;Checks if the number of seconds it has been sense the tape started playing 
    			INX                   ;is equal to the interval of time generated by the DivideLED function 
    			STX CounterLED        ;If it is, it resets the counter, then shifts the LED output, which was
    			CPX DivVal            ;origonally loaded with $FF to the right one by one until all the lights
    			BNE RecN              ;are off.
    			MOVW #0, CounterLED			
    			LDAA LEDVAL
    			LSRA 			
    			STAA LEDVAL
    			BRA RecN

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;!!!!!!!!!!!!!!!!!!!!!!!!!Record Now Timing!!!!!!!!!!!!!!!!!!!!!!!!!


RecN: 		LDAA CurrSSSet		;If the user requests to record a video, the screen saver flag should be set to 2.
    			CMPA #2
    			LBNE StopRecording
			
    			LDAA PlayPause       ;The counter for the recording functionality should only work if the user 
    			CMPA #1              ;hasn't pressed the pause button. That's what this flag checks for.
    			LBNE StopRecording
			
    			LDX RECNMS			;Counts to 1s for the recording time.
    			INX				
    			STX	RECNMS		
    			CPX #8000			
    			LBNE StopRecording			
    			MOVW #0, RECNMS	
			
    			LDAA RECNOS		;Counts the ones hand of the seconds up to 9, then resets 
    			INCA				
    			STAA RECNOS
    			CMPA #58			;ASKII for 9
    			LBNE StopRecording			
    			MOVB #48, RECNOS	
			
    			LDAA RECNTS     	;Counts the 10s hand of the seconds up to 5, then resets 
    			INCA
    			STAA RECNTS
    			CMPA #54			;ASKII value for 6
    			LBNE StopRecording
    			MOVB #48, RECNTS
			
    			LDAA RECNOM		;	Counts the ones hand of the minutes up to 9, then resets 
    			INCA				
    			STAA RECNOM
    			CMPA #58			;ASKII for 9
    			LBNE StopRecording			
    			MOVB #48, RECNOM		
			
    			LDAA RECNTM      ;Counts the 10s hand of the minutes up to 5, then resets 
    			INCA
    			STAA RECNTM
    			CMPA #54			;ASKII value for 6
    			LBNE StopRecording
    			MOVB #48, RECNTM
			
    			LDAA RECNH			;Increments the hours as they go by, resets after 9.
    			INCA				
    			STAA RECNH
	    		CMPA #58			;ASKII for 9
	    		LBNE StopRecording			
    			MOVB #48, RECNH		
    			LBRA StopRecording

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;!!!!!!!!!!!!!!!!!!!!!!!!!!Record Later End Check!!!!!!!!!!!!!!!!!!!!!!!!!!

StopRecording: 

   	  		LDX #SS
	    		LDY #ERSS
	    		LDAA X
	    		LDAB Y
	    		CBA 
	    		LBNE StartRecording
	    		LDAA 1,X
	  	  	LDAB 1,Y
		    	CBA
    			LBNE StartRecording
    			
    			LDX #MM
     			LDY #ERMM
    			LDAA X
    			LDAB Y
    			CBA
    			LBNE StartRecording
    			LDAA 1,X
    			LDAB 1,Y
  	  		CBA
    			LBNE StartRecording
    			
    			LDX #HH
    			LDY #ERHH
    			LDAA X
    			LDAB Y
    			CBA
	    		LBNE StartRecording
		     	LDAA 1,X
    			LDAB 1,Y
    			CBA
    			LBNE StartRecording
    			
    			LDX #DAY
    			LDY #ERDAY
    			LDAA X
    			LDAB Y
    			CBA
	    		BNE StartRecording
	    		LDAA 1,X
    			LDAB 1,Y
    			CBA
    			BNE StartRecording
    			
    			LDX #MO
    			LDY #ERMO
    			LDAA X
    			LDAB Y
    			CBA
    			BNE StartRecording
    			LDAA 1,X
    			LDAB 1,Y
    			CBA
    			BNE StartRecording
   	  		
   	  		LDX #YEAR
     			LDY #ERYEAR
  		  	LDAA X
  	  		LDAB Y
    			CBA 
   	  		LBNE StartRecording
    			LDAA 1,X
    			LDAB 1,Y
    			CBA 
    			LBNE StartRecording
    			LDAA 2,X
    			LDAB 2,Y
    			CBA
    			LBNE StartRecording
    			LDAA 3,X
    			LDAB 3,Y
    			CBA 
    			BNE StartRecording
					
	    		MOVB #0, CurrSSSet 	;Set the recording time feature
	    		MOVB #0, PlayPause 
	    		MOVW #00, port_s   
	    		MOVW #00, RMM
	    		MOVW #00, RSS
	    		MOVW #00, RHH
	    		MOVW #00, RDAY
	    		MOVW #00, RMO	
	    		BRA StartRecording

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;!!!!!!!!!!!!!!!!!!!!!!!!!!Record Later Start Check!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

StartRecording: 

			    LDX #SS
			    LDY #RSS
			    LDAA X
			    LDAB Y
			    CBA 
			    LBNE RSong
			    LDAA 1,X
			    LDAB 1,Y
			    CBA
			    LBNE RSong
			    
			    LDX #MM
			    LDY #RMM
			    LDAA X
			    LDAB Y
			    CBA
			    LBNE RSong
			    LDAA 1,X
			    LDAB 1,Y
			    CBA
			    BNE RSong
			    
			    LDX #HH
			    LDY #RHH
			    LDAA X
			    LDAB Y
			    CBA
			    BNE RSong
			    LDAA 1,X
			    LDAB 1,Y
			    CBA
			    BNE RSong
			    
			    LDX #DAY
			    LDY #RDAY
			    LDAA X
			    LDAB Y
			    CBA
			    BNE RSong
			    LDAA 1,X
			    LDAB 1,Y
			    CBA
			    BNE RSong
			    
			    LDX #MO
			    LDY #RMO
			    LDAA X
  		    LDAB Y
			    CBA
			    BNE RSong
			    LDAA 1,X
			    LDAB 1,Y
			    CBA
			    BNE RSong
			    
			    LDX #YEAR
			    LDY #RYEAR
			    LDAA X
			    LDAB Y
		      CBA 
			    LBNE RSong
			    LDAA 1,X
			    LDAB 1,Y
			    CBA 
			    LBNE RSong
			    LDAA 2,X
			    LDAB 2,Y
			    CBA
			    LBNE RSong
			    LDAA 3,X
			    LDAB 3,Y
			    CBA 
			    BNE RSong
			
			    MOVB #2, CurrSSSet 	;Set the recording time feature
			    MOVB #1, PlayPause    	
			    BRA RSong

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;*****************************Song_Check*****************************      
RSong:    LDAA  SongDone
          CMPA  #3
          BNE   PSong
          JSR   Song_Record
          BRA   Go

PSong:    LDAA  SongDone
          CMPA  #2
          BNE   ESong
          JSR   Song_Play
          BRA   Go
      
ESong:    LDAA  SongDone
          CMPA  #1
          BNE   Go
          JSR   Song_Eject
          BRA   Go

;*****************************Song_Check*****************************
      
Go:       LDAA	VHSLoaded			;If a VHS is Loaded (Not Equal to 0), branch to PlayMovie
			    LBNE	PlayMovie

			    LDAA	RTI_Load_VHS		;If RTI_Load_VHS = 0, Branch to EjectVHS
			    CMPA	#0
			    LBEQ	EjectVHS			;Else procede to LoadVHS
	
;*****************************LOAD_VHS*****************************
LoadVHS:	LDAA	RTI_Eject_VHS		;If RTI_Load_VHS = 1, and RTI_Eject_VHS = 1, Branch to Continue
			    CMPA	#1
			    LBEQ	Exit
			
			    LDAA	HalfTurnDone
			    LBNE	LHalfLoop
			
			    LDAA	AccellerateDone
			    LBNE	LSpeedLoop	
			
			    LDAA	RTICounter1
			    BEQ		LContinue
			
			    LDAA	SpeedSetting
			    BEQ		LNumSwitch
			
			    LDX		StepperSpeed
			    BNE		LRun
			    LDAA	Repeats
			    BNE		LRepeater

;Send the Next Number in the Sequence to the Stepper Motor:									
LNumSwitch:LDAA	Num_Repeats
			    STAA	Repeats
			    LDX		#StepperForward		;FORWARD (Clockwise)
			    LDAB	RTICounter1
			    CMPB	#5					;Compare the Current Value of Register B to 5
			    BEQ		LReset1				;If the Value of Register B > 5, branch to "LReset1"
			    LDAA	B,x					;Load the B'th Value of the Array stored in Register X into Accumulator A
			    STAA	Port_P
			    STAA	StepperTesting
			    INC		RTICounter1
			    BRA		LRepeats

;Acceleration of Stepper Motor:
LRepeater:LDX		PreviousSpeed
			    DEC		Repeats
			
LRun:		  DEX		
			    STX		StepperSpeed
			    LBRA	Exit
			
LRepeats:	INC		SpeedSetting
			    LDAB	SpeedSetting
			    CMPB	#10
			    LBNE	DecNumReps

LSwitch:	INC		SpeedSwitch
			    INC		SpeedSwitch
			    MOVB	#0, SpeedSetting

LContinue:LDAA	SpeedSwitch			;Load A with SpeedSwitch
			    CMPA	#20					;If SpeedSwitch is 20, branch to L3SecStart to Run Full Speed for 3 Seconds
			    BGE		L3SecStart			;Otherwise procede to check the Speed Setting (Determine if Accellerate or Slow)
			
LCheckSpeed:LDAA	Run3SecDone
			    CMPA	#1
			    BEQ		LSpeedFWD			;While Run3SecDone is NOT 0, branch to LSpeedFWD for Slow Down speed
			
LSpeedBCK:LDX		#StepperSpeedBCK	;Otherwise, Load the Address for the Accelleration Speed Array into X
			    BRA		LSpeed				;Branch to LSpeed to collect the required speed value from the array
			
LSpeedFWD:LDX		#StepperSpeedFWD	;Load the Address for the Slow Down Speed Array into X

LSpeed:		LDAA	SpeedSwitch			;Load A with SpeedSwitch
			    LDY		A,x					;Load the Speed from the Array into Y
			    STY		StepperSpeed		;Store the Speed value to StepperSpeed and PreviousSpeed
			    STY		PreviousSpeed		
			    BRA		LNumSwitch			;Branch to LNumSwitch
			
LReset1:	MOVB	#0, RTICounter1		;Reset the RTICounter1 Value back to 0
			    BRA		LNumSwitch			;Branch back to "Load_Start"

;Run Full Speed for 3 Seconds:										
L3SecStart:MOVB #0, Port_P
          LDAA	SlowDownDone		;Load A with SlowDownDone
			    LBNE	LHStart			    ;While SlowDownDone is NOT 0, branch to LHStart
			    LDX		#400
			    STX		Repeats2

L3SecRepeat:MOVB	#60, AccellerateDone	;Load 60 into AccellerateDone
			    LDX		Repeats2
			    DEX
			    STX		Repeats2			;If Repeats2 reaches 0, we are done with the 3 second motor spin
			    BEQ		L3SecDone			
			
LSpeedLoop:DEC	AccellerateDone		;Decrement AccellerateDone
			    LDAA	AccellerateDone
			    LBNE	Exit				;While AccellerateDone is not 0, branch to Exit
			
LResetBack:LDX	#StepperForward		;FORWARD (Clockwise)
			    LDAB	RTICounter1
			    CMPB	#5					;Compare the Current Value of Register B to 5
			    BEQ		LReset2				;If the Value of Register B > 5, branch to "LReset1"
			    LDAA	B,x					;Load the B'th Value of the Array stored in Register X into Accumulator A
			    STAA	Port_P
			    STAA	StepperTesting		;Next step is to check the StepperTesting value to see if the motor values are even changing
			    INC		RTICounter1			
			    BRA		L3SecRepeat			;Branch back to L3SecRepeat to reset AccellerateDone and Decrement Repeats

LReset2:	MOVB	#0, RTICounter1		;Reset the RTICounter1 Value back to 0
			    BRA		LResetBack			;Branch back to "LResetBack"
			
L3SecDone:MOVB	#1, Run3SecDone		;Move 1 to Run3SecDone to indicate that we need to Slow Down now
			    MOVB	#0, AccellerateDone	;Move 0 to AccelerateDone so that the RTI will go back to Slow the Stepper Motor
			    MOVB	#0, SpeedSwitch		;Move 0 to SpeedSwitch so that the Slow Down can function correctly
			    MOVB	#1, SlowDownDone	;Move 1 to SlowDownDone to indicate that after the Slow Down we do a Half Turn
			    LBRA	ResetNumRepeats		;Branch to ResetNumRepeats so as to Reset the RTI so we can Slow Down

LHStart:  LDX		#40
			    STX		Repeats2

LHalfRep: MOVB	#60, HalfTurnDone	;Load 60 into HalfTurnDone
          LDX		Repeats2
			    DEX
			    STX		Repeats2			;If Repeats2 reaches 0, we are done with the half turn
			    BEQ		LFinish

LHalfLoop:DEC   HalfTurnDone
          LDAA  HalfTurnDone
			    LBNE  Exit
			
LHalfTurn:LDX	  #StepperBackward	;BACKWARD (Counter-Clockwise)
			    LDAB	RTICounter1
			    CMPB	#5					;Compare the Current Value of Register B to 5
			    BEQ		LReset3				;If the Value of Register B > 5, branch to "LReset3"
			    LDAA	B,x					;Load the B'th Value of the Array stored in Register X into Accumulator A
			    STAA	Port_P
			    STAA	StepperTesting		;Next step is to check the StepperTesting value to see if the motor values are even changing
			    INC		RTICounter1		
			    BRA		LHalfRep			
			
LReset3:	MOVB	#0, RTICounter1		;Reset the RTICounter1 Value back to 0
			    BRA		LHalfTurn   			;Branch back to "LHalfTurn"	

LFinish:	MOVB	#0, RTI_Load_VHS	;Set RTI_Load_VHS to 0 so that the program will know it has finished loading
			    MOVB	#0, AccellerateDone	;Reset all variables used in the Load VHS section
			    MOVB	#0, RTICounter1
			    MOVW	#0, RTICounter2
			    MOVW	#0, StepperSpeed
			    MOVB	#0, StepperTesting
			    MOVB	#0, Run3SecDone
			    MOVB	#0, SlowDownDone
			    MOVB	#0, HalfTurnDone
			    MOVB  #0, HalfTurnCounter
			    MOVW	#0,	PreviousSpeed
			    MOVB	#0, SpeedSetting
			    MOVB	#0, SpeedSwitch
			    MOVB	#1, VHSLoaded
			    LBRA	ResetNumRepeats
			
		   	
;*****************************LOAD_VHS*****************************

;****************************EJECT_VHS*****************************
EjectVHS:	LDAA	RTI_Eject_VHS	      ;If RTI_Load_VHS = 0, and RTI_Eject_VHS = 0, Branch to Continue
			    CMPA	#0                  ;Otherwise, Run the Following Eject VHS Routine:
			    LBEQ	Exit
					
					LDAA  LoadingDots         ;Check the LoadingDots Variable
					BNE   EGo                 ;If Not Equal to 0, Branch to EGo
					INC   LoadingDots         ;Otherwise, Increment Loading Dots to 1
					          				
EGo:						
			    LDAA	HalfTurnDone
			    LBNE	EHalfLoop
			    
          LDAA	AccellerateDone
			    LBNE	ESpeedLoop	
			
			    LDAA	RTICounter1
			    BEQ		EContinue
			
			    LDAA	SpeedSetting
			    BEQ		ENumSwitch
			
			    LDX		StepperSpeed
			    BNE		ERun
			    LDAA	Repeats
			    BNE		ERepeater

;Send the Next Number in the Sequence to the Stepper Motor:									
ENumSwitch:LDAA	Num_Repeats
			    STAA	Repeats
			    LDX		#StepperBackward	;BACKWARD (Counter-Clockwise)
			    LDAB	RTICounter1
			    CMPB	#5					;Compare the Current Value of Register B to 5
			    BEQ		EReset1				;If the Value of Register B > 5, branch to "EReset1"
			    LDAA	B,x					;Load the B'th Value of the Array stored in Register X into Accumulator A
			    STAA	Port_P
			    STAA	StepperTesting
			    INC		RTICounter1
			    BRA		ERepeats

;Acceleration of Stepper Motor:
ERepeater:LDX		PreviousSpeed
			    DEC		Repeats
			
ERun:		  DEX		
			    STX		StepperSpeed
			    LBRA	Exit
			
ERepeats:	INC		SpeedSetting
			    LDAB	SpeedSetting
			    CMPB	#10
			    LBNE	DecNumReps

ESwitch:	INC		SpeedSwitch
			    INC		SpeedSwitch
			    MOVB	#0, SpeedSetting

EContinue:LDAA	SpeedSwitch			;Load A with SpeedSwitch
			    CMPA	#20					    ;If SpeedSwitch is 20 or more, branch to L3SecStart to Run Full Speed for 3 Seconds
			    BGE		E3SecStart			;Otherwise procede to check the Speed Setting (Determine if Accellerate or Slow 
			
ECheckSpeed:LDAA	Run3SecDone
			    CMPA	#1
		    	BEQ		ESpeedFWD			;While Run3SecDone is NOT 0, branch to LSpeedFWD for Slow Down speed
			
ESpeedBCK:LDX		#StepperSpeedBCK	;Otherwise, Load the Address for the Accelleration Speed Array into X
			    BRA		ESpeed				;Branch to LSpeed to collect the required speed value from the array
			
ESpeedFWD:LDX		#StepperSpeedFWD	;Load the Address for the Slow Down Speed Array into X
          INC   LoadingDots

ESpeed:		LDAA	SpeedSwitch			;Load A with SpeedSwitch
			    LDY		A,x					;Load the Speed from the Array into Y
			    STY		StepperSpeed		;Store the Speed value to StepperSpeed and PreviousSpeed
			    STY		PreviousSpeed		
			    BRA		ENumSwitch			;Branch to LNumSwitch
			
EReset1:	MOVB	#0, RTICounter1		;Reset the RTICounter1 Value back to 0
			    BRA		ENumSwitch			;Branch back to "Load_Start"

;Run Full Speed for 3 Seconds:										
E3SecStart:MOVB #0, Port_P
          LDAA	SlowDownDone		;Load A with SlowDownDone
			    BNE		EHStart   			;While SlowDownDone is NOT 0, branch to EStart
			    LDX		#400
			    STX		Repeats2
			    MOVB  #1,SongDone
			    INC   LoadingDots

E3SecRepeat:MOVB	#60, AccellerateDone	;Load 60 into AccellerateDone
			    LDX		Repeats2
			    DEX
			    STX		Repeats2			;If Repeats2 reaches 0, we are done with the 3 second motor spin
			    BEQ		E3SecDone			
			
ESpeedLoop:DEC	AccellerateDone		;Decrement AccellerateDone
			    LDAA	AccellerateDone
			    LBNE	Exit				;While AccellerateDone is not 0, branch to Exit
			
EResetBack:LDX	#StepperBackward	;BACKWARD (Counter-Clockwise)
			    LDAB	RTICounter1
			    CMPB	#5					;Compare the Current Value of Register B to 5
			    BEQ		EReset2				;If the Value of Register B > 5, branch to "LReset1"
			    LDAA	B,x					;Load the B'th Value of the Array stored in Register X into Accumulator A
			    STAA	Port_P
			    STAA	StepperTesting		;Next step is to check the StepperTesting value to see if the motor values are even changing
			    INC		RTICounter1			
			    BRA		E3SecRepeat			;Branch back to L3SecRepeat to reset AccellerateDone and Decrement Repeats

EReset2:	MOVB	#0, RTICounter1		;Reset the RTICounter1 Value back to 0
			    BRA		EResetBack			;Branch back to "LResetBack"
			
E3SecDone:MOVB	#1, Run3SecDone		;Move 1 to Run3SecDone to indicate that we need to Slow Down now
			    MOVB	#0, AccellerateDone	;Move 0 to AccelerateDone so that the RTI will go back to Slow the Stepper Motor
			    MOVB	#0, SpeedSwitch		;Move 0 to SpeedSwitch so that the Slow Down can function correctly
			    MOVB	#1, SlowDownDone	;Move 1 to SlowDownDone to indicate that after the Slow Down we do a Half Turn
			    LBRA	ResetNumRepeats		;Branch to ResetNumRepeats so as to Reset the RTI so we can Slow Down

EHStart:  LDX		#40
			    STX		Repeats2

EHalfRep: MOVB	#60, HalfTurnDone	;Load 60 into HalfTurnDone
          LDX		Repeats2
			    DEX
			    STX		Repeats2			;If Repeats2 reaches 0, we are done with the half turn
			    BEQ		EFinish

EHalfLoop:DEC   HalfTurnDone
          LDAA  HalfTurnDone
			    LBNE  Exit
			
EHalfTurn:LDX	  #StepperForward	;FORWARD (Clockwise)
			    LDAB	RTICounter1
			    CMPB	#5					;Compare the Current Value of Register B to 5
			    BEQ		EReset3				;If the Value of Register B > 5, branch to "LReset3"
			    LDAA	B,x					;Load the B'th Value of the Array stored in Register X into Accumulator A
			    STAA	Port_P
			    STAA	StepperTesting		;Next step is to check the StepperTesting value to see if the motor values are even changing
			    INC		RTICounter1		
			    BRA		EHalfRep			
			
EReset3:	MOVB	#0, RTICounter1		;Reset the RTICounter1 Value back to 0
			    BRA		EHalfTurn   			;Branch back to "EHalfTurn"			

EFinish:	MOVB	#0, RTI_Eject_VHS	;Set RTI_Load_VHS to 0 so that the program will know it has finished loading
			    MOVB	#0, AccellerateDone	;Reset all variables used in the Load VHS section
			    MOVB	#0, RTICounter1
			    MOVW	#0, RTICounter2
			    MOVW	#0, StepperSpeed
			    MOVB	#0, StepperTesting
			    MOVB	#0, Run3SecDone
			    MOVB	#0, SlowDownDone
			    MOVB	#0, HalfTurnDone
			    MOVB  #0, HalfTurnCounter
			    MOVW	#0,	PreviousSpeed
			    MOVB	#0, SpeedSetting
			    MOVB	#0, SpeedSwitch
			    MOVB	#0, VHSLoaded
			    MOVB  #0, SkipBo
			    BRA		ResetNumRepeats

;****************************EJECT_VHS*****************************

DecNumReps:DEC	Num_Repeats
			    LDAA	Num_Repeats
			    CMPA	#1
			    BEQ		ResetNumRepeats
			    LBRA	Exit

Continue:	LDX		RTICounter2
			    INX
			    STX		RTICounter2
			    CPX		#1000
			    BEQ 	ResetCount

ResetCount:MOVW	#0, RTICounter2
			    INC		ScreenSaverSeconds
			    INC		RTICounter2
			
ResetNumRepeats:LDAA	#10
					STAA	Num_Repeats
					LBRA	Exit		

;****************************Play_Movie*****************************

PlayMovie:	LDAA	StartPlaying	  ;Load StartPlaying into A
			      LBEQ	Exit			      ;If equal to 0, do not start playing and jump to Exit
									                ;Else, start the DC Motor playing the Movie at 50% speed
		      	LDAA	FForRewind
	      		BNE		FF_Rewind

PlayCount:  LDAA  PlaySpeed
            INCA
            STAA  PlaySpeed
            CMPA  #50
            LBNE  Exit
									
StartPlay:	MOVB  #0, PlaySpeed
            LDAA	RTICounter1		  ;Load RTICounter into A
	      		INCA					        ;Increment A (RTICounter1)
		      	STAA	RTICounter1		  ;Store back to RTICounter1
					
		      	LDAA	#7              ;Load Register A with 7 for 50% Speed
      			STAA	t_on            ;Store 7, the Value from the Array, into t_on
	      		LDAB	#15	        	  ;Load Register B with the t_check value of 15
	    	  	SUBB	t_on            ;Subtract t_on from 15
	      		STAB	t_off           ;Store the Results of the Subtraction into t_off
			  							
	      		LDAB	RTICounter1
	      		CBA						        ;Compare t_on (A) to the Counter
	      		BHS		Bit_Set			    ;If Counter is Less than or Equal to the t_on, branch to Bit_Set
		      	CMPB	#15				      ;Else, if Greater than 15 (t_check), branch to Exit
		      	BHI		ResetCount1	
					
Bit_Clear:	BCLR	Port_t, #$8		  ;Clear bit 3 of Port_t_DCMotor
		      	BRA		Exit

Bit_Set:	  BSET	Port_t, #$8		  ;Set bit 3 of Port_t_DCMotor
		      	BRA		Exit

ResetCount1:MOVB	#0, RTICounter1	;Reset Counter to 0 if 15 is reached
            MOVB  #0, PlaySpeed
		      	BRA		Exit

;****************************Play_Movie*****************************

;****************************FF_Rewind*****************************

FF_Rewind:	LDAA	FForRewind		  ;Load FForRewind into A
		      	BEQ		Exit			      ;If equal to 0, do not change speed and jump to Exit

FF_RCount:  LDAA  PlaySpeed
            INCA
            STAA  PlaySpeed
            CMPA  #50
            BNE   Exit
									
Rewind_FF:	MOVB  #0, PlaySpeed
            LDAA	RTICounter1		  ;Load RTICounter into A
		      	INCA					        ;Increment A (RTICounter1)
		      	STAA	RTICounter1		  ;Store back to RTICounter1
					
			      LDAA	DC_Speed        ;Load Register A with DC_Speed
  	    		STAA	t_on            ;Store 8, the Value from the Array, into t_on
	  		    LDAB	#15	        	  ;Load Register B with the t_check value of 15
		      	SUBB	t_on            ;Subtract t_on from 15
		      	STAB	t_off           ;Store the Results of the Subtraction into t_off
			  							
		      	LDAB	RTICounter1
	    	  	CBA						        ;Compare t_on (A) to the Counter
	    		  BHS		Bit_Set			    ;If Counter is Less than or Equal to the t_on, branch to Bit_Set
	    	  	CMPB	#15				      ;Else, if Greater than 15 (t_check), branch to Exit
	    	  	BHI		ResetCount1	
					
B_Clear:	  BCLR	Port_t, #$8		  ;Clear bit 3 of Port_t_DCMotor
		      	BRA		Exit

B_Set:		  BSET	Port_t, #$8		  ;Set bit 3 of Port_t_DCMotor
		      	BRA		Exit

ResetCount2:MOVB	#0, RTICounter1	;Reset Counter to 0 if 15 is reached
            MOVB  #0, PlaySpeed
		      	BRA		Exit

;****************************FF_Rewind*****************************


Exit:	    	BSET	RTI_Flag, #$80
			      RTI						;Return from Interrupt