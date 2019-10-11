	XREF	disp, PreviousMenu, display_string, Menu, Keypad, StoreIND, UserError, MRating, MTime, SetLCD_Confirm, Port_P
	XREF	DelayCounter, PB_Testing
	XDEF	MovieLength
	
MovieLength:
	
;*********************string initializations*********************
           ;intializing string "disp" to be:
           ;"The value of the pot is:      ",0
           movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #'M',disp+2
           movb #'o',disp+3
           movb #'v',disp+4
           movb #'i',disp+5
           movb #'e',disp+6
           movb #' ',disp+7
           movb #'L',disp+8
           movb #'e',disp+9
           movb #'n',disp+10
           movb #'g',disp+11
           movb #'t',disp+12
           movb #'h',disp+13
           movb #':',disp+14
           movb #' ',disp+15
           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #' ',disp+19
           movb #' ',disp+20
           movb #' ',disp+21
           movb #' ',disp+22 
           movb #' ',disp+23 ;Length 1 to F
           movb #'S',disp+24
           movb #'e',disp+25 
           movb #'c',disp+26 
           movb #'o',disp+27 
           movb #'n',disp+28
           movb #'d',disp+29
           movb #'s',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0' 
               
;*********************string initialization*********************

			LDD 	#disp				;Load the mneu title into D
			JSR		display_string		;Display the string
			
			;Read the input from the keypad
Loop:		JSR		Keypad				;Run keypad routine to gather input 1
			DEC		StoreIND			;The values we are currently getting are over by 1
			LDAA	StoreIND			;Load the index
			STAA 	MTime
			CMPA	#10
			BGE		Seperate
			LDAB	#$30
			ABA
			STAA	disp+22				;Store to the LCD
			LDD		#disp
			JSR		display_string		;Display the users input to the screen
			BRA		Confirm

Seperate:	CLRA
			LDAB	StoreIND
			LDX		#10
			IDIVS
			PSHD
			LDAB	#$30
			ABX
			PSHX
			PULD
			STAB	disp+21
			LDAB	#$30
			PULA
			PULA
			ABA
			STAA	disp+22
			LDD		#disp
			JSR		display_string
			BRA		Confirm
			
Confirm:	JSR		SetLCD_Confirm
			LDAA	Port_P
			JSR		DelayCounter
			STAA	PB_Testing
			CMPA	#0
			BEQ		Exit
			BRA		Confirm
			
Exit:		JSR		MRating				;Check the movie rating