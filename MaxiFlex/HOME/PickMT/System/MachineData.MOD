MODULE MachineData

    CONST num MAX_DATA_SIZE:=12;
    CONST num MAX_SEND_REPEAT:=3;

    VAR string mData{MAX_DATA_SIZE};
    VAR string serial;
    VAR string version;
    VAR string rtype;
    VAR string cid;
    VAR string lanip;
    VAR string clang;
    VAR string dutyTime;

    PROC main()
        serial:=GetSysInfo(\SerialNo);
        version:=GetSysInfo(\SWVersion);
        rtype:=GetSysInfo(\RobotType);
        cid:=GetSysInfo(\CtrlId);
        lanip:=GetSysInfo(\LanIp);
        clang:=GetSysInfo(\CtrlLang);
        dutyTime:=GetServiceInfo(ROB_1\DutyTimeCnt);

        mData:=["Multiflex","20184","2015","31.08.15","10.10.15",serial,version,rtype,cid,lanip,clang,dutyTime];
        WHILE TRUE DO
            IF clientConnected THEN
			WaitTime 1;
                    FOR i FROM 1 TO MAX_DATA_SIZE DO
                        tpWriteSocket mData{i},":"+ValToStr(i-1)+":";
                    ENDFOR
                clientConnected:=FALSE;     
            ENDIF
            !WaitTime 10;
        ENDWHILE
    ENDPROC
ENDMODULE