REPORT zlogger_demo_07.

PARAMETERS info1 TYPE c LENGTH 70 DEFAULT TEXT-001 MODIF ID dsp. "Press ENTER to display log
PARAMETERS info2 TYPE c LENGTH 70 DEFAULT TEXT-002 MODIF ID dsp. "Press ENTER again to refresh log

INITIALIZATION.

  "create docking container
  DATA docker TYPE REF TO cl_gui_docking_container.

  CREATE OBJECT docker
    EXPORTING
      no_autodef_progid_dynnr = abap_true
      ratio                   = 80
      side                    = cl_gui_docking_container=>dock_at_bottom.

  "create display profile
  DATA my_profile TYPE REF TO zif_logger_display_profile.

  my_profile = zcl_logger_factory=>create_display_profile(
                 i_single_log  = abap_true )->set_grid( abap_true ).

  "Create logger
  DATA my_logger TYPE REF TO zif_logger.

  my_logger = zcl_logger_factory=>create_log( desc = 'ABAP Logger Demo 07' ).

AT SELECTION-SCREEN OUTPUT.

  "hide parameters (for information only)
  LOOP AT SCREEN.
    IF screen-group1 = 'DSP'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

AT SELECTION-SCREEN.

  "put some messages
  my_logger->w( obj_to_log = 'demonstration warning' ).
  my_logger->e( obj_to_log = 'demonstration error' ).
  my_logger->s( obj_to_log = 'demonstration success' ).

  "Display messages in container
  my_logger->display_in_container(
    container = docker
    profile   = my_profile->get( ) ).
