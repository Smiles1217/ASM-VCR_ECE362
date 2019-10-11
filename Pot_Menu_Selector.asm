	XDEF Pot_Menu_Selector, PValue_Testing
	XREF Menu, read_pot, pot_value, init_LCD, display_string, SetLCD_StartMenu, SetLCD_MainMenu, SetLCD_PlayMenu, SetLCD_SettingsMenu, SetLCD_LoadVHS, SetLCD_ParentPswrdSet, SetLCD_DateTime, SetLCD_PreviousMenu, SetLCD_PlayMovie, SetLCD_RecordNow, SetLCD_RecordLater, SetLCD_EjectVHS, SetLCD_FastForward, SetLCD_Rewind, SetLCD_Playing, SetLCD_Paused, SetLCD_Error, Option, PValue_Testing
	XREF SetLCD_SelectSettingsMenu
	
	
Pot_Menu_Selector:
		
			        LDAA Menu		;Load the Menu ID		
		        	CMPA #1			;If Start Menu is calling this function
		        	LBEQ Start		;Load start menu operation			
	        		CMPA #2			;If Main Menu is calling this function
	        		LBEQ Main		;Load Main Menu operation			
	        		CMPA #4			;If Settings Menu is calling this function
        			LBEQ Settings	;Load Settings menu operation			
	         		CMPA #3			;If Play Menu is calling this function
	        		LBEQ Play		;Load Play Menu operation			
		        	CMPA #5			;If Rating Menu is calling this function
	        		LBEQ Rate		;Show rating Menu
	        		CMPA #6			;If Fast Forward Menu is calling this function
	        		LBEQ FF			;Show the Fast Forward Menu
	        		CMPA #7			;If the Rewing Menu is calling this function
	        		LBEQ Rewind		;Show the Rewind Menu
	        		CMPA #8			;If PCont Menu is calling this function
	        		LBEQ PCont		;Show rating Menu
		
		;START MENU OPERATION		
Start:		    JSR	 read_pot	;Read the value of the Pot
		        	STAB PValue_Testing
	        		LDAA PValue_Testing
	        		CMPA #60		;Compare the pot value to 120/2 = 60 (Simulate two options)
	        		BHI SOP2		;Branch to display option 2
		        	MOVB #1, Option	;Option = 1
		        	RTS				;Return from subroutine
		
SOP2	    	  MOVB #2, Option	;Option = 2
			        RTS				;Return from subroutine
				
		;MAIN MENU OPERATION		
Main:		      JSR	 read_pot
		        	STAB PValue_Testing	;Read the value of the pot
	        		LDAA PValue_Testing
        			CMPA #96		;See if pot is set to select last (5th) option
        			BHI MOP5		;Branch to display option 5
	        		CMPA #72		;See if pot is set to select 4th option
	        		BHI	MOP4		;Branch to display option 4
	        		CMPA #48		;See if pot is set to select 3rd option
		        	BHI MOP3		;Branch to display option 3
	        		CMPA #24		;See if pot is set to select 2nd option
	        		BHI MOP2		;Branch to display option 2
		        	MOVB #1, Option	;Option = 1
		        	RTS				;Return from subroutine
		
MOP5:	      	MOVB #5, Option	;Option = 5
			        RTS
			        
MOP4:	      	MOVB #4, Option	;Option = 4
			        RTS
			        
MOP3:		      MOVB #3, Option	;Option = 3
			        RTS
			        
MOP2:		      MOVB #2, Option	;Option = 2
			        RTS		
		
		;SETTINGS MENU OPERATION 
Settings:	    JSR read_pot	;Read the value of the pot
			        STAB PValue_Testing	;Read the value of the pot
		        	LDAA PValue_Testing
	        		CMPA #80		;See if pot is set to select last (3rd) option
	         		BHI SeOP3		;Branch to display option 3
	        		CMPA #40		;See if pot is set to select the 2nd option
		        	BHI SeOP2		;Branch to display option 2
	        		MOVB #1, Option	;Option = 1
	        		RTS
			
