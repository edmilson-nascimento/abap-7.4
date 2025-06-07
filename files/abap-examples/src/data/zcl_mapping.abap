CLASS zcl_mapping DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      map_data
        IMPORTING
          VALUE(it_source) TYPE TABLE OF ty_source
        EXPORTING
          VALUE(it_target) TYPE TABLE OF ty_target.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_source,
        field1 TYPE string,
        field2 TYPE string,
      END OF ty_source,
      ty_source_tab TYPE STANDARD TABLE OF ty_source WITH DEFAULT KEY,

      BEGIN OF ty_target,
        field_a TYPE string,
        field_b TYPE string,
      END OF ty_target,
      ty_target_tab TYPE STANDARD TABLE OF ty_target WITH DEFAULT KEY.

ENDCLASS.

CLASS zcl_mapping IMPLEMENTATION.

  METHOD map_data.
    LOOP AT it_source INTO DATA(ls_source).
      DATA(ls_target) = VALUE ty_target(
        field_a = ls_source-field1
        field_b = ls_source-field2
      ).
      APPEND ls_target TO it_target.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.