MODULE ServerComm
    !====================================================================
    ! Module: ServerComm
    ! Datum: 10.08.2015
    ! Programmierer: MR
    ! Beschreibung: Senden der Zykluszeit über Socket
    !====================================================================
    PERS num MAX_CLIENTS:=1;
    VAR socketdev server_socket;
    VAR num state:=1;
    CONST string IP:="192.168.1.2";
    VAR num port:=1025;
    CONST num MAX_PORT_NUMBER:=4999;
    VAR bool listening:=true;
    VAR num i:=1;
    VAR socketdev client_socket{3};
    VAR num nRetries_Closed;
    VAR num nRetries_AddrUsed;
    VAR num nRetries_Timeout;
    CONST num MAX_EQUAL_DATA_AMOUNT := 25;

	VAR string receive_string;

    PROC main()
        WHILE TRUE DO
            waitForClients;
            !WaitTime 0.01;
        ENDWHILE
    ENDPROC
    ! TODO: Make it possible that more clients can connect to server
	! TODO: Implementation of handshake to check that data is send correctly

    PROC waitForClients()
        TEST state
        CASE 1:
            nRetries_Closed:=0;
            nRetries_AddrUsed:=0;
            nRetries_Timeout:=0;
            SocketCreate server_socket;
            state:=2;
        CASE 2:
            ! Throw error: ERR_SOCK_CLOSED, ERR_SOCK_ADDR_INUSE
            SocketBind server_socket,IP,port;
			IF(DOutput(showSocketCmts) = 1) TPwrite "Bind to " + IP + ":" + ValToStr(port);
            state:=3;
        CASE 3:
            ! Throw error: ERR_SOCK_CLOSED
            SocketListen server_socket;
			IF(DOutput(showSocketCmts) = 1) TPwrite "Listening on socket.";
            state:=4;
        CASE 4:			
            WHILE listening DO
                IF i<=MAX_CLIENTS THEN					
                    SocketAccept server_socket,client_socket{i}\Time:=WAIT_MAX;    
                    clientConnected := TRUE;	
					WaitTime 1;
					IF(DOutput(showSocketCmts) = 1) TPwrite "Accept client no. " + ValToStr(i);
                    i:=i+1;
                ELSE
                    listening:=FALSE;
                ENDIF
            ENDWHILE
				FOR i FROM 1 TO 25 DO
					IF (bufferState{i}) THEN
						SocketSend client_socket{1}\Str:=sendbuffer{i};
						sendbuffer{i} := "";
						bufferState{i} := false;
						WaitTime 0.08;
					ELSE
					! Send something to signal alive state
						SocketSend client_socket{1}\Str:=":p:;";
					ENDIF					
				ENDFOR
        DEFAULT:

        ENDTEST

    ERROR
        IF ERRNO=ERR_SOCK_CLOSED THEN
		IF(DOutput(showSocketCmts) = 1) TPwrite "Socket closed.";
            nRetries_Closed:=RemainingRetries();
            IF (nRetries_Closed>=0) THEN
			IF(DOutput(showSocketCmts) = 1) TPwrite "Initialize socket.";
                initSocket;
				TRYNEXT;
            ENDIF
        ENDIF
        IF ERRNO=ERR_SOCK_ADDR_INUSE THEN
		IF(DOutput(showSocketCmts) = 1) TPwrite "Soccket addres in use.";
            nRetries_AddrUsed:=RemainingRetries();
            IF (nRetries_AddrUsed>=0) THEN
                TRYNEXT;
            ENDIF
        ENDIF
        IF ERRNO=ERR_SOCK_TIMEOUT THEN
		IF(DOutput(showSocketCmts) = 1) TPwrite "Socket timeout.";
            nRetries_Timeout:=RemainingRetries();
            IF (nRetries_Timeout>=0) THEN
                initSocket;
				TRYNEXT;
            ENDIF
        ENDIF
    ENDPROC

    PROC initSocket()
        SocketClose server_socket;
        SocketClose client_socket{1};
        i:=1;
        state:=1;
        listening:=TRUE;
    ENDPROC
    
    PROC setPPmain()
        ! Set pp of serverCom to main by emergency stop
        PulseDO \PLength:=0.5, DOF_StartAtMain;
    ENDPROC
ENDMODULE
