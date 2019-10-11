	XDEF PWChanged
	XREF disp, display_string, Parent_Control_Disp
	
PWChanged:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'P',disp	 ;Line 1 Start
           movb #'a',disp+1
           movb #'s',disp+2
           movb #'s',disp+3
           movb #'w',disp+4
           movb #'o',disp+5
           movb #'r',disp+6
           movb #'d',disp+7
           movb #' ',disp+8
           movb #'C',disp+9
           movb #'h',disp+10
           movb #'a',disp+11
           movb #'n',disp+12
           movb #'g',disp+13
           movb #'e',disp+14
           movb #' ',disp+15
           movb #'S',disp+16 ;Line 2 Start
           movb #'u',disp+17
           movb #'c',disp+18
           movb #'c',disp+19
           movb #'e',disp+20
           movb #'s',disp+21
           movb #'s',disp+22
           movb #'f',disp+23
           movb #'u',disp+24
           movb #'l',disp+25 
           movb #'l',disp+26 
           movb #'!',disp+27 
           movb #' ',disp+28
           movb #' ',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0  ,disp+32    ;string terminator, acts like '\0' 
    
;*********************string initialization*********************

			    LDD #disp
			    JSR display_string 
			
			    LDY #60000
			    LDAA #20

Loop:		  DEY
			    BEQ Next 
		      BRA Loop

Next:		  DECA 
			    BEQ Return
			    BRA Loop
			
Return:		RTS