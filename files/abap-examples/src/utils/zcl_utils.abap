CLASS zcl_utils DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      log_message IMPORTING iv_message TYPE string,
      handle_error IMPORTING iv_error_message TYPE string.

  PRIVATE SECTION.
    CONSTANTS: c_log_prefix TYPE string VALUE 'LOG: '.
ENDCLASS.

CLASS zcl_utils IMPLEMENTATION.

  METHOD log_message.
    WRITE: / c_log_prefix, iv_message.
  ENDMETHOD.

  METHOD handle_error.
    WRITE: / 'ERROR:', iv_error_message.
  ENDMETHOD.

ENDCLASS.