	XDEF Wall_Clock
	XREF disp, display_string, MO, YEAR, DAY, HH, MM, SS, SSKeypad, StoreIND, SSaverFlg, SetLCD_PlayMenu, SetLCD_SettingsMenu, MRating
	XREF Parent_Control_Disp, SetLCD_MainMenu, Menu, SetLCD_StartMenu, Keypad, PreviousMenu, PB_Testing, DelayCounter, Port_P, SECOND
	XREF CountMS, VHSLoaded, RecordN, CurrSSSet

My_Constants 	SECTION
DISP			dc.b 	'VHS     /  /    LOADED    :  :  0'
DISP1			dc.b 	'VHS     /  /    EJECTED   :  :  0'

Wall_Clock:
		        LDAA Menu
		        STAA PreviousMenu
		           
	          LDAA VHSLoaded
		        CMPA #0
		        BEQ Ejected
		        
Loaded:		  LDX	#DISP				;Load the address of what needs to be displayed
		        LDY #disp				;Load the disp variable	
		        BRA Init

Ejected:		LDX #DISP1
			      LDY #disp		  	

Init:	      LDAA 1,X+				;Load first variable of DISP. initalize the string.
		        CMPA #$30				;See if last value
		        BEQ Next				;Move to the next thing.
		        STAA 1,Y+				;Save it to the address in disp
		        BRA Init				;Keep looping until string is populated.

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!DISPLAY UPDATED WALL CLOCK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
Next:	      MOVB #1, SSKeypad     ;Set the flag that allows the keypad to only scan once and return if nothing is pressed.
      	  	JSR Keypad              ;This keeps the CPU from getting hung up waiting for a keyboard press.
        		LDAA StoreIND           ;StoreIND is set up to be $FF if nothing is pressed.
        		CMPA #$FF
        		BNE	Wakeup               ;If something is pressed, wake up the display
		
        		LDAA	Port_P          ;Checks if the push button is pressed, if it is, wake up the display
        		JSR		DelayCounter		;Debouncing for PB
        		STAA	PB_Testing
        		CMPA	#0
        		BEQ		Wakeup 	
        		
        		LDAA  CurrSSSet
        		CMPA  #2
        		LBEQ   StartR

        		LDD #disp              ;Load the display
        		JSR display_string
		
        		LDAA MO					;Display Month
        		STAA disp+6
        		LDAA MO+1
        		STAA disp+7
		
        		LDAA DAY				;Display Day
        		STAA disp+9
        		LDAA DAY+1
        		STAA disp+10
		
        		LDAA YEAR				;Display Year
        		STAA disp+12
        		LDAA YEAR+1
        		STAA disp+13
        		LDAA YEAR+2
        		STAA disp+14
        		LDAA YEAR+3
        		STAA disp+15
		
        		LDAA HH					;Display Hour
        		STAA disp+24
        		LDAA HH+1
        		STAA disp+25
		
        		LDAA MM					;Display Minutes
	        	STAA disp+27
		        LDAA MM+1
		        STAA disp+28
		
        		LDAA SS					;Display Seconds
        		STAA disp+30
        		LDAA SS+1
        		STAA disp+31

		        LBRA Next           ;Continuously loads the Wall clock until it is woken up.

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Wakeup:     MOVB #0, SSaverFlg
        		MOVB #0, SECOND
	        	MOVB #0, CountMS
	        	MOVB #0, SSKeypad
	        	LDAA PreviousMenu
	        	CMPA #1						;Start Menu
	        	BEQ StartM
	        	CMPA #2						;Main Menu
	        	BEQ MainM				
	        	CMPA #3						;Play Menu
	        	BEQ PlayM 
	        	CMPA #4						;Settings Menu
	        	BEQ SetM
	        	CMPA #5						;Rating Menu
	        	BEQ RatingM						
	        	BRA ParentM

StartM:			JSR SetLCD_StartMenu			;Branch to the start menu
				
PlayM:			JSR SetLCD_PlayMenu

ParentM:		JSR Parent_Control_Disp			

MainM:			JSR SetLCD_MainMenu

SetM:			  JSR SetLCD_SettingsMenu

RatingM:		JSR MRating

StartR:     JSR RecordN
