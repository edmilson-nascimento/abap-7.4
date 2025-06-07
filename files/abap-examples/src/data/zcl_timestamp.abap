CLASS zcl_timestamp DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      convert_date_to_timestamp
        IMPORTING
          VALUE(iv_date) TYPE d
        EXPORTING
          VALUE(ev_timestamp) TYPE timestamp,
      convert_timestamp_to_date
        IMPORTING
          VALUE(iv_timestamp) TYPE timestamp
        EXPORTING
          VALUE(ev_date) TYPE d.

ENDCLASS.

CLASS zcl_timestamp IMPLEMENTATION.

  METHOD convert_date_to_timestamp.
    DATA: lv_timestamp TYPE timestamp.
    CALL FUNCTION 'TIMESTAMP_TO_DATE'
      EXPORTING
        date     = iv_date
      IMPORTING
        timestamp = lv_timestamp.
    ev_timestamp = lv_timestamp.
  ENDMETHOD.

  METHOD convert_timestamp_to_date.
    DATA: lv_date TYPE d.
    CALL FUNCTION 'DATE_TO_TIMESTAMP'
      EXPORTING
        timestamp = iv_timestamp
      IMPORTING
        date      = lv_date.
    ev_date = lv_date.
  ENDMETHOD.

ENDCLASS.