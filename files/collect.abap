REPORT x .



*----------------------------------------------------------------------*
* Modifications                                                        *
*----------------------------------------------------------------------*
* Date..........: 2023-11-30                                           *
* Author........: Edmilson N De Jesus - EX135415                       *
* Tag...........: MOD1 - AST-74032: Sincronismo SITRD para JUMP da     *
*                        morada das instalações - ID0008 & ID0009      *
*----------------------------------------------------------------------*

*>>> MOD1 - Begin

*<<< MOD1 - End


TYPES:
  BEGIN OF ty_call,
    tabname TYPE dd03l-tabname,
    valor   TYPE i,
  END OF ty_call,
  tab_call TYPE TABLE OF ty_call.

DATA:
  ls_collect TYPE ty_call,
  lt_collect TYPE tab_call,
  lt_reduce  TYPE tab_call.


SELECT tabname, fieldname, as4local, as4vers,
       position
  FROM dd03l
  INTO TABLE @DATA(lt_data)
 WHERE fieldname IN ( 'ABCKZFLOC' ,'FUNCLOC', 'YGA_A013' ) .

IF ( sy-subrc EQ 0 ) .

  LOOP AT lt_data INTO DATA(ls_data) .

    ls_collect-tabname =  ls_data-tabname .
    ls_collect-valor   = 1 .

    COLLECT ls_collect INTO lt_collect .
    CLEAR   ls_collect .

  ENDLOOP .

  lt_reduce = VALUE #(
    FOR GROUPS table OF <line> IN lt_data
    GROUP BY <line>-tabname
    ( tabname = table
      valor   = REDUCE i( INIT i TYPE i
                           FOR ls_field IN GROUP table
                          NEXT i = i + 1 ) )
  ).


  DELETE lt_collect WHERE valor LT 3 .

ENDIF .







BREAK-POINT .