;**************************************************************
;* This stationery serves as the framework for a              *
;* user application. For a more comprehensive program that    *
;* demonstrates the more advanced functionality of this       *
;* processor, please see the demonstration applications       *
;* located in the examples subdirectory of the                *
;* Freescale CodeWarrior for the HC12 Program directory       *
;**************************************************************

; Include Derivative-Specific Definitions
            INCLUDE 'derivative.inc'

;Export Symbols
            XDEF Entry, _Startup, disp, Menu, Option, PValue_Testing, PB_Testing, Port_P, PreviousMenu, StepperForward, StepperBackward, Counter, RTICounter1, Alternator
            XDEF RTI_Enable, RTI_Interval, RTI_Flag, StepperSpeedFWD, StepperSpeedBCK, SpeedTesting, SpeedSwitch, Num_Repeats, Repeats, SpeedSetting
            XDEF Num_Seconds, StepperHalfTurn, port_u, port_u_ddr, port_u_psr, port_u_pde, PreviousAlternate, RTI_Load_VHS, RTI_Eject_VHS, MTime
            XDEF StoreIND, ScreenSaverSeconds, StepperSpeed, RTICounter2, PreviousSpeed, StepperTesting, AccellerateDone, Run3SecDone, SlowDownDone
            XDEF Repeats2, VHSLoaded, SwitchMenu, DutyCycle,  t_on, t_off, StartPlaying, Port_t, DC_Speed, FForRewind, SpeakerData, Port_t_DDR
            XDEF ToneCount, Eject_Sequence, MicroSeconds, Num_HalfSeconds, Num_QuarterSeconds, Play_Sequence, SongDone, Record_Sequence, SkipBo
            XDEF ParentRating, PassSET, PASS, CONF, PSET, Count2, PCON, ConfPW, StartF, PWCFlg, LoadingDots, RatingLimitSet, RSongDone
			      XDEF MO, DAY, YEAR, HH, MM, SS, CountMS, countMS, SSaverFlg, SECOND, CurrSSSet, SSKeypad, COUNTMS, PlayPause, VALFLG
			      XDEF port_s, DivVal, LEDVAL, countMS1, CounterLED, RECNH, RECNTM, RECNOM, RECNTS, RECNOS, RECNMS, ERMO, ERDAY, ERYEAR, ERHH, ERMM, ERSS, PCDisp
			      XDEF RMO, RDAY, RYEAR, RHH, RSS, RMM, RecLSet, Comp, PlaySpeed, HalfTurnDone, HalfTurnCounter, MovieDone, PasswordSet
			      XDEF RecLSet
;Import Symbols
            XREF __SEG_END_SSTACK, init_LCD, display_string, read_pot, pot_value, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS       
			      XREF DelayCounter, ResetVariables, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater
			      XREF SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, Pot_Menu_Selector, SetLCD_Error, SetLCD_SelectSettingsMenu
			      XREF RTI_ISR, SetLCD_Rewinding, SetLCD_FastForwarding, SetLCD_EnterTodaysDate, SetLCD_Confirm, SendsChr, PlayTone, SendMessageInfo, Enter_Date, MovieLength

