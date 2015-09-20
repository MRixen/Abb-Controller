MODULE MainModule
    !***************************************************
    !Programtype:  Foreground
    !Description:  Main Program
    !              Project M11xxx
    !              This Module handles the main loop
    !              This program is common to all parts
    !
    !Programmer:   Xxxx Xxxxxxx
    !              Svensk Industriautomation AB.
    !              Phone +46 36 2100xxx
    !
    ! Copyright (c) Svensk Industriautomation AB 2011
    ! All rights reserved
    !
    !---------------------------------------------------
    !Version           Date            Description
    !---------------------------------------------------
    !4.0              20111124         Created
    !4.1              13.02.2013       AK
    !***************************************************
    !# -----------------------
    !#--------Bool data
    !# -----------------------
    !
    PERS bool bFirstRefPos:=FALSE;
    PERS bool bLastPick1:=TRUE;
    !
    LOCAL PERS num nCamera:=1;
    !
    !# -----------------------
    !#--------String data
    !# -----------------------
    !
    VAR string sState:="Idle";
    !
    !-----------------------------------------------------------------------------
    ! Procedure:   main
    ! Description: This procedure handles the main pick loop.
    !              DO NOT ADD ANY CODE HERE.
    !              Add all code for initialization in procedure Initialize,
    !              otherwise the system might not behave correctly.
    !-----------------------------------------------------------------------------
    PROC Main()
            Grundstellung;
            !InitializeMain;
            !InitPickVision;
            ResetCycletimes;
            setUnloadPositions;
            WHILE TRUE DO
              !CheckSystem;
              CheckAndEnterState;
              WaitTime 0.01;
            ENDWHILE
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure:     CheckSystem
    ! Description:   This procedure checks If endcycle or Entry has bin requested.
    ! Argument:
    ! Remarks:
    ! Called from:   Main
    !-----------------------------------------------------------------------------
    PROC CheckSystem()
        ChkPrgNr;
        IF DOutput(DOF_EndCycle)=1 AND DOutput(DOF_AutoOn)=1 THEN
            ! ordered stop from PickVision
            Grundstellung\Ende;
        ELSEIF DOutput(DOF_EntryRequest)=1 AND DOutput(DOF_AutoOn)=1 THEN
            Grundstellung;
            WaitTime\InPos,0;
            StopPickVision;
            Set EntryGranted;
            TPWrite "Roboter wurde gestoppt! Tür Auf";
            ExitCycle;
        ENDIF
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure:     InitializeMain
    ! Description:   This procedure holds all initialization made when starting the
    !                robot program for the beginning. Add all initialization for the
    !                current application here.
    ! Argument:
    ! Remarks:
    ! Called from:   Main
    !-----------------------------------------------------------------------------
    PROC InitializeMain()
        SoftDeact;
        Reset EntryGranted;
        ChkDoor;
        bFirstRefPos:=TRUE;
        ResetCycleTimes;
        IDelete iConfPick;
        CONNECT iConfPick WITH ConfirmPick;
    ENDPROC
    
    
    PROC setUnloadPositions()
        pUnload:=pLage1;   
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure:     LoadCameraModules
    ! Description:   These procedure is used to load the cameramodules.
    !                bModuleCamXLoaded has to be initialized as FALSE.
    !                PickVision always load PvMain when started. bModuleCamXLoaded must THEN be FALSE.
    !                If PickVision is started and you choose to start robot program from robotcontroler
    !                THEN bModuleCamXLoaded is TRUE and THEN sModuleCamX is not loaded.
    ! Remarks:
    ! Called from:   IntiPickVision
    !-----------------------------------------------------------------------------
    PROC LoadCameraModules()
        IF sModuleCam1<>stEmpty AND OpMode()=OP_AUTO THEN
            Load sModuleCam1;
        ELSE
            TPWrite "Keine Programmnummer von PickVision";
            BELT_ACTION{1}:=RUN_NEVER;
            ALLOW_AUTO_GRAB{1}:=FALSE;
            BELT_ACTION{2}:=RUN_NEVER;
            ALLOW_AUTO_GRAB{2}:=FALSE;
        ENDIF
        InitializeCam;
    ERROR
        IF ERRNO=ERR_LOADED THEN
            TRYNEXT;
        ENDIF
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure:     PickCamera
    ! Description:   Called when entering state PickCamera.
    ! Argument:
    ! Remarks:
    ! Called from:   CheckAndEnterState
    !-----------------------------------------------------------------------------
    PROC PickCamera()
        IF (bCoordReceived{CAMERA_NO_1}=TRUE) AND (bCoordReceived{CAMERA_NO_2}=TRUE) THEN
            IF bLastPick1 THEN
                nCamera:=2;
                bLastPick1:=FALSE;
            ELSE
                nCamera:=1;
                bLastPick1:=TRUE;
            ENDIF
        ELSEIF bCoordReceived{CAMERA_NO_1}=TRUE THEN
            nCamera:=1;
            bLastPick1:=TRUE;
        ELSEIF bCoordReceived{CAMERA_NO_2}=TRUE THEN
            nCamera:=2;
            bLastPick1:=FALSE;
        ENDIF
        IF nCamera=1 THEN
            wCamera:=wCamera1;
        ELSE
            wCamera:=wCamera2;
        ENDIF
        RefPosIn;
        IF RobOS() SetNextTarget nCamera;
        !    IF NOT getPartState(gOpen) THEN
        !        TPWrite "Greifer nicht geöffnet!";
        !    ENDIF
        !    WHILE NOT getPartState(gOpen) DO
        !        WaitTime 0.1;
        !        Greifer\Auf;
        !    ENDWHILE
        PickCam;





        ! Only for simulation
        !    IF openClamp THEN
        !      Reset doClampAopenClose;
        !      Reset doClampBopenClose;
        !      openClamp:=FALSE;
        !    ENDIF
        !
        RefPosOut;
    ENDPROC

    TRAP ConfirmPick
        CallByVar "ConfirmPick",nCamera;
    ENDTRAP

    !-----------------------------------------------------------------------------
    ! Procedure:     Position_n
    ! Description:   Called when entering state Position.
    ! Argument:
    ! Remarks:
    ! Called from:   CheckAndEnterState
    !-----------------------------------------------------------------------------
    PROC Position_n()
        IF nCamera=CAMERA_NO_1 CallByVar "Position_",nPosition;
        IF nCamera=CAMERA_NO_2 CallByVar "Position_",nPosition;
        IF nCamera=CAMERA_NO_3 CallByVar "Position_",nPosition;
        IF nCamera=CAMERA_NO_4 CallByVar "Position_",nPosition;
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure:mvTo
    ! Date: 26.02.2015     Version: 1.0     Programmer: AK
    !
    ! Description: Sicher in angegebene Achsposition fahren
    !-----------------------------------------------------------------------------
    PROC mvTo(num RobAx1)
        VAR jointtarget pAktRobax;
        WaitTime\InPos,0;
        pAktRobax:=CJointT();
        pAktRobax.robax.rax_2:=-14;
        pAktRobax.robax.rax_3:=31;
        pAktRobax.robax.rax_5:=74;
        MoveAbsJ pAktRobax\NoEOffs,vmax,z5,tGreifer;
        pAktRobax.robax.rax_4:=0;
        pAktRobax.robax.rax_6:=-3;
        MoveAbsJ pAktRobax\NoEOffs,vmax,z5,tGreifer;
        pAktRobax.robax.rax_1:=RobAx1;
        MoveAbsJ pAktRobax\NoEOffs,vmax,z50,tGreifer;
        WaitTime\InPos,0;
    ERROR
        RAISE ;
    ENDPROC

    PROC mvToNioPosition()
        VAR jointtarget pAktRobax;
        WaitTime\InPos,0;
        pAktRobax:=CJointT();
        pAktRobax.robax.rax_2:=0;
        pAktRobax.robax.rax_3:=20;
        pAktRobax.robax.rax_5:=65;
        MoveAbsJ pAktRobax\NoEOffs,vmax,z5,tGreifer;
        pAktRobax.robax.rax_4:=0;
        pAktRobax.robax.rax_6:=0;
        MoveAbsJ pAktRobax\NoEOffs,vmax,z5,tGreifer;
        pAktRobax.robax.rax_1:=-40;
        MoveAbsJ pAktRobax\NoEOffs,vmax,z50,tGreifer;
    ERROR
        RAISE ;
    ENDPROC
ENDMODULE
