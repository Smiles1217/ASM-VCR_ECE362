	XDEF DivideLED
	XREF MTime, DivVal
	
DivideLED:
				LDX #MTime			;Populate the time
				LDAB X
				SUBB #$30
				CLRA 
				LDY #3600			;Number of seconds in an hour.
				EMUL
				STD DivVal

				LDAB 1,X
				SUBB #$30
				CLRA
				LDY #600			;Number of seconds in 10 mins
				EMUL
				ADDD DivVal
				STD	DivVal
				
				LDAB 2,X
				SUBB #$30
				CLRA
				LDY #60				;Number of seconds in a minute
				EMUL
				ADDD DivVal
				STD DivVal
				
				LDAB 3,X
				SUBB #$30
				CLRA
				LDY #10				
				EMUL
				ADDD DivVal
				STD DivVal
				
				LDAB 3,X
				SUBB #$30
				CLRA
				ADDD DivVal
				STD DivVal
				
				
				
				LDD DivVal			;Divide time to get interval for lights
				LDX #8
				IDIV
				STX DivVal
				
				RTS	
				
				
				