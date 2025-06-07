CLASS zcl_collect DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      collect_data
        IMPORTING
          VALUE(it_data) TYPE STANDARD TABLE OF ty_data
        EXPORTING
          VALUE(et_result) TYPE STANDARD TABLE OF ty_result.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_data,
        key   TYPE string,
        value TYPE i,
      END OF ty_data,
      ty_result TYPE STANDARD TABLE OF ty_data WITH DEFAULT KEY.

ENDCLASS.

CLASS zcl_collect IMPLEMENTATION.

  METHOD collect_data.
    DATA: lt_temp TYPE ty_result.

    LOOP AT it_data INTO DATA(ls_data).
      " Use COLLECT to aggregate data based on the key
      COLLECT ls_data INTO lt_temp.
    ENDLOOP.

    et_result = lt_temp.
  ENDMETHOD.

ENDCLASS.