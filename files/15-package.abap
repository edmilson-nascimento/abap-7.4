IF gv_ausp = abap_true.
    " Em caso de grandes quantidades, essa classe será chamada novamente, para um segundo
    " processamento feito em pacotes de tamanhos diferentes
    IF    me->is_second_step( me->gv_second ) = abap_true
       OR me->is_allowed_for_simple_process( im_package = lc_process_package_size
                                             im_data    = me->gt_kssk ).
      data_query_ausp( ).
      data_prepare_ausp( ).

    ELSE.
      DATA(lt_packages) = me->split_packages( im_package = lc_process_package_size
                                              im_data    = me->gt_kssk ).
      LOOP AT lt_packages ASSIGNING FIELD-SYMBOL(<fs_package>).
        me->create_new_program_call( <fs_package> ).
      ENDLOOP.
      MESSAGE i000(>0) WITH 'Foram criados processos paralelos em jobs.'.
    ENDIF.
  ENDIF.