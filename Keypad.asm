	XREF	DelayCounter, port_u, StoreIND, SwitchMenu, SetLCD_StartMenu, SSaverFlg, SECOND, CountMS, SSKeypad
	XDEF	Keypad
	
MyVariables: SECTION
var2		ds.b 	1				;The Actual Hex Keypad Value that was Pressed

MyConstants: SECTION
Seq			dc.b 	$EB, $77, $7B, $7D, $B7, $BB, $BD, $D7, $DB, $DD, $E7, $ED, $7E, $BE, $DE, $EE  
Row			dc.b 	$70, $B0, $D0, $E0, $0

	
Keypad:		;This is the Keypad Subroutine

          LDAA	SwitchMenu			;Load A with the SwitchMenu Value
			    LBNE	GoToStart			;If not equal to 0, branch to GoToStart to go back to the StartMenu

			    LDAA #0				
			    STAA StoreIND		;Reset index
			    
LDRow:		LDX #Row			;Grab address of row 

ScanNR:		LDAA 1,X+			;Load an element for the row
			    CMPA #$0			;See if last value of the row							
		    	BEQ SSFlg			;See if we need to set the a screen saver 
		    	STAA port_u 		;Store to keyboard input
		    	JSR DelayCounter	;Delay for 1ms (debounce allowance)
		    	LDAB port_u			;Read the value of port u
	    		STAB var2			;Store B for later.
	    		ANDB #$0F			;Mask upper nibble of port u
	    		CMPB #$F			;Check if nothing is presseD		
	    		BEQ ScanNR			;Branch to scan next row
	    		LDY #Seq			;Load the address of the sequence
    			LDAA #0				;Store 0 into A
    			STAA StoreIND		;Store index counter.
    			
CheckSeq:	LDAA 1,Y+			;Postautoinc, through sequence.
    			LDAB StoreIND		;Load B with the index.
    			INCB				;Increment index 
    			STAB StoreIND		;Store new index back into memory
    			LDAB var2			;Load full value of port u to B
    			CBA					;Compare Seq number to what's stored in port u			
    			BEQ Release			;Value found, print it
    			BRA CheckSeq		;Else, branch back to continue looking

Release:	BRSET port_u, #$0F, Return	;To return 
		    	JSR DelayCounter 			;Debounce
	    		BRA Release 				;Wait for button to be unpressed.


Return:		LDAA StoreIND		;Load index
    			DECA				;Increase by 1
    			STAA StoreIND		;Store it back 
    			MOVB #0, SSaverFlg	;Reset the screen saver flag
    			MOVB #0, SECOND
    			MOVB #0, CountMS
    			RTS					;Return to main
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SSFlg:		LDAA SSKeypad
    			CMPA #1
    			BNE LDRow
    			MOVB #$FF, StoreIND
    			RTS

GoToStart:MOVB	#0,SwitchMenu		      ;Reset SwitchMenu value to 0 (No switch needed)
			    JSR		SetLCD_StartMenu      ;Go back to the StartMenu