;All Variables used will be declared in main below:
Variables: SECTION
disp			    	    ds.b	 33			;LCD
Menu			    	    ds.b	 1			;Which Menu is being Displayed
Option			  	    ds.b	 1			;Which Option is being shown on the Menu
PValue_Testing	    ds.b	 1			;TEST Variable for Holding the Potentiometer Value
PB_Testing			    ds.b	 1			;TEST Variable for Holding the Push Button Value
PreviousMenu		    ds.b	 1			;Which Menu were we on Previously
Counter			  	    ds.b	 1			;General Purpose Counter to be used in Multiple Subroutines (MAKE SURE TO ALWAYS RESET TO 0 WHEN DONE USING)
Alternator			    ds.b	 1			;General Purpose Alternator (MAKE SURE TO ALWAYS RESET TO 0 WHEN DONE USING)
RTICounter1			    ds.b	 1			;1 Byte Counter for RTI use ONLY**
RTICounter2			    ds.w	 1			;2 Byte Counter for RTI use ONLY**
SpeedSwitch			    ds.b	 1
SpeedTesting		    ds.b	 2
SpeedSetting		    ds.b	 1
Repeats			  	    ds.b	 1			;1 Byte Repeats Counter for RTI use ONLY**
Repeats2		  	    ds.w	 1			;2 Byte Repeats Counter for RTI use ONLY**
Num_Repeats			    ds.b	 1
Num_Seconds			    ds.w	 1
Num_HalfSeconds     ds.w   1
Num_QuarterSeconds  ds.w   1
StepperHalfTurn	   	ds.b	 1
PreviousAlternate 	ds.b	 1
RTI_Load_VHS	    	ds.b	 1
RTI_Eject_VHS	    	ds.b	 1
ScreenSaverSeconds	ds.b	 1
StepperSpeed		    ds.w	 1
PreviousSpeed		    ds.w	 1			;Counts the Number of Stepper Rotations
StepperTesting	    ds.b	 1
AccellerateDone	    ds.b	 1
Run3SecDone			    ds.b	 1
SlowDownDone		    ds.b	 1
HalfTurnDone        ds.b   1
HalfTurnCounter     ds.b   1
VHSLoaded		  	    ds.b	 1			;If a VHS is loaded this variable will be 1, otherwise it will be 0
SwitchMenu			    ds.b	 1			;If we need to switch menus, this will be 1, otherwise it will be 0
t_off			          ds.b	 1
t_on			          ds.b   1
StartPlaying		    ds.b	 1
DC_Speed			      ds.b	 1
FForRewind			    ds.b	 1
ToneCount           ds.b   1
MicroSeconds        ds.w   1
SongDone            ds.b   1
SkipBo              ds.b   1      ;Skips displaying the Play Option if the IRQ is pressed
ParentRating		    ds.b	 1			;Holds value to distingush parental rating OFF/G/PG/PG13/R to 0/1/2/3/4, Bre 11/26/2018
PassSET				      ds.b	 1			;Holds 0/1 for false/true to distingush if a password has been set. Bre 11/26/2018
PASS			      	  ds.b	 4			;Holds the 4 value password input from the keyboard. 
StoreIND			      ds.b 	 1			;Holds the Keypad input 11/27/2018 Bre
CONF				        ds.b	 4			;Holds the 4 value confirmation password input from the keyboard.
Count2				      ds.b	 1      ;Another counter created to avoid glitches.
PSET				        ds.b	 1
PCON				        ds.b	 1			;Tell if parental control is ON/OFF
ConfPW				      ds.b	 1			;Flag to tell menu needs top half of string reloaded
StartF				      ds.b	 1			;Start Flag
PWCFlg			    	  ds.b	 1			;Flag to let ConfirmPW know that we need to enter the change PW input screen.
MO					        ds.b   2			;Month
DAY					        ds.b   2			;Day
YEAR				        ds.b 	 4			;Year
HH			    	      ds.b   2  		;Hour, military time
MM				      	  ds.b	 2			;Minute
SS					        ds.b	 2			;Second
CountMS				      ds.b	 2			;To count the ms in order to implement the wall clock
countMS				      ds.b	 2			;THE REAL COUNT TO MS, HA YOU THOUGHT THE OTHER ONE WAS IT!
SSaverFlg			      ds.b 	 1			;Flag to show a screen saver needs to come on
SECOND				      ds.b	 1			;Counts to 30 seconds to set Screen saver
CurrSSSet			      ds.b	 1			;To pick which screen saver to show
SSKeypad			      ds.b	 1			;Flag for Screen Saver keypad wakeup
MTime				        ds.b 	 5			;Holds the length of time the movie should run
COUNTMS				      ds.b	 2			;MS counting for Play Time
PlayPause			      ds.b	 1			;Flag to show if the movie is playing or paused.
VALFLG				      ds.b	 1			;Flag to keep an eye on the decrementing counter for play SS
DivVal			    	  ds.b	 4			;Holds number of seconds to increment to decrement LEDs
LEDVAL				      ds.b	 1			;Holds LED value to send to LEDs 
countMS1			      ds.b	 1			;Holds ms for LED display
CounterLED			    ds.b 	 4			;Counter for the seconds for the LEDs
RECNH				        ds.b	 1			;Hold Hours for Record now features
RECNTM				      ds.b	 1			;Hold Tens min for record now features
RECNOM				      ds.b 	 1			;Hold ones min for record now features
RECNTS				      ds.b	 1			;Hold tens sec for record now features
RECNOS				      ds.b	 1			;Hold ones sec for record now features 
RECNMS				      ds.b	 2			;MS for record now features 
RMO					        ds.b   2			;Month for recording
RDAY				        ds.b   2			;Day for recording
RYEAR				        ds.b 	 4			;Year for recording
RHH			    	      ds.b   2			;Hour, military time for recording
RMM					        ds.b	 2			;Minute for recording
RSS					        ds.b	 2			;Second for recording 
RecLSet				      ds.b	 1			;Flag to see if we need to check to start recording
Comp                ds.b   1      ;Variable for Comparing Parental Control Rating Setting
PlaySpeed           ds.b   1      ;Variable for Slowing the rate at which the DC Motor Runs
LoadingDots         ds.b   1
MovieDone           ds.b   1
RatingLimitSet      ds.b   1
PCDisp	            ds.b	 1
ERMO					      ds.b   2			;Month for end record time/date features
ERDAY				        ds.b   2			;Day for end record time/date features
ERYEAR				      ds.b 	 4			;Year for end record time/date features
ERHH			    	    ds.b   2			;Hour, military time for end record time/date features
ERMM					      ds.b	 2			;Minute for end record time/date features
ERSS					      ds.b	 2			;Second for end record time/date features
PasswordSet         ds.b   1
RSongDone           ds.b   1

