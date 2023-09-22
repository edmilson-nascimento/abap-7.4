
data(lt_filter) =
  " Atribuição do tipo TT_PRPS
  value tt_prps(
  " Agrupa a Definição do Projeto na variavel DP
  for groups DP of ls_data in lt_pstab
  " Condicao para não retornar valores vazios
  where ( psphi is not initial )
  group by ls_data-psphi ascending
  " Atribuir a variavel
    ( psphi = DP ) ) .


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

* Renato Lara
    DATA(lt_inc_cl_group) = VALUE tt_inc_cl_group(
     FOR GROUPS group OF <fs_inc_class> IN lt_inc_class
     GROUP BY ( classification_type     = <fs_inc_class>-classification_type
                classification_category = <fs_inc_class>-classification_category )
     LET amount = REDUCE #( INIT amount_val TYPE f
                            FOR <group> IN GROUP group
                            NEXT amount_val += <group>-amount )
     IN ( classification_type = group-classification_type
          classification_category = group-classification_category
          amount = amount )
    ).


* [12:05] Renato Lara 
TYPES:
  BEGIN OF ty_inc_class,
    classification_type     TYPE string,
    classification_category TYPE string,
    amount                  TYPE f,
  END OF ty_inc_class,
  tt_inc_class    TYPE STANDARD TABLE OF ty_inc_class
                  WITH DEFAULT KEY,
  tt_inc_cl_group TYPE SORTED TABLE OF ty_inc_class 
                  WITH UNIQUE KEY classification_type classification_category.


*
