REPORT zlogger_demo_02.

"create settings
DATA(my_settings) = zcl_logger_factory=>create_settings( ).
my_settings->set_expiry_date( sy-datum )->set_autosave( abap_false ).

"Create logger
DATA(my_logger) = zcl_logger_factory=>create_log(
                    desc      = 'ABAP Logger Demo 02'
                    settings  = my_settings ) ##no_text.

"put some messages
my_logger->i( 'program start' ) ##no_text.
my_logger->w( 'First warning...' ) ##no_text.

"Display messages in popup
my_logger->popup( ).
