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