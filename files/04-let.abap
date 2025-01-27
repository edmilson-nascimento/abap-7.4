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


CONSTANTS:
      BEGIN OF c_status,
        faturado_ini    TYPE zbresd_status_link VALUE '20',
        faturado_ok     TYPE zbresd_status_link VALUE '29',
        compensado_parc TYPE zbresd_status_link VALUE '98',
        compensado_ok   TYPE zbresd_status_link VALUE '99',
      END OF c_status .
    CONSTANTS:
      BEGIN OF c_bloq,
        cod_bloq_transf      TYPE zbresd_value_param VALUE 'COD_BLOQUEIO_TRANSFERENCIA',
        cod_bloq_cvp         TYPE zbresd_value_param VALUE 'COD_BLOQUEIO_CVP_REMESSA',
        cod_bloq_fat         TYPE zbresd_value_param VALUE 'COD_BLOQUEIO_CVP_FATURA',
        cod_bloq_pag_div_pix TYPE zbresd_value_param VALUE 'COD_BLOQUEIO_PAG_DIVERGENTE_PIX',
      END OF c_bloq .
    CONSTANTS:
      BEGIN OF c_gen,
        base_url              TYPE zbresd_value_param VALUE 'BASE_URL',
        days_proc_range       TYPE zbresd_value_param VALUE 'DAYS_PROCESS_RANGE',
        cod_parceiro_vendedor TYPE zbresd_value_param VALUE 'COD_PARCEIRO_VENDEDOR',
        doc_adiantamento      TYPE zbresd_value_param VALUE 'TIPO_DOC_ADIANTAMENTO',
        doc_compensacao       TYPE zbresd_value_param VALUE 'TIPO_DOC_COMPENSACAO',
        fatura                TYPE c VALUE 'F',
        remessa               TYPE c VALUE 'R',
      END OF c_gen .
    CONSTANTS:
      BEGIN OF c_pag,
        ini  TYPE zbresd_status_link VALUE '20',
        erro TYPE zbresd_status_link VALUE '21',
        ok   TYPE zbresd_status_link VALUE '29',
      END OF c_pag .

    CLASS-DATA:
      BEGIN OF vg_constante,
        status  LIKE c_status,
        bloq    LIKE c_bloq,
        generic LIKE c_gen,
        pag     like c_pag,
      END OF vg_constante .