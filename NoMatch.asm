	XDEF NoMatch
	XREF disp, display_string, Ent_Curr_PW, ConfirmPW
	
NoMatch:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #' ',disp	 ;Line 1 Start
           movb #' ',disp+1
           movb #' ',disp+2
           movb #' ',disp+3
           movb #'P',disp+4
           movb #'a',disp+5
           movb #'s',disp+6
           movb #'s',disp+7
           movb #'w',disp+8
           movb #'o',disp+9
           movb #'r',disp+10
           movb #'d',disp+11
           movb #'s',disp+12
           movb #' ',disp+13
           movb #' ',disp+14
           movb #' ',disp+15
           movb #'D',disp+16 ;Line 2 Start
           movb #'i',disp+17
           movb #'d',disp+18
           movb #' ',disp+19
           movb #'N',disp+20
           movb #'O',disp+21
           movb #'T',disp+22
           movb #' ',disp+23
           movb #'M',disp+24
           movb #'a',disp+25 
           movb #'t',disp+26 
           movb #'c',disp+27 
           movb #'h',disp+28
           movb #'!',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0  ,disp+32    ;string terminator, acts like '\0' 
    
;*********************string initialization*********************

			    LDD   #disp
			    JSR   display_string 
			
		    	LDY   #60000
			    LDAA  #20

Loop:		  DEY
			    BEQ   Next 
			    BRA   Loop

Next:		  DECA 
			    BEQ   Return
			    BRA   Loop
			
Return:		JSR   ConfirmPW
			