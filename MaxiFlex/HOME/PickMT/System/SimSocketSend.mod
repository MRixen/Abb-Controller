MODULE SimSocketSend
    VAR num cntr:=0;
    
    ! Testing event messages
    VAR string motorstate := "1";
    VAR errdomain domain := OP_STATE; 
    VAR string errNumber := "2";
    !
      
    PROC main()    
        WHILE TRUE DO
            !tpWriteSocket "Testmessage "+ValToStr(cntr),":l";
            !tpWriteSocket ValToStr(cntr),":c";
            !tpWriteSocket motorstate+"_"+ValToStr(domain)+"_"+errNumber,":e"; 
            !cntr:=cntr+1;
            WaitTime 10;
        ENDWHILE
    ENDPROC
ENDMODULE