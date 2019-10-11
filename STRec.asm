	XDEF STRec
	XREF RYEAR, YEAR, RMO, MO, RDAY, DAY, RHH, HH, RMM, MM, RSS, SS, CurrSSSet
	
STRec:
		LDAA RYEAR
		CMPA YEAR
		BNE Exit
		
		LDAA RMO
		CMPA MO
		BNE Exit
		
		LDAA RDAY
		CMPA DAY
		BNE Exit
		
		LDAA RHH
		CMPA HH
		BNE Exit
		
		LDAA RMM
		CMPA MM
		BNE Exit
		
		LDAA RSS
		CMPA SS
		BNE Exit
		
		MOVB #2, CurrSSSet 		
		
Exit: 	RTS
