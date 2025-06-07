CLASS zcl_let DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS demonstrate_let_expression.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_let IMPLEMENTATION.

  METHOD demonstrate_let_expression.
    DATA: lt_data TYPE TABLE OF string,
          lv_result TYPE string.

    lt_data = VALUE #( ( 'Apple' ) ( 'Banana' ) ( 'Cherry' ) ).

    lv_result = REDUCE string( INIT lv_string = ''
                                FOR lv_item IN lt_data
                                NEXT lv_string = COND #( WHEN lv_string IS INITIAL THEN lv_item
                                                          ELSE lv_string && ', ' && lv_item ) ).

    WRITE: / 'Fruits:', lv_result.
  ENDMETHOD.

ENDCLASS.