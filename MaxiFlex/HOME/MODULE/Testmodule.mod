MODULE Testmodule
    !=============================================================================
    ! Module: C398106
    ! Date: 02.02.2015
    ! Programmer: AK
    ! Company: Viega
    ! 
    ! Part: Ident.: Bez.:  Mod.:  Abm.: 
    ! Greifer: 1
    !=============================================================================
    !Version           Date            Description
    !---------------------------------------------------
    !4.0              20111124         Created
    !4.1              07.02.2015       AK
    !***************************************************
    CONST robtarget pRefPosIn:=[[-2.24,590.62,323.84],[0.0166667,-0.711586,0.702224,0.0157748],[1,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pRefPosOut:=[[286.77,522.04,169.09],[0.010544,-0.774783,0.631957,0.0151744],[0,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVPLage1:=[[684.31,366.32,658.71],[0.342048,-0.739306,0.522772,-0.251276],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVPLage2:=[[546.67,429.45,668.04],[0.43431,-0.342097,0.833124,-0.0157661],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVPLage3:=[[563.49,420.70,648.77],[0.08332,0.0738914,0.913894,0.390378],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pNotReach:=[[-87.84,-1032.82,734.74],[0.323188,0.660794,0.559778,-0.38151],[-2,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];


    ! For testing
    CONST robtarget pVPLage11:=[[819.09,7.89,726.36],[0.412219,-0.438411,0.555029,-0.574294],[0,0,-2,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVPLage22:=[[805.63,10.20,732.97],[0.544355,0.578099,0.41343,0.445595],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPickNew:=[[-5.33,-90.21,-131.50],[0.0210707,0.029696,-0.999295,-0.00914865],[0,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !
    CONST robtarget pLage1:=[[-416.81,-103.33,-3.24],[0.297107,0.891935,0.256194,-0.224819],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pLage2:=[[12.68,66.05,-415.17],[0.0336951,-0.986693,0.100565,-0.123244],[0,-2,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pLage3:=[[13.79,69.62,-416.83],[0.134418,-0.105505,0.985286,0.0034997],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pUnloadRef:=[[-49.44,75.13,268.09],[0.647615,-0.211858,-0.692403,0.237254],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pNio:=[[542.61,457.85,264.40],[0.0183766,-0.367334,0.92989,0.00570985],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pNioRefOut:=[[365.55,481.11,383.96],[0.018377,-0.367336,0.929889,0.0057096],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pRefPosUnload:=[[487.38,37.02,675.31],[0.396707,-0.0342798,0.917202,0.0137593],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PERS BOOL loadCycleActive:=TRUE;

    ! Copy position because there are the same
    VAR robtarget pUnload:=[[0,0,0],[0,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    VAR num cntr := 1;

    ! Only for simulation
    !PERS BOOL openClamp;
    !
    !-----------------------------------------------------------------------------
    ! Procedure:     InitializeCam_n
    ! Description:   This is an intermediate position used when entering the picking
    !                area. Update this position to suite the current application.           
    ! Argument:      
    ! Remarks:       
    ! Called from:   LoadCameraModules in mainmodule
    !-----------------------------------------------------------------------------
    PROC InitializeCam()
        AccSet 100,100;
        vmax:=v7000;
        VelSet 100,10000;
    ENDPROC





    !-----------------------------------------------------------------------------
    ! Procedure:     CheckAndEnterState
    ! Description:   This procedure checks what to do next and enters the actual state
    ! Argument:
    ! Remarks:
    ! Called from:   Main
    !-----------------------------------------------------------------------------
    PROC CheckAndEnterState()
        !GetBAZState;
        TEST sState
        CASE "Idle","RunCycle":
            sState:=Baz.Cycle;
            !Ist Baz.Cycle anders als RunCycle immer auf Teilen der Maschine warten
            ! Aufruf von GetBazState() in ComInBaz()
            IF Baz.Cycle<>"RunCycle" ComInBAZ;
            !Bei NIO erst Maschine entleeren, dann neu bestücken
            IF Baz.Cycle="NIOCycle" AND Baz.State=Empty sState:="PickCamera";
            !Ist empty Cycle aktiv nicht mehr einlegen
            IF Baz.Cycle="EmptyCycle" sState:=Baz.Cycle;
            !Normaler Ablauf 
            IF Baz.Cycle="RunCycle" sState:="PickCamera";
        CASE "PickCamera":
            !IF bCoordReceived{CAMERA_NO_1}=TRUE OR bCoordReceived{CAMERA_NO_2}=TRUE THEN
            PickCamera;
            sState:="Position_n";
            !ENDIF
        CASE "Position_n":
            NextCycleTime;
            !IF cntr = 10 THEN
                !Position_2;
                !Position_1;
            !ELSE
                Position_1;
                !IF cntr >= 10 THEN
                !     cntr := 1;
                !ENDIF              
            !ENDIF
            !cntr := cntr + 1;
            sState:="Idle";
        CASE "NIOCycle":
            NIOCycle;
            sState:="Idle";
        CASE "EmptyCycle":
            EmptyCycle;
            sState:="Idle";
        DEFAULT:
            Stop;
        ENDTEST
    ENDPROC

    PROC Position_1()
        ConfJ\On;
        ConfL\On;
        MoveJ\Conc,pVPLage1,vmax,z10,tGreiferQuer\Wobj:=wobj0;
        !MoveJ Offs(pLage1,0,0,170),vmax,z40,tGreiferQuer;
        ! For testing
        !MoveJ \Conc, pVPLage11,vmax,z100,tGreiferQuer;
        !
        !ComInBAZ;
        IF ((diEmptyCycle=0) OR loadCycleActive) THEN
            TEST GetClamp()
            CASE "A":
                LoadClamp_P1;
            DEFAULT:
                EmptyGripper;
            ENDTEST
        ENDIF
    ENDPROC

    PROC Position_2()
        ConfJ\On;
        ConfL\On;
        ! Test error messages
        MoveL pNotReach, vmax, fine, tGreiferQuer\WObj:=wobj0;
    ENDPROC

    PROC Position_3()
        ConfJ\On;
        ConfL\On;
        MoveJ\conc,pVPLage3,vmax,z200,tGreiferQuer\Wobj:=wobj0;
        !MoveJ Offs(pLage2,0,0,170),vmax,z40,tGreiferQuer;
        ! For testing
        !MoveJ \Conc, pVPLage22,vmax,z100,tGreiferQuer;
        !
        !ComInBAZ;
        IF ((diEmptyCycle=0) OR loadCycleActive) THEN
            TEST GetClamp()
            CASE "A":
                LoadClamp_P3;
            DEFAULT:
                EmptyGripper;
            ENDTEST
        ENDIF
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure: LoadClampA_Px
    ! Date: 04.02.2015     Version: 1.0     Programmer: AK
    !
    ! Description: Beladen Spannbacke A. Position 1 von rechts. Position 2 von links.
    !-----------------------------------------------------------------------------
    PROC LoadClamp_P1()
        MoveJ\Conc,RelTool(pLage1,0,0,-50),vmax,z10,tGreiferQuer\WObj:=wBazA;
        !WaitUntil Spannbacke(\A\Auf);
        PathAccLim FALSE,TRUE\DecelMax:=7;
        MoveL pLage1,vmax,fine,tGreiferQuer\WObj:=wBazA;
        PathAccLim FALSE,FALSE;
        WaitTime 0.01;
        !IF Spannbacke(\A\Zu\state:=Part) THEN
        !   Greifer\Auf;
        SoftDeact;
        MoveL pLage1,vmax,fine,tGreiferQuer\WObj:=wBazA;
        !
        MoveL RelTool(pLage1,0,0,-180),vmax,z10,tGreiferQuer\WObj:=wBazA;
        MoveJ\Conc,pVPLage1,vmax,z200,tGreiferQuer\Wobj:=wobj0;
        !MoveJ pVPLage1,vmax, z10,tGreiferQuer\WObj:=wBazA;
        loadCycleActive:=TRUE;
        !ELSE
        !            SoftDeact;
        !            MoveL pLage1,vmax,fine,tGreiferQuer\WObj:=wBazA;
        !            !
        !            MoveL RelTool(pLage1,0,0,-180),vmax,z100,tGreiferQuer\WObj:=wBazA;
        !            TriggJ pVPLage1,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
        !            EmptyGripper;
        !ENDIF
    ENDPROC

    PROC LoadClamp_P2()
        MoveJ\Conc,RelTool(pLage2,0,0,-50),vmax,z10,tGreiferQuer\WObj:=wBazA;
        WaitUntil Spannbacke(\A\Auf);
        PathAccLim FALSE,TRUE\DecelMax:=7;
        MoveL pLage2,vmax,fine,tGreiferQuer\WObj:=wBazA;
        PathAccLim FALSE,FALSE;
        WaitTime 0.01;
        IF Spannbacke(\A\Zu\state:=Part) THEN
            Greifer\Auf;
            SoftDeact;
            MoveL pLage2,vmax,fine,tGreiferQuer\WObj:=wBazA;
            !
            MoveL RelTool(pLage2,0,0,-180),vmax,z100,tGreiferQuer\WObj:=wBazA;
            TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            loadCycleActive:=TRUE;
        ELSE
            SoftDeact;
            MoveL pLage2,vmax,fine,tGreiferQuer\WObj:=wBazA;
            !
            MoveL RelTool(pLage2,0,0,-180),vmax,z100,tGreiferQuer\WObj:=wBazA;
            TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            EmptyGripper;
        ENDIF
    ENDPROC

    PROC LoadClamp_P3()
        MoveJ\Conc,RelTool(pLage3,0,0,-50),vmax,z10,tGreiferQuer\WObj:=wBazA;
        WaitUntil Spannbacke(\A\Auf);
        PathAccLim FALSE,TRUE\DecelMax:=7;
        MoveL pLage3,vmax,fine,tGreiferQuer\WObj:=wBazA;
        PathAccLim FALSE,FALSE;
        WaitTime 0.01;
        IF Spannbacke(\A\Zu\state:=Part) THEN
            Greifer\Auf;
            SoftDeact;
            MoveL pLage3,vmax,fine,tGreiferQuer\WObj:=wBazA;
            !
            MoveL RelTool(pLage3,0,0,-180),vmax,z100,tGreiferQuer\WObj:=wBazA;
            TriggJ pVPLage3,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            loadCycleActive:=TRUE;
        ELSE
            SoftDeact;
            MoveL pLage3,vmax,fine,tGreiferQuer\WObj:=wBazA;
            !
            MoveL RelTool(pLage3,0,0,-180),vmax,z100,tGreiferQuer\WObj:=wBazA;
            TriggJ pVPLage3,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            EmptyGripper;
        ENDIF
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure: UnloadClampX
    ! Date: 04.02.2015     Version: 1.0     Programmer: AK
    !
    ! Description: Entladen Spannbacke A.
    !-----------------------------------------------------------------------------
    PROC UnloadClamp()
        ! For testing
        WaitTime 30;
        !
        !        WaitTime 0.01;
        !        ComInBAZ;
        !		TriggL pUnloadRef,vmax,tTurnStraightOff\T2:=tTurnCrossOn,z20,tGreiferQuer\WObj:=wBazA;
        !        MoveJ Offs(pUnload,0,0,100),vmax,z40,tGreiferQuer\WObj:=wBazA;
        !        MoveL pUnload,vmax,fine,tGreiferQuer\WObj:=wBazA;
        !        Greifer\Zu\state:=Part;
        !        WaitUntil Spannbacke(\A\Auf);
        !        SoftDeact;
        !        MoveL pUnload,vmax,fine,tGreiferQuer\WObj:=wBazA;
        !        MoveL Offs(pUnload,0,0,100),vmax,z100,tGreiferQuer\WObj:=wBazA;
    ENDPROC

    !----------------------------------------------------------------------------- 
    ! Procedure: EmptyGripper 
    ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
    ! 
    ! Description: Greifer Entleeren
    !----------------------------------------------------------------------------- 
    PROC EmptyGripper()
        mvTo 91;
        Greifer\Auf;
        WaitTime 0.1;
        Greifer\Gerade;
    ENDPROC

    !----------------------------------------------------------------------------- 
    ! Procedure: NIOCycle
    ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
    ! 
    ! Description: Werkstücke aus BAZ entladen und in NIO Kiste ablegen
    !----------------------------------------------------------------------------- 
    PROC NIOCycle()
        UnloadClamp;
        MoveJ Offs(pUnload,0,0,350),vmax,z40,tGreiferQuer\WObj:=wBazA;
        MoveJ pNio,vmax,fine,tGreifer\WObj:=wobj0;
        Greifer\Gerade;
        WaitTime 0.01;
        Greifer\Auf;
        MoveJ pNioRefOut,vmax,fine,tGreifer\WObj:=wobj0;
        GetBAZState;
    ENDPROC

    !----------------------------------------------------------------------------- 
    ! Procedure: EmptyCycle
    ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
    ! 
    ! Description: Keine Teile mehr in BAZ einlegen, nur Umspannen
    !----------------------------------------------------------------------------- 
    PROC EmptyCycle()
        GetBAZState;
        Grundstellung\emptyCycle;
        endCycleTurmat;
    ENDPROC

    PROC endCycleTurmat()
        VAR bool bMaxTime;
        WHILE diTurmatAuto=1 DO
            WaitUntil diFreigabeBeladen=1\MaxTime:=1\TimeFlag:=bMaxTime;
            IF bMaxTime THEN
                TPWrite "Warte bis BAZ bereit zum Schließen der Futter.";
                WHILE diFreigabeBeladen=0 DO
                    CheckSystem;
                    WaitTime 0.5;
                    IF diTurmatAuto=0 THEN
                        GOTO FINISHCYCLE;
                    ENDIF
                ENDWHILE
            ENDIF
            WaitUntil Spannbacke(\A\emptyCycle);
            WaitUntil Spannbacke(\B\emptyCycle);
            WaitUntil diFreigabeBeladen=0\MaxTime:=1\TimeFlag:=bMaxTime;
            IF bMaxTime THEN
                TPWrite "Warte bis BAZ geschwenkt hat.";
                WHILE diFreigabeBeladen=1 AND diTurmatAuto=1 DO
                    CheckSystem;
                    WaitTime 0.5;
                    IF diTurmatAuto=0 THEN
                        GOTO FINISHCYCLE;
                    ENDIF
                ENDWHILE
            ENDIF
            FINISHCYCLE:
        ENDWHILE
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure:     PickCam_n
    ! Description:   This is an intermediate position used when entering the picking
    !                area. Update this position to suite the current application.           
    ! Argument:
    ! Remarks:       
    ! Called from:   PickCamera
    !-----------------------------------------------------------------------------
    PROC PickCam()
        ConfJ\On;
        ConfL\On;
        PathAccLim FALSE,TRUE\DecelMax:=8;
        MoveJ\Conc,RelTool(pPickNew,0,0,-50),vmax,z10,tGreifer\WObj:=wCamera;
        MoveL pPickNew,vmax,fine,tGreifer\WObj:=wCamera;

        Greifer\Zu\state:=Part;
        PathAccLim FALSE,FALSE;

        ! For testing
        Reset doClampOpenClose;
        MoveJ\Conc,Offs(pPickNew,0,0,50),vmax,z10,tGreifer\WObj:=wCamera;
        !
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure:     RefPosInCam_n
    ! Description:   This is an intermediate position used when entering the picking
    !                area. Update this position to suite the current application.           
    ! Argument:
    ! Remarks:       
    ! Called from:   Main
    !-----------------------------------------------------------------------------
    PROC RefPosIn()
        ConfJ\On;
        ConfL\On;
        IF bFirstRefPos=TRUE THEN
            bFirstRefPos:=FALSE;
            MoveJ\Conc,pRefPosIn,v500,z10,tGreifer\WObj:=wobj0;
        ELSE
            MoveJ\Conc,pRefPosIn,vmax,z10,tGreifer\WObj:=wobj0;
        ENDIF
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure:     RefPosOut_n
    ! Description:   This is an intermediate position used when leaving the picking
    !                area. Update this position to suite the current application.
    ! Argument: 
    ! Remarks:       
    ! Called from:   Main
    !-----------------------------------------------------------------------------
    PROC RefPosOut()
        ConfJ\On;
        ConfL\On;
        MoveJ\Conc,pRefPosOut,vmax,z10,tGreifer\WObj:=wobj0;
    ENDPROC
ENDMODULE
