	XDEF Parent_Control_Disp
	XREF disp, display_string, ParentRating, Port_P, DelayCounter, Keypad, StoreIND, SetLCD_SettingsMenu, Change_Settings, RatingLimitSet
	XREF Pot_Menu_Selector, Option, MRating, PB_Testing, SetPCPW, Menu, SetPCMO, PreviousMenu, SetLCD_PreviousMenu, Ent_Curr_PW
	XREF ConfirmPW, ConfPW, PWCFlg, Port_t, SSaverFlg, CurrSSSet, Wall_Clock, SECOND, CountMS, PlayPause, port_s, LEDVAL, PlayT
  XREF PCDisp, PasswordSet


Parent_Control_Disp:

;*********************string initializations*********************
           ;intializing string "disp" to be:

           movb #'P',disp	 ;Line 1 Start
           movb #'C',disp+1
           movb #' ',disp+2
           movb #'s',disp+3
           movb #'e',disp+4
           movb #'t',disp+5
           movb #' ',disp+6
           movb #'t',disp+7
           movb #'o',disp+8
           movb #':',disp+9
           movb #' ',disp+10
           movb #' ',disp+11
           movb #' ',disp+12
           movb #' ',disp+13
           movb #' ',disp+14
           movb #' ',disp+15
    
;*********************string initialization*********************

			        LDAA ParentRating		;Load current parent rating
		        	CMPA #0					;If the parental rating is set to "off"/0
        			BEQ dispOFF				;Branch to display that it's off.
	        		CMPA #1					;If the parental ratin gis set to G/1
	        		BEQ dispG				;Branch to display G
	        		CMPA #2					;If the parental rating is set to PG/2
	        		BEQ dispPG				;Branch to display PG
	        		CMPA #3					;If parental rating is set to PG-13/3
	        		BEQ dispPG13			;Branch to display PG13
	        		CMPA #4					;If parental rating is set to R/4
	        		LBEQ dispR				;Branch to dispaly R
			
dispOFF:	    movb #'N',disp+10
		        	movb #'o',disp+11
		        	movb #'t',disp+12
		        	movb #'S',disp+13
	        		movb #'e',disp+14
	        		movb #'t',disp+15
		        	LBRA Display 			;Display
			
dispG:	     	movb #' ',disp+10
	        		movb #' ',disp+11
	        		movb #'G',disp+12
		        	movb #' ',disp+13
		        	movb #' ',disp+14
	        		movb #' ',disp+15
	        		BRA Display 			;Display

dispPG:	    	movb #' ',disp+10
		        	movb #' ',disp+11
	        		movb #'P',disp+12
	        		movb #'G',disp+13
	        		movb #' ',disp+14
	        		movb #' ',disp+15
	        		BRA Display 			;Display
			
dispPG13:   	movb #' ',disp+10
	        		movb #'P',disp+11
	        		movb #'G',disp+12
	        		movb #'-',disp+13
	        		movb #'1',disp+14
	        		movb #'3',disp+15
	        		BRA Display 			;Display

dispR:	    	movb #' ',disp+10
	        		movb #' ',disp+11
	        		movb #'R',disp+12
	        		movb #' ',disp+13
	        		movb #' ',disp+14
	        		movb #' ',disp+15
	        		BRA Display 			;Display

Display:	    LDD	#disp				;Load display string from memory
	        		JSR display_string		;Display to LCD.
	        		MOVB #8, Menu			;Change the menu to parental control settings (8)
			
Loop:	      	MOVB #1, PCDisp
              LDAA 	ConfPW
	        		CMPA 	#1
	        		LBEQ 	ConfirmPss1
			
	        		LDAA 	SSaverFlg
	        		CMPA 	#1
	        		LBEQ	PICKSS
			
	        		LDAA 	PlayPause			;If movie is playing, update the LEDs
	        		CMPA 	#1
	        		BEQ 	LOADLED
	        		BRA 	PMS
			
LOADLED:    	LDAA 	LEDVAL
		        	STAA 	port_s
			
PMS:      		JSR		Pot_Menu_Selector	;Chose menu selections
	        		LDAA	Option 				;Load the option number into A
	        		CMPA	#1					
	        		BEQ		SelSetPC			;Option 1: Set Rating Limit
	        		CMPA	#2
	        		BEQ		SelSetPW			;Option 2: Set Password
	        		CMPA	#3					
	        		BEQ 	Prev				;Option 3: Load previous Menu
			


SelSetPC:   	JSR		SetPCMO				;Display "Set PC Rating"
		         	LDAA	Port_P
        			JSR		DelayCounter
	        		STAA	PB_Testing
		        	CMPA	#0
	        		BEQ		Release		
	        		BRA		Loop

Release:      LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release
	        		
SetPC:	    	MOVB  #0, SECOND
		        	MOVB  #0, CountMS
		        	MOVB  #0, RatingLimitSet
		        	JSR   MRating 				;Jump to set the rating		
	          	BRA   Loop
			


SelSetPW:   	JSR		SetPCPW				;Display "Set PC Password"
	        		LDAA	Port_P
	        		JSR		DelayCounter
	        		STAA	PB_Testing
	        		CMPA	#0
	        		BEQ		Release1		
	        		BRA		Loop

Release1:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release1
	        		
SetPW:    		MOVB  #0, SECOND
		        	MOVB  #0, CountMS
	        		BRSET Port_t, #$01, ConfirmPss
	        		MOVB  #0, PasswordSet
	        		JSR 	Ent_Curr_PW	
	        		LBRA 	Parent_Control_Disp			
			
			
			
Prev:	      	JSR		SetLCD_PreviousMenu ;Display "Previous Menu"
		        	LDAA	Port_P
		        	JSR		DelayCounter
		        	STAA	PB_Testing
	        		CMPA	#0
        			BEQ		Release2		
	        		LBRA	Loop
	        		
Release2:     LDAA  Port_P                ;This Section waits for the PB to be released
              JSR		DelayCounter			    ;Wait 1 Millisecond (Debounce)
              CMPA  #0          
              BEQ   Release2	        		
	        		
Pre:	      	MOVB #0, SECOND
		        	MOVB #0, CountMS
		        	JSR  	SetLCD_SettingsMenu	
			
ConfirmPss: 	MOVB 	#1, PWCFlg	
	        		JSR 	ConfirmPW
			
ConfirmPss1:	JSR ConfirmPW

PICKSS:	    	LDAA 	CurrSSSet
		        	CMPA 	#0
		        	BEQ		WC
	        		CMPA 	#1
	        		BEQ		PSS
	        		LBRA	Loop
			
PSS:    	  	JSR		PlayT
			
WC:		      	JSR 	Wall_Clock
		   	

