* Usando a mesma tabela interna para atribuor novos dados
TYPES:
  BEGIN OF ty_result,
    po    TYPE ekko-ebeln,
    ccode TYPE ekko-bukrs,
    uname TYPE ekko-ernam,
  END OF ty_result,
  tab_result TYPE STANDARD TABLE OF ty_result
             WITH KEY po .

* Fill data
DATA(result1) = VALUE tab_result(
  ( po    = '4000000001'
    ccode = '0001'
    uname = 'ABAP.DEV1' )
  ( po    = '4000000002'
    ccode = '2001'
    uname = 'ABAP.DEV2' )
  ( po    = '4000000003'
    ccode = '3001'
    uname = 'ABAP.DEV3' )
  ( po    = '4000000004'
    ccode = '0001'
    uname = 'ABAP.DEV5' )
  ( po    = '4000000005'
    ccode = '2001'
    uname = 'ABAP.DEV5' )
).
" Write stated data
cl_demo_output=>write_data( result1 ).

* Old way
* Change the company code to 0005 where company code is 0001
* LOOP AT result1 ASSIGNING <fs> WHERE ccode EQ '0001'.
*   <fs>-ccode = '0005'.
* ENDLOOP.

* Proposed resolution
result1 = VALUE #(
  LET lt_temp = result1
  IN
  FOR ls_temp IN lt_temp
    ( po    = ls_temp-po
      ccode = COND #( WHEN ls_temp-ccode EQ '0001'
                      THEN '0005'
                      ELSE ls_temp-ccode )
      uname = ls_temp-uname ) ) .

* Write changed data
cl_demo_output=>write_data( result1 ).

* Display
cl_demo_output=>display( ).

* Populate sy-tabix in the additional fields within the for loop
DATA(lt_target2) = VALUE gtt_struct2( FOR lwa_source IN lt_source
                            INDEX INTO index
                            LET base = VALUE ty_struct2( field3 = index )
                            IN ( CORRESPONDING #( BASE ( base ) lwa_source ) ) ).