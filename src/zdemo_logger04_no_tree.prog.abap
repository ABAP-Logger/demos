*&---------------------------------------------------------------------*
*& Report zdemo_logger04_no_tree
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_logger04_no_tree MESSAGE-ID bl.
DATA:
  logger     TYPE REF TO zif_logger,
  my_profile TYPE REF TO zif_logger_display_profile.

START-OF-SELECTION.

  PERFORM logs_create.

  IF logger->is_empty( ) = abap_false.
    logger->popup( my_profile->get( ) ).
  ENDIF.

FORM logs_create.

  DATA:
    ls_context    TYPE bal_s_ex01,
    ls_importance TYPE balprobcl,
    ls_msg        TYPE bal_s_msg,
    lv_msgno      TYPE symsgno,
    lv_msg        TYPE string.

  logger = zcl_logger_factory=>create_log( object    = 'ABAPUNIT'
                                           subobject = 'LOGGER'
                                           desc      = 'Application Log Demo'
                                           settings  = zcl_logger_factory=>create_settings(
*                                              )->set_expiry_date( lv_expire
                                              )->set_autosave( abap_false
                                              )->set_must_be_kept_until_expiry( abap_true
                                              ) ).

  "create display profile
  my_profile = zcl_logger_factory=>create_display_profile( i_no_tree = 'X' )->set_grid( abap_true ).
  TRY.
      my_profile->set_value( i_fld = 'SHOW_ALL'
                             i_val = abap_true ).
      my_profile->set_context( 'BAL_S_EX01' ).
      my_profile->set_value( i_fld = 'EXP_LEVEL'
                             i_val = 0 ).

    CATCH zcx_logger_display_profile INTO DATA(lv_error).
      logger->e( lv_error->get_text( ) ).
  ENDTRY.


  lv_msgno = '301'.
  DO.
    ls_msg-msgid = 'BL'.
    ls_msg-msgno = lv_msgno.

    "derive message type
    IF lv_msgno CP '*4'.
      ls_msg-msgty = 'E'.
    ELSEIF lv_msgno CP '*2*'.
      ls_msg-msgty = 'W'.
    ELSE.
      ls_msg-msgty = 'S'.
    ENDIF.

    "derive message type
    IF lv_msgno CP '*2'.
      ls_importance = '1'.
    ELSEIF lv_msgno CP '*5*'.
      ls_importance = '2'.
    ELSE.
      ls_importance = '3'.
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
                 importance = ls_importance ).

    " exit when end number is reached
    lv_msgno = lv_msgno + 1.
    IF lv_msgno >= 332.
      EXIT.
    ENDIF.

  ENDDO.


ENDFORM.
