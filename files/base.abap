
        " Buscar todos os registro por grupos.
        DO.

          " Limpar para próxima iteração
          CLEAR lt_item_list_single.

          " Buscar itens
          get_entity_list( EXPORTING iv_entity_set_name = 'FILE_ITEM'
                                     io_filter_node     = lo_filter_node
                                     iv_skip            = lv_skip
                                     iv_top             = lc_top
                           IMPORTING et_return_data     = lt_item_list_single
                                     es_response        = ls_response
                                     ev_success         = lv_success ).

          IF lv_success <> abap_true.
            es_response = ls_response.
            RETURN.
          ENDIF.

          " Prox pacote/lote
          lv_skip += lc_top.

          " Combinar tabelas
          lt_item_list = VALUE #( BASE lt_item_list
                                  ( LINES OF lt_item_list_single ) ).

          " Validar quando sir do laço
          IF lines( lt_item_list_single ) < lc_top.
            EXIT.
          ENDIF.

        ENDDO.
