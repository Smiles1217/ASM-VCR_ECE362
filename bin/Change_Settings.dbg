	XDEF Change_Settings
	XREF PassSET, PASS, SelectRating, NewPASS, Keypad, StoreIND, MRating, Menu, PreviousMenu, Option, disp, display_string, Pot_Menu_Selector, Ent_Curr_PW
	XREF DelayCounter, Port_P
	

Change_Settings:

;*********************string initializations*********************
           ;intializing string "disp" to be:
           ;"The value of the pot is:      ",0
           movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #' ',disp+2
           movb #'P',disp+3
           movb #'C',disp+4
           movb #' ',disp+5
           movb #' ',disp+6
           movb #' ',disp+7
           movb #'M',disp+8
           movb #'e',disp+9
           movb #'n',disp+10
           movb #'u',disp+11
           movb #':',disp+12
           movb #' ',disp+13
           movb #' ',disp+14
           movb #' ',disp+15
              
;*********************string initialization*********************

			LDD disp
			JSR display_string
			LDAA PassSET 				;Load value to see if password is set
			CMPA #1						;If a password is set 
			LBEQ EntCPW					;Branch to enter the password currently set	
			LDAA Menu					;Loads the value of the previous menu into A.
			STAA PreviousMenu			;Stores it as the previous menu
			MOVB #6, Menu				;Store new menu for pot menu selector
			
Loop:		JSR		Pot_Menu_Selector
			LDAA	Option
			CMPA	#1
			BEQ		SetRating
			CMPA	#2
			BEQ		SetNewPW
			
			
			
			
			
			

SetRating:	
;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'S',disp+16 ;Line 2 Start
           movb #'e',disp+17
           movb #'t',disp+18
           movb #' ',disp+19
           movb #'n',disp+20
           movb #'e',disp+21
           movb #'w',disp+22
           movb #' ',disp+23
           movb #'R',disp+24
           movb #'a',disp+25 
           movb #'t',disp+26 
           movb #'i',disp+27 
           movb #'n',disp+28
           movb #'g',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************
			LDD disp
			JSR display_string
			LDAA	Port_P
			JSR		DelayCounter
			CMPA	#0					;If selected, 
			BEQ		JSetRating			;Branch to jump to Parent_Control Display menu
			BRA		Loop
			
JSetRating:	MOVB #1, SelectRating		;Say we're the parent.
			JMP MRating					;Select the rating.
			MOVB #0, SelectRating		;Turn off parent allowance.
			
			
			
			
			
			

SetNewPW:
;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'S',disp+16 ;Line 2 Start
           movb #'e',disp+17
           movb #'t',disp+18
           movb #' ',disp+19
           movb #'n',disp+20
           movb #'e',disp+21
           movb #'w',disp+22
           movb #' ',disp+23
           movb #'P',disp+24
           movb #'a',disp+25 
           movb #'s',disp+26 
           movb #'s',disp+27 
           movb #'w',disp+28
           movb #'o',disp+29
           movb #'r',disp+30
           movb #'d',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************
			MOVB #1, NewPASS			;Say we're entering a new password.
			JMP Ent_Curr_PW				;Jump to password routine
			MOVB #0, NewPASS			;Unset the new password flag.
				
EntCPW:		JSR Ent_Curr_PW				;Jump to enter the password currently set.
			
			
			
