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
TYPES tab_save TYPE STANDARD TABLE OF zca_tquermes_pri WITH DEFAULT KEY.
DATA lt_save_data TYPE tab_save.

IF lines( im_data ) = 0.
  RETURN.
ENDIF.

BREAK-POINT.

" Atualizando numero do item
LOOP AT im_data into data(ls_item).

  " Se a prioridade não foi alterada, matem o mesmo Numero de item
  IF line_exists( im_data_db[ inc      = ls_item-inc
                              priority = ls_item-priority ] ).
    DATA(item_db) = VALUE #( im_data_db[ inc      = ls_item-inc
                                         priority = ls_item-priority ]-item ).
    ls_item-item = item_db.
    CONTINUE.
  ENDIF.

  " Atribuindo novo item (considerar apenas itens que tivaram prioridade alterada)
  ls_item-item = CONV zca_tquermes_pri-item( 1 ).

  DO 999 TIMES.
    IF line_exists( im_data_db[ inc  = ls_item-inc
                                item = ls_item-item ] ).

      ls_item-item = ls_item-item + 1.
      CONTINUE.
    ENDIF.
    EXIT.
  ENDDO.

  " Criando dados que devem ser salvos pois foram alterados neste processamento
  lt_save_data = value #( base lt_save_data ( corresponding zca_tquermes_pri( ls_item ) ) ).
ENDLOOP.


*