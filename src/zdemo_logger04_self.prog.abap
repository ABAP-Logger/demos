*&---------------------------------------------------------------------*
*& Report zdemo_logger04_self
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_logger04_self MESSAGE-ID bl.
DATA:
  logger     TYPE REF TO zif_logger,
  my_profile TYPE REF TO zif_logger_display_profile.

PARAMETERS p_grid   AS CHECKBOX DEFAULT 'X'.

START-OF-SELECTION.

  PERFORM logs_create.

  IF logger->is_empty( ) = abap_false.
    logger->popup( my_profile->get( ) ).
  ENDIF.

FORM logs_create.

  DATA:
    ls_context    TYPE bal_s_ex01,
    lv_importance TYPE balprobcl,
    ls_msg        TYPE bal_s_msg,
    lv_msgno      TYPE symsgno,
    lv_msg        TYPE string,
    lv_rem        TYPE i.

  logger =
    zcl_logger_factory=>create_log(
      object = ''
      subobject = ''
      desc = 'Application Log Demo'
      settings  = zcl_logger_factory=>create_settings(
*     )->set_expiry_date( lv_expire
      )->set_autosave( abap_false
      )->set_must_be_kept_until_expiry( abap_true
                                     ) ).

  PERFORM display_profile_self.

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


    lv_rem = lv_msgno MOD 2.
    IF lv_rem  = 0.
      ls_context-carrid = 'SF'.
    ELSE.
      ls_context-carrid = 'AI'.
    ENDIF.

    ls_context-connid = lv_importance.
    ls_context-fldate = sy-datum + lv_importance.
    ls_context-id = lv_importance + 1000.

    logger->add( context    = ls_context
                 importance = lv_importance ).

*   exit when end number is reached
    lv_msgno = lv_msgno + 1.
    IF lv_msgno >= 332.
      EXIT.
    ENDIF.

  ENDDO.

ENDFORM.

FORM display_profile_self.
  DATA:
    lt_lev1_fcat TYPE bal_t_fcat,
    lt_lev2_fcat TYPE bal_t_fcat,
    lt_lev3_fcat TYPE bal_t_fcat,
    ls_fcat   TYPE bal_s_fcat.

  "create display profile
  my_profile = zcl_logger_factory=>create_display_profile( i_no_tree = 'X' )->set_grid( p_grid ).
  TRY.
      my_profile->set_context_message( 'BAL_S_EX01' ).
      my_profile->set_value( i_fld = 'TITLE'
                             i_val = 'Application Log:Self defined display profile' ).
      my_profile->set_value( i_fld = 'HEAD_TEXT'
                             i_val = 'Application.Log.Demo' ).
      my_profile->set_value( i_fld = 'TREE_SIZE'
                             i_val = 28 ).
      my_profile->set_value( i_fld = 'HEAD_SIZE'
                             i_val = 47 ).
      my_profile->set_value( i_fld = 'EXP_LEVEL'
                             i_val = 1 ).
      my_profile->set_value( i_fld = 'CWIDTH_OPT'
                             i_val = 'X' ).
      my_profile->set_value( i_fld = 'MESS_MARK'
                             i_val = 'X' ).
      my_profile->set_value( i_fld = 'SHOW_ALL'
                             i_val = 'X' ).


      "Level 1 level1 fields
      CLEAR ls_fcat.
      ls_fcat-ref_table = 'BAL_S_SHOW'.
      ls_fcat-ref_field = 'EXTNUMBER'.
      ls_fcat-outputlen  = 40.
      APPEND ls_fcat TO lt_lev1_fcat.

      CLEAR ls_fcat.
      ls_fcat-ref_table = 'BAL_S_EX01'.
      ls_fcat-ref_field = 'CARRID'.
      ls_fcat-outputlen  = 3.
      APPEND ls_fcat TO lt_lev2_fcat.

      CLEAR ls_fcat.
      ls_fcat-ref_table = 'BAL_S_EX01'.
      ls_fcat-ref_field = 'CONNID'.
      ls_fcat-outputlen  = 4.
      APPEND ls_fcat TO lt_lev3_fcat.

      CLEAR ls_fcat.
      ls_fcat-ref_table = 'BAL_S_EX01'.
      ls_fcat-ref_field = 'ID'.
      ls_fcat-outputlen  = 8.
      APPEND ls_fcat TO lt_lev3_fcat.

      my_profile->set_value( i_fld = 'LEV1_FCAT'
                             i_val = lt_lev1_fcat ).
      my_profile->set_value( i_fld = 'LEV2_FCAT'
                             i_val = lt_lev2_fcat ).
      my_profile->set_value( i_fld = 'LEV3_FCAT'
                             i_val = lt_lev3_fcat ).
    CATCH zcx_logger_display_profile INTO DATA(lx_error).
      logger->e( lx_error->get_text( ) ).
  ENDTRY.

ENDFORM.
