	XREF	disp, display_string
	XDEF	PG

PG:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp+16 ;Line 2 Start
           movb #' ',disp+17
           movb #' ',disp+18
           movb #' ',disp+19
           movb #' ',disp+20
           movb #' ',disp+21
           movb #' ',disp+22
           movb #'P',disp+23
           movb #'G',disp+24
           movb #' ',disp+25 
           movb #' ',disp+26 
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