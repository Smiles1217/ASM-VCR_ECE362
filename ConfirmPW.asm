	XDEF ConfirmPW
	XREF CONF, PASS, display_string, disp, Parent_Control_Disp, Ent_Curr_PW, PWChanged, NoMatch, StoreIND, Keypad
	XREF SetLCD_PlayMenu, NTK, PSET, Menu, PreviousMenu, Confirmed, SetLCD_Error, SetLCD_StartMenu, MRating, RTICALL, PCON, ConfPW
	XREF SetLCD_MainMenu, StartF, SetLCD_SettingsMenu, Port_t, PWCFlg, PlayPause, CurrSSSet, PCDisp
	
My_Variables	SECTION
Counter			ds.b	1
Different 	ds.b 	1
	
ConfirmPW:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'C',disp	 ;Line 1 Start
           movb #'o',disp+1
           movb #'n',disp+2
           movb #'f',disp+3
           movb #'i',disp+4
           movb #'r',disp+5
           movb #'m',disp+6
           movb #' ',disp+7
           movb #'P',disp+8
           movb #'a',disp+9
           movb #'s',disp+10
           movb #'s',disp+11
           movb #'w',disp+12
           movb #'o',disp+13
           movb #'r',disp+14
           movb #'d',disp+15
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

				LDD #disp
				JSR display_string 				;Display the string
				
				JSR Keypad 						;Read a value from the keypad
				LDAA StoreIND					;Load what was input
				ADDA #$30						;Convert to ASKII
				STAA disp+16					;Post auto increment though 4 values of input
				STAA CONF						;Store in PASS.
				LDD #disp
				JSR display_string 				;Display the string
				
				JSR Keypad 						;Read a value from the keypad
				LDAA StoreIND					;Load what was input
				ADDA #$30						;Convert to ASKII
				STAA disp+17					;Post auto increment though 4 values of input
				STAA CONF+1						;Store in PASS.
				LDD #disp
				JSR display_string 				;Display the string
				
				JSR Keypad 						;Read a value from the keypad
				LDAA StoreIND					;Load what was input
				ADDA #$30						;Convert to ASKII
				STAA disp+18					;Post auto increment though 4 values of input
				STAA CONF+2						;Store in PASS.
				LDD #disp
				JSR display_string 				;Display the string
				
				JSR Keypad 						;Read a value from the keypad
				LDAA StoreIND					;Load what was input
				ADDA #$30						;Convert to ASKII
				STAA disp+19					;Post auto increment though 4 values of input
				STAA CONF+3						;Store in PASS.
				LDD #disp
				JSR display_string 				;Display the string

Confirm:LDAA PASS
				LDAB CONF
				CBA 
				BEQ Same1
				BRA Diff

Same1:	LDAA PASS+1
				LDAB CONF+1
				CBA 
				BEQ Same2
				BRA Diff

Same2:	LDAA PASS+2
				LDAB CONF+2
				CBA 
				BEQ Same3
				BRA Diff
				
Same3:	LDAA PASS+3
				LDAB CONF+3
				CBA 
				BEQ Same
				BRA Diff
				
Same:		LDAA PSET
				CMPA #0
				BEQ PWCh
				BRA PWCONF						

PWCh:	  JSR PWChanged					;Jump to display that password has changed.
				BRA LPM
				
PWCONF:	JSR Confirmed 					;Tell the user they entered the correct password
				BRA LPM							;Branch to load calling menu !!!!!!!!!!LOOK AT!!!!!!!!!!

Diff:		BRSET Port_t, #$01, YEP					;See if the password has been set 
				MOVB #1, Different 				;Flag to show input is different					
				
NAH:		JSR NoMatch						;Passwords didn't match
				JSR Ent_Curr_PW					;Return to origonal PW menu
				
YEP:	  JSR NTK							;Gonna need to see some ID
				BRA LPM							;Branch to calling menu
				
LPM:		LDAA StartF
				CMPA #0
				BEQ StartUP
				MOVB #0, ConfPW			;Password has been confirmed, unset the flag
				LDAA Menu
				CMPA #1
				BEQ StartM
				CMPA #2
				BEQ MainM				    ;To branch to the main menu
				CMPA #3							;If the play menu is the calling function, go back to it.
				BEQ PlayM 
				CMPA #4							;If called from the settings menu
				BEQ SetM
				CMPA #5							;If called from the rating menu
				BEQ RatingM						
				CMPA #6							;If the parent control menu is the calling function, go back to it
				BEQ ParentM
				
StartM:	JSR SetLCD_StartMenu			;Branch to the start menu
				
PlayM:	JSR SetLCD_PlayMenu

ParentM:LDAA PWCFlg						;Means PC menu					
				CMPA #1
				BEQ Nxt 
				JSR Parent_Control_Disp			;Jump to set the rating
				
Nxt:		MOVB #0, PWCFlg
				JSR Ent_Curr_PW						;Allow user to enter new password

MainM:	JSR SetLCD_MainMenu

SetM:		JSR SetLCD_SettingsMenu

RatingM:BRSET Port_t, #$01, Cont  
				BRA   PlayMenu

Cont:		LDAA Different 
				CMPA #1
				BEQ Cont2	
				LDAA PCDisp
				CMPA #1
				BNE PlayMenu
				MOVB #0, PCDisp
				JSR Parent_Control_Disp
				
PlayMenu:JSR SetLCD_PlayMenu
				
Cont2:	MOVB #0, Different
				LDAA PreviousMenu
				CMPA #3
				BEQ PlayM
				CMPA #6
				BEQ ParentM

StartUP:MOVB #1, StartF
				CLI
				JSR SetLCD_StartMenu
				
