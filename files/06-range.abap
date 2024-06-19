  select vbeln, posnr
   up to 100 rows
    from vbap
    into table @data(lt_data) .

  if ( sy-subrc ne 0 ) .
    return .
  endif .

  data(lt_range) =
    value fip_t_vbeln_range(
      for l in lt_data (
        sign   = rsmds_c_sign-including
        option = rsmds_c_option-equal
        low    = l-vbeln
      )
    ) .

***********************************************************************

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
        IF ( lines( im_ativos )  EQ 0 ) .
          RETURN .
        ENDIF .
    
    DATA(lr_equipament) = VALUE ranges_equnr(
      FOR GROUPS equipament OF l IN im_ativos
      WHERE ( equnr IS NOT INITIAL )
      GROUP BY l-equnr ASCENDING
      WITHOUT MEMBERS
      ( sign   = rsmds_c_sign-including
        option = rsmds_c_option-equal
        low    = equipament ) ) .
    IF ( lines( lr_equipament ) EQ 0 ) .
      RETURN .
    ENDIF .

    SELECT *
      FROM /yga/tativos
      INTO TABLE @lt_ativos
      WHERE equnr IN @lr_equipament .
    IF ( sy-subrc NE 0 ) .
      RETURN .
    ENDIF .

    