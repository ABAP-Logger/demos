*&---------------------------------------------------------------------*
*& Report zdemo_logger04_self
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_logger04_self MESSAGE-ID bl.

DATA logger TYPE REF TO zif_logger.

PARAMETERS p_grid AS CHECKBOX DEFAULT space.

START-OF-SELECTION.

  PERFORM logs_create.

END-OF-SELECTION.

  IF logger->is_empty( ) = abap_false.
    logger->fullscreen( ).
  ENDIF.

FORM logs_create.
  DATA:
    ls_context         TYPE bal_s_ex01,
    ls_display_profile TYPE bal_s_prof,
    ls_fcat            TYPE bal_s_fcat,
    ls_importance      TYPE balprobcl,
    ls_msg             TYPE bal_s_msg,
    lv_msgno           TYPE symsgno,
    lv_msg             TYPE string.

  ls_display_profile-title     = 'Application Log:Self defined display profile'.
  ls_display_profile-use_grid = p_grid.
  ls_display_profile-head_text = 'Application.Log.Demo'.
  ls_display_profile-head_size = 47.
  ls_display_profile-tree_size = 28.
  ls_display_profile-disvariant-report = sy-repid.
  ls_display_profile-disvariant-handle = 'LOG'.
  ls_display_profile-show_all = 'X'.

  "Level 1 can create method to added level1 fields
  CLEAR ls_fcat.
  ls_fcat-ref_table = 'BAL_S_SHOW'.
  ls_fcat-ref_field = 'EXTNUMBER'.
  ls_fcat-outputlen  = 40.
  APPEND ls_fcat TO ls_display_profile-lev1_fcat.

  CLEAR ls_fcat.
  ls_fcat-ref_table = 'BAL_S_EX01'.
  ls_fcat-ref_field = 'CARRID'.
  ls_fcat-outputlen  = 3.
  APPEND ls_fcat TO ls_display_profile-lev2_fcat.

  CLEAR ls_fcat.
  ls_fcat-ref_table = 'BAL_S_EX01'.
  ls_fcat-ref_field = 'CONNID'.
  ls_fcat-outputlen  = 4.
  APPEND ls_fcat TO ls_display_profile-lev2_fcat.

  CLEAR ls_fcat.
  ls_fcat-ref_table = 'BAL_S_EX01'.
  ls_fcat-ref_field = 'ID'.
  ls_fcat-outputlen  = 8.
  APPEND ls_fcat TO ls_display_profile-lev3_fcat.

  DATA(lv_self_defined) = zcl_logger_settings=>display_profile_names-self_defined.

  DATA(lo_log_settings) =
    zcl_logger_factory=>create_settings(
*                                       )->set_expiry_date( lv_expire
                                         )->set_autosave( abap_false
                                         )->set_must_be_kept_until_expiry( abap_true
                                         )->set_display_profile( i_display_profile = ls_display_profile
                                                                 i_profile_name    = lv_self_defined ).
*                                                              i_context = ls_context

  logger =
    zcl_logger_factory=>create_log( object    = 'ABAPUNIT'
                                    subobject = 'LOGGER'
                                    desc      = 'Application Log Demo'
                                    settings  = lo_log_settings ).

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

    IF lv_msgno MOD 2 = 0.
      "Airline
      ls_context-carrid = 'SF'.
    ELSE.
      ls_context-carrid = 'AI'.
    ENDIF.

    "Connection number
    ls_context-connid = ls_importance.
    "Flight Date
    ls_context-fldate = sy-datum + ls_importance.
    "customer
    ls_context-id = ls_importance + 1000.

    logger->add( context    = ls_context
                 importance = ls_importance ).

    "exit when end number is reached
    lv_msgno = lv_msgno + 1.
    IF lv_msgno >= 332.
      EXIT.
    ENDIF.

  ENDDO.

ENDFORM.
