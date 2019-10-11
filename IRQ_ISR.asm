	XREF	SetLCD_StartMenu, VHSLoaded, RTI_Load_VHS, RTI_Eject_VHS, RTI_Flag, SwitchMenu, DC_Speed, RTICounter1, Port_t, SetLCD_EjectingVHS
	XREF  SendMessageInfo, SSaverFlg, SECOND, CountMS, SSKeypad, SkipBo, CurrSSSet, StartPlaying, LEDVAL, PasswordSet, RatingLimitSet
	XDEF	IRQ_ISR

;This Interrupt Service Routine utilized the IRQ button on the board to Eject the VHS at any time

IRQ_ISR:	LDAA	VHSLoaded			    ;If VHSLoaded = 0, Branch to Exit
			    BEQ		Exit				      ;Else procede to LoadVHS

          MOVB  #0, DC_Speed      ;Set the DC Motor Speed to 0
          BCLR	Port_t, #$8		    ;Clear bit 3 of Port_t_DCMotor
			    MOVB  #0, VHSLoaded     ;To Indicate that a VHS is not Loaded
		    	MOVB  #0, RTICounter1   ;Reset RTICounter1 to 0
		    	MOVB	#0, RTI_Load_VHS	;Set RTI_Load_VHS to 0 and RTI_Eject_VHS to 1
		    	MOVB	#1, RTI_Eject_VHS	;So that the program knows to run the Eject VHS section in the next RTI itteration
		    	MOVB	#1, SwitchMenu		;Also set SwitchMenu to 1 so that the program know to switch back to the StartMenu
					MOVB  #0, SSaverFlg
		      MOVB  #0, SECOND
		      MOVB  #0, CountMS
		      MOVB  #0, SSKeypad
		      MOVB  #1, SkipBo
		      MOVB  #0, LEDVAL	      ;Reset LED value to 0
		      MOVB  #0, CurrSSSet	    ;Set Screen Saver Back to Wall Clock
          MOVB  #0, StartPlaying
          MOVB  #0, PasswordSet
          MOVB  #0, RatingLimitSet
										              ;Then Exit the IRQ_ISR		
Exit:	    BSET	RTI_Flag, #$80
		    	RTI
			
;Need to set this up so that it also stops playing/recording if that is happening