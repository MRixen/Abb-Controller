MODULE Diagnose

    ! MachineData
    CONST num MAX_DATA_SIZE:=12;
    VAR string mData{MAX_DATA_SIZE};
    VAR string serial;
    VAR string version;
    VAR string rtype;
    VAR string cid;
    VAR string lanip;
    VAR string clang;
    VAR string dutyTime;
    VAR string machineName;
    VAR string projectNumber;
    VAR string dateOfCreation;
    VAR string preAccept;
    VAR string finAccept;

    ! EventMessages
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

    ! CycleTimer
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


    PERS num cntrMachine:=1;
    PERS num cntrCycle:=1;
    PERS num cntrLogging:=1;
    PERS num cntrEvent:=1;

    PROC main()
        ! MachineData
        serial:=GetSysInfo(\SerialNo);
        version:=GetSysInfo(\SWVersion);
        rtype:=GetSysInfo(\RobotType);
        cid:=GetSysInfo(\CtrlId);
        lanip:=GetSysInfo(\LanIp);
        clang:=GetSysInfo(\CtrlLang);
        dutyTime:=GetServiceInfo(ROB_1\DutyTimeCnt);
        machineName:="Multiflex";
        projectNumber:="20168";
        dateOfCreation:="2015";
        preAccept:="19.02.15";
        finAccept:="KW 48-2015";
        mData:=[machineName,projectNumber,dateOfCreation,preAccept,finAccept,serial,version,rtype,cid,lanip,clang,dutyTime];

        ! EventMessages        
        CONNECT err_int WITH err_trap;
        IError COMMON_ERR,TYPE_ALL,err_int;

        ! CycleTimer
        CONNECT nextCT WITH nextCTtrap;
        ISignalDO nextCTpulser,1,nextCT;
        CONNECT resetCT WITH resetCTtrap;
        ISignalDO resetCTpulser,1,resetCT;

        WHILE TRUE DO
            IF (clientConnected AND isSending) THEN
                FOR i FROM 1 TO MAX_DATA_SIZE DO
                    tpWriteSocket mData{i},":"+ValToStr(i-1)+":";
                ENDFOR
                isSending:=FALSE;
            ENDIF
            WaitTime 0.01;

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
        tpWriteSocket ValToStr(robotState)+"::"+ValToStr(err_domain)+"::"+ValToStr(err_number)+"::"+ValToStr(err_type)+"::"+str1+"::"+"X"+"::"+"X"+"::"+"X"+"::"+"X",":e:";
        ! Send only the first string (str1) because there is too much load in string when using str1...5 
    ENDTRAP

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

            WriteCycleTimeLog nCycleTime,false;

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
            WriteCycleTimeLog nCycleTime,true;
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

    PROC WriteCycleTimeLog(num nCycleTime,bool setHeader)
        Open "home:/Taktzeitaufzeichnung.txt",ioFileLog\Append;
        IF setHeader Write ioFileLog,"Date"+";"+"Time"+";"+"Cycle Time";
        Write ioFileLog,CDate()+";"+CTime()+";"+ValToStr(nCycleTime);
        Close ioFileLog;
    ENDPROC


    PROC tpWriteSocket(string msg,string msgType)
        IF clientConnected THEN
                sendbuffer{cntrMachine}:=msgType+msg+";";
                bufferState{cntrMachine}:=TRUE;
                cntrMachine:=cntrMachine+1;
                IF (cntrMachine>=25) THEN
                    cntrMachine:=1;
                ENDIF
        ENDIF
    ENDPROC
ENDMODULE