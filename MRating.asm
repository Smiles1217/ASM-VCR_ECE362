	XREF	display_string, Menu, PreviousMenu, disp, Option, G, PG, PG13, R, Pot_Menu_Selector, DelayCounter, Port_P
	XREF	SetLCD_PlayMenu, SetLCD_StartMenu, SwitchMenu, SSaverFlg, ParentRating, Parent_Control_Disp, SECOND, Wall_Clock
	XREF  Ent_Curr_PW, CountMS, ConfPW, Comp, ConfirmPW, PlayPause, CurrSSSet, port_s, PlayT, LEDVAL, RatingLimitSet
	XREF  PasswordSet, Port_t 
	XDEF	MRating

MRating:

            LDAA  RatingLimitSet       ;If this is the first time MRating has been called
            LBEQ  SetDisp              ;Ask for the Rating Limit, Otherwise ask for the Movie Rating
	
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
           movb #'R',disp+8
           movb #'a',disp+9
           movb #'t',disp+10
           movb #'i',disp+11
           movb #'n',disp+12
           movb #'g',disp+13
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
           movb #0,disp+32    ;string terminator, acts like '\0' 
           
;*********************string initialization*********************
              LBRA  StartRate     

SetDisp:
;*********************string initializations*********************
           ;intializing string "disp" to be:
           ;"The value of the pot is:      ",0
           movb #' ',disp	 ;Line 1 Start
           movb #'R',disp+1
           movb #'a',disp+2
           movb #'t',disp+3
           movb #'i',disp+4
           movb #'n',disp+5
           movb #'g',disp+6
           movb #' ',disp+7
           movb #'L',disp+8
           movb #'i',disp+9
           movb #'m',disp+10
           movb #'i',disp+11
           movb #'t',disp+12
           movb #':',disp+13
           movb #' ',disp+14
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
           movb #0,disp+32    ;string terminator, acts like '\0' 
           
;*********************string initialization*********************
              MOVB  #1, RatingLimitSet

StartRate:	  LDAA	Menu				;Loads the value of the previous menu into A.
		        	STAA	PreviousMenu		;Stores it as the previous menu
			        MOVB 	#5, Menu			;Load the Play menu options
			        LDD 	#disp				;Load the mneu title into D
			        JSR		display_string		;Display the string

Loop:	        LDAA 	ConfPW				;Flag for PW confirmation if PC goes from hi to lo
		        	CMPA 	#1
		        	LBEQ 	ConfirmPss
			
	        		LDAA 	SSaverFlg
	        		CMPA 	#1
		        	LBEQ	PICKSS
			
	        		LDAA 	PlayPause			;If movie is playing, update the LEDs
        			CMPA 	#1
        			BEQ 	LOADLED
	        		BRA 	PMS
			
LOADLED:     	LDAA 	LEDVAL
		        	STAA 	port_s

PMS:	        MOVB	#32, Port_P
			        LDAA	SwitchMenu			;Load A with the SwitchMenu Value
			        LBNE	GoToStart			;If not equal to 0, branch to GoToStart to go back to the StartMenu
              JSR		Pot_Menu_Selector	;Load the Menu options for Rating display
		        	LDAA	Option
		        	CMPA	#1
	        		BEQ		GR
	        		CMPA	#2
		        	BEQ		PGR
	        		CMPA	#3
		        	BEQ		PG13R
		        	LBRA	RR
			
;!!!!!!!!!!!!!!!G-RATING IS SET HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		
			
GR:			      JSR		G	
			        LDAA	Port_P
			        JSR		DelayCounter	;For debounce.
		        	CMPA	#0
			        BEQ		Release
			        BRA		Loop

Release:      LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release
			
ST1:		      MOVB #0, SECOND
			        MOVB #0, CountMS
			        LDAA PreviousMenu		;Check calling function
			        CMPA #3					;If we're the parent.
			        BNE P1					;Set the parental rating
			
			        MOVB #1, Comp
			        LBRA Ret
			
