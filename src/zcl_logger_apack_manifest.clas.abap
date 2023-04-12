class ZCL_LOGGER_APACK_MANIFEST definition
  public
  final
  create public .

public section.

  interfaces ZIF_APACK_MANIFEST .

  methods CONSTRUCTOR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_LOGGER_APACK_MANIFEST IMPLEMENTATION.


  METHOD constructor.
    zif_apack_manifest~descriptor-group_id        = 'github.com/ABAP-logger'.
    zif_apack_manifest~descriptor-artifact_id     = 'ABAP-Logger-demos'.
    zif_apack_manifest~descriptor-version         = '0.1'.
    zif_apack_manifest~descriptor-git_url         = 'https://github.com/ABAP-Logger/demos'.
    zif_apack_manifest~descriptor-dependencies    = VALUE #(
      ( group_id    = 'github.com/ABAP-logger'
        artifact_id = 'ABAP-Logger'
        git_url     = 'https://github.com/ABAP-logger' ) ).
    zif_apack_manifest~descriptor-repository_type = ``.
  ENDMETHOD.
ENDCLASS.
