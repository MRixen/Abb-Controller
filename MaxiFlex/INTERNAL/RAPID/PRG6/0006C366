MODULE MainBaz
  !====================================================================
  ! Module: Baz
  ! Datum: 26.02.2015
  ! Programmierer: AK
  ! Beschreibung: Überwacht das Teilen des Baz.
  !====================================================================
  PROC main()
    WHILE TRUE DO
      WaitUntil diFreigabeBeladen=1;
      Baz.Turned:=TRUE;
      Baz.NewData:=TRUE;
      WaitUntil diFreigabeBeladen=0;
      WaitTime 0.1;
    ENDWHILE
  ENDPROC
ENDMODULE
