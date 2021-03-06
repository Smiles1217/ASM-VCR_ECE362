	XDEF Check_Rec_Time
	XREF display_string, disp, Count2, Enter_Rec_Time, SetLCD_MainMenu, RHH, RSS, RMM, RecLSet, End_Record_Date
	
My_Variables	SECTION
Hold			ds.b	1

My_Constants 	SECTION
DISP3			dc.b 	'Invalid Time                  0'

Check_Rec_Time:

			LDAA disp+16		;Populate and check the hour variable
			STAA RHH
			SUBA #$30
			CMPA #2
			LBHI Inv
			BEQ Chk_HR 
Cont_H		LDAB disp+17
			STAB RHH+1
			BRA Min
			
Chk_HR:		LDAA disp+17
			SUBA #$30
			CMPA #3
			BHI Inv
			BRA Cont_H
		
Min:		LDAA disp+19		;Populate the minute variable
			STAA RMM
			SUBA #$30
			CMPA #5
			BHI Inv
			LDAB disp+20
			STAB RMM+1
		
Secnd:		LDAA disp+22		;Populate the second variable
			STAA RSS
			SUBA #$30
			CMPA #5
			BHI Inv 
			LDAB disp+23
			STAB RSS+1
			
Rate:		MOVB #1, RecLSet
			JSR End_Record_Date		;Everything is correct, move on to set the rating.	 !!!!!CHANGE BACK TO MRATING!!!!

		
		
Inv:	LDX	#DISP3				;Load the address of what needs to be displayed
		LDY #disp				;Load the disp variable		

		
Init:	LDAA 1,X+				;Load first variable of DISP. initalize the string.
		CMPA #$30					;See if last value
		BEQ Next				;Move to the next thing.
		STAA 1,Y+				;Save it to the address in disp
		BRA Init				;Keep looping until string is populated.
	
Next:	LDD #disp
		JSR display_string
		
			LDY #60000				;Displays incorrect date string for a time
			LDAA #20
Loop1:		DEY
			BEQ Next1
			BRA Loop1
Next1:		DECA 
			BEQ Return
			BRA Loop1
			
Return:		JSR Enter_Rec_Time				;Ask the user to enter in a date again