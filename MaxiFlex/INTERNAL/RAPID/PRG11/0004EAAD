MODULE CycleTime
    ! CycleTimer
    CONST num TOTAL_NUM_OF_CYCLES:=50;
    PERS bool bFirstCycle:=FALSE;
    PERS num nCycleTime:=2.011;
    PERS num cycleTimeMean{TOTAL_NUM_OF_CYCLES};
    VAR clock cCycleTime;
    VAR num nCycles;
    VAR num nCyclesShow;
    VAR num cycleTimeActual{TOTAL_NUM_OF_CYCLES};
    VAR num totalTime;
    VAR iodev ioFileLog;
    VAR intnum getCT;
    VAR intnum resetCT;

    PROC initCycleTimer()
        CONNECT getCT WITH getCycleTimeData;
        ISignalDO getCTpulser,1,getCT;
        CONNECT resetCT WITH resetCycleTimeData;
        ISignalDO resetCTpulser,1,resetCT;
    ENDPROC


    TRAP getCycleTimeData
        NextCycleTime;
    ENDTRAP

    TRAP resetCycleTimeData
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

            ! store latset cycle time in the array
            FOR i FROM (TOTAL_NUM_OF_CYCLES-1) TO 1 DO
                cycleTimeActual{i+1}:=cycleTimeActual{i};
                cycleTimeMean{i+1}:=cycleTimeMean{i};
            ENDFOR
            cycleTimeActual{1}:=nCycleTime;
            cycleTimeMean{1}:=totalTime/nCycles;

            ! Save total time
            totalTime:=0;
            FOR i FROM 1 TO TOTAL_NUM_OF_CYCLES DO
                totalTime:=totalTime+cycleTimeActual{i};
            ENDFOR

            ! Send logs and cycle time to remote console (smartphone)
            tpWriteSocket "Gesamtzahl der gefertigten Teile:: "+ValToStr(nCyclesShow),":l:";
            tpWriteSocket ValToStr(nCycleTime),":c1:";
            tpWriteSocket ValToStr(cycleTimeMean{1}),":c2:";

            ! Copy to global variable
            ctMean:=cycleTimeMean{1};
            ctCounter:=nCycleTime;

            ClkReset cCycleTime;
        ENDIF
        ClkStart cCycleTime;
        bFirstCycle:=FALSE;
    ENDPROC

    PROC ResetCycleTimes()
        nCycles:=0;
        nCyclesShow:=0;
        ! reset the array
        FOR i FROM 1 TO TOTAL_NUM_OF_CYCLES DO
            cycleTimeActual{i}:=0;
        ENDFOR
        ClkStop cCycleTime;
        ClkReset cCycleTime;
        bFirstCycle:=TRUE;
    ENDPROC
ENDMODULE