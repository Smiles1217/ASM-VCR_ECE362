  XREF  Num_Seconds, MicroSeconds, ToneCount, Num_HalfSeconds, Num_QuarterSeconds, SongDone
  XDEF  SecondsCounter
  
SecondsCounter:
        LDX   MicroSeconds
        BEQ   ResetMicro
        CPX   #$16E6
        BEQ   QuarterSecondCounter
        CPX   #$0F43
        BEQ   HalfSecondCounter
        CPX   #$07A2
        BEQ   QuarterSecondCounter
Back:   DEX
        STX   MicroSeconds
        RTS

QuarterSecondCounter:
        LDY   Num_QuarterSeconds
        INY
        STY   Num_QuarterSeconds
        LDAA  SongDone
        BEQ   Back
        LDAA  ToneCount
        CMPA  #2
        BLO   Back
        CMPA  #5
        BHI   Back
        INC   ToneCount
        BRA   Back

HalfSecondCounter:
        LDY   Num_HalfSeconds
        INY
        STY   Num_HalfSeconds
        LDY   Num_QuarterSeconds
        INY
        STY   Num_QuarterSeconds
        LDAA  SongDone
        BEQ   Back
        INC   ToneCount
        BRA   Back
        
ResetMicro:
        LDY   Num_Seconds
        INY
        STY   Num_Seconds
        LDY   Num_HalfSeconds
        INY
        STY   Num_HalfSeconds
        LDY   Num_QuarterSeconds
        INY
        STY   Num_QuarterSeconds
        MOVW  #$1E85, MicroSeconds
        BRA   SecondsCounter