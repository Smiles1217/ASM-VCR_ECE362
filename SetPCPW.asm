	XDEF SetPCPW
	XREF disp, display_string
	
SetPCPW:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'S',disp+16 ;Line 2 Start
           movb #'e',disp+17
           movb #'t',disp+18
           movb #' ',disp+19
           movb #'P',disp+20
           movb #'C',disp+21
           movb #' ',disp+22
           movb #'P',disp+23
           movb #'a',disp+24
           movb #'s',disp+25 
           movb #'s',disp+26 
           movb #'w',disp+27 
           movb #'o',disp+28
           movb #'r',disp+29
           movb #'d',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0'    
;*********************string initialization*********************

		LDD		#disp				;Load display.
		JSR		display_string		;Display the string.		   
		RTS