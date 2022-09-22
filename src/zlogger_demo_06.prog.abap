REPORT zlogger_demo_06.

"I am not sure if the callback routine is working properly.


INCLUDE sbal_constants.

"create display profile
DATA(my_profile) = zcl_logger_factory=>create_display_profile(
               i_single_log  = abap_true )->set_grid( abap_true ).

"create settings
DATA(my_settings) = zcl_logger_factory=>create_settings( ).
my_settings->set_expiry_date( sy-datum )->set_autosave( abap_false ).

"Create logger (autosave and 2nd DB connection is default)
DATA(my_logger) = zcl_logger_factory=>create_log(
                    desc      = 'ABAP Logger Demo 06'
                    settings = zcl_logger_factory=>create_settings( ) ) ##no_text.

"put a message with details
my_logger->i(
  obj_to_log    = 'Message with detail'
  callback_fm   = const_callback_form
  callback_form = 'CALLBACK_DETAIL'
  callback_prog = sy-repid ) ##no_text.


my_logger->popup( my_profile->get( ) ).


FORM callback_detail                                        "#EC CALLED
       TABLES t_params STRUCTURE spar.

  cl_demo_output=>display_data( t_params[] ).

ENDFORM.