;All Constants used will be declared in main below:
Constants:	 SECTION
_SEG_END_SSTACK		  equ 	$500		;The Stack
Port_P				      equ		$258		;Stepper Motor
Port_P_DDR			    equ		$25A		;Stepper Motor DDR
Port_t				      equ		$240		;Switches/DCMotor
StepperForward		  dc.b	$0A, $12, $14, $0C, $0	;Stepper Motor Clockwise Sequence
StepperBackward		  dc.b	$0, $0C, $14, $12, $0A	;Stepper Motor CounterClockwise Sequence
StepperSpeedFWD		  dc.w	$1, $3, $5, $7, $9, $11, $13, $15, $17, $19, $21		;Stepper Motor Speed Values
StepperSpeedBCK		  dc.w	$21, $19, $17, $15, $13, $11, $9, $7, $5, $3, $1		;Stepper Motor Speed Values
RTI_Enable 			    equ		$0038
RTI_Interval		    equ		$003B
RTI_Flag			      equ		$0037
IRQ_Enable			    equ		$001E
port_u				      equ 	$268
port_u_ddr			    equ 	$26A
port_u_psr			    equ 	$26D
port_u_pde			    equ 	$26C
DutyCycle		  	    dc.b	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
SpeakerData         dc.w  $250, $180, $150, $120, $100, $20
Eject_Sequence      dc.b  $5, $F, $D, $B, $D, $F, $5, $F
Play_Sequence       dc.b  $1E, $F, $7, $3, $2, $3, $2, $1
Record_Sequence     dc.b  $2, $3, $2, $3, $2, $3, $2, $3
Port_t_DDR:			    equ		$242  ;DC Motor DDR
port_s				      equ	  $248	;LED output
port_s_ddr		    	equ	  $24A	;To switch input/output mode for LED DDR.


