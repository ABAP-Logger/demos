REPORT zlogger_demo_04.


"create display profile
DATA(my_profile) = zcl_logger_factory=>create_display_profile(
               i_single_log  = abap_true )->set_grid( abap_true ).
my_profile->set_context( 'ZLOGGER_DEMO_03_CONTEXT_S' ).
my_profile->set_value(
    i_fld = 'EXP_LEVEL'
    i_val = 0 ).
"Create logger
DATA(my_logger) = zcl_logger_factory=>create_log( desc = 'ABAP Logger Demo 04' ) ##no_text.

"put some messages
my_logger->i( obj_to_log = 'program start' context = VALUE zlogger_demo_03_context_s( docno = '0000012345' ) ) ##no_text.
DATA(posnr) = 10.
DO 10 TIMES.
  my_logger->i( obj_to_log = 'item check start' context = VALUE zlogger_demo_03_context_s( docno = '0000012345' itmno = posnr ) ) ##no_text.
  CASE sy-index MOD 2.
    WHEN 0.
      my_logger->w( obj_to_log = 'item check contains warnings' context = VALUE zlogger_demo_03_context_s( docno = '0000012345' itmno = posnr ) ) ##no_text.
    WHEN 1.
      my_logger->e( obj_to_log = 'item check failed' context = VALUE zlogger_demo_03_context_s( docno = '0000012345' itmno = posnr ) ) ##no_text.
    WHEN 2.
      my_logger->s( obj_to_log = 'item check failed' context = VALUE zlogger_demo_03_context_s( docno = '0000012345' itmno = posnr ) ) ##no_text.

  ENDCASE.
  posnr = posnr + 10.
ENDDO.

"Display messages in popup
my_logger->popup( my_profile->get( ) ).
