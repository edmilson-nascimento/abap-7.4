CLASS zcl_count DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      count_records
        IMPORTING
          VALUE(iv_table_name) TYPE string
        RETURNING
          VALUE(rv_count) TYPE i.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_count IMPLEMENTATION.

  METHOD count_records.
    DATA: lt_data TYPE TABLE OF string.

    " Select records from the specified table
    SELECT COUNT(*) INTO rv_count FROM (iv_table_name).

    " If needed, you can fetch the data into lt_data
    " SELECT * FROM (iv_table_name) INTO TABLE lt_data.

  ENDMETHOD.

ENDCLASS.