MODULE ServerSendTest
    VAR socketstatus socketStateClient;
    VAR num cntr := 0;
    PROC main()
        WHILE TRUE DO
            tpWriteSocket("HELLO " + ValToStr(cntr));
            cntr := cntr + 1;
            WaitTime 1;
        ENDWHILE
    ENDPROC
    
        PROC tpWriteSocket(string msg)
        socketStateClient := SocketGetStatus( client_socket{1} );
        IF socketStateClient = SOCKET_CONNECTED THEN
            SocketSend client_socket{1} \Str := msg + ";";
        ENDIF        
    ENDPROC
ENDMODULE