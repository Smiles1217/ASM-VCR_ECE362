  XREF  ToneCount, Eject_Sequence, SendsChr, PlayTone, Num_Seconds, Num_HalfSeconds, SongDone, SwitchMenu
  XDEF  Song_Eject
 
Song_Eject:

      LDAB  ToneCount         ;Load the current ToneCount
      CMPB  #8                ;Compare ToneCount to 8
      BEQ   ResetToneCount    ;If ToneCount = 8, Branch to ResetToneCount
      LDX   #Eject_Sequence   ;Else Load the Address for the Eject_Sequence Array
      LDAA  B,x               ;Load the (ToneCount)'th Value of the Array into A
      PSHA                    ;Push A to the stack
      JSR   SendsChr          ;Call the SendsChr command to queue up the tone
      JSR   PlayTone          ;Then calls the PlayTone command to play the tone
      PULA                    ;Pull A back off the Stack
      RTS                     ;Return
      
ResetToneCount:
      MOVB  #0,ToneCount      ;Reset the ToneCount back to 0
      MOVB  #0,SongDone       ;Reset SongDone to 0
      BRA   Song_Eject