SeOP3:	    	MOVB #3, Option	;Option = 3
		        	RTS
		        	
SeOP2:	    	MOVB #2, Option	;Option = 2
		        	RTS
						
		;PLAY MENU OPERATION			
Play:		      JSR	 read_pot
	        		STAB PValue_Testing
        			LDAA PValue_Testing	;Read the value of the pot
	         		CMPA #90		;See if pot is set to select last (4th) option
	        		BHI POP4		;Branch to display option 4
        			CMPA #60		;See if pot is set to select the 3rd option
	        		BHI POP3		;Branch to display option 3
        			CMPA #30		;See if pot is set to select the 2nd option
        			BHI POP2		;Branch to display option 2
        			MOVB #1, Option	;Option = 1
	        		RTS
			
POP4:	      	MOVB #4, Option	;Option = 4
		        	RTS
		        	
POP3:	      	MOVB #3, Option	;Option = 3
			        RTS
			        				
POP2:	      	MOVB #2, Option	;Option = 2
			        RTS	

		;RATINGS SELECTION
Rate:		      JSR	 read_pot	;Read the value of the Pot
		        	STAB PValue_Testing
	        		LDAA PValue_Testing
	        		CMPA #90		;See if pot is set to select last (4th) option
	        		BHI Rate4		;Branch to display option 4
	        		CMPA #60		;See if pot is set to select the 3rd option
	        		BHI Rate3		;Branch to display option 3
	        		CMPA #30		;See if pot is set to select the 2nd option
	        		BHI Rate2		;Branch to display option 2
	        		MOVB #1, Option	;Option = 1
	        		RTS

Rate4:	    	MOVB #4, Option	;Option = 4
			        RTS
			    
Rate3:		    MOVB #3, Option	;Option = 3
			        RTS	
						
Rate2:		    MOVB #2, Option	;Option = 2
			        RTS	
			
FF:			      JSR	 read_pot	;Read the value of the Pot
		        	STAB PValue_Testing
        			LDAA PValue_Testing
        			CMPA #90		;See if pot is set to select last (4th) option
        			BHI FF16X		;Branch to display option 4
	        		CMPA #60		;See if pot is set to select the 3rd option
        			BHI FF8X		;Branch to display option 3
        			CMPA #30		;See if pot is set to select the 2nd option
        			BHI FF4X		;Branch to display option 2
        			MOVB #1, Option	;Option = 1
        			RTS

FF16X:		    MOVB #4, Option	;Option = 4
			        RTS
			        
FF8X:	      	MOVB #3, Option	;Option = 3
			        RTS
			        				
FF4X:	      	MOVB #2, Option	;Option = 2
			        RTS	


Rewind:		    JSR	 read_pot	;Read the value of the Pot
			        STAB PValue_Testing
		        	LDAA PValue_Testing
			        CMPA #90		;See if pot is set to select last (4th) option
			        BHI R16X		;Branch to display option 4
			        CMPA #60		;See if pot is set to select the 3rd option
		        	BHI R8X		;Branch to display option 3
			        CMPA #30		;See if pot is set to select the 2nd option
			        BHI R4X		;Branch to display option 2
			        MOVB #1, Option	;Option = 1
		        	RTS

R16X:		      MOVB #4, Option	;Option = 4
			        RTS
			
R8X:		      MOVB #3, Option	;Option = 3
			        RTS
							
R4X:		      MOVB #2, Option	;Option = 2
			        RTS

			
PCont:		    JSR	 read_pot	;Read the value of the Pot
			        STAB PValue_Testing
			        LDAA PValue_Testing
			        CMPA #80		;See if pot is set to select last (3th) option
			        BHI PCont3		;Branch to display option 3
			        CMPA #40		;See if pot is set to select the second value
			        BHI PCont2		;Branch to display option 2
			        MOVB #1, Option	;Option = 1
			        RTS

PCont3:		    MOVB #3, Option	;Option = 3
			        RTS
			
PCont2:		    MOVB #2, Option	;Option = 2
			        RTS	