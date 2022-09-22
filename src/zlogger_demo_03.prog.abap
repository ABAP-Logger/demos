REPORT zlogger_demo_03.

"Create logger
DATA(my_logger) = zcl_logger_factory=>create_log( desc = 'ABAP Logger Demo 03' ) ##no_text.

"create display profile
DATA(my_profile) = zcl_logger_factory=>create_display_profile( )->set_grid( abap_true ).
TRY.
    my_profile->set_value( i_fld = 'SHOW_ALL' i_val = abap_true ).
    my_profile->set_value( i_fld = 'NONSENSE' i_val = 'Does not matter' ) ##no_text.
  CATCH zcx_logger_display_profile INTO DATA(error).
    my_logger->E( error->get_text( ) ).
ENDTRY.


"put some messages
my_logger->i( 'program start' ) ##no_text.
my_logger->w( 'This is a warning' ) ##no_text.
my_logger->s( 'Everything ok at the end' ) ##no_text.
my_logger->s( 'Lo saved. See transaction SLG1' ) ##no_text.

"Display messages in popup
my_logger->popup( my_profile->get( ) ).
