	XREF	StepperSpeedFWD, StepperSpeedBCK, SpeedSwitch, SpeedTesting, SpeedSetting, Repeats, Num_Repeats, AddLoadDot, ResetVariables
	XDEF	StepperSlowDown

StepperSlowDown:	PSHX
					PSHY
					PSHD
					LDAB		SpeedSetting
					LDAA		Num_Repeats
					STAA		Repeats
					LDX			#StepperSpeedFWD
										
Continue:			LDAA		SpeedSwitch
					CMPA		#20
					BEQ			BreakOut
					LDY			A,x
					STY			SpeedTesting
					
Repeater:			LDY			SpeedTesting
					DEC			Repeats
					
Loop:				DEY
					BNE			Loop
					LDAA		Repeats
					BNE			Repeater

					INCB
					STAB		SpeedSetting
					CMPB		#10
					BEQ			SwitchSpeed

Exit:				DEC			Num_Repeats
					LDAA		Num_Repeats
					CMPA		#1
					BEQ			ResetNumRepeats
					
BreakOut:			PULD
					PULY
					PULX
					RTS	

SwitchSpeed:		INC			SpeedSwitch
					INC			SpeedSwitch
					LDAB		#0
					STAB		SpeedSetting
					BRA			Exit	
					
ResetNumRepeats:	LDAA		#5
					STAA		Num_Repeats
					BRA			BreakOut		