

TYPES:
  BEGIN OF line,
    rows  TYPE string,
    slice TYPE bseg_t,
  END OF line,
  itab   TYPE STANDARD TABLE OF line WITH EMPTY KEY,
  bseg_t TYPE STANDARD TABLE OF bseg WITH EMPTY KEY.
DATA: result TYPE itab.
*Filling large table:

SELECT * UP TO 31000 ROWS
  INTO TABLE @DATA(lt_bseg)
  FROM bseg.
*Here we costruct table of tables which contains slices of the main table by 1000 rows each.

WHILE lt_bseg IS NOT INITIAL.
  result = VALUE itab( BASE result
                       (
                       rows  = | { sy-index * 1000 }-{ sy-index * 1000 + 1000 } |
                       slice = VALUE bseg_t( FOR wa IN lt_bseg INDEX INTO i FROM i + 1 TO i + 1
                                             ( LINES OF lt_bseg FROM i TO i + 999 ) )
                       )
                     ).
  DELETE lt_bseg FROM 1 TO 1000.
ENDWHILE.

BREAK-POINT.