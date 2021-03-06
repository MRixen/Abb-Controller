MODULE MachineData

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
    VAR string dateOfFAT;
    VAR string dateOfSOP;
	VAR bool isSending;
	PERS num cntr:=18;

    PROC main()
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
        dateOfFAT:="?";
        dateOfSOP:="KW48-2015";
		
		isSending := TRUE;

        mData:=[machineName,projectNumber,dateOfCreation,dateOfFAT,dateOfSOP,serial,version,rtype,cid,lanip,clang,dutyTime];
        WHILE isSending DO
            IF (clientConnected AND isSending) THEN					
                    FOR i FROM 1 TO MAX_DATA_SIZE DO
                        tpWriteSocket mData{i},":"+ValToStr(i-1)+":";
                    ENDFOR                 
				isSending:=FALSE;				
            ENDIF
        ENDWHILE
		! Give other threads enough time to process
		WaitTime 5;
    ENDPROC

    PROC tpWriteSocket(string msg,string msgType)
	IF clientConnected THEN
		sendbufferMdata{cntr}:=msgType+msg+";";
		bufferStateMdata{cntr}:=TRUE;	
		cntr:=cntr+1;
		IF (cntr>=25) THEN
			cntr:=1;
        ENDIF
		ENDIF
    ENDPROC	
ENDMODULE