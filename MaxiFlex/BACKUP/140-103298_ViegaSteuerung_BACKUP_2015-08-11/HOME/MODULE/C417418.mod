MODULE C417418
    !=============================================================================
    ! Module: C417418
    ! Date: 02.02.2015
    ! Programmer: AK
    ! Company: Viega
    ! 
    ! Part: Ident.: Bez.: Bogen Profipex  Mod.:  Abm.: NW32
    ! Greifer: 
    ! Description: Werkstücke werden von BAZ entladen.
    ! Startbedingung der Maschine: beide Spannbacke geöffnet
    !=============================================================================
    !Version           Date            Description
    !---------------------------------------------------
    !4.0              20111124         Created
    !4.1              07.02.2015       AK
    !***************************************************

    CONST robtarget pLage1A:=[[99.86,15.62,24.30],[0.707778,0.0137878,-0.706298,0.00170354],[-1,-1,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pLage2A:=[[99.28,17.05,23.96],[0.00349639,0.709121,-0.0120362,0.704976],[-1,-1,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVPLage1:=[[383.78,228.39,536.46],[0.334551,-0.0743233,-0.654615,-0.673818],[0,0,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVPLage2:=[[392.01,152.61,529.65],[0.0546559,0.338327,-0.63438,0.6929],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pLage1B:=[[99.93,15.37,22.61],[0.707361,0.0204475,-0.7065,0.00898904],[0,-2,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pLage2B:=[[99.16,16.70,23.02],[0.000622755,0.711273,-0.00688353,0.702882],[0,-2,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pRefPosIn:=[[20.93,377.95,273.15],[0.00479305,0.67772,-0.735234,0.0101821],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pRefPosOut:=[[249.34,436.29,353.68],[0.16121,-0.502078,0.846174,0.076933],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pUnloadRefA:=[[-49.44,75.13,268.09],[0.647615,-0.211858,-0.692403,0.237254],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pUnloadRefB:=[[190.37,75.41,267.93],[0.647002,-0.211499,-0.692682,0.238429],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pAbwPos:=[[274.14,13.81,394.99],[0.0262274,-0.999203,0.0296184,-0.00524922],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pNio:=[[365.32,-375.85,290.51],[0.0144841,-0.367811,-0.929683,-0.0139708],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pNioRefOut:=[[339.43,8.77,426.89],[0.00761769,0.00713383,-0.999923,-0.00674705],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pSpcL:=[[-107.29,-702.91,327.66],[0.108535,0.732549,0.662287,-0.113878],[-2,-2,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pSpcR:=[[-54.37,-756.72,329.63],[0.105374,0.736087,0.659103,-0.112493],[-2,-3,2,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pRefSpcIn:=[[230.89,-497.27,568.03],[0.277324,0.534989,0.790088,-0.11242],[-1,-2,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pRefSpcOut:=[[231.70,-376.42,616.24],[0.261353,0.673232,0.687447,-0.0766155],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pRefSpcOutPre:=[[45.30,-454.50,479.27],[0.0269289,0.657011,0.745667,-0.10767],[-1,-3,2,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pRefPosUnload:=[[487.38,37.02,675.31],[0.396707,-0.0342798,0.917202,0.0137593],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    CONST tooldata t277058:=[TRUE,[[-32.6,0,263.99],[1,0,0,0]],[4,[0,0,125],[1,0,0,0],0,0,0]];
    CONST tooldata t277058Q:=[TRUE,[[41,0,255.99],[0.707106781,0,0.707106781,0]],[4,[0,0,125],[1,0,0,0],0,0,0]];

    PERS BOOL spcPartInPos:=FALSE;
	PERS BOOL firstSpcSignal:=FALSE;
	PERS BOOL loadCycleActive:=FALSE;
	
	! Copy position because there are the same
    VAR robtarget pUnloadA:=[[0,0,0],[0,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget pUnloadB:=[[0,0,0],[0,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

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
        !~~~~~ Anfang Benutzeranpassung ~~~~~
        !AccSet 70,70;
        vmax:=v2500;
        
        tGreifer:=t277058;
        tGreiferQuer:=t277058Q;
        nProgrammnummer:=417418;
        
        !~~~~~ Ende Benutzeranpassung ~~~~~

        !    IF getPartState()=nioPart THEN
        !      TPwrite "NIO part inside gripper";
        !      Stop;
        !    ELSEIF getPartState()=normPart THEN
        !      TPwrite "Part inside gripper";
        !      Stop;
        !    ELSE
        Greifer\Gerade;
        Greifer\Auf;
        BELT_ACTION{1}:=RUN_ONE_DETAIL;
        ALLOW_AUTO_GRAB{1}:=TRUE;
        nImageGrabDelay{1}:=0.05;
        BELT_ACTION{2}:=RUN_ONE_DETAIL;
        ALLOW_AUTO_GRAB{2}:=TRUE;
        nImageGrabDelay{2}:=0.05;
        TriggIO tTurnCrossOn,50\Start\DOp:=doTurnGripperCross,1;
        TriggIO tTurnStraightOff,50\Start\DOp:=doTurnGripperStraight,0;

        TriggIO tTurnStraightOn,0.2\Time\DOp:=doTurnGripperStraight,1;
        TriggIO tTurnCrossOff,0.2\Time\DOp:=doTurnGripperCross,0;

        TriggInt tConfPick,150\Start,iConfPick;
        !    ENDIF
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure:     CheckAndEnterState
    ! Description:   This procedure checks what to do next and enters the actual state
    ! Argument:
    ! Remarks:
    ! Called from:   Main
    !-----------------------------------------------------------------------------
    PROC CheckAndEnterState()
        GetBAZState;
        TEST sState
        CASE "Idle","RunCycle":
            sState:=Baz.Cycle;
            !Ist Baz.Cycle anders als RunCycle immer auf Teilen der Maschine warten
            ! Aufruf von GetBazState() in ComInBaz()
            IF Baz.Cycle<>"RunCycle" ComInBAZ;
            !Bei NIO erst Maschine entleeren, dann neu bestücken
            IF (Baz.Cycle="NIOCycleClampA" OR Baz.Cycle="NIOCycleClampB") AND Baz.State=Empty sState:="PickCamera";
            !Ist empty Cycle aktiv nicht mehr einlegen
            IF Baz.Cycle="EmptyCycle" sState:=Baz.Cycle;
            !Bei SPCCycle erst Maschine enteeren, dann neu bestücken
            IF Baz.Cycle="SPCCycle" AND Baz.State=Empty sState:="PickCamera";
            !Normaler Ablauf 
            IF Baz.Cycle="RunCycle" sState:="PickCamera";
        CASE "PickCamera":
            IF bCoordReceived{CAMERA_NO_1}=TRUE OR bCoordReceived{CAMERA_NO_2}=TRUE THEN
                PickCamera;
                sState:="Position_n";
            ENDIF
        CASE "Position_n":
            Position_n;
			IF DOutput(showCycleTime)=1 THEN
                NextCycleTime;
            ENDIF
            sState:="Idle";    
			IF firstSpcSignal=TRUE AND Baz.ClampA=Part AND Baz.ClampB=Part THEN     
                ! Wait for next spc-signal
                WHILE diFreigabeBeladen=0 DO
                    CheckSystem;
                    WaitTime 0.5;
                ENDWHILE            
                IF diSPCCycle=0 THEN
                    firstSpcSignal:=FALSE;
                ENDIF
            ELSE
                 !Do nothing
            ENDIF
        CASE "NIOCycleClampA":
            NIOCycleClampA;
            sState:="Idle";
        CASE "NIOCycleClampB":
            NIOCycleClampB;
            sState:="Idle";
        CASE "EmptyCycle":
            EmptyCycle;
            sState:="Idle";
        CASE "SPCCycle":
            SPCCycle;
            firstSpcSignal:=TRUE;
            sState:="Idle";
        DEFAULT:
            Stop;
        ENDTEST
    ENDPROC

    !einlegen von rechts
    PROC Position_1()
        ConfJ\On;
        ConfL\On;
        MoveJ pVPLage1,vmax,fine,tGreiferQuer;
        !IF (getPartState(gClose)) THEN
            ComInBAZ;
        	IF ( (diEmptyCycle=0) OR loadCycleActive ) THEN
            TEST GetClamp()
            CASE "A":
                LoadClampA_P1;
            CASE "B":
                LoadClampB_P1;
            DEFAULT:
                EmptyGripper;
            ENDTEST
         ENDIF
        !ELSE
        !    TPWrite "Teil verloren, neues holen.";
        !ENDIF
    ENDPROC

    !einlegen von links
    PROC Position_2()
        ConfJ\On;
        ConfL\On;
        MoveJ pVPLage2,vmax,fine,tGreiferQuer;
        !IF (getPartState(gClose)) THEN
            ComInBAZ;
        	IF ( (diEmptyCycle=0) OR loadCycleActive ) THEN            
            TEST GetClamp()
            CASE "A":
                LoadClampA_P2;
            CASE "B":
                LoadClampB_P2;
            DEFAULT:
                EmptyGripper;
            ENDTEST
         ENDIF
       !ELSE
        !    TPWrite "Teil verloren, neues holen.";
        !ENDIF
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure: LoadClampB_Px
    ! Date: 04.02.2015     Version: 1.0     Programmer: AK
    !
    ! Description: Beladen Spannbacke B. Position 1 von rechts. Position 2 von links.
    !-----------------------------------------------------------------------------
    PROC LoadClampB_P1()
        MoveJ Offs(pLage1B,0,0,200),vmax,z40,tGreiferQuer\WObj:=wBazB;
        WaitUntil Spannbacke(\B\Auf);
        MoveL pLage1B,vmax,fine,tGreiferQuer\WObj:=wBazB;
        WaitTime 0.01;
        IF Spannbacke(\B\Zu\state:=Part) THEN
            Greifer\Auf;
            SoftDeact;
            !MoveL pLage1B,vmax,fine,tGreiferQuer\WObj:=wBazB;
            MoveL Offs(pLage1B,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazB;
            IF diErrClampA=1 OR diErrClampB=1 THEN
                TriggJ pVPLage1,vmax,tTurnStraightOff\T2:=tTurnCrossOn,z100,tGreiferQuer;
            ELSE
                TriggJ pVPLage1,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            ENDIF
            loadCycleActive := FALSE;
        ELSE
            SoftDeact;
            MoveL pLage1B,vmax,fine,tGreiferQuer\WObj:=wBazB;
            MoveL Offs(pLage1B,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazB;
            TriggJ pVPLage1,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            !MoveJ pAbwPos,vmax,fine,tGreifer\WObj:=wobj0;
            EmptyGripper;
            !Greifer\Auf;
        ENDIF
        ! Only for simulation
        !openClamp:=TRUE;
        !
    ENDPROC

    PROC LoadClampB_P2()
        MoveJ Offs(pLage2B,0,0,200),vmax,z40,tGreiferQuer\WObj:=wBazB;
        WaitUntil Spannbacke(\B\Auf);
        MoveL pLage2B,vmax,fine,tGreiferQuer\WObj:=wBazB;
        WaitTime 0.01;
        IF Spannbacke(\B\Zu\state:=Part) THEN
            Greifer\Auf;
            SoftDeact;
            !MoveL pLage2B,vmax,fine,tGreiferQuer\WObj:=wBazB;
            MoveL Offs(pLage2B,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazB;
            IF diErrClampA=1 OR diErrClampB=1 THEN
                TriggJ pVPLage2,vmax,tTurnStraightOff\T2:=tTurnCrossOn,z100,tGreiferQuer;
            ELSE
                TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            ENDIF
            loadCycleActive := FALSE;
        ELSE
            SoftDeact;
            MoveL pLage2B,vmax,fine,tGreiferQuer\WObj:=wBazB;
            MoveL Offs(pLage2B,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazB;
            TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            !MoveJ pAbwPos,vmax,fine,tGreifer\WObj:=wobj0;
            EmptyGripper;
            !Greifer\Auf;
        ENDIF
        ! Only for simulation
        !openClamp:=TRUE;
        !
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure: LoadClampA_Px
    ! Date: 04.02.2015     Version: 1.0     Programmer: AK
    !
    ! Description: Beladen Spannbacke A. Position 1 von rechts. Position 2 von links.
    !-----------------------------------------------------------------------------
    PROC LoadClampA_P1()
        MoveJ Offs(pLage1A,0,0,200),vmax,z40,tGreiferQuer\WObj:=wBazA;
        WaitUntil Spannbacke(\A\Auf);
        MoveL pLage1A,vmax,fine,tGreiferQuer\WObj:=wBazA;
        WaitTime 0.01;
        IF Spannbacke(\A\Zu\state:=Part) THEN
            Greifer\Auf;
            SoftDeact;
            !MoveL pLage1A,vmax,fine,tGreiferQuer\WObj:=wBazA;
            MoveL Offs(pLage1A,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazA;
            TriggJ pVPLage1,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            loadCycleActive := TRUE;
        ELSE
            SoftDeact;
            MoveL pLage1A,vmax,fine,tGreiferQuer\WObj:=wBazA;
            MoveL Offs(pLage1A,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazA;
            TriggJ pVPLage1,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            EmptyGripper;
            ! Greifer\Auf;
        ENDIF
    ENDPROC

    PROC LoadClampA_P2()
        MoveJ Offs(pLage2A,0,0,200),vmax,z40,tGreiferQuer\WObj:=wBazA;
        WaitUntil Spannbacke(\A\Auf);
        MoveL pLage2A,vmax,fine,tGreiferQuer\WObj:=wBazA;
        WaitTime 0.01;
        IF Spannbacke(\A\Zu\state:=Part) THEN
            Greifer\Auf;
            SoftDeact;
            ! MoveL pLage2A,vmax,fine,tGreiferQuer\WObj:=wBazA;
            MoveL Offs(pLage2A,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazA;
            TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            loadCycleActive := TRUE;
        ELSE
            SoftDeact;
            MoveL pLage2A,vmax,fine,tGreiferQuer\WObj:=wBazA;
            MoveL Offs(pLage2A,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazA;
            TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
            !MoveJ pAbwPos,vmax,fine,tGreifer\WObj:=wobj0;
            EmptyGripper;
            !Greifer\Auf;
        ENDIF
    ENDPROC

    !-----------------------------------------------------------------------------
    ! Procedure: UnloadClampX
    ! Date: 04.02.2015     Version: 1.0     Programmer: AK
    !
    ! Description: Entladen Spannbacke A.
    !-----------------------------------------------------------------------------
    PROC UnloadClampA()
        WaitTime 0.01;
        !Greifer\Quer;
        ComInBAZ;
        TriggL pUnloadRefA,vmax,tTurnStraightOff\T2:=tTurnCrossOn,z20,tGreiferQuer\WObj:=wBazA;
        !MoveL pUnloadRefA,vmax,z20,tGreiferQuer\WObj:=wBazA;
        MoveJ Offs(pUnloadA,0,0,200),vmax,z40,tGreiferQuer\WObj:=wBazA;
        MoveL pUnloadA,vmax,fine,tGreiferQuer\WObj:=wBazA;
        Greifer\Zu\state:=Part;
        WaitUntil Spannbacke(\A\Auf);
        SoftDeact;
        MoveL pUnloadA,vmax,fine,tGreiferQuer\WObj:=wBazA;
        MoveL Offs(pUnloadA,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazA;
    ENDPROC

    PROC UnloadClampB()
        WaitTime 0.01;
        !Greifer\Quer;
        ComInBAZ;
        TriggL pUnloadRefB,vmax,tTurnStraightOff\T2:=tTurnCrossOn,z20,tGreiferQuer\WObj:=wBazB;
        !MoveL pUnloadRefB,vmax,z20,tGreiferQuer\WObj:=wBazB;
        MoveJ Offs(pUnloadB,0,0,200),vmax,z40,tGreiferQuer\WObj:=wBazB;
        MoveL pUnloadB,vmax,fine,tGreiferQuer\WObj:=wBazB;
        Greifer\Zu\state:=Part;
        WaitUntil Spannbacke(\B\Auf);
        SoftDeact;
        MoveL pUnloadB,vmax,fine,tGreiferQuer\WObj:=wBazB;
        MoveL Offs(pUnloadB,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazB;
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
    PROC NIOCycleClampA()
        !WaitTime 0.1;        
        !Greifer\Quer;
        !WHILE DOutput(doTurnGripperCross)=0 DO
        !    Greifer\Quer;
        !ENDWHILE
        !IF (DOutput(doTurnGripperCross)=1 AND DOutput(doTurnGripperStraight)=0) THEN
        UnloadClampA;
        MoveJ Offs(pUnloadA,0,0,350),vmax,z40,tGreiferQuer\WObj:=wBazA;
        MoveJ pNio,vmax,fine,tGreifer\WObj:=wobj0;
        Greifer\Gerade;
        WaitTime 0.01;
        Greifer\Auf;
        MoveJ pNioRefOut,vmax,fine,tGreifer\WObj:=wobj0;
        GetBAZState;
        !ENDIF
    ENDPROC

    PROC NIOCycleClampB()
        !WaitTime 0.1;    
        !Greifer\Quer;
        !WHILE DOutput(doTurnGripperCross)=0 DO
        !    Greifer\Quer;
        !ENDWHILE
        !IF (DOutput(doTurnGripperCross)=1 AND DOutput(doTurnGripperStraight)=0) THEN
        UnloadClampB;
        MoveJ Offs(pUnloadB,0,0,350),vmax,z40,tGreiferQuer\WObj:=wBazB;
        MoveJ pNio,vmax,fine,tGreifer\WObj:=wobj0;
        Greifer\Gerade;
        WaitTime 0.01;
        Greifer\Auf;
        MoveJ pNioRefOut,vmax,fine,tGreifer\WObj:=wobj0;
        GetBAZState;
        !ENDIF
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
    ! Procedure: SPCCycle
    ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
    ! 
    ! Description: Werkstück(e) aus BAZ entnehmen und auf SPC-Band ablegen
    !----------------------------------------------------------------------------- 
    PROC SPCCycle()
        IF Baz.ClampA=SPCPart THEN
            UnloadClampA;
            SPCBelt pSpcR;
        ELSEIF Baz.ClampB=SPCPart THEN
            UnloadClampB;
            SPCBelt pSpcL;
            PulseDO\PLength:=0.35,doSpcBelt;
            WaitTime 0.01;
            spcPartInPos:=FALSE;
        ENDIF
        GetBAZState;
    ENDPROC

    !----------------------------------------------------------------------------- 
    ! Procedure: SPCBelt
    ! Date: 27.02.2015     Version: 1.0     Programmer: AK 
    ! 
    ! Description: 
    !----------------------------------------------------------------------------- 
    PROC SPCBelt(robtarget position)
        MoveJ Offs(pUnloadA,0,0,350),vmax,z40,tGreiferQuer\WObj:=wBazA;
        ! Prüfen ob Band frei
        IF NOT (diSpcBelt=1 OR (diSpcBelt=0 AND spcPartInPos)) THEN
            ! Information anzeigen, dass Band nicht frei ist
            TPWrite "SPC-Band nicht frei. Bitte Teile entnehmen.";
        ENDIF
        WHILE NOT (diSpcBelt=1 OR (diSpcBelt=0 AND spcPartInPos)) DO
            WaitTime 0.1;
        ENDWHILE
        TriggJ pRefSpcIn,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z80,tGreifer\WObj:=wSpcBelt;
        !	Greifer\Gerade;
        !MoveJ pRefSpcIn, vmax, z80, tGreifer\WObj:=wSpcBelt;
        MoveJ Offs(position,0,0,20),vmax,z40,tGreifer\WObj:=wSpcBelt;
        MoveL Offs(position,0,0,0),vmax,fine,tGreifer\WObj:=wSpcBelt;
        WaitTime 0.01;
        Greifer\Auf;
        MoveL Offs(position,0,0,20),vmax,z40,tGreifer\WObj:=wSpcBelt;
        WaitTime 0.01;
        MoveJ pRefSpcOutPre,vmax,z40,tGreifer\WObj:=wSpcBelt;
        TriggJ pRefSpcOut,vmax,tTurnStraightOff\T2:=tTurnCrossOn,z40,tGreifer\WObj:=wSpcBelt;
        ! MoveJ pRefSpcOut,vmax,z40,tGreifer\WObj:=wSpcBelt;
        spcPartInPos:=TRUE;
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
        ConfJ\Off;
        ConfL\Off;
        !AccSet 75,75;
        MoveJ RelTool(pPick,0,0,-nPZ),vmax,z40,tGreifer\WObj:=wCamera;
        MoveL pPick,vmax,fine,tGreifer\WObj:=wCamera;
        WaitTime 0.01;
        !AccSet 100,100;
        Greifer\Zu\state:=Part;
        WaitTime 0.01;
        MoveJ Offs(pPick,0,0,nPZ),vmax,z40,tGreifer\WObj:=wCamera;
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
            TriggJ pRefPosIn,v500,tTurnStraightOn\T2:=tTurnCrossOff,z10,tGreifer\WObj:=wobj0;
        ELSE
            TriggJ pRefPosIn,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z200,tGreifer\WObj:=wobj0;
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
        TriggJ pRefPosOut,vmax,tConfPick\T2:=tTurnCrossOn\T3:=tTurnStraightOff,z200,tGreifer\WObj:=wobj0;
        RETURN ;
        MoveJ pRefPosOut,vmax,z200,tGreifer\WObj:=wobj0;
    ENDPROC
ENDMODULE
