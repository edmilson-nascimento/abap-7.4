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

    if ( is_data is initial ) .
      return .
    endif .

    select vbeln, posnr, charg, lfimg, meins, aufnr
      from lips
     where charg eq @is_data-charg
       and aufnr eq @is_data-aufnr
     order by aufnr, charg ascending
      into table @data(lt_data_qty) .

    if ( sy-subrc ne 0 ) .
      return .
    endif .

    result =
      reduce lfimg( init qty type lfimg
                    for  l in lt_data_qty
                    next qty = qty + l-lfimg  ) .

    loop at lt_data into ls_data .

      ls_outtab-total_p = 
        me->get_total_por_tp_deposito( i_lote        = ls_data-i_lote
                                       i_tp_deposito = ls_data-tp_deposito
                                       i_tab_all     = gt_tab_ll ) .

    endloop .

    DATA(lv_count) = reduce kwart(
      init i type kwart
      for ls_line in zif_psxra_model~mt_desp_incl
     where ( objnr = ls_line-objnr )
      next i = i + ls_line-wkg ) .
      
*--------------------------------------------------
*|VBELN     |POSNR|CHARG     |LFIMG|MEINS|AUFNR   |
*--------------------------------------------------
*|1870000078|   10|CA00099412|   2 |KG   |11459204|
*|1870000107|   10|CA00099412|   2 |KG   |11459204|
*|1870000108|   10|CA00099412|   2 |KG   |11459204|

*|1870000110|   10|CA00099424|   2 |KG   |11459204|
*|1870000111|   10|CA00099412|   1 |KG   |11459204|
*|1870000113|   10|CA00099431|   2 |KG   |11459204|
*|1870000114|   10|CA00099426|   4 |KG   |11459204|
*|1870000120|   10|CA00099431|   2 |KG   |11459204|
*|1870000121|   10|CA00099425|   1 |KG   |11459204|
*|1870000126|   10|CA00099423|   3 |KG   |11459204|
*|1870000127|   10|CA00099424|   3 |KG   |11459204|
*|1870000128|   10|CA00099412|   4 |KG   |11459204|
*|1870000129|   10|CA00099431|   2 |KG   |11459204|
*|1870000130|   10|CA00099424|   7 |KG   |11459204|
*|1870000134|   10|CA00099431|   4 |KG   |11459204|
*--------------------------------------------------


* Agrupamento para totalizador
DATA(lv_count_materials) = REDUCE I( INIT CNT1 = 0
FOR GROUPS OF M1 IN me->gt_goodsmvt_item GROUP BY M1-material
NEXT CNT1 = CNT1 + 1 ).    