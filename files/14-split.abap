
TYPES:
  BEGIN OF line,
    rows  TYPE string,
    slice TYPE bseg_t,
  END OF line,
  itab   TYPE STANDARD TABLE OF line WITH EMPTY KEY,
  bseg_t TYPE STANDARD TABLE OF bseg WITH EMPTY KEY.

DATA result TYPE itab.
DATA package TYPE i VALUE 1000 .

*Filling large table:
SELECT * UP TO 31100 ROWS
  INTO TABLE @DATA(lt_bseg)
  FROM bseg.

*Here we costruct table of tables which contains slices of the main table by 1000 rows each.
WHILE lt_bseg IS NOT INITIAL.
  result = VALUE itab( BASE result
                       (
*                      rows  = | { sy-index * 1000 }-{ sy-index * 1000 + 1000 } |
                       rows  = | { sy-index * package }-{ sy-index * package + package } |
                       slice = VALUE bseg_t( FOR wa IN lt_bseg INDEX INTO i FROM i + 1 TO i + 1
*                                            ( LINES OF lt_bseg FROM i TO i + 999 ) )
                                             ( LINES OF lt_bseg FROM i TO i + ( package - 1 ) ) )
                       )
                     ).
* DELETE lt_bseg FROM 1 TO 1000.
  DELETE lt_bseg FROM 1 TO package.
ENDWHILE.

BREAK-POINT.


    TYPES:
      BEGIN OF ty_st_kssk,
        objek TYPE kssk-objek,
        clint TYPE kssk-clint,
        stdcl TYPE kssk-stdcl,
      END OF ty_st_kssk,
      tab_st_kssk TYPE STANDARD TABLE OF ty_st_kssk WITH DEFAULT KEY,
      BEGIN OF ty_st_kssk_package,
        item TYPE i,
        data TYPE tab_st_kssk,
      END OF ty_st_kssk_package,
      tab_st_kssk_package TYPE STANDARD TABLE OF ty_st_kssk_package WITH DEFAULT KEY.