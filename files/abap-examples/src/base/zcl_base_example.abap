CLASS zcl_base_example DEFINITION
  INHERITING FROM cl_abap_object
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      display_message
        IMPORTING
          !message TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_base_example IMPLEMENTATION.

  METHOD display_message.
    WRITE: / message.
  ENDMETHOD.

ENDCLASS.