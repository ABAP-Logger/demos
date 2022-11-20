*&---------------------------------------------------------------------*
*& Report ZDEMO_LOGGER04_STANDARD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_logger04_standard MESSAGE-ID bl.
DATA :
  logger     TYPE REF TO zif_logger,
  my_profile TYPE REF TO zif_logger_display_profile.

START-OF-SELECTION.
  DATA(log_collection) = zcl_logger_factory=>create_collection( ).

  PERFORM logs_create USING 'Log Demo : JONES'.
  PERFORM logs_create USING 'Log Demo : SMITH'.
  PERFORM logs_create USING 'Log Demo : MEYER'.

IF logger->is_empty( ) EQ abap_false.
*  logger->popup( my_profile->get( ) ).
  log_collection->display_logs_using_profile( my_profile->get( ) ).
ENDIF.

FORM logs_create
  USING desc.
  DATA:
    ls_context           TYPE bal_s_ex01.

  logger = zcl_logger_factory=>create_log(
            object = 'ABAPUNIT'
            subobject = 'LOGGER'
            desc = desc "
            settings  = zcl_logger_factory=>create_settings(
               )->set_autosave( abap_false
               )->set_must_be_kept_until_expiry( abap_true ) ).


  "create display profile
  my_profile = zcl_logger_factory=>create_display_profile(
*I_DETLEVEL = 'X'
*I_NO_TREE = 'X'
*I_POPUP
*I_SINGLE_LOG = 'X'
i_standard  = 'X'
).

  my_profile->set_grid( abap_true ).
  my_profile->set_context( 'BAL_S_EX01' ).
  my_profile->set_value( i_fld = 'EXP_LEVEL' i_val = 0 ).
  my_profile->set_value( i_fld = 'CWIDTH_OPT' i_val = 'X' ).
  my_profile->set_value( i_fld = 'MESS_MARK' i_val = 'X' ).
  my_profile->set_value( i_fld = 'SHOW_ALL' i_val = 'X' ).

  DATA :
    importance TYPE balprobcl,
    l_s_msg    TYPE bal_s_msg,
    l_msgno    TYPE symsgno,
    lv_msg     TYPE string.

  l_msgno = 301.
  DO.
    l_s_msg-msgid = 'BL'.
    l_s_msg-msgno = l_msgno.

*   derive message type
    IF l_msgno CP '*4'.
      l_s_msg-msgty = 'E'.
    ELSEIF l_msgno CP '*2*'.
      l_s_msg-msgty = 'W'.
    ELSE.
      l_s_msg-msgty = 'S'.
    ENDIF.

*   derive message type
    IF l_msgno CP '*2'.
      importance = '1'.
    ELSEIF l_msgno CP '*5*'.
      importance = '2'.
    ELSE.
      importance = '3'.
    ENDIF.

    MESSAGE ID l_s_msg-msgid TYPE l_s_msg-msgty NUMBER l_s_msg-msgno
             INTO lv_msg.

    ls_context-carrid = 'SF'. "Airline
    ls_context-connid = 3. "Connection number
    ls_context-fldate = sy-datum + l_msgno. "Flight Date
    ls_context-id = l_msgno + 1000 ."customer

    logger->add( context = ls_context
                 importance = importance
                 ).

*   exit when end number is reached
    ADD 1 TO l_msgno.
    IF l_msgno >= 332.
      EXIT.
    ENDIF.

  ENDDO.

  log_collection->add_logger( logger =  logger ).

ENDFORM.
