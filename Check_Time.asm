	XDEF Check_Time
	XREF display_string, disp, Count2, MRating, Enter_Time, SetLCD_SettingsMenu, Menu, Wall_Clock, HH, SS, MM
	
My_Variables	SECTION
Hold			ds.b	1

My_Constants 	SECTION
DISP3			dc.b 	'Invalid Time                  0'

Check_Time:

			LDAA disp+16		;Populate and check the hour variable
			STAA HH
			SUBA #$30
			CMPA #2
			LBHI Inv
			BEQ Chk_HR 
Cont_H		LDAB disp+17
			STAB HH+1
			BRA Min
			
Chk_HR:		LDAA disp+17
			SUBA #$30
			CMPA #3
			BHI Inv
			BRA Cont_H
		
Min:		LDAA disp+19		;Populate the minute variable
			STAA MM
			SUBA #$30
			CMPA #5
			BHI Inv
			LDAB disp+20
			STAB MM+1
		
Secnd:		LDAA disp+22		;Populate the second variable
			STAA SS
			SUBA #$30
			CMPA #5
			BHI Inv 
			LDAB disp+23
			STAB SS+1
		
			LDAA Menu
			CMPA #0				;Initalization 
			BEQ Rate
			CMPA #4				;Settings menu calling
			BEQ SMenu
			
			
			
Rate:		JSR MRating		;Everything is correct, move on to set the rating
SMenu:		JSR SetLCD_SettingsMenu 
		
		
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
			
Return:		JSR Enter_Time			;Ask the user to enter in a date again