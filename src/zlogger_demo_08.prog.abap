REPORT zlogger_demo_08.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME.
  PARAMETERS:
    p_single RADIOBUTTON GROUP sel DEFAULT 'X',
    p_stndrd RADIOBUTTON GROUP sel,
    p_notree RADIOBUTTON GROUP sel,
    p_self   RADIOBUTTON GROUP sel.
SELECTION-SCREEN END OF BLOCK b01.


END-OF-SELECTION.

* show a single log file
  IF p_single IS NOT INITIAL.
    SUBMIT zlogger_demo_08_single AND RETURN.
  ENDIF.

* show many log files
  IF p_stndrd IS NOT INITIAL.
    SUBMIT zlogger_demo_08_standard AND RETURN.
  ENDIF.

* show one log file and no tree next to it
  IF p_notree IS NOT INITIAL.
    SUBMIT zlogger_demo_08_no_tree AND RETURN.
  ENDIF.

  IF p_self IS NOT INITIAL.
    SUBMIT zlogger_demo_08_self AND RETURN.
  ENDIF.
