	XDEF NTK
	XREF disp, display_string
	
NTK:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp	 ;Line 1 Start
           movb #'I',disp+1
           movb #'m',disp+2
           movb #' ',disp+3
           movb #'G',disp+4
           movb #'o',disp+5
           movb #'n',disp+6
           movb #'n',disp+7
           movb #'a',disp+8
           movb #' ',disp+9
           movb #'N',disp+10
           movb #'e',disp+11
           movb #'e',disp+12
           movb #'d',disp+13
           movb #' ',disp+14
           movb #' ',disp+15
           movb #'T',disp+16 ;Line 2 Start
           movb #'o',disp+17
           movb #' ',disp+18
           movb #'S',disp+19
           movb #'e',disp+20
           movb #'e',disp+21
           movb #' ',disp+22
           movb #'S',disp+23
           movb #'o',disp+24
           movb #'m',disp+25 
           movb #'e',disp+26 
           movb #' ',disp+27 
           movb #'I',disp+28
           movb #'D',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0  ,disp+32    ;string terminator, acts like '\0' 
    
;*********************string initialization*********************

		    	LDD #disp
		    	JSR display_string 
			
		    	LDY #60000
		    	LDAA #20

Loop:	  	DEY
		    	BEQ Next 
			    BRA Loop

Next:	  	DECA 
		    	BEQ Return
		    	BRA Loop
			
Return:		RTS