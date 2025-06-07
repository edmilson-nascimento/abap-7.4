CLASS zcl_diff_sorted DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      compare_tables
        IMPORTING
          VALUE(it_table1) TYPE STANDARD TABLE
          VALUE(it_table2) TYPE STANDARD TABLE
        RETURNING
          VALUE(rt_diff) TYPE STANDARD TABLE.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_diff_sorted IMPLEMENTATION.

  METHOD compare_tables.
    DATA: lt_diff TYPE STANDARD TABLE OF data_element_type, " Replace with actual data type
          lt_table1 TYPE SORTED TABLE OF data_element_type WITH UNIQUE KEY field_name, " Replace with actual data type and field name
          lt_table2 TYPE SORTED TABLE OF data_element_type WITH UNIQUE KEY field_name. " Replace with actual data type and field name

    " Fill sorted tables
    lt_table1 = it_table1.
    lt_table2 = it_table2.

    " Find differences
    LOOP AT lt_table1 INTO DATA(ls_entry1).
      IF NOT line_exists( lt_table2[ field_name = ls_entry1-field_name ] ). " Replace with actual field name
        APPEND ls_entry1 TO lt_diff.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_table2 INTO DATA(ls_entry2).
      IF NOT line_exists( lt_table1[ field_name = ls_entry2-field_name ] ). " Replace with actual field name
        APPEND ls_entry2 TO lt_diff.
      ENDIF.
    ENDLOOP.

    rt_diff = lt_diff.
  ENDMETHOD.

ENDCLASS.