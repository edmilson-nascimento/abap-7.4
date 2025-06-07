CLASS zcl_loop DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      demonstrate_loops.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_loop IMPLEMENTATION.

  METHOD demonstrate_loops.
    DATA: lt_data TYPE TABLE OF i,
          lv_sum  TYPE i.

    " Fill the internal table with some values
    APPEND 1 TO lt_data.
    APPEND 2 TO lt_data.
    APPEND 3 TO lt_data.
    APPEND 4 TO lt_data.
    APPEND 5 TO lt_data.

    " Loop through the internal table and calculate the sum
    LOOP AT lt_data INTO DATA(lv_value).
      lv_sum = lv_sum + lv_value.
    ENDLOOP.

    " Output the result
    WRITE: / 'The sum of the values is:', lv_sum.
  ENDMETHOD.

ENDCLASS.