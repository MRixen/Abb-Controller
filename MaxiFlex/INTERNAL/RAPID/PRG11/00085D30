MODULE Info
    ! MachineData
    CONST num MAX_DATA_SIZE:=15;
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
    VAR string actOverride;
    VAR string payLoad;
    VAR intnum getMD;
	VAR BOOL syncNonStaticMachineData := TRUE;


    PROC initMachineData()
		VAR num endLimiter;
		VAR string element;
		VAR bool breakLoop;
		VAR num i;
	
        serial:=GetSysInfo(\SerialNo);
        version:=GetSysInfo(\SWVersion);
        rtype:=GetSysInfo(\RobotType);
        cid:=GetSysInfo(\CtrlId);
        lanip:=GetSysInfo(\LanIp);
        clang:=GetSysInfo(\CtrlLang);
        dutyTime:=GetServiceInfo(ROB_1\DutyTimeCnt);
        machineName:="MaxiFlex Kreuzgelenke";
        projectNumber:="20193";
        dateOfCreation:="2015";
        preAccept:="KW 42";
        finAccept:="?";
        actOverride:=ValToStr(CSpeedOverride());
		
		! Get payload of robot
		endLimiter:=StrFind(serial,1,"-");
		element:=StrPart(serial,1,endLimiter-1);
		breakLoop := TRUE;
		i := 1;
		WHILE(breakLoop) DO				
			IF(element = robotProductName{i}) THEN
				payLoad := robotPayloadData{i};
				breakLoop := FALSE;
			ENDIF
			i := i + 1;
        ENDWHILE


        CONNECT getMD WITH getMachineData;
        ISignalDO getMDpulser,1,getMD;
    ENDPROC

    PROC sendMachineData()
        IF syncNonStaticMachineData THEN
            setNonStaticData;
            IF (NOT allDataIsSend) THEN
                FOR i FROM 1 TO MAX_DATA_SIZE DO
                    tpWriteSocket mData{i},":"+ValToStr(i-1)+":";
                ENDFOR
                allDataIsSend:=TRUE;
            ELSE

                ! ----------------CAUTION------------------
                ! Because of data loss we need to send the hole data again and again
                ! We need a handshake to solve this
                FOR i FROM 1 TO MAX_DATA_SIZE DO
                    tpWriteSocket mData{i},":"+ValToStr(i-1)+":";
                ENDFOR
                ! ----------------CAUTION------------------

                ! Uncomment the following code when handshake is implemented

                ! Send only the non static value (duty time)
                !FOR i FROM 13 TO MAX_DATA_SIZE DO
                !    tpWriteSocket mData{i},":"+ValToStr(i-1)+":";
                !ENDFOR
            ENDIF
        ELSE
            FOR i FROM 1 TO MAX_DATA_SIZE DO
                tpWriteSocket mData{i},":"+ValToStr(i-1)+":";
            ENDFOR
        ENDIF
    ENDPROC

    TRAP getMachineData
        sendMachineData;
    ENDTRAP

    PROC setNonStaticData()
        dutyTime:=GetServiceInfo(ROB_1\DutyTimeCnt);
        actOverride:=ValToStr(CSpeedOverride());
        mData:=[machineName,projectNumber,dateOfCreation,preAccept,finAccept,serial,version,rtype,cid,lanip,clang,robSpeed,actOverride,dutyTime,payLoad];
    ENDPROC
ENDMODULE