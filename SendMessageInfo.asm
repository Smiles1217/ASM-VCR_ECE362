  XREF	SendsChr, __SEG_END_SSTACK, SpeakerData, Port_t_DDR, ToneCount
  XDEF  SendMessageInfo

SendMessageInfo:	
					        LDY		#SpeakerData	;Load the Address of the Array "Data" from the Stack
					
Loop1:			    	LDX   ToneCount     ;Load the Number of Tones
                  BEQ		Finish	  	  ;If X is Equal to Zero, branch to "Finish"
				        	LDD		1,y+	    	  ;Else, Load the Value of the Array "Data" into D and increment Y
				        	PSHD			      	  ;Push the Values stored in D onto the Stack
			        		JSR 	SendsChr      ;Call the "SendsChr" Function
			        		LDX   ToneCount
			        		DEX                 ;Decrement the Counter stored in Register X
			        		STX   ToneCount
			        		BRA		Loop1	    	  ;Branch back to Loop1 Forever
					
Finish:			    	RTS			         	  ;Return