MyCode:     SECTION
Entry:
_Startup:
		
			LDS		#_SEG_END_SSTACK
			MOVB	#$1E,Port_P_DDR
			MOVB	#0, Menu			;Initial Menu is StartMenu (0)
			MOVW	#0, MTime			;Initial Movie Length is 0
			MOVB	#0, StoreIND		;Initial Keypad Index Value of 0
			MOVB	#0, ScreenSaverSeconds	;Initial Screen Saver Time of 0
			MOVW	#0, StepperSpeed
			MOVB	#0, StepperTesting
			MOVB	#0, AccellerateDone
			MOVB	#0, Run3SecDone
			MOVB	#0, SlowDownDone
			MOVB	#0, HalfTurnDone
			MOVB  #0, HalfTurnCounter
			MOVW	#0,	PreviousSpeed
			MOVB	#0, VHSLoaded
			MOVB  #0, LoadingDots
			MOVB  #0, MovieDone
			MOVB  #0, RatingLimitSet
			MOVB  #0, PasswordSet
			MOVB  #0, RSongDone
			
			MOVB  #0, PlaySpeed
			MOVB  #0, SkipBo
			MOVB  #0, Comp
			
			MOVW  #0, Num_Seconds
			MOVW  #0, Num_HalfSeconds
			MOVW  #0, Num_QuarterSeconds
			MOVB  #0, SongDone
			
			MOVB	#0, SwitchMenu		;Initial SwitchMenu value is 0 (No switch needed)
			MOVB  #0, ToneCount
			MOVW  #$1E85, MicroSeconds
			BSET  Port_t_DDR, #$E8  ;Set Bit 5 of Port_t_DDR
			
			MOVB	#0, t_on
			MOVB	#0, t_off
			MOVB	#0,	StartPlaying
			MOVB	#0, DC_Speed
			MOVB	#0, FForRewind
			
			LDD		#0					;Reset register D to 0
			STAA	PCON
			STAA 	ConfPW
			STAA	StartF
			STAA	countMS
			STAA 	SSaverFlg
			STAA 	SECOND
			STAA	CurrSSSet
			STAA 	SSKeypad
			STAA	CountMS
			STAA	COUNTMS
			STAA 	countMS1
			
			MOVB  #$FF, LEDVAL	;Initalize LED value to start with all values on
			MOVW  #0, CounterLED
			MOVB  #0, PlayPause
			MOVW  #0, RECNMS
 			MOVB  #0, ParentRating	;Default parent rating is off.
 			MOVB  #0, PassSET		;Default password set to false.
 			LDAA  #48				;ASKII Value for 0
			STAA 	RECNH
			STAA	RECNTM
			STAA	RECNOM
			STAA	RECNTS
			STAA	RECNOS
			
			BSET 	port_u_ddr, #$F0	;Make last 4 bites outputs.
 			BSET 	port_u_psr, #$F0	;Set pins 0-3 as pull up
 			BSET 	port_u_pde, #$0F	;Activate pull up pins
 			MOVB  #$FF, port_s_ddr	;Set DDR for LEDs to output.
 			
 			MOVB	#0, RTI_Load_VHS
 			MOVB	#0, RTI_Eject_VHS
 			MOVB	#$80, RTI_Enable    ;Enable Real Time Interrupts
 			MOVB	#$C0, IRQ_Enable	;Enable IRQ Interrupts
			MOVB	#$10, RTI_Interval  ;Set the Initial RTI Interval to 128us
			MOVB	#0, RTICounter1		;Initialize RTICounter1 to 0
			MOVW	#0, RTICounter2		;Initialize RTICounter2 to 0
 			
			JSR		ResetVariables		;Initialize Global Variables to their Default Values
			JSR		init_LCD
			
			JSR		Enter_Date				;To begin start up procedure.
