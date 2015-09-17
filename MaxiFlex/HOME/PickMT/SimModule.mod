MODULE SimModule
   CONST robtarget p110:=[[49.999997879,-79.492891535,159.976111887],[0.000000005,0.923879533,-0.382683432,0.000000001],[1,-1,1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    CONST robtarget p11011101:=[[50.000287767,-79.492844512,34.976129532],[0.000000129,0.923879533,-0.382683432,0.000000026],[1,-1,1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    CONST robtarget p111:=[[50.000000005,-79.492884729,9.976113983],[0,0.923879533,-0.382683432,0],[1,0,1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];

  PROC SimMode()
    !InitializeMain;
    !InitPickVision;
    InitSim;
    WHILE TRUE DO
      CheckSystem;
      CheckAndEnterState;
      WaitTime 0.01;
    ENDWHILE
  ENDPROC  
  
  PROC InitSim()
    bCoordReceived{CAMERA_NO_1}:=TRUE;
    nPosition:=2;
    pPick:=[[50.000000005,-79.492884729,9.976113983],[0,0.923879533,-0.382683432,0],[1,0,1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    InitializeCam;
    !Nur f�r C000002
    WaitUntil Spannbacke(\A\Auf) and Spannbacke(\B\Auf);
  ENDPROC
ENDMODULE