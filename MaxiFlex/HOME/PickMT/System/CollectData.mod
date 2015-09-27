MODULE CollectData

	VAR intnum trap_col;
	
    PROC main()
		WaitTime 5; ! Reduce speed that send thread is faster...
    ENDPROC    
	
		
	TRAP col
		collData;
	ENDTRAP
	
	PROC collData()
        VAR string data;
        VAR num i:=1;
        VAR bool isRunning;

        data:=msgType+msg+";";
        i:=1;
        isRunning:=TRUE;
       
        WHILE isRunning DO
            IF (NOT bufferState{i}) THEN
                sendbuffer{i}:=data;
                bufferState{i}:=TRUE;
                isRunning:=FALSE;
            ELSE
                i:=i+1;
            ENDIF
            IF (i>=5) THEN
                i:=1;
                sendbuffer{i}:=data;
                bufferState{i}:=TRUE;
                isRunning:=FALSE;
            ENDIF
        ENDWHILE
    ENDPROC
ENDMODULE