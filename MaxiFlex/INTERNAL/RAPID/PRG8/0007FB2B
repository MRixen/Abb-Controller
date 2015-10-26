MODULE EventMessages
    VAR intnum err_int;
    VAR trapdata err_data;
    VAR errdomain err_domain;
    VAR num err_number;
    VAR errtype err_type;
    VAR num firstCycleStart;
    VAR num robotState:=1;
    VAR string str1:="";
    VAR string str2:="";
    VAR string str3:="";
    VAR string str4:="";
    VAR string str5:="";

    PROC main()
        CONNECT err_int WITH err_trap;
        IError COMMON_ERR,TYPE_ALL,err_int;
        WHILE TRUE DO
            WaitTime 0.2;
        ENDWHILE
    ENDPROC

    TRAP err_trap
        GetTrapData err_data;
        ReadErrData err_data,err_domain,err_number,err_type\Str1:=str1\Str2:=str2\Str3:=str3\Str4:=str4\Str5:=str5;

        IF (DOutput(DOF_CycleOn))=1 AND firstCycleStart=0 THEN
            ! Cycle On State
            robotState:=1;
            firstCycleStart:=1;
        ENDIF
        IF (DOutput(DOF_CycleOn)=0) AND (firstCycleStart=1) THEN
            ! Cycle Off State - Robot stops, something happen
            robotState:=0;
            firstCycleStart:=0;
        ENDIF
        !tpWriteSocket ValToStr(robotState)+"_"+ValToStr(err_domain)+"_"+ValToStr(err_number)+"_"+str1+"_"+str2+"_"+str3+"_"+str4+"_"+str5,":e:";    ! String too long because there ist too much load in str1...5 
        TPwrite ValToStr(robotState)+"_"+ValToStr(err_domain) + "_" + ValToStr(err_number)+"_"+ValToStr(err_type)+"_"+str1;
		tpWriteSocket ValToStr(robotState)+"::"+ValToStr(err_domain)+"::"+ValToStr(err_number)+"::"+ValToStr(err_type)+"::"+str1+"::"+"X"+"::"+"X"+"::"+"X"+"::"+"X",":e:";
    ENDTRAP
ENDMODULE