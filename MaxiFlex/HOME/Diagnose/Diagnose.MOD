MODULE Diagnose
    PERS num cntr:=5;
    VAR intnum getLOG;

    
    !TODO Wertefehler, da am Ende ein Whitespace steht (5. Zeile)

    PROC main()
        initMachineData;
        initEventMessages;
        initCycleTimer;
        initArticleCounter;
		initLogging;
        WHILE TRUE DO
            IF (clientConnected AND isSending) THEN
                PulseDO\PLength:=0.5,getADpulser;
                ! Send article data
                PulseDO\PLength:=0.5,getMDpulser;
                ! Send machine data
                isSending:=FALSE;
            ENDIF
            WaitTime 0.01;
        ENDWHILE
    ENDPROC

    PROC initLogging()
        CONNECT getLOG WITH getLogMessage;
        ISignalDO getLOGpulser,1,getLOG;
    ENDPROC

    TRAP getLogMessage
        tpWriteSocket logMessage,":l:";
    ENDTRAP
    
    PROC saveArticleData(string filename,string data{*},string header{*},num size,bool setHeader,bool overwrite,bool noNewLine)
    	IF NOT stopWriting THEN
            stopWriting:=TRUE;
            WriteToFile filename,data,header,size,setHeader,overwrite,noNewLine;
            stopWriting:=FALSE;
        ENDIF
    ENDPROC

    PROC WriteToFile(string filename,string data{*},string header{*},num size,bool setHeader,bool overwrite,bool noNewLine)
        VAR string headerString;
        VAR string dataString;
        VAR string readText:="EOF";
        VAR bool fileIsAvailable:=TRUE;

        IF (size<1) size:=1;

        ! Overwrite file or read from it to check if its empty
        IF overwrite THEN
            RemoveFile filename;
        ELSE
            Open filename,ioFileLog\Read;
            IF (fileIsAvailable) THEN
                readText:=ReadStr(ioFileLog);
                ! read from file to check if it is empty (write header) or not (dont write header)
                Close ioFileLog;
            ENDIF
        ENDIF

        ! Open file and write the header (when its empty and if flag is set)
        Open filename,ioFileLog\Append;
        ! Set header
        IF (readText=EOF) THEN
            IF setHeader THEN
                FOR i FROM 1 TO size DO
                    headerString:=headerString+header{i}+";";
                    IF (i=size) Write ioFileLog,headerString;
                ENDFOR
            ENDIF
        ENDIF
        ! Set data
        FOR i FROM 1 TO size DO
            dataString:=dataString+data{i}+";";
        ENDFOR
        IF (NOT setHeader) THEN
            IF (NOT noNewLine) THEN
                Write ioFileLog,dataString;
            ELSE
                Write ioFileLog,dataString\NoNewLine;
            ENDIF
            Close ioFileLog;
        ELSE
            Close ioFileLog;
        ENDIF
    ERROR
        IF ERRNO=ERR_FILEOPEN THEN
            fileIsAvailable:=FALSE;
            TRYNEXT;
        ENDIF
        IF ERRNO=ERR_FILEACC THEN
            TRYNEXT;
        ENDIF
    ENDPROC
    
    FUNC string readArticleData(string filename,num row,num column)
        VAR string element;
        IF NOT stopReading THEN
            stopReading := TRUE;
            element := ReadFromFile(filename,row,column);
            stopReading := FALSE;
        ENDIF
        RETURN element;
    ENDFUNC

    FUNC string ReadFromFile(string filename,num row,num column)
        VAR string readText{MAX_ARTICLE_COUNTER}:=[" "," "," "," "," "];
        VAR string element:=" ";
        VAR num startLimiter:=0;
        VAR num endLimiter:=1;
        VAR num counter:=1;
        VAR bool fileIsAvailable:=TRUE;

        ! Read the hole file without header
        Open filename,ioFileLog\Read;
        IF (fileIsAvailable) THEN
            readText{1}:=ReadStr(ioFileLog);
            FOR i FROM 1 TO MAX_ARTICLE_COUNTER DO
                readText{i}:=ReadStr(ioFileLog);
            ENDFOR
            Close ioFileLog;

            IF (NOT (readText{1}="EOF")) THEN
                ! Extract the specific string at position (row, column) only when file isn't empty
                WHILE (counter<=column-1) DO
                    startLimiter:=StrFind(readText{row},startLimiter+1,";");
                    counter:=counter+1;
                ENDWHILE
                endLimiter:=StrFind(readText{row},startLimiter+1,";");

                element:=StrPart(readText{row},startLimiter+1,(endLimiter-startLimiter)-1);
            ENDIF
        ENDIF
        RETURN element;
    ERROR
        IF ERRNO=ERR_FILEOPEN THEN
            fileIsAvailable:=FALSE;
            TRYNEXT;
        ENDIF
    ENDFUNC

    PROC tpWriteSocket(string msg,string msgType)
        IF clientConnected THEN
            sendbuffer{cntr}:=msgType+msg+";";
            bufferState{cntr}:=TRUE;
            cntr:=cntr+1;
            IF (cntr>=25) THEN
                cntr:=1;
            ENDIF
        ENDIF
    ENDPROC
ENDMODULE