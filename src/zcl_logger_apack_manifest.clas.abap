CLASS zcl_logger_apack_manifest DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apack_manifest .

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LOGGER_APACK_MANIFEST IMPLEMENTATION.


  METHOD constructor.
    if_apack_manifest~descriptor-group_id        = 'github.com/ABAP-logger'.
    if_apack_manifest~descriptor-artifact_id     = 'ABAP-Logger-demos'.
    if_apack_manifest~descriptor-version         = '0.1'.
    if_apack_manifest~descriptor-git_url         = 'https://github.com/ABAP-Logger/demos'.
    if_apack_manifest~descriptor-dependencies    = VALUE #(
      ( group_id    = 'github.com/ABAP-logger'
        artifact_id = 'ABAP-Logger'
        git_url     = 'https://github.com/ABAP-logger' ) ).
    if_apack_manifest~descriptor-repository_type = ``.
  ENDMETHOD.
ENDCLASS.
