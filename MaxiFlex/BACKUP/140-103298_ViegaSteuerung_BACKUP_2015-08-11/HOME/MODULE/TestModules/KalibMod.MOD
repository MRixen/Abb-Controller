MODULE KalibMod

    CONST robtarget myTestPoint:=[[109.80,-3.02,16.65],[0.0010835,0.999992,-0.00209965,-0.00316363],[1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PERS num xPoints:=30;
    PERS num yPoints:=23;

    PERS num xPointsCntr:=9;
    PERS num xPointsOffset:=9;

    PERS num yPointsCntr:=23;
    PERS num yPointsOffset:=9;

    PERS num rotQ2:=0;
    PERS num rotQ3:=1;

    PROC putThisInsideMain()
        xPointsCntr:=10;
        yPointsCntr:=0;

        WHILE yPointsCntr<=yPoints-1 DO
            WHILE xPointsCntr<=xPoints-1 DO
                moveToNextPoint xPointsCntr*xPointsOffset,yPointsCntr*yPointsOffset,rotQ2,rotQ3;
                xPointsCntr:=xPointsCntr+1;
                WaitTime 0.25;
            ENDWHILE
            IF rotQ2=1 THEN
                rotQ2:=0;
                rotQ3:=1;
            ELSE
                rotQ2:=1;
                rotQ3:=0;
            ENDIF
            yPointsCntr:=yPointsCntr+1;
            xPointsCntr:=9;
        ENDWHILE
    ENDPROC

    PROC moveToNextPoint(num positionX,num positionY,num rotQ2,num rotQ3)
        !MoveJ myTestPoint,v100,fine,tCalibTool\WObj:=wCamera1;
        MoveL [[positionX,positionY,0.5],[0,rotQ2,rotQ3,0],[1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v100,fine,tCalibTool\WObj:=wCamera1;
    ENDPROC
ENDMODULE