CLASS zcl_logger_demo_manifest DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_apack_manifest.

    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_logger_demo_manifest IMPLEMENTATION.


  METHOD constructor.

    DATA dep TYPE if_apack_manifest=>ty_dependency.

    dep-group_id    = 'github.com/ABAP-Logger'.
    dep-artifact_id = 'ABAP-Logger'.
    dep-version     = '1.0.0'.
    dep-git_url     = 'https://github.com/ABAP-Logger/ABAP-Logger'.

    if_apack_manifest~descriptor-group_id        = 'github.com/ABAP-Logger'.
    if_apack_manifest~descriptor-artifact_id     = 'ABAP-Logger-demos'.
    if_apack_manifest~descriptor-version         = '1.0.0'.
    if_apack_manifest~descriptor-git_url         = 'https://github.com/ABAP-Logger/demos'.
    APPEND dep TO if_apack_manifest~descriptor-dependencies.

  ENDMETHOD.
ENDCLASS.
