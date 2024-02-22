

TYPES:
  BEGIN OF ts_knbk,
    kunnr TYPE knbk-kunnr,
    koinh TYPE knbk-koinh,
  END OF ts_knbk,
  knbk_t TYPE STANDARD TABLE OF ts_knbk
           WITH DEFAULT KEY .

DATA(lt_knbk1) = VALUE knbk_t(
 ( kunnr = '111'
   koinh = 'Name 111' )
 ( kunnr = '123'
   koinh = 'Name 123' )
).

DATA(lt_knbk2) = VALUE knbk_t(
 ( kunnr = '123'
   koinh = 'Name 123' )
 ( kunnr = '122'
   koinh = 'Name 122' )
 ( kunnr = '121'
   koinh = 'Name 121' )
).

*types tt_xknbk type sorted table of ts_knbk ...
*types tt_yknbk type sorted table of ts_knbk ...

DATA(lt_knbk_diff) = VALUE knbk_t(
  FOR ls_knbk IN COND #( WHEN lines( lt_knbk1 ) >= lines( lt_knbk2 ) THEN lt_knbk1 ELSE lt_knbk2 )
    ( LINES OF COND #(
      WHEN lines( lt_knbk1 ) >= lines( lt_knbk2 ) AND NOT line_exists( lt_knbk2[ table_line = ls_knbk ] ) THEN VALUE #( ( ls_knbk ) )
      WHEN lines( lt_knbk2 ) > lines( lt_knbk1 ) AND NOT line_exists( lt_knbk1[ table_line = ls_knbk ] ) THEN VALUE #( ( ls_knbk ) )
    ) )
).

BREAK-POINT .

*