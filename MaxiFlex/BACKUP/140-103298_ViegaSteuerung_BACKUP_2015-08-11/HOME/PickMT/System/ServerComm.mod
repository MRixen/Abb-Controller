MODULE ServerComm
    !====================================================================
    ! Module: ServerComm
    ! Datum: 10.08.2015
    ! Programmierer: MR
    ! Beschreibung: Senden der Zykluszeit über Socket
    !====================================================================
!    VAR socketdev server_socket;
!    VAR socketdev client_socket;

    PROC main()
!        SocketCreate server_socket;
!        SocketBind server_socket,"192.168.126.1",1025;
!        SocketListen server_socket;
!        WHILE listening DO
!            ! Waiting for a connection request
!            SocketAccept server_socket,client_socket;
!        ENDWHILE
        WHILE TRUE DO
            WaitTime 1;
        ENDWHILE
    ENDPROC
ENDMODULE
