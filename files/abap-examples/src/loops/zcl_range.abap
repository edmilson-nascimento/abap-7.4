CLASS zcl_range DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      define_ranges,
      use_ranges.

  PRIVATE SECTION.
    TYPES: 
      BEGIN OF ty_range,
        sign   TYPE c LENGTH 1,
        option TYPE c LENGTH 2,
        low    TYPE i,
        high   TYPE i,
      END OF ty_range,
      tt_range TYPE STANDARD TABLE OF ty_range WITH DEFAULT KEY.

ENDCLASS.

CLASS zcl_range IMPLEMENTATION.

  METHOD define_ranges.
    DATA lt_ranges TYPE tt_range.

    " Define ranges
    APPEND VALUE #( sign = 'I' option = 'EQ' low = 1 high = 10 ) TO lt_ranges.
    APPEND VALUE #( sign = 'I' option = 'BT' low = 20 high = 30 ) TO lt_ranges.
    APPEND VALUE #( sign = 'E' option = 'EQ' low = 15 high = 15 ) TO lt_ranges.

    " Output the defined ranges
    LOOP AT lt_ranges INTO DATA(ls_range).
      WRITE: / 'Sign:', ls_range-sign, 'Option:', ls_range-option, 
             'Low:', ls_range-low, 'High:', ls_range-high.
    ENDLOOP.
  ENDMETHOD.

  METHOD use_ranges.
    DATA lt_data TYPE TABLE OF i.
    DATA lt_ranges TYPE tt_range.

    " Sample data
    APPEND 5 TO lt_data.
    APPEND 15 TO lt_data.
    APPEND 25 TO lt_data.
    APPEND 35 TO lt_data.

    " Define ranges
    APPEND VALUE #( sign = 'I' option = 'EQ' low = 10 high = 10 ) TO lt_ranges.
    APPEND VALUE #( sign = 'I' option = 'BT' low = 20 high = 30 ) TO lt_ranges.

    " Check data against ranges
    LOOP AT lt_data INTO DATA(lv_value).
      LOOP AT lt_ranges INTO DATA(ls_range).
        IF ( ls_range-sign = 'I' AND ls_range-option = 'EQ' AND lv_value = ls_range-low ) OR
           ( ls_range-sign = 'I' AND ls_range-option = 'BT' AND lv_value BETWEEN ls_range-low AND ls_range-high ).
          WRITE: / 'Value', lv_value, 'is within range:', ls_range-low, 'to', ls_range-high.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.