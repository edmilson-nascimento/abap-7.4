CLASS zcl_reduce DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      reduce_example.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_reduce IMPLEMENTATION.

  METHOD reduce_example.
    DATA: lt_data TYPE TABLE OF i,
          lv_sum  TYPE i.

    " Fill the internal table with some example data
    lt_data = VALUE #( ( 1 ) ( 2 ) ( 3 ) ( 4 ) ( 5 ) ).

    " Use REDUCE to sum the values in the internal table
    lv_sum = REDUCE i( INIT sum = 0
                       FOR value IN lt_data
                       NEXT sum = sum + value ).

    " Output the result
    WRITE: / 'The sum of the values is:', lv_sum.
  ENDMETHOD.

ENDCLASS.