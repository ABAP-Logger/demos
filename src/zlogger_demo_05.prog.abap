REPORT zlogger_demo_05.


"create display profile
DATA my_profile TYPE REF TO zif_logger_display_profile.
my_profile = zcl_logger_factory=>create_display_profile(
               i_single_log  = abap_true )->set_grid( abap_true ).

"Create logger (autosave and 2nd DB connection is default)
DATA my_logger TYPE REF TO zif_logger.
my_logger = zcl_logger_factory=>create_log(
                    object    = 'BCT2'
                    subobject = 'ALPHA'
                    desc      = 'ABAP Logger Demo 05'
                    settings = zcl_logger_factory=>create_settings( ) ) ##no_text.

"put some messages
my_logger->i( obj_to_log = 'program start' ) ##no_text.
my_logger->i( obj_to_log = 'I do some database updates...' ) ##no_Text.
my_logger->w( obj_to_log = 'Initiate rollback.' ) ##no_text.
ROLLBACK WORK.
my_logger->w( obj_to_log = 'Rollback done.' ) ##no_text.
my_logger->s( obj_to_log = 'Log saved.' ) ##no_text.


"Display messages in popup
DATA my_saved_log TYPE REF TO zcl_logger.
my_saved_log = zcl_logger=>open(
    object                   = 'BCT2'
    subobject                = 'ALPHA'
    desc                     = 'ABAP Logger Demo 05' ) ##no_text.
IF my_saved_log IS BOUND.
  my_saved_log->popup( my_profile->get( ) ).
ENDIF.
