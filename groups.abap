    data(lt_filter) =
      value re_t_aufnr(
        for groups order of line in me->gt_final
        where ( aufnr is not initial )
        group by line-aufnr ascending
        ( order ) ) .



    me->gt_componentes = VALUE #(
      FOR GROUPS components OF <fs_mat> IN lt_data
      GROUP BY ( aufnr   = <fs_mat>-aufnr
                 matnr_c = <fs_mat>-matnr_c
                 einheit = <fs_mat>-einheit ) ASCENDING

               ( aufnr   = components-aufnr
                 matnr_c = components-matnr_c
                 einheit = components-einheit

                 qtd_prevista =
                   REDUCE menge_d( INIT lv_menge TYPE menge_d
                                    FOR ls_mat IN GROUP components
                                   NEXT lv_menge = lv_menge + ls_mat-qtd_prevista )
                 qtd_integrada =
                   REDUCE menge_d( INIT lv_menge TYPE menge_d
                                    FOR ls_mat IN GROUP components
                                   NEXT lv_menge = lv_menge + ls_mat-qtd_integrada )
                 qtd_realizada =
                   REDUCE menge_d( INIT lv_menge TYPE menge_d
                                    FOR ls_mat IN GROUP components
                                   NEXT lv_menge = lv_menge + ls_mat-qtd_realizada ) ) ).
