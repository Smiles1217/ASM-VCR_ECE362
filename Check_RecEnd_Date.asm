	XDEF Check_RecEnd_Date
	XREF disp, display_string, StoreIND, Keypad, Counter, End_Record_Time, End_Record_Date, RecordL, ERMO, ERDAY, ERYEAR,
	
My_Variables	SECTION
Hold			ds.b	1

My_Constants 	SECTION
DISP2			dc.b 	'Invalid Date:                  0'

Check_RecEnd_Date:

			LDAA disp+16		;Checks and populates month variables
			LDX #ERMO
			STAA X
			SUBA #$30
			CMPA #1
			BHI Invalid 
			BEQ ChkMO2		
Nest:			LDAB disp+17
			STAB 1,X
			SUBB #$30
			CMPB #9
			BHI Invalid
			BRA Cont22
			
ChkMO2:		LDAA disp+17
			SUBA #$30
			CMPA #2
			BHI Invalid
			BRA Nest
		
Cont22:		LDAA disp+19		;Checks and populates day variables
			LDX	#ERDAY
			STAA X
			SUBA #$30
			CMPA #3
			BHI Invalid 
			LBEQ Check_D2
Pop_Day:		LDAB disp+20
			STAB 1,X

			LDAA disp+22		;Checks and populates year variables
			STAA ERYEAR
Cont_Y:		LDAA disp+23
			STAA ERYEAR+1
			LDAA disp+24
			STAA ERYEAR+2
			LDAA disp+25
			STAA ERYEAR+3
			
			JSR End_Record_Time
		
		
		
Invalid:		LDX	#DISP2				;Load the address of what needs to be displayed
			LDY #disp				;Load the disp variable
		
Init:			LDAA 1,X+				;Load first variable of DISP. initalize the string.
			CMPA #$30					;See if last value
			BEQ Next				;Move to the next thing.
			STAA 1,Y+				;Save it to the address in disp
			BRA Init				;Keep looping until string is populated.
	
Next:			LDD #disp
			JSR display_string
			LDY #60000				;Displays incorrect date string for a time
			LDAA #20
Loop1:		DEY
			BEQ Next1
			BRA Loop1
Next1:		DECA 
			BEQ Return
			BRA Loop1
			
Return:		JSR End_Record_Date		;Ask the user to enter in a date again

			
Check_D2:		LDAA disp+20
			SUBA #$30
			CMPA #0
			BNE Invalid
			LBRA Pop_Day