	XDEF UserError
	XREF disp, PreviousMenu, display_string, Menu, Keypad, StoreIND
	
UserError:
	
;*********************string initializations*********************
           ;intializing string "disp" to be:
           ;"The value of the pot is:      ",0
           movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #' ',disp+2
           movb #'E',disp+3
           movb #'N',disp+4
           movb #'T',disp+5
           movb #' ',disp+6
           movb #'0',disp+7
           movb #'-',disp+8
           movb #'9',disp+9
           movb #' ',disp+10
           movb #' ',disp+11
           movb #' ',disp+12
           movb #' ',disp+13
           movb #' ',disp+14
           movb #' ',disp+15
           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #' ',disp+19
           movb #' ',disp+20
           movb #' ',disp+21
           movb #' ',disp+22
           movb #' ',disp+23
           movb #' ',disp+24
           movb #' ',disp+25 
           movb #' ',disp+26 
           movb #' ',disp+27 
           movb #'S',disp+28
           movb #'E',disp+29
           movb #'C',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0' 
               
;*********************string initialization*********************

			;LDAA	Menu				;Loads the value of the previous menu into A.
			;STAA	PreviousMenu		;Stores it as the previous menu
			;MOVB 	#3, Menu			;Load the Play menu options
			LDD 	#disp				;Load the mneu title into D
			JSR		display_string		;Display the string
			RTS							