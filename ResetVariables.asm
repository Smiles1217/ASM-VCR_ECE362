	XREF	SpeedSwitch, SpeedSetting, SpeedTesting, Num_Seconds, Repeats, Num_Repeats, Counter, StepperHalfTurn
	XREF	Alternator, PreviousAlternate, LoadingDots
	XDEF	ResetVariables
	
;The purpose of this subroutine is to systematically reset the following variables to their default values
;This is intended to be called ANYWHERE in the program to reset ALL global variables that are used in multiple sections
	
ResetVariables:	
			;Reset to 0
				MOVB	#0,SpeedSwitch
				MOVB	#0,SpeedSetting
				MOVW	#0,SpeedTesting
				MOVB	#0,Counter
				MOVB	#0,StepperHalfTurn
				MOVB	#0,Alternator
				MOVB	#0,PreviousAlternate
				MOVB  #0,LoadingDots
				
			;Reset to 5
				MOVB	#5,Repeats
				MOVB	#10,Num_Repeats
				
				RTS