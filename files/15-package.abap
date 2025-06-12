" Em caso de grandes quantidades, essa classe será chamada novamente, para um segundo
" processamento feito em pacotes de tamanhos diferentes
IF     me->is_second_step( me->gv_second ) = abap_true
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


  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_process_mode,
        ausp TYPE char1 VALUE '1',
        kssk TYPE char1 VALUE '2',
      END OF gc_process_mode.

    TYPES:
      BEGIN OF ty_st_kssk,
        objek TYPE kssk-objek,
        clint TYPE kssk-clint,
        stdcl TYPE kssk-stdcl,
      END OF ty_st_kssk,
      tab_st_kssk TYPE STANDARD TABLE OF ty_st_kssk WITH DEFAULT KEY,

      BEGIN OF ty_st_kssk_package,
        item TYPE numc4,
        data TYPE tab_st_kssk,
      END OF ty_st_kssk_package,
      tab_st_kssk_package TYPE STANDARD TABLE OF ty_st_kssk_package WITH DEFAULT KEY,

      BEGIN OF ty_st_klah,
        klah_clint TYPE klah-clint,
        klart      TYPE klah-klart,
        class      TYPE klah-class,
        imerk      TYPE ksml-imerk,
      END OF ty_st_klah,
      tab_st_klah TYPE STANDARD TABLE OF ty_st_klah WITH DEFAULT KEY,

      BEGIN OF ty_st_klah_package,
        item       TYPE numc4,
        class_type TYPE kssk-klart,
        data       TYPE tab_st_klah,
      END OF ty_st_klah_package,
      tab_st_klah_package TYPE STANDARD TABLE OF ty_st_klah_package WITH DEFAULT KEY,

      BEGIN OF single_record_ausp,
        klart TYPE ausp-klart,
        data  TYPE tab_st_kssk,
      END OF single_record_ausp,

      BEGIN OF task_result_ausp,
        data TYPE tab_ausp,
      END OF task_result_ausp,

      BEGIN OF record_kssk,
        class_type TYPE kssk-klart,
        filter     TYPE tab_st_klah,
      END OF record_kssk,
      single_record_kssk TYPE record_kssk,

      BEGIN OF task_result_kssk,
        data TYPE tab_st_kssk,
      END OF task_result_kssk.

  PRIVATE SECTION.

    DATA:
      gt_filter      TYPE tab_st_kssk,
      ausp_filter TYPE single_record_ausp.

    "! <p class="shorttext synchronized" lang="pt">Divide a tabela interna em pacotes</p>
    "! @parameter im_package | <p class="shorttext synchronized" lang="pt">Quantidade por pacotes</p>
    "! @parameter result     | <p class="shorttext synchronized" lang="pt">Pacotes dividos</p>
    "! @parameter im_data    | <p class="shorttext synchronized" lang="pt">Dados completos</p>
    METHODS split_packages
      IMPORTING im_data_ausp TYPE tab_st_kssk OPTIONAL
                im_data_kssk TYPE tab_st_klah OPTIONAL
                im_package   TYPE i
      EXPORTING !ex_task     TYPE STANDARD TABLE.

    METHODS process
      IMPORTING im_process_mode     TYPE char01
                im_single_task_ausp TYPE tab_st_kssk_package OPTIONAL
                im_single_task_kssk TYPE tab_st_klah_package OPTIONAL
      EXPORTING ex_ausp             TYPE tab_ausp
                ex_kssk             TYPE tab_st_kssk.




METHOD split_packages.

    IF lines( im_data ) = 0.
        RETURN.
    ENDIF.

    IF im_package IS INITIAL.
        RETURN.
    ENDIF.

    DATA(lt_data_temp) = im_data.

    WHILE lt_data_temp IS NOT INITIAL.
        result = VALUE tab_st_kssk_package(
                            BASE result
                            ( item = sy-index
                            data = VALUE tab_st_kssk( FOR wa IN lt_data_temp INDEX INTO i FROM i + 1 TO i + 1
                                                        ( LINES OF lt_data_temp FROM i TO i + ( im_package - 1 ) ) ) ) ).
        DELETE lt_data_temp FROM 1 TO im_package.
    ENDWHILE.

ENDMETHOD.