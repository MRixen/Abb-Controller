MODULE CycleTimer

    CONST num TOTAL_NUM_OF_CYCLES:=50;
    PERS bool bFirstCycle:=FALSE;
    PERS num nCycleTime:=2.059;
    PERS num nTotalCycleTime:=2.05688;
    VAR clock cCycleTime;
    VAR num nCycles;
    VAR num nCyclesShow;
    VAR num nTimeArray{TOTAL_NUM_OF_CYCLES};
    VAR num nTotalArrayTime;
    VAR iodev ioFileLog;
	
	VAR intnum nextCT;
	VAR intnum resetCT;

    PROC main()
		CONNECT nextCT WITH nextCTtrap;
		ISignalDO nextCTpulser,1,nextCT;
		
		CONNECT resetCT WITH resetCTtrap;
		ISignalDO resetCTpulser,1,resetCT;

		WHILE TRUE DO		
			WaitTime 0.01;
		ENDWHILE
    ENDPROC
	
	TRAP nextCTtrap
		NextCycleTime;	
	ENDTRAP
	
	TRAP resetCTtrap
		ResetCycleTimes;	
	ENDTRAP
	
	    PROC NextCycleTime()

        ! skip calculation first cycle and start clock
        IF bFirstCycle=FALSE THEN
            ! maximum numbers of cycles in calculation=TOTAL_NUM_OF_CYCLES
            IF nCycles<TOTAL_NUM_OF_CYCLES Incr nCycles;
            Incr nCyclesShow;
            ClkStop cCycleTime;
            nCycleTime:=ClkRead(cCycleTime);

            WriteCycleTimeLog(nCycleTime);

            ! store latset cycle time in the array
            FOR i FROM (TOTAL_NUM_OF_CYCLES-1) TO 1 DO
                nTimeArray{i+1}:=nTimeArray{i};
            ENDFOR
            nTimeArray{1}:=nCycleTime;
            ! calculate tot. time in array and meantime
            nTotalArrayTime:=0;
            FOR i FROM 1 TO TOTAL_NUM_OF_CYCLES DO
                nTotalArrayTime:=nTotalArrayTime+nTimeArray{i};
            ENDFOR
            nTotalCycleTime:=nTotalArrayTime/nCycles;
            ! Print times on FP
            TPErase;

            tpWriteSocket "Gesamtzahl der gefertigten Teile:: "+ValToStr(nCyclesShow),":l:";
			tpWriteSocket ValToStr(nCycleTime),":c:";

            !TPWrite "Zykluszeit basiert auf den "+ValToStr(TOTAL_NUM_OF_CYCLES)+" neusten";
            !TPWrite "Teilen: "+ValToStr(nTotalCycleTime)+" s";
            !TPWrite "Neuester Zyklus: "+ValToStr(nCycleTime)+" s";
            !TPWrite "Gesamtzahl der gefertigten Teile: "+ValToStr(nCyclesShow)+" st";
            ClkReset cCycleTime;


        ENDIF
        ClkStart cCycleTime;
        bFirstCycle:=FALSE;
    ENDPROC
	
	    PROC StopCycleTime()
        ! skip calculation first cycle and start clock
        ! maximum numbers of cycles in calculation=TOTAL_NUM_OF_CYCLES
        IF nCycles<TOTAL_NUM_OF_CYCLES Incr nCycles;
        Incr nCyclesShow;
        ClkStop cCycleTime;
        nCycleTime:=ClkRead(cCycleTime);

        WriteCycleTimeLog(nCycleTime);

        ! store latset cycle time in the array
        FOR i FROM (TOTAL_NUM_OF_CYCLES-1) TO 1 DO
            nTimeArray{i+1}:=nTimeArray{i};
        ENDFOR
        nTimeArray{1}:=nCycleTime;
        ! calculate tot. time in array and meantime
        nTotalArrayTime:=0;
        FOR i FROM 1 TO TOTAL_NUM_OF_CYCLES DO
            nTotalArrayTime:=nTotalArrayTime+nTimeArray{i};
        ENDFOR
        nTotalCycleTime:=nTotalArrayTime/nCycles;
        ! Print times on FP
        TPErase;
        TPWrite "Zykluszeit basiert auf den "+ValToStr(TOTAL_NUM_OF_CYCLES)+" neusten";
        TPWrite "Teilen: "+ValToStr(nTotalCycleTime)+" s";
        TPWrite "Neuester Zyklus: "+ValToStr(nCycleTime)+" s";
        TPWrite "Gesamtzahl der gefertigten Teile: "+ValToStr(nCyclesShow)+" st";
        ClkReset cCycleTime;
        bFirstCycle:=FALSE;
    ENDPROC

    PROC StartCycleTime()
        ClkStart cCycleTime;
        bFirstCycle:=FALSE;
    ENDPROC
	
	    PROC ResetCycleTimes()
        nCycles:=0;
        nCyclesShow:=0;
        ! reset the array
        FOR i FROM 1 TO TOTAL_NUM_OF_CYCLES DO
            nTimeArray{i}:=0;
        ENDFOR
        ClkStop cCycleTime;
        ClkReset cCycleTime;
        bFirstCycle:=TRUE;
    ENDPROC

    PROC WriteCycleTimeLog(num nCycleTime)
        Open "home:/Taktzeitaufzeichnung.txt",ioFileLog\Append;
        Write ioFileLog,CDate()+" "+CTime()+" Taktzeit: "+ValToStr(nCycleTime);
        Close ioFileLog;
    ENDPROC
ENDMODULE