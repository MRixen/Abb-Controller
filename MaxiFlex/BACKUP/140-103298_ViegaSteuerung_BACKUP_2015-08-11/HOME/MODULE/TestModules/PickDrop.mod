MODULE PickDrop
  !=============================================================================
  ! Module: PickDrop
  ! Date: 02.02.2015
  ! Programmer: AK
  ! Company: Viega
  ! 
  ! Part: Ident.: Bez.: Aushalsstück Profipex.:  Abm.: NW25
  ! Greifer: 
  ! Description: Abgreifungenauigkeit analysieren
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
  CONST robtarget pAbwPos:=[[274.14,13.81,394.99],[0.0262274,-0.999203,0.0296184,-0.00524922],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pNio:=[[365.32,-375.85,290.51],[0.0144841,-0.367811,-0.929683,-0.0139708],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pRefNio:=[[365.32,-375.85,290.51],[0.0144841,-0.367811,-0.929683,-0.0139708],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pSpcL:=[[-30.67,-811.89,315.59],[0.0901323,0.897131,0.336636,-0.271494],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pSpcR:=[[-145,-702.89,315.59],[0.0901323,0.897131,0.336636,-0.271494],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget pRefSpc:=[[-145,-702.89,315.59],[0.0901323,0.897131,0.336636,-0.271494],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];    
  CONST robtarget pDrop:=[[72.03,280.79,60.84],[0.577934,0.404748,-0.427772,0.564962],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  !CONST tooldata t277057:=[TRUE,[[-32.6,-1.6,263.99],[1,0,0,0]],[4,[0,0,125],[1,0,0,0],0,0,0]];
    CONST tooldata t277057:=[TRUE,[[0,0,139],[1,0,0,0]],[4,[0,0,125],[1,0,0,0],0,0,0]];
  CONST tooldata t277057Q:=[TRUE,[[41,0,255.99],[0.707106781,0,0.707106781,0]],[4,[0,0,125],[1,0,0,0],0,0,0]];

	! Copy position because there are the same
    VAR robtarget pUnloadA:=[[0,0,0],[0,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget pUnloadB:=[[0,0,0],[0,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

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
    tGreifer:=t277057;
    tGreiferQuer:=t277057Q;
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
    CASE "NIOCycle":
      NIOCycle;
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
    MoveJ pDrop, vmax, fine, tGreiferQuer; 
	WaitTime 0.01;
	Greifer\Auf;
  ENDPROC

  !einlegen von links
  PROC Position_2()
    ConfJ\On;
    ConfL\On;
    MoveJ pDrop, vmax, fine, tGreiferQuer; 
		WaitTime 0.01;
	Greifer\Auf;
  ENDPROC

  !-----------------------------------------------------------------------------
  ! Procedure: LoadClampB_Px
  ! Date: 04.02.2015     Version: 1.0     Programmer: AK
  !
  ! Description: Beladen Spannbacke B. Position 1 von rechts. Position 2 von links.
  !-----------------------------------------------------------------------------
 
  !----------------------------------------------------------------------------- 
  ! Procedure: EmptyGripper 
  ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
  ! 
  ! Description: Greifer Entleeren
  !----------------------------------------------------------------------------- 
  PROC EmptyGripper()
  ENDPROC

  !----------------------------------------------------------------------------- 
  ! Procedure: NIOCycle
  ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
  ! 
  ! Description: Beide Werkstücke aus BAZ entladen und in NIO Kiste ablegen
  !----------------------------------------------------------------------------- 
  PROC NIOCycle()  
  ENDPROC
  
  !----------------------------------------------------------------------------- 
  ! Procedure: EmptyCycle
  ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
  ! 
  ! Description: Keine Teile mehr in BAZ einlegen, nur Umspannen
  !----------------------------------------------------------------------------- 
  PROC EmptyCycle()
  ENDPROC
  
  !----------------------------------------------------------------------------- 
  ! Procedure: SPCCycle
  ! Date: 26.02.2015     Version: 1.0     Programmer: AK 
  ! 
  ! Description: Werkstück(e) aus BAZ entnehmen und auf SPC-Band ablegen
  !----------------------------------------------------------------------------- 
  PROC SPCCycle()
  ENDPROC
  
  !----------------------------------------------------------------------------- 
  ! Procedure: SPCBelt
  ! Date: 27.02.2015     Version: 1.0     Programmer: AK 
  ! 
  ! Description: 
  !----------------------------------------------------------------------------- 
  PROC SPCBelt()
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
    WaitTime 5;
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
    TriggJ pRefPosOut,vmax,tConfPick\T2:=tTurnStraightOn\T3:=tTurnCrossOff,z200,tGreifer\WObj:=wobj0;
    RETURN ;
    MoveJ pRefPosOut,vmax,z200,tGreifer\WObj:=wobj0;
  ENDPROC
ENDMODULE
