REPORT zlogger_demo_04.

PARAMETERS p_notree RADIOBUTTON GROUP dis DEFAULT 'X'.
PARAMETERS p_cxtree RADIOBUTTON GROUP dis.
PARAMETERS p_cxlev2 RADIOBUTTON GROUP dis.

"create display profile
DATA(my_profile) = zcl_logger_factory=>create_display_profile(
               i_single_log  = abap_true )->set_grid( abap_true ).
my_profile->set_context_message( 'ZLOGGER_DEMO_03_CONTEXT_S' ).
CASE 'X'.
  WHEN p_notree.
  WHEN p_cxtree.
    my_profile->set_context_tree( 'ZLOGGER_DEMO_03_CONTEXT_S' ).
  WHEN p_cxlev2.
    my_profile->set_context_tree(
      i_context_structure = 'ZLOGGER_DEMO_03_CONTEXT_S'
      i_under_log         = abap_true ).
ENDCASE.

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
