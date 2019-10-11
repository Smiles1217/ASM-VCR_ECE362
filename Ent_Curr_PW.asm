	XDEF Ent_Curr_PW
	XREF PASS, StoreIND, Keypad, disp, display_string, ConfirmPW, PasswordSet
	
My_Variable		SECTION
Counter			ds.b	1

Ent_Curr_PW:

         LDAA  PasswordSet          ;If this is the first time Ent_Curr_PW has been called
         LBEQ  SetDisp              ;Ask to Set the Password, Otherwise ask to Enter the Password
         
;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'E',disp	 ;Line 1 Start
           movb #'n',disp+1
           movb #'t',disp+2
           movb #'e',disp+3
           movb #'r',disp+4
           movb #' ',disp+5
           movb #'P',disp+6
           movb #'a',disp+7
           movb #'s',disp+8
           movb #'s',disp+9
           movb #'w',disp+10
           movb #'o',disp+11
           movb #'r',disp+12
           movb #'d',disp+13
           movb #':',disp+14
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
           movb #' ',disp+28
           movb #' ',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0  ,disp+32    ;string terminator, acts like '\0' 
    
;*********************string initialization*********************
         LBRA  StartPW

SetDisp:
;*********************string initializations*********************
           ;intializing string "disp" to be:
           
           movb #'S',disp	 ;Line 1 Start
           movb #'e',disp+1
           movb #'t',disp+2
           movb #' ',disp+3
           movb #'P',disp+4
           movb #'C',disp+5
           movb #' ',disp+6
           movb #'P',disp+7
           movb #'a',disp+8
           movb #'s',disp+9
           movb #'s',disp+10
           movb #'w',disp+11
           movb #'o',disp+12
           movb #'r',disp+13
           movb #'d',disp+14
           movb #':',disp+15
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
           movb #' ',disp+28
           movb #' ',disp+29
           movb #' ',disp+30
           movb #' ',disp+31
           movb #0,disp+32    ;string terminator, acts like '\0' 
           
;*********************string initialization*********************
        MOVB  #1, PasswordSet
		
StartPW:LDD #disp
				JSR display_string 				;Display the string
				LDY #PASS
				
				JSR Keypad 						;Read a value from the keypad
				LDAA StoreIND					;Load what was input
				ADDA #$30						;Convert to ASKII
				STAA disp+16					;Post auto increment though 4 values of input
				STAA PASS						;Store in PASS.
				LDD #disp
				JSR display_string 				;Display the string
				
				JSR Keypad 						;Read a value from the keypad
				LDAA StoreIND					;Load what was input
				ADDA #$30						;Convert to ASKII
				STAA disp+17					;Post auto increment though 4 values of input
				STAA PASS+1						;Store in PASS.
				LDD #disp
				JSR display_string 				;Display the string
				
				JSR Keypad 						;Read a value from the keypad
				LDAA StoreIND					;Load what was input
				ADDA #$30						;Convert to ASKII
				STAA disp+18					;Post auto increment though 4 values of input
				STAA PASS+2						;Store in PASS.
				LDD #disp
				JSR display_string 				;Display the string
				
				JSR Keypad 						;Read a value from the keypad
				LDAA StoreIND					;Load what was input
				ADDA #$30						;Convert to ASKII
				STAA disp+19					;Post auto increment though 4 values of input
				STAA PASS+3						;Store in PASS.
				LDD #disp
				JSR display_string 				;Display the string
				
    		JSR ConfirmPW