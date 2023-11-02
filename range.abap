  select vbeln, posnr
   up to 100 rows
    from vbap
    into table @data(lt_data) .

  if ( sy-subrc ne 0 ) .
    return .
  endif .

  break-point .

  data(lt_range) =
    value fip_t_vbeln_range(
      for l in lt_data (
        sign   = rsmds_c_sign-including
        option = rsmds_c_option-equal
        low    = l-vbeln
      )
    ) .


  lt_range = value #(
    for groups vbeln of wa in lt_data
      group by wa-vbeln ascending
      without members
        ( sign   = rsmds_c_sign-including
          option = rsmds_c_option-equal
*         low    = wa-vbeln  )  ) .
          low    = vbeln  )  ) .

          lt_objnr = VALUE #( FOR ls_objrn IN t_equi ( objnr = ls_objrn-objnr ) ).


  lt_objnr = value #(
    for groups order of ls_objrn in t_equi
      group by ls_objrn-objnr ascending
      without members
        ( objnr = order )  ) .