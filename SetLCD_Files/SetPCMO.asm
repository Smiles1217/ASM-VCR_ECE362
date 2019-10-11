	XDEF SetPCMO
	XREF disp, display_string

SetPCMO:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'S',disp+16 ;Line 2 Start
           movb #'e',disp+17
           movb #'t',disp+18
           movb #' ',disp+19
           movb #'R',disp+20
           movb #'a',disp+21
           movb #'t',disp+22
           movb #'i',disp+23
           movb #'n',disp+24
           movb #'g',disp+25 
           movb #' ',disp+26 
           movb #'L',disp+27 
           movb #'i',disp+28
           movb #'m',disp+29
           movb #'i',disp+30
           movb #'t',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************

		LDD		#disp				;Load display.
		JSR		display_string		;Display the string.		   
		RTS