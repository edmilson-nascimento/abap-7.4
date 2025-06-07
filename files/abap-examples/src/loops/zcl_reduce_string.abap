CLASS zcl_reduce_string DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      reduce_string_example.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_reduce_string IMPLEMENTATION.

  METHOD reduce_string_example.
    DATA: lt_strings TYPE TABLE OF string,
          lv_result  TYPE string.

    " Sample data
    lt_strings = VALUE #( 'Hello' 'World' 'ABAP' 'Programming' ).

    " Reduce strings into a single string
    lv_result = REDUCE string(
      INIT result TYPE string
      FOR lv_string IN lt_strings
      NEXT result = result && lv_string ).

    " Output the result
    WRITE: / 'Reduced String:', lv_result.
  ENDMETHOD.

ENDCLASS.