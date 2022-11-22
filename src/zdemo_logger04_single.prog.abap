*&---------------------------------------------------------------------*
*& Report zdemo_logger04_single
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_logger04_single MESSAGE-ID bl.
DATA logger TYPE REF TO zif_logger.

START-OF-SELECTION.

  PERFORM logs_create.

END-OF-SELECTION.
  IF logger->is_empty( ) = abap_false.
    logger->fullscreen( ).
  ENDIF.

FORM logs_create.

  DATA:
    lv_importance TYPE balprobcl,
    ls_msg        TYPE bal_s_msg,
    lv_msgno      TYPE symsgno,
    lv_msg        TYPE string.

  logger = zcl_logger_factory=>create_log(
             object = ''
             subobject = ''
             desc = 'Application Log Demo'
             settings  =
               zcl_logger_factory=>create_settings(
                 )->set_autosave( abap_false
                 )->set_must_be_kept_until_expiry( abap_true )
                                       ).

  lv_msgno = 301.
  DO.
    ls_msg-msgid = 'BL'.
    ls_msg-msgno = lv_msgno.

    "   derive message type
    IF lv_msgno CP '*4'.
      ls_msg-msgty = 'E'.
    ELSEIF lv_msgno CP '*2*'.
      ls_msg-msgty = 'W'.
    ELSE.
      ls_msg-msgty = 'S'.
    ENDIF.

    "   derive message importance
    IF lv_msgno CP '*2'.
      lv_importance = '1'.
    ELSEIF lv_msgno CP '*5*'.
      lv_importance = '2'.
    ELSE.
      lv_importance = '3'.
    ENDIF.

    MESSAGE ID ls_msg-msgid TYPE ls_msg-msgty NUMBER ls_msg-msgno
             INTO lv_msg.

    logger->add( importance = lv_importance ).

    "   exit when end number is reached
    lv_msgno = lv_msgno + 1.
    IF lv_msgno >= 332.
      EXIT.
    ENDIF.

  ENDDO.

ENDFORM.
