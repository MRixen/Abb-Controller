MODULE C000002
  !=============================================================================
  ! Module: C000002
  ! Date: 02.02.2015
  ! Programmer: AK
  ! Company: Viega
  ! 
  ! Part: Ident.: Bez.: Bogen 90°  Mod.:  Abm.: 
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
    CONST robtarget pLage1A:=[[101.88,15.65,4.73],[0.711189,0.00347897,-0.702982,-0.00379113],[-1,-1,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pLage2A:=[[104.40,17.38,4.76],[0.0184535,-0.699828,-0.00658381,-0.714043],[-1,-1,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVPLage1:=[[383.78,228.39,536.46],[0.334551,-0.0743233,-0.654615,-0.673818],[0,0,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVPLage2:=[[414.01,152.62,529.66],[0.054636,0.338324,-0.634392,0.692891],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pLage1B:=[[102.34,15.92,4.46],[0.718292,0.0152283,-0.695551,0.00575157],[0,-2,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pLage2B:=[[104.02,17.15,4.53],[0.013393,-0.705612,-0.0166274,-0.708276],[0,-2,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pUnloadA:=[[101.88,15.65,4.73],[0.711189,0.00347897,-0.702982,-0.00379113],[-1,-1,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pUnloadB:=[[102.34,15.92,4.46],[0.718292,0.0152283,-0.695551,0.00575157],[0,-2,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pAbwPos:=[[274.14,13.81,394.99],[0.0262274,-0.999203,0.0296184,-0.00524922],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pNio:=[[365.32,-375.85,290.51],[0.0144841,-0.367811,-0.929683,-0.0139708],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pSpcL:=[[-32.52,-814.50,302.31],[0.0440071,0.918977,0.372282,-0.122276],[-1,-3,2,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pSpcR:=[[-129.83,-713.85,303.74],[0.044017,0.918979,0.372273,-0.122281],[-2,-3,2,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pRefSpc:=[[182.89,-602.71,481.36],[0.409098,0.489053,0.71944,-0.275449],[-1,-2,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST tooldata t277057:=[TRUE,[[-33,0,263.99],[1,0,0,0]],[4,[0,0,125],[1,0,0,0],0,0,0]];
    CONST tooldata t277057Q:=[TRUE,[[41,0,255.99],[0.707106781,0,0.707106781,0]],[4,[0,0,125],[1,0,0,0],0,0,0]];

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
    AccSet 70,70;
    vmax:=v2000;
    tGreifer:=t277057;
    tGreiferQuer:=t277057Q;
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
    WaitUntil Spannbacke(\B\Zu);
    IF Spannbacke(\B\Zu\state:=Part) THEN
      Greifer\Auf;
      SoftDeact;
      !MoveL pLage1B,vmax,fine,tGreiferQuer\WObj:=wBazB;
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
    !openClamp:=TRUE;
    !
  ENDPROC

  PROC LoadClampB_P2()
    MoveJ Offs(pLage2B,0,0,100),vmax,z40,tGreiferQuer\WObj:=wBazB;
    WaitUntil Spannbacke(\B\Auf);
    MoveL pLage2B,vmax,fine,tGreiferQuer\WObj:=wBazB;
    WaitUntil Spannbacke(\B\Zu);
    IF Spannbacke(\B\Zu\state:=Part) THEN
      Greifer\Auf;
      SoftDeact;
      !MoveL pLage2B,vmax,fine,tGreiferQuer\WObj:=wBazB;
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
    MoveJ Offs(pLage1A,0,0,100),vmax,z40,tGreiferQuer\WObj:=wBazA;
    WaitUntil Spannbacke(\A\Auf);
    MoveL pLage1A,vmax,fine,tGreiferQuer\WObj:=wBazA;
	WaitUntil Spannbacke(\A\Zu);
    IF Spannbacke(\A\Zu\state:=Part) THEN
      Greifer\Auf;
      SoftDeact;
      !MoveL pLage1A,vmax,fine,tGreiferQuer\WObj:=wBazA;
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
    WaitUntil Spannbacke(\A\Zu);
    IF Spannbacke(\A\Zu\state:=Part) THEN
      Greifer\Auf;
      SoftDeact;
     ! MoveL pLage2A,vmax,fine,tGreiferQuer\WObj:=wBazA;
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
	MoveL Offs(position,0,0,50),vmax,z40,tGreifer\WObj:=wSpcBelt;
	WaitTime 0.01;
	MoveJ pRefSpc,vmax,z40,tGreifer\WObj:=wSpcBelt;
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
