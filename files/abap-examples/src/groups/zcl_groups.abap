CLASS zcl_groups DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      group_data
        IMPORTING
          VALUE(it_data) TYPE STANDARD TABLE OF string
        RETURNING
          VALUE(rt_grouped) TYPE STANDARD TABLE OF string.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_groups IMPLEMENTATION.

  METHOD group_data.
    DATA: lt_grouped TYPE STANDARD TABLE OF string,
          lv_current TYPE string,
          lv_count   TYPE i.

    SORT it_data.
    DELETE ADJACENT DUPLICATES FROM it_data.

    LOOP AT it_data INTO lv_current.
      lv_count = 0.
      LOOP AT it_data INTO DATA(lv_item) WHERE lv_item = lv_current.
        lv_count = lv_count + 1.
      ENDLOOP.
      APPEND |{ lv_current } - { lv_count }| TO lt_grouped.
    ENDLOOP.

    rt_grouped = lt_grouped.
  ENDMETHOD.

ENDCLASS.