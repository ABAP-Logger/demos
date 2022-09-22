REPORT zlogger_demo_01.

"Create logger
DATA(my_logger) = zcl_logger_factory=>create_log( desc = 'ABAP Logger Demo 01' )  ##no_text.

"put some messages
my_logger->i( 'program start' ) ##no_text.
my_logger->w( 'First warning...' ) ##no_text.
my_logger->s( 'Log saved. See transaction SLG1' ) ##no_text.

"Display messages in popup
my_logger->popup( ).
