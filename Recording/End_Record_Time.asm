	XDEF End_Record_Time
	XREF disp, display_string, Count2, Check_RecEnd_Time, StoreIND, Keypad
	
My_Constants 	SECTION
DISP			dc.b 	'End Rec Time:     :  :         0'

My_Variables	SECTION
BSap			ds.b	1		;To keep track of location of disp.
	
End_Record_Time:

		MOVB #16, Count2		;Initalize the counter position to start at the second half of the display string.
		LDX	#DISP				;Load the address of what needs to be displayed
		LDY #disp				;Load the disp variable		

		
Init:	LDAA 1,X+				;Load first variable of DISP. initalize the string.
		CMPA #$30					;See if last value
		BEQ Next				;Move to the next thing.
		STAA 1,Y+				;Save it to the address in disp
		BRA Init				;Keep looping until string is populated.
	
Next:	LDD #disp
		JSR display_string
		
ReadK:	JSR Keypad				;Read input from keypad.
		LDY #disp				;Reset Y to point to the beginning of the display string.	
		LDAB StoreIND			;Load what was entered.
		CMPB #10				;To see if a digit is pressed.
		BGE ChkB				;If greater than, check for back space. (A-F was pressed)
		BRA Place				;Otherwise, Place the number on the LCD.
		
ChkB:	CMPB #11				;See if B was pressed
		BEQ BS					;Branch to backspace operation 
		BRA ReadK				;If not, ignore the input.		
		
Place 	LDAA Count2			;Load counter
		CMPA #18				;If counter refers to '/' place.
		BEQ incCount			;Branch to increase the counter.
		CMPA #21				;If counter refers to '/' space
		BEQ incCount			;Increment the counter.
		CMPA #24				;If at last position
		BEQ ChckDate			;Branch to check the date
Cont1:	LDAB StoreIND
		ADDB #$30				;Convert to ASII
		LDAA Count2
		STAB A,Y				;Store ASKII value to LCD 
		INCA 
		STAA Count2			;Increment the counter
		LDD #disp
		JSR display_string
		BRA ReadK				;Read the next keypress. 
		
BS:		LDAA Count2 
		CMPA #16
		BEQ Cont2				;Can't go backwards, so read next value
		DECA
		STAA Count2
		CMPA #18				;If counter refers to '/' place.
		BEQ decCount			;Branch to increase the counter.
		CMPA #21				;If counter refers to '/' space
		BEQ decCount			;Increment the counter.
Cont2:	LDAB #32
		STAB A,Y
		LDD #disp
		JSR display_string
		BRA ReadK


incCount:		INCA 
				STAA Count2
				BRA Cont1
				
decCount: 		DECA
				STAA Count2
				BRA Cont2

ChckDate:		JSR Check_RecEnd_Time