P1:		      	MOVB #1, ParentRating	;Set the parental rating to 1/G.
			        LBRA Ret					;Return
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			
;!!!!!!!!!!!!!!!PG-RATING IS SET HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	
PGR:		      JSR		PG	
			        LDAA	Port_P
			        JSR		DelayCounter	;For debounce.
			        CMPA	#0
			        BEQ		Release1
		        	LBRA	Loop

Release1:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release1
			
ST2:		      MOVB  #0, SECOND
		        	MOVB  #0, CountMS
			        LDAA  PreviousMenu		;Check calling function
			        CMPA  #3					;If we're the parent.
			        BNE   P2					;Set the parental rating
			
			        MOVB  #2, Comp
			        LBRA  Ret
			
P2:			      MOVB  #2, ParentRating	;Set the parental rating to 2/PG.
			        BRA   Ret					;Return
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!				
						
;!!!!!!!!!!!!!!!PG13-RATING IS SET HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!				
PG13R:		    JSR		PG13	
		          LDAA	Port_P
			        JSR		DelayCounter	;For debounce.
			        CMPA	#0
			        BEQ		Release2
		          LBRA	Loop

Release2:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release2
			
ST3:		      MOVB  #0, SECOND
			        MOVB  #0, CountMS
		        	LDAA  PreviousMenu		;Check calling function
			        CMPA  #3				;If we're the parent.
		        	BNE   P3					;Set the parental rating
			
			        MOVB  #1, Comp
			        BRA   Ret
			
P3:			      MOVB  #3, ParentRating	;Set the parental rating to 3/PG-13.
			        BRA   Ret					;Return
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	

;!!!!!!!!!!!!!!!R-RATING IS SET HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	
RR:			      JSR		R	
			        LDAA	Port_P
			        JSR		DelayCounter	        ;For debounce.
			        CMPA	#0
			        BEQ		Release3
			        LBRA	Loop

Release3:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release3
			
ST4:		      MOVB  #0, SECOND
		        	MOVB  #0, CountMS
			        LDAA  PreviousMenu		      ;Check calling function
			        CMPA  #3					          ;If we're the parent
			        BNE   P4					          ;Set the parental rating
			
			        MOVB  #4, Comp
			        BRA   Ret
			
P4:			      MOVB  #4, ParentRating	    ;Set the parental rating to 4/R
		        	BRA   Ret					          ;Return
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			
GoToStart:  	MOVB	#0,SwitchMenu		      ;Reset SwitchMenu value to 0 (No switch needed)
		        	JSR		SetLCD_StartMenu	    ;Go back to the StartMenu
			
Ret:	        LDAA 	Menu	
		          CMPA 	#3
		          BEQ 	CMPRat				        ;See if password is required.
		          CMPA 	#6	
		          BEQ 	RetPC				          ;Branch to the PC menu
		          JSR 	Ent_Curr_PW			      ;Otherwise branch initalize the password
		
RetPC:	      JSR 	Parent_Control_Disp		;Return to parental control menu
 
RetPl:	      MOVB	#1, CurrSSSet		      ;Flag to show that the movie is Paused, but Ready to be Played
		          MOVB	#2, PlayPause
		          JSR 	SetLCD_PlayMenu
			
ConfirmPss:	  JSR 	ConfirmPW

CMPRat:		    BRCLR Port_t, #$01, RetPl   ;If Switch 1 is not set, branch to RetPl because PC is disabled
              LDAA  Comp
			        LDAB  ParentRating
			        CBA
			        BHI	  ConfirmPss
			        BRA   RetPl
			
PICKSS:		    LDAA 	CurrSSSet
			        CMPA 	#0
			        BEQ		WC
		          CMPA 	#1
			        BEQ		PSS
		        	LBRA	Loop
			  
PSS:	      	JSR		PlayT
			
WC:		      	JSR 	Wall_Clock