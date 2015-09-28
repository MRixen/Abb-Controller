MODULE ServerComm
    !====================================================================
    ! Module: ServerComm
    ! Datum: 10.08.2015
    ! Programmierer: MR
    ! Beschreibung: Senden der Zykluszeit �ber Socket
    !====================================================================
    PERS num MAX_CLIENTS:=1;
    VAR socketdev server_socket;
    VAR num state:=1;
    CONST string IP:="192.168.1.2";
    VAR num port:=1025;
    CONST num MAX_PORT_NUMBER:=4999;
    VAR bool listening:=true;
    VAR num i:=1;
    VAR socketstatus socketStateServer;
    VAR socketstatus socketStateClient1;
    VAR socketstatus socketStateClient2;
	VAR socketstatus socketStateClient3;
    CONST num MAX_WAIT_FOR_CONNECTION:=5;
    VAR string inMsg:="";
    VAR string clientMessage1old:="";
    VAR string clientMessage2old:="";
	VAR string clientMessage3old:="";
    VAR socketdev client_socket{3};
    VAR num nRetries_Closed;
    VAR num nRetries_AddrUsed;
    VAR num nRetries_Timeout;
    VAR num equalDataCounter1 := 0;
	VAR num equalDataCounter2 := 0;
	VAR num equalDataCounter3 := 0;
    CONST num MAX_EQUAL_DATA_AMOUNT := 25;



    PROC main()
        WHILE TRUE DO
            waitForClients;
            WaitTime 0.01;
        ENDWHILE
    ENDPROC
	! TODO: Ping to signal alive...
	! TODO: Optimize reconnection
    ! TODO: Make it possible that more clients can connect to server

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
					WaitTime 1;
                    clientConnected := TRUE;	
					WaitTime 0.3;
					IF(DOutput(showSocketCmts) = 1) TPwrite "Accept client no. " + ValToStr(i);
                    i:=i+1;
                ELSE
                    listening:=FALSE;
                ENDIF
            ENDWHILE
				FOR i FROM 1 TO 50 DO
					IF (bufferState{i}) THEN
						SocketSend client_socket{1}\Str:=sendbuffer{i};
						sendbuffer{i} := "";
						bufferState{i} := false;
						WaitTime 0.3;
					ELSE
					! Send something to signal alive state
						SocketSend client_socket{1}\Str:=" ";
					ENDIF					
				ENDFOR
        DEFAULT:

        ENDTEST

    ERROR
        IF ERRNO=ERR_SOCK_CLOSED THEN
		IF(DOutput(showSocketCmts) = 1) TPwrite "Socket closed.";
            nRetries_Closed:=RemainingRetries();
            IF (nRetries_Closed>=2) THEN
			IF(DOutput(showSocketCmts) = 1) TPwrite "Initialize socket.";
                initSocket;
                TRYNEXT;
            ENDIF
        ENDIF
        IF ERRNO=ERR_SOCK_ADDR_INUSE THEN
		IF(DOutput(showSocketCmts) = 1) TPwrite "Soccket addres in use.";
            nRetries_AddrUsed:=RemainingRetries();
            IF (nRetries_AddrUsed>=2) THEN
                TRYNEXT;
            ENDIF
        ENDIF
        IF ERRNO=ERR_SOCK_TIMEOUT THEN
		IF(DOutput(showSocketCmts) = 1) TPwrite "Socket timeout.";
            nRetries_Timeout:=RemainingRetries();
            IF (nRetries_Timeout>=2) THEN
                !initSocket;
            ENDIF
        ENDIF
    ENDPROC

    PROC initSocket()
		!client3Started := false;
        SocketClose server_socket;
        SocketClose client_socket{1};
!        SocketClose client_socket{2};
!		SocketClose client_socket{3};
        i:=1;
        state:=1;
        listening:=TRUE;
    ENDPROC
ENDMODULE
