	XREF	disp, display_string
	XDEF	PG13

PG13:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #' ',disp+19
           movb #' ',disp+20
           movb #' ',disp+21
           movb #'P',disp+22
           movb #'G',disp+23
           movb #'-',disp+24
           movb #'1',disp+25 
           movb #'3',disp+26 
           movb #' ',disp+27 
           movb #' ',disp+28
           movb #' ',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************

			LDD 	#disp				;Load the mneu title into D
			JSR		display_string		;Display the string
			
			RTS