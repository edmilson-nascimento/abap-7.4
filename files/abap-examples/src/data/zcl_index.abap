CLASS zcl_index DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      create_index,
      use_index.

  PRIVATE SECTION.
    DATA: lt_data TYPE TABLE OF string,
          lt_index TYPE HASHED TABLE OF string WITH UNIQUE KEY table_line.

ENDCLASS.

CLASS zcl_index IMPLEMENTATION.

  METHOD create_index.
    " Sample data for demonstration
    lt_data = VALUE #( ( 'Data1' ) ( 'Data2' ) ( 'Data3' ) ( 'Data4' ) ).

    " Create index for data retrieval
    LOOP AT lt_data INTO DATA(lv_entry).
      INSERT lv_entry INTO TABLE lt_index.
    ENDLOOP.
  ENDMETHOD.

  METHOD use_index.
    DATA(lv_search) = 'Data2'.
    DATA(lv_found) TYPE string.

    " Use index to find data
    READ TABLE lt_index INTO lv_found WITH KEY table_line = lv_search.
    IF sy-subrc = 0.
      WRITE: / 'Found:', lv_found.
    ELSE.
      WRITE: / 'Not Found'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.