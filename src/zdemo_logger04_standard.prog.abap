*&---------------------------------------------------------------------*
*& Report ZDEMO_LOGGER04_STANDARD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_logger04_standard MESSAGE-ID bl.
DATA:
  logger     TYPE REF TO zif_logger,
  my_profile TYPE REF TO zif_logger_display_profile.

START-OF-SELECTION.
  DATA(log_collection) = zcl_logger_factory=>create_collection( ).

  PERFORM logs_create USING 'Log Demo : JONES'.
  PERFORM logs_create USING 'Log Demo : SMITH'.
  PERFORM logs_create USING 'Log Demo : MEYER'.

  IF logger->is_empty( ) = abap_false.
    log_collection->display_logs_using_profile( my_profile->get( ) ).
  ENDIF.

FORM logs_create
    USING desc.
  DATA:
    ls_context    TYPE bal_s_ex01,
    lv_importance TYPE balprobcl,
    ls_msg        TYPE bal_s_msg,
    lv_msgno      TYPE symsgno,
    lv_msg        TYPE string.

  logger =
    zcl_logger_factory=>create_log( object = 'ABAPUNIT'
                                    subobject = 'LOGGER'
                                    desc = desc
                                    settings  = zcl_logger_factory=>create_settings( )->set_autosave( abap_false
                                                                                      )->set_must_be_kept_until_expiry( abap_true ) ).


  "create display profile
  my_profile = zcl_logger_factory=>create_display_profile( i_standard  = 'X' ).

  my_profile->set_grid( abap_true ).
  my_profile->set_context_message( 'BAL_S_EX01' ).
  my_profile->set_value( i_fld = 'EXP_LEVEL'
                         i_val = 0 ).
  my_profile->set_value( i_fld = 'CWIDTH_OPT'
                         i_val = 'X' ).
  my_profile->set_value( i_fld = 'MESS_MARK'
                         i_val = 'X' ).
  my_profile->set_value( i_fld = 'SHOW_ALL'
                         i_val = 'X' ).

  lv_msgno = 301.
  DO.
    ls_msg-msgid = 'BL'.
    ls_msg-msgno = lv_msgno.

*   derive message type
    IF lv_msgno CP '*4'.
      ls_msg-msgty = 'E'.
    ELSEIF lv_msgno CP '*2*'.
      ls_msg-msgty = 'W'.
    ELSE.
      ls_msg-msgty = 'S'.
    ENDIF.

*   derive message type
    IF lv_msgno CP '*2'.
      lv_importance = '1'.
    ELSEIF lv_msgno CP '*5*'.
      lv_importance = '2'.
    ELSE.
      lv_importance = '3'.
    ENDIF.

    MESSAGE ID ls_msg-msgid TYPE ls_msg-msgty NUMBER ls_msg-msgno
             INTO lv_msg.

    "Airline
    ls_context-carrid = 'SF'.
    "Connection number
    ls_context-connid = 3.
    "Flight Date
    ls_context-fldate = sy-datum + lv_msgno.
    "customer
    ls_context-id = lv_msgno + 1000.

    logger->add( context    = ls_context
                 importance = lv_importance ).

    " exit when end number is reached
    lv_msgno = lv_msgno + 1.
    IF lv_msgno >= 332.
      EXIT.
    ENDIF.

  ENDDO.

  log_collection->add_logger( logger ).

ENDFORM.
