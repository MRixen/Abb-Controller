MODULE CycleTimer

    CONST num TOTAL_NUM_OF_CYCLES:=50;
    PERS bool bFirstCycle:=FALSE;
    PERS num nCycleTime:=2.03;
    PERS num cycleTimeMean{TOTAL_NUM_OF_CYCLES};
    VAR clock cCycleTime;
    VAR num nCycles;
    VAR num nCyclesShow;
    VAR num cycleTimeActual{TOTAL_NUM_OF_CYCLES};
	VAR string cycleTimeMeanString;
	VAR string cycleTimeActualString;
    VAR num totalTime;
    VAR iodev ioFileLog;
	
	VAR intnum nextCT;
	VAR intnum resetCT;
	
	PERS num cntr:=1;

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

            WriteCycleTimeLog nCycleTime, false;
			
            ! store latset cycle time in the array
            FOR i FROM (TOTAL_NUM_OF_CYCLES-1) TO 1 DO
                cycleTimeActual{i+1}:=cycleTimeActual{i};
				cycleTimeMean{i+1}:=cycleTimeMean{i};				
            ENDFOR
            cycleTimeActual{1}:=nCycleTime;
			cycleTimeMean{1}:=totalTime/nCycles;      

			! Save total time
            totalTime:=0;
			cycleTimeActualString:="";
			cycleTimeMeanString:="";
            FOR i FROM 1 TO TOTAL_NUM_OF_CYCLES DO
                totalTime:=totalTime+cycleTimeActual{i};
            ENDFOR			

			! Convert cycle times to string (max. 80 characters per string)
			! TODO: Make it possible to send much more cycle time data (for 1 hour)
            FOR i FROM 1 TO 16 DO
				cycleTimeMeanString:=cycleTimeMeanString+NumToStr(cycleTimeMean{i},1)+"_";
				cycleTimeActualString:=cycleTimeActualString+NumToStr(cycleTimeActual{i},1)+"_";							
            ENDFOR	
			
            ! Print times on FP
            TPErase;

			! Send logs and cycle time to remote console (smartphone)
            tpWriteSocket "Gesamtzahl der gefertigten Teile:: "+ValToStr(nCyclesShow),":l:";
			tpWriteSocket ValToStr(nCycleTime),":c1:";
			tpWriteSocket ValToStr(cycleTimeMean{1}),":c2:";
			
            ClkReset cCycleTime;
            ELSE
                ! Init header in log file
                WriteCycleTimeLog nCycleTime, true;
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
	
    PROC WriteCycleTimeLog(num nCycleTime, bool setHeader)
        Open "home:/Taktzeitaufzeichnung.txt",ioFileLog\Append;
        IF setHeader Write ioFileLog,"Date"+";"+"Time"+";"+"Cycle Time";
        Write ioFileLog,CDate()+";"+CTime()+";"+ValToStr(nCycleTime);
        Close ioFileLog;
    ENDPROC
	
	    PROC tpWriteSocket(string msg,string msgType)
		IF clientConnected THEN
		sendbufferCycleTime{cntr}:=msgType+msg+";";
		bufferStateCycleTime{cntr}:=TRUE;	
		cntr:=cntr+1;
		IF (cntr>=25) THEN
			cntr:=1;
        ENDIF
		ENDIF
    ENDPROC
ENDMODULE