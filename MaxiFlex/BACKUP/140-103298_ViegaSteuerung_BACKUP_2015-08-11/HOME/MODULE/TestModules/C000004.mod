MODULE C000004
  !=============================================================================
  ! Module: C000004
  ! Date: 02.02.2015
  ! Programmer: AK
  ! Company: Viega
  ! 
  ! Part: Ident.: Bez.: Rohr D28  Mod.:  Abm.: 
  ! Greifer: 
  ! Description: Werkstücke werden von BAZ entladen.
  ! Startbedingung der Maschine: beide Spannbacke geöffnet
  !=============================================================================
  !Version           Date            Description
  !---------------------------------------------------
  !4.0              20111124         Created
  !4.1              07.02.2015       AK
  !***************************************************
  CONST robtarget pRefPosIn:=[[20.93,377.95,273.15],[0.00479305,0.67772,-0.735234,0.0101821],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pRefPosOut:=[[249.34,436.29,353.68],[0.16121,-0.502078,0.846174,0.076933],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pLage1A:=[[100.58,13.08,-24.02],[0.702872,0.00946785,-0.711241,0.0042126],[-1,-1,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pLage2A:=[[101.15,25.36,-19.16],[0.00735835,-0.706927,0.0125645,-0.707136],[-1,-1,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pVPLage1:=[[383.78,228.39,536.46],[0.334551,-0.0743233,-0.654615,-0.673818],[0,0,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pVPLage2:=[[414.01,152.62,529.66],[0.054636,0.338324,-0.634392,0.692891],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pLage1B:=[[100.40,11.21,-18.69],[0.6973,-0.00874512,-0.71672,0.00303246],[0,-2,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pLage2B:=[[100.50,25.61,-16.25],[0.00174146,0.696794,0.0316466,0.71657],[0,-2,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pUnloadA:=[[100.00,27.75,-16.49],[0.702308,0.00380268,-0.711852,-0.00394726],[-1,-1,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pUnloadB:=[[100.29,29.66,-15.44],[0.696835,-0.0013711,-0.716483,0.0327179],[0,-2,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pAbwPos:=[[274.14,13.81,394.99],[0.0262274,-0.999203,0.0296184,-0.00524922],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pNio:=[[365.32,-375.85,290.51],[0.0144841,-0.367811,-0.929683,-0.0139708],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pRefNio:=[[365.32,-375.85,290.51],[0.0144841,-0.367811,-0.929683,-0.0139708],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pSpcL:=[[-30.67,-811.89,315.59],[0.0901323,0.897131,0.336636,-0.271494],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pSpcR:=[[-145,-702.89,315.59],[0.0901323,0.897131,0.336636,-0.271494],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pRefSpc:=[[-145,-702.89,315.59],[0.0901323,0.897131,0.336636,-0.271494],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST tooldata t277058:=[TRUE,[[-33,0,266.5],[1,0,0,0]],[4,[0,0,125],[1,0,0,0],0,0,0]];
    CONST tooldata t277058Q:=[TRUE,[[43,5,255.99],[0.707106781,0,0.707106781,0]],[4,[0,0,125],[1,0,0,0],0,0,0]];

  ! Only for simulation
  PERS BOOL openClamp;
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
    AccSet 70,70;
    vmax:=v2000;
    tGreifer:=t277058;
    tGreiferQuer:=t277058Q;
    nProgrammnummer:=0;
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
      sState:="Idle";
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
    ComInBAZ;
    TEST GetClamp()
    CASE "A":
      LoadClampA_P1;
    CASE "B":
      LoadClampB_P1;
    DEFAULT:
      EmptyGripper;
    ENDTEST
  ENDPROC

  !einlegen von links
  PROC Position_2()
    ConfJ\On;
    ConfL\On;
    MoveJ pVPLage2,vmax,fine,tGreiferQuer;
    ComInBAZ;
    TEST GetClamp()
    CASE "A":
      LoadClampA_P2;
    CASE "B":
      LoadClampB_P2;
    DEFAULT:  
      EmptyGripper;
    ENDTEST
  ENDPROC

  !-----------------------------------------------------------------------------
  ! Procedure: LoadClampB_Px
  ! Date: 04.02.2015     Version: 1.0     Programmer: AK
  !
  ! Description: Beladen Spannbacke B. Position 1 von rechts. Position 2 von links.
  !-----------------------------------------------------------------------------
  PROC LoadClampB_P1()
    MoveJ Offs(pLage1B,0,0,100),vmax,z40,tGreiferQuer\WObj:=wBazB;
    WaitUntil Spannbacke(\B\Auf);
    MoveL pLage1B,vmax,fine,tGreiferQuer\WObj:=wBazB;
    WaitTime 0.01;
    IF Spannbacke(\B\Zu\state:=Part) THEN
      Greifer\Auf;
      SoftDeact;
      MoveL pLage1B,vmax,fine,tGreiferQuer\WObj:=wBazB;
      MoveL Offs(pLage1B,0,0,100),vmax,z100,tGreiferQuer\WObj:=wBazB;
      TriggJ pVPLage1,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
    ELSE
      SoftDeact;
      MoveL pLage1B,vmax,fine,tGreiferQuer\WObj:=wBazB;
      MoveL Offs(pLage1B,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazB;
      TriggJ pVPLage1,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
      MoveJ pAbwPos,vmax,fine,tGreifer\WObj:=wobj0;
      Greifer\Auf;
    ENDIF
    ! Only for simulation
    openClamp:=TRUE;
    !
  ENDPROC

  PROC LoadClampB_P2()
    MoveJ Offs(pLage2B,0,0,100),vmax,z40,tGreiferQuer\WObj:=wBazB;
    WaitUntil Spannbacke(\B\Auf);
    MoveL pLage2B,vmax,fine,tGreiferQuer\WObj:=wBazB;
    WaitTime 0.01;
    IF Spannbacke(\B\Zu\state:=Part) THEN
      Greifer\Auf;
      SoftDeact;
      MoveL pLage2B,vmax,fine,tGreiferQuer\WObj:=wBazB;
      MoveL Offs(pLage2B,0,0,100),vmax,z100,tGreiferQuer\WObj:=wBazB;
      TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
    ELSE
      SoftDeact;
      MoveL pLage2B,vmax,fine,tGreiferQuer\WObj:=wBazB;
      MoveL Offs(pLage2B,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazB;
      TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
      MoveJ pAbwPos,vmax,fine,tGreifer\WObj:=wobj0;
      Greifer\Auf;
    ENDIF
    ! Only for simulation
    openClamp:=TRUE;
    !
  ENDPROC

  !-----------------------------------------------------------------------------
  ! Procedure: LoadClampA_Px
  ! Date: 04.02.2015     Version: 1.0     Programmer: AK
  !
  ! Description: Beladen Spannbacke A. Position 1 von rechts. Position 2 von links.
  !-----------------------------------------------------------------------------
  PROC LoadClampA_P1()
    MoveJ Offs(pLage1A,0,0,100),vmax,z40,tGreiferQuer\WObj:=wBazA;
    WaitUntil Spannbacke(\A\Auf);
    MoveL pLage1A,vmax,fine,tGreiferQuer\WObj:=wBazA;
    WaitTime 0.01;
    IF Spannbacke(\A\Zu\state:=Part) THEN
      Greifer\Auf;
      SoftDeact;
      MoveL pLage1A,vmax,fine,tGreiferQuer\WObj:=wBazA;
      MoveL Offs(pLage1A,0,0,100),vmax,z100,tGreiferQuer\WObj:=wBazA;
      TriggJ pVPLage1,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
    ELSE
      SoftDeact;
      MoveL pLage1A,vmax,fine,tGreiferQuer\WObj:=wBazA;
      MoveL Offs(pLage1A,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazA;
      TriggJ pVPLage1,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
      MoveJ pAbwPos,vmax,fine,tGreifer\WObj:=wobj0;
      Greifer\Auf;
    ENDIF
  ENDPROC

  PROC LoadClampA_P2()
    MoveJ Offs(pLage2A,0,0,100),vmax,z40,tGreiferQuer\WObj:=wBazA;
    WaitUntil Spannbacke(\A\Auf);
    MoveL pLage2A,vmax,fine,tGreiferQuer\WObj:=wBazA;
    WaitTime 0.01;
    IF Spannbacke(\A\Zu\state:=Part) THEN
      Greifer\Auf;
      SoftDeact;
      MoveL pLage2A,vmax,fine,tGreiferQuer\WObj:=wBazA;
      MoveL Offs(pLage2A,0,0,100),vmax,z100,tGreiferQuer\WObj:=wBazA;
      TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
    ELSE
      SoftDeact;
      MoveL pLage2A,vmax,fine,tGreiferQuer\WObj:=wBazA;
      MoveL Offs(pLage2A,0,0,200),vmax,z100,tGreiferQuer\WObj:=wBazA;
      TriggJ pVPLage2,vmax,tTurnStraightOn\T2:=tTurnCrossOff,z100,tGreiferQuer;
      MoveJ pAbwPos,vmax,fine,tGreifer\WObj:=wobj0;
      Greifer\Auf;
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
    Greifer\Quer;
    ComInBAZ;
    MoveJ Offs(pUnloadA,0,0,100), vmax, z40, tGreiferQuer\WObj:=wBazA;
    MoveL pUnloadA, vmax, fine, tGreiferQuer\WObj:=wBazA;
    Greifer\Zu\state:=Part;
    WaitUntil Spannbacke(\A\Auf);
    SoftDeact;      
    MoveL pUnloadA, vmax, fine, tGreiferQuer\WObj:=wBazA;
    MoveL Offs(pUnloadA,0,0,100), vmax, z100, tGreiferQuer\WObj:=wBazA;
  ENDPROC
  
  PROC UnloadClampB()
  WaitTime 0.01;
    Greifer\Quer;
    ComInBAZ;
    MoveJ Offs(pUnloadB,0,0,100), vmax, z40, tGreiferQuer\WObj:=wBazB;
    MoveL pUnloadB, vmax, fine, tGreiferQuer\WObj:=wBazB;
    Greifer\Zu\state:=Part;
    WaitUntil Spannbacke(\B\Auf);
    SoftDeact;      
    MoveL pUnloadB, vmax, fine, tGreiferQuer\WObj:=wBazB;
    MoveL Offs(pUnloadB,0,0,100), vmax, z100, tGreiferQuer\WObj:=wBazB;
  ENDPROC
  
  !----------------------------------------------------------------------------- 
  ! Procedure: EmptyGripper 
  ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
  ! 
  ! Description: Greifer Entleeren
  !----------------------------------------------------------------------------- 
  PROC EmptyGripper()
    mvTo 100;
    Greifer\Gerade;
    Greifer\Auf;
  ENDPROC

  !----------------------------------------------------------------------------- 
  ! Procedure: NIOCycle
  ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
  ! 
  ! Description: Werkstücke aus BAZ entladen und in NIO Kiste ablegen
  !----------------------------------------------------------------------------- 
  PROC NIOCycleClampA()  
    Greifer\Quer;
    UnloadClampA;
	MoveJ Offs(pUnloadA,0,0,350), vmax, z40, tGreiferQuer\WObj:=wBazA;
    MoveJ pNio,vmax,fine,tGreifer\WObj:=wobj0;
    Greifer\Gerade;
    WaitTime 0.01;
    Greifer\Auf;
	GetBAZState;
  ENDPROC
  
    PROC NIOCycleClampB()  
    Greifer\Quer;
    UnloadClampB;
	MoveJ Offs(pUnloadB,0,0,350), vmax, z40, tGreiferQuer\WObj:=wBazB;
	MoveJ pNio,vmax,fine,tGreifer\WObj:=wobj0;
    Greifer\Gerade;
    WaitTime 0.01;
    Greifer\Auf;
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
    Grundstellung \Ende;
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
	  SPCBelt pSpcL;
    ELSEIF Baz.ClampB=SPCPart THEN 
      UnloadClampB;
	  SPCBelt pSpcR;
	  PulseDO \PLength:=0.25, doSpcBelt;  
	  WaitTime 0.01;
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
    MoveJ Offs(pUnloadA,0,0,350), vmax, z40, tGreiferQuer\WObj:=wBazA;
	Greifer\Gerade;
	MoveJ pRefSpc,vmax,z40,tGreifer\WObj:=wSpcBelt;
  	MoveJ Offs(position,0,0,50),vmax,z40,tGreifer\WObj:=wSpcBelt;
	MoveL Offs(position,0,0,0),vmax,fine,tGreifer\WObj:=wSpcBelt;
	WaitTime 0.01;
	Greifer\Auf;
	MoveL Offs(position,0,0,150),vmax,z40,tGreifer\WObj:=wSpcBelt;
	WaitTime 0.01;
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
    AccSet 75,75;
    MoveJ RelTool(pPick,0,0,-nPZ),vmax,z40,tGreifer\WObj:=wCamera;
    MoveL pPick,vmax,fine,tGreifer\WObj:=wCamera;
    AccSet 100,100;
    Greifer\Zu\state:=Part;
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
