	XREF	LoadingDots, disp, display_string, ResetVariables
	XDEF	AddLoadDot

AddLoadDot:	PSHD
			INC		LoadingDots			;A is a valued at 1 through 5 and represents the position in the StepperForward sequence
			
			LDAA	LoadingDots
			movb	#'.',disp+23		;This Branch Routine is a Bonus Feature of a Loading Screen
			CMPA	#1
			BEQ		DisplayDots
			movb	#'.',disp+24
			CMPA	#2
			BEQ		DisplayDots
			movb	#'.',disp+25
			CMPA	#3
			BEQ		DisplayDots
			movb	#'.',disp+26
			CMPA	#4
			BEQ		DisplayDots
			movb	#'.',disp+27
			BRA		DisplayDots
			
DisplayDots:LDD		#disp
			JSR 	display_string
			
			PULD
			RTS