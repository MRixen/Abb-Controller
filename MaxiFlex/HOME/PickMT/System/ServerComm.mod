MODULE ServerComm
    !====================================================================
    ! Module: ServerComm
    ! Datum: 10.08.2015
    ! Programmierer: MR
    ! Beschreibung: Senden der Zykluszeit über Socket
    !====================================================================
    PERS num MAX_CLIENTS:=1;
    VAR socketdev socket;
    VAR num state:=1;
    CONST string IP:="192.168.1.2";
    CONST string IPremote := "192.168.1.4";
    !VAR num port:=1025;
	VAR num port:=4555;
    CONST num MAX_PORT_NUMBER:=4999;
    VAR bool listening:=true;
    VAR num i:=1;
    VAR socketdev client_socket{3};
    VAR num nRetries_Closed;
    VAR num nRetries_AddrUsed;
    VAR num nRetries_Timeout;
    CONST num MAX_EQUAL_DATA_AMOUNT:=25;
    CONST num sendDelayTime:=0.08;
    VAR string receive_string;
    VAR string recMsg:="0";
    VAR socketstatus socketState;
    VAR bool connectionIsEstablished:=FALSE;

    CONST num SERVER:=1;
    CONST num CLIENT:=2;
    CONST NUM communicationModell:=CLIENT;
    CONST NUM MAX_RESEND_COUNTER:=5;
    VAR NUM resendCounter:=1;

    PROC main()
        WHILE TRUE DO
            waitForClients;
        ENDWHILE
    ENDPROC

    PROC waitForClients()
        IF (NOT connectionIsEstablished) THEN		
            ! CREATE SERVER SOCKET
            IF (communicationModell=SERVER) THEN
                SocketCreate socket;
                ! Throw error: ERR_SOCK_CLOSED, ERR_SOCK_ADDR_INUSE
                SocketBind socket,IP,port;
                IF (DOutput(showSocketCmts)=1) TPwrite "Bind to "+IP+":"+ValToStr(port);
                ! Throw error: ERR_SOCK_CLOSED
                SocketListen socket;
                IF (DOutput(showSocketCmts)=1) TPwrite "Listening on socket.";
                SocketAccept socket,client_socket{i}\Time:=WAIT_MAX;
                clientConnected:=TRUE;
                WaitTime 1;
                connectionIsEstablished:=TRUE;
                IF (DOutput(showSocketCmts)=1) TPwrite "Accept client no. "+ValToStr(i);
            ENDIF
            IF (communicationModell=CLIENT) THEN
                ! CREATE CLIENT SOCKET
				SocketCreate client_socket{1};
                SocketConnect client_socket{1},IPremote,port\Time:=2;
                clientConnected:=TRUE;
                WaitTime 1;
                connectionIsEstablished:=TRUE;
            ENDIF
        ENDIF
        FOR i FROM 1 TO 25 DO
            IF (NOT (SocketGetStatus(socket)=SOCKET_CLOSED)) THEN
                IF (bufferState{i}) THEN
					RESEND:
                    SocketSend client_socket{1}\Str:=sendbuffer{i};
                    SocketReceive client_socket{1}\Str:=recMsg\Time:=3;
					IF ((recMsg="0") AND (resendCounter<=MAX_RESEND_COUNTER)) THEN
						! Send again
						resendCounter := resendCounter+1;
						GOTO RESEND;
					ENDIF
                    sendbuffer{i}:="";
                    bufferState{i}:=false;
					resendCounter:=1;
                    recMsg:="0";
                    WaitTime sendDelayTime;
                ENDIF
                IF (NOT bufferState{i}) THEN
                    ! Send something to signal alive state
                    SocketSend client_socket{1}\Str:=":p:;";
                ENDIF
            ENDIF
        ENDFOR

    ERROR
        IF ERRNO=ERR_SOCK_CLOSED THEN
            IF (DOutput(showSocketCmts)=1) TPwrite "Socket closed.";
            nRetries_Closed:=RemainingRetries();
            IF (nRetries_Closed>=0) THEN
                IF (DOutput(showSocketCmts)=1) TPwrite "Initialize socket.";
                initSocket;
                TRYNEXT;
            ENDIF
        ENDIF
        IF ERRNO=ERR_SOCK_ADDR_INUSE THEN
            IF (DOutput(showSocketCmts)=1) TPwrite "Soccket addres in use.";
            nRetries_AddrUsed:=RemainingRetries();
            IF (nRetries_AddrUsed>=0) THEN
                TRYNEXT;
            ENDIF
        ENDIF
        IF ERRNO=ERR_SOCK_TIMEOUT THEN
            IF (DOutput(showSocketCmts)=1) TPwrite "Socket timeout.";
            nRetries_Timeout:=RemainingRetries();
!            IF (nRetries_Timeout>=0) THEN
               initSocket;
                TRYNEXT;
!            ENDIF
        ENDIF
    ENDPROC

    PROC initSocket()
        allDataIsSend:=FALSE;
        SocketClose socket;
        SocketClose client_socket{1};
        i:=1;
        state:=1;
        listening:=TRUE;
        clientConnected:=FALSE;
        isSending:=TRUE;
        nRetries_Closed:=0;
        nRetries_AddrUsed:=0;
        nRetries_Timeout:=0;
        connectionIsEstablished:=FALSE;
    ENDPROC
ENDMODULE
