*&---------------------------------------------------------------------*
*& Report YTEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
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

  IF lv_class_uc CS '|' OR lv_class_uc IS INITIAL.

    DATA(lv_class_0038) = REDUCE string(
      INIT text TYPE string
       FOR ls_out IN gt_output
     WHERE ( object = <fs_output>-object )
      NEXT text = COND string(
                    WHEN text = '' THEN ls_out-class_0038
                    WHEN text NS ls_out-class_0038 THEN text && '|' && ls_out-class_0038  ) ).
  ENDIF.

ENDLOOP .

*DATA:
*  customer_01        TYPE scustom,
*  bookings        TYPE ty_bookings,
*  connections     TYPE ty_connections,
*  fm_name         TYPE rs38l_fnam,
*  fp_docparams    TYPE sfpdocparams,
*  fp_outputparams TYPE sfpoutputparams.
*
*DATA:
*  form_name TYPE fpname VALUE 'ZTESTE'.
*
** GETTING THE DATA
*
*
** PRINT:
*
** Sets the output parameters and opens the spool job
*CALL FUNCTION 'FP_JOB_OPEN'
*  CHANGING
*    ie_outputparams = fp_outputparams
*  EXCEPTIONS
*    cancel          = 1
*    usage_error     = 2
*    system_error    = 3
*    internal_error  = 4
*    OTHERS          = 5.
*IF sy-subrc <> 0.
*  RETURN .
*ENDIF.
*
** Get the name of the generated function module
*CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
*  EXPORTING
*    i_name     = form_name
*  IMPORTING
*    e_funcname = fm_name.
*IF sy-subrc <> 0.
*  RETURN .
*ENDIF.
*
** Call the generated function module
*CALL FUNCTION fm_name
*  EXPORTING
*    /1bcdwb/docparams = fp_docparams
*    customer          = customer_01
*    bookings          = bookings
*    connections       = connections
**   IMPORTING
**   /1BCDWB/FORMOUTPUT       =
*  EXCEPTIONS
*    usage_error       = 1
*    system_error      = 2
*    internal_error    = 3.
*IF sy-subrc <> 0.
*  RETURN .
*ENDIF.
*
** Close the spool job
*CALL FUNCTION 'FP_JOB_CLOSE'
**   IMPORTING
**    E_RESULT             =
*  EXCEPTIONS
*    usage_error    = 1
*    system_error   = 2
*    internal_error = 3
*    OTHERS         = 4.
*IF sy-subrc <> 0.
*  RETURN .
*ENDIF.