
data(lt_filter) =
  " Atribuição do tipo TT_PRPS
  value tt_prps(
  " Agrupa a Definição do Projeto na variavel DP
  for groups DP of ls_data in lt_pstab
  " Condicao para não retornar valores vazios
  where ( psphi is not initial )
  " Campo que sera agrupado 
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


t_result = VALUE #( FOR GROUPS group OF ls_source IN it_source
                     GROUP BY ( so             = ls_source-so
                                customer       = ls_source-customer
                                material_group = ls_source-material_group )
                     ( so             = group-so
                       customer       = group-customer
                       material_group = group-material_group
                       liters         = REDUCE #( INIT lv_liters = 0
                                                  FOR ls_member IN GROUP group
                                                  NEXT lv_liters = lv_liters + ls_member-liters ) ) ).


TYPES:
  BEGIN OF type_line,
    matnr TYPE mara-matnr,
    charg TYPE mcha-charg,
  END OF type_line,
  type_tab TYPE STANDARD TABLE OF type_line
           WITH DEFAULT KEY .

DATA(lt_source) = VALUE type_tab(
  ( matnr = '20000010' charg = '11M10' )
  ( matnr = '20000020' charg = '11M20' )
  ( matnr = '20000010' charg = '11M10' )
  ( matnr = '20000030' charg = '11M30' )
  ( matnr = '20000040' charg = '11M40' )
  ( matnr = '20000010' charg = '11M10' )
  ( matnr = '20000020' charg = '11M20' )
).

DATA(lt_result) = VALUE type_tab(
    FOR GROUPS group OF ls_source IN lt_source
  GROUP BY ( matnr = ls_source-matnr
             charg = ls_source-charg ) ASCENDING
WITHOUT MEMBERS
           ( matnr = group-matnr
             charg = group-charg ) ) .


* Agrupamento para totalizador
DATA(lv_count_materials) = REDUCE I( INIT CNT1 = 0
FOR GROUPS OF M1 IN me->gt_goodsmvt_item GROUP BY M1-material
NEXT CNT1 = CNT1 + 1 ).    