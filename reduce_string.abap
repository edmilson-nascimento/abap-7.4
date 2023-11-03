
REPORT ytest.

TYPES:
  BEGIN OF ty_output,
    object        TYPE objnum, "EQUI/LOCINST
    object_int    TYPE objnum,
    klass         TYPE klassenart,
    class_act     TYPE klasse_d,
    class_0038    TYPE klasse_d,
    class_uc      TYPE klasse_d,
    class_act_s   TYPE char100,
    status_class  TYPE icon_d,
    status_dclass TYPE icon_d,
    comments      TYPE /yga/comments,
  END OF ty_output,
  tt_output TYPE TABLE OF ty_output.

DATA gt_output TYPE tt_output .

gt_output = VALUE #(

( object       = 'ED-0815-RD-BT-111425'
  object_int   = '?0100000000000114975'
  klass        = '003'
  class_act    = 'APOIO_BT'
  class_0038   = 'APOIO_BT'
  class_uc     = 'REDE_BT'
  class_act_s  = 'REDE_BT | GERAL_LI' )

( object       = 'ED-0815-RD-BT-111425'
  object_int   = '?0100000000000114975'
  klass        = '003'
  class_act    = 'APOIO_BT'
  class_0038   = 'REDE_BT'
  class_uc     = 'REDE_BT'
  class_act_s  = 'REDE_BT | GERAL_LI' )

( object       = 'ED-0815-RD-BT-111425'
  object_int   = '?0100000000000114975'
  klass        = '003'
  class_act    = 'APOIO_BT'
  class_0038   = 'REDE_BT'
  class_uc     = 'REDE_++'
  class_act_s  = 'REDE_BT | GERAL_LI' )

).

LOOP AT gt_output ASSIGNING FIELD-SYMBOL(<fs_output>).

  DATA(text_class_uc) = REDUCE string(
    INIT text01 TYPE string
     FOR ls_out IN gt_output
   WHERE ( object = <fs_output>-object )
   
*   NEXT text01 = text01 && '|' && |{ ls_out-class_uc  } | ) .

*    NEXT text01 =
*      COND #( WHEN text01 IS INITIAL THEN ls_out-class_uc
*              ELSE text01 && '|' && |{ ls_out-class_uc  } | ) ) .

    NEXT text01 =
      COND #( WHEN text01 IS INITIAL THEN ls_out-class_uc
              WHEN text01 NS ls_out-class_uc THEN text01 && '|' && |{ ls_out-class_uc  } |
              ELSE text01 ) ) .

  DATA(lv_class_uc) = REDUCE string(
    INIT text01 TYPE string
     FOR ls_out IN gt_output
   WHERE ( object = <fs_output>-object )
    NEXT text01 = COND string(
                    WHEN text01 = '' THEN ls_out-class_uc "CONV #( |V { ls_out-class_uc }| )
                    WHEN text01 NS ls_out-class_uc THEN text01 && '|' && ls_out-class_uc  ) ).

  IF ( lv_class_uc CS '|' OR lv_class_uc IS INITIAL ) .

    DATA(lv_class_0038) = REDUCE string(
      INIT text TYPE string
       FOR ls_out IN gt_output
     WHERE ( object = <fs_output>-object )
      NEXT text = COND string(
                    WHEN text = '' THEN ls_out-class_0038
                    WHEN text NS ls_out-class_0038 THEN text && '|' && ls_out-class_0038  ) ).
  ENDIF.

ENDLOOP .


IF ( lines( im_equi ) EQ 0 ) .
  RETURN .
ENDIF .

me->gt_equi = im_equi .

ENDMETHOD .

METHOD get_data .

CLEAR me->gt_outtab .

IF ( lines( me->gt_equi ) EQ 0 ) .
  RETURN .
ENDIF .

SELECT equnr, objnr
  FROM equi
  INTO TABLE @DATA(lt_data)
 WHERE equnr IN @me->gt_equi .
IF ( sy-subrc NE 0 ) .
  RETURN .
ENDIF .

SELECT equnr, spras, eqktx, eqktu
  FROM eqkt
  INTO TABLE @me->gt_outtab
   FOR ALL ENTRIES IN @lt_data
 WHERE equnr EQ @lt_data-equnr
   AND spras EQ @sy-langu .
IF ( sy-subrc NE 0 ) .
  RETURN .
ENDIF .

SELECT j~objnr, j~stat, j~inact,
       t~istat, t~spras, t~txt04
  FROM jest AS j
  LEFT JOIN tj02t AS t
    ON j~stat EQ t~istat
  INTO TABLE @DATA(lt_status)
   FOR ALL ENTRIES IN @lt_data
 WHERE j~objnr EQ @lt_data-objnr
*      AND j~inact EQ @abap_false
   AND t~spras EQ @sy-langu .

" Informando status
LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

  ASSIGN me->gt_outtab[ equnr = <fs_data>-equnr ] TO FIELD-SYMBOL(<fs_out>) .
  IF ( <fs_out> IS NOT ASSIGNED ) .
    CONTINUE .
  ENDIF .

  <fs_out>-sttxt = REDUCE #( INIT s   type ilom_sttxs
                                  sep type char03
                              FOR l IN lt_status
                            WHERE ( objnr = <fs_data>-objnr )
                             NEXT s   = s && sep && l-txt04
                                  sep = '/' ) .

  UNASSIGN <fs_out> .

ENDLOOP .