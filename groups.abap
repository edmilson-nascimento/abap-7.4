    data(lt_filter) =
      value re_t_aufnr(
        for groups order of line in me->gt_final
        where ( aufnr is not initial )
        group by line-aufnr ascending
        ( order ) ) .
