
REPORT zmodel_alv.

*CLASS class_report DEFINITION .
*
*  PUBLIC SECTION .
*
*    TYPES:
*      BEGIN OF ty_out,
*        bp_id         TYPE snwd_bpa-bp_id,
*        company_name  TYPE snwd_bpa-company_name,
*        currency_code TYPE snwd_bpa-currency_code,
*        web_address   TYPE snwd_bpa-web_address,
*        email_address TYPE snwd_bpa-email_address,
*        country       TYPE snwd_ad-country,
*        city          TYPE snwd_ad-city,
*        postal_code   TYPE snwd_ad-postal_code,
*        street        TYPE snwd_ad-street,
*      END OF ty_out,
*
*      tab_out     TYPE TABLE OF ty_out,
*      range_bp_id TYPE RANGE OF snwd_bpa-bp_id,
*      tab_bpa     TYPE TABLE OF snwd_bpa, " Address Table
*      tab_ad      TYPE TABLE OF snwd_ad.  " Business Partners
*
*    METHODS buscar_dados
*      IMPORTING
*        !bp_id   TYPE class_report=>range_bp_id
*      CHANGING
*        !bpa_tab TYPE class_report=>tab_bpa
*        !ad_tab  TYPE class_report=>tab_ad .
*
*    METHODS processar_dados
*      IMPORTING
*        !bpa_tab TYPE class_report=>tab_bpa
*        !ad_tab  TYPE class_report=>tab_ad
*      CHANGING
*        !out_tab TYPE class_report=>tab_out .
*
*    METHODS exibir_informacoes
*      CHANGING
*        !out_tab TYPE class_report=>tab_out .
*
*  PROTECTED SECTION .
*
*  PRIVATE SECTION .
*
*ENDCLASS .
*
*
*CLASS class_report IMPLEMENTATION .
*
*  METHOD buscar_dados.
*
*    REFRESH:
*      bpa_tab, ad_tab.
*
*    " Retorna quantidade de linhs de uma tabela interna
*    DATA(lv_quantidade_de_lines) = lines( bp_id ).
*
*    " IF ( lines( bp_id ) = 0 ).
*    IF ( lv_quantidade_de_lines = 0 ).
*      RETURN.
*    ENDIF.
*
*    SELECT * INTO TABLE bpa_tab
*      FROM snwd_bpa
*      WHERE bp_id IN bp_id.
*    IF ( sy-subrc <> 0 ).
*      RETURN.
*    ENDIF.
*
*    SELECT * INTO TABLE ad_tab
*      FROM snwd_ad
*      FOR ALL ENTRIES IN bpa_tab
*      WHERE node_key = bpa_tab-address_guid.
*
*  ENDMETHOD.
*
*
*  METHOD processar_dados .
*
*    DATA:
*      out_line TYPE class_report=>ty_out .
*
*    REFRESH out_tab .
*
*    IF ( lines( bpa_tab ) GT 0 ) AND
*       ( lines( ad_tab )  GT 0 ) .
*
*      LOOP AT bpa_tab INTO DATA(bpa_line) .
*
*        out_line-bp_id         = bpa_line-bp_id .
*        out_line-company_name  = bpa_line-company_name .
*        out_line-currency_code = bpa_line-currency_code .
*        out_line-web_address   = bpa_line-web_address .
*        out_line-email_address = bpa_line-email_address .
*
*        READ TABLE ad_tab INTO DATA(ad_line)
*          WITH KEY node_key = bpa_line-address_guid .
*
*        IF ( sy-subrc EQ 0 ) .
*
*          out_line-country     = ad_line-country .
*          out_line-city        = ad_line-city .
*          out_line-postal_code = ad_line-postal_code .
*          out_line-street      = ad_line-street .
*
*          APPEND out_line TO out_tab .
*          CLEAR  out_line .
*
*        ENDIF .
*
*      ENDLOOP .
*
*    ENDIF .
*
*  ENDMETHOD .
*
*
*  METHOD exibir_informacoes.
*
*    DATA:
*      salv_table TYPE REF TO cl_salv_table,
*      columns    TYPE REF TO cl_salv_columns_table,
*      display    TYPE REF TO cl_salv_display_settings.
*
*
*    IF ( lines( out_tab ) = 0 ).
*    ELSE.
*
*      TRY.
*
*          cl_salv_table=>factory( IMPORTING r_salv_table = salv_table
*                                  CHANGING  t_table      = out_tab ).
*
*          " Otimizar largura da columa
*          columns = salv_table->get_columns( ).
*          IF ( columns IS BOUND ).
*            columns->set_optimize( cl_salv_display_settings=>true ).
*          ENDIF.
*
*          " Usando Status
*          salv_table->set_screen_status( pfstatus      = 'STANDARD_FULLSCREEN'
*                                         report        = 'SAPLKKBL'
*                                         set_functions = salv_table->c_functions_all ).
*
*          " Layout de Zebra
*          display = salv_table->get_display_settings( ).
*          IF ( display IS BOUND ).
*            display->set_striped_pattern( cl_salv_display_settings=>true ).
*          ENDIF.
*
*          salv_table->display( ).
*
*        CATCH cx_salv_msg.
*        CATCH cx_salv_not_found.
*        CATCH cx_salv_existing.
*        CATCH cx_salv_data_error.
*        CATCH cx_salv_object_not_found.
*
*      ENDTRY.
*
*    ENDIF.
*
*  ENDMETHOD.
*
*
*ENDCLASS .
*
*" Declaracoes globais
*DATA:
*  filtro            TYPE class_report=>range_bp_id,
*  alv_global_object TYPE REF TO class_report,
*  bpa_table         TYPE class_report=>tab_bpa,
*  ad_table          TYPE class_report=>tab_ad,
*  out_table         TYPE class_report=>tab_out.
*
*INITIALIZATION.
*  " antes de aparecer os filtros
*  " informar uma data padrao por exemplo
*
*  " Essa opcao pode ser substituida por um parametro de selecao
*  filtro =
*    VALUE #( sign   = 'I'
*             option = 'EQ'
*             ( low = '0100000000' )
*             ( low = '0100000001' )
*             ( low = '0100000002' )
*             ( low = '0100000003' )
*             ( low = '0100000004' )
*             ( low = '0100000005' ) ).
*
*
*START-OF-SELECTION.
*  " clicou para executar o relatorio (F8)
*  " depois de informar os filtros
*
*  " Passo para se buscar os dados
*
*  " Criando objeto
*  alv_global_object = NEW class_report( ).
*
*  " Verificando se foi criado o objeto
*  IF ( alv_global_object IS BOUND ).
*
*    alv_global_object->buscar_dados( EXPORTING bp_id   = filtro
*                                     CHANGING  bpa_tab = bpa_table
*                                               ad_tab  = ad_table ).
*
*    alv_global_object->processar_dados( EXPORTING bpa_tab = bpa_table
*                                                  ad_tab  = ad_table
*                                        CHANGING  out_tab = out_table ).
*  ENDIF.
*
*END-OF-SELECTION.
*  " apos o evento START-
*  " ainda antes de exibir o ALV

TYPES:
  BEGIN OF ty_mara,
    matnr TYPE mara-matnr,
    maktx TYPE makt-maktx,
    spras TYPE makt-spras,
  END OF ty_mara,
  tab_mara TYPE STANDARD TABLE OF ty_mara WITH DEFAULT KEY,
  BEGIN OF ty_material,
    material TYPE mara-matnr,
    maktx    TYPE makt-maktx,
    spras    TYPE makt-spras,
  END OF ty_material,
  tab_material TYPE STANDARD TABLE OF ty_material WITH DEFAULT KEY.


DATA(lt_source) = VALUE tab_mara( spras = 'PT'
                                  ( matnr = '10000018'
                                    maktx = 'MOLA PAPEIS METAL 32MM PRETO' )
                                  ( matnr = '20000074'
                                    maktx = 'CABO AL/ACO 160 26X2.58/7X2' )
                                  ( matnr = '40007379'
                                    maktx = 'REDES AEREAS DE BT' ) ).

cl_demo_output=>display_data( lt_source ).


DATA(lt_target) = CORRESPONDING tab_material( lt_source
                             MAPPING material = matnr ).
cl_demo_output=>display_data( lt_target ).
























*