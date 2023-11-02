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

    DATA dep TYPE if_apack_manifest=>ty_dependency.

    dep-group_id    = 'github.com/ABAP-Logger'.
    dep-artifact_id = 'ABAP-Logger'.
    dep-git_url     = 'https://github.com/ABAP-Logger/ABAP-Logger'.

    if_apack_manifest~descriptor-group_id        = 'github.com/ABAP-Logger'.
    if_apack_manifest~descriptor-artifact_id     = 'ABAP-Logger-demos'.
    if_apack_manifest~descriptor-version         = '0.1'.
    if_apack_manifest~descriptor-git_url         = 'https://github.com/ABAP-Logger/demos'.
    APPEND dep TO if_apack_manifest~descriptor-dependencies.
    if_apack_manifest~descriptor-repository_type = ``.
  ENDMETHOD.
ENDCLASS.
