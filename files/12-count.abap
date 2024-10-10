DATA(lv_lines) = REDUCE i( 
  INIT count = 0
  FOR ls_data IN lt_data
  FOR lo_data IN REF #( ls_data-data )->*
  WHERE ( lo_data IS ASSIGNED )
  FOR lo_data_info IN lo_data
  LET external_id_part = CONV string( lo_data_info-external_id(8) )
  IN 
    ( IF external_id_part = me->external_id(8)
      THEN count + 1
      ELSE count ) ).


        TYPES:
        "! <p class="shorttext synchronized" lang="PT">Estrutura de Documento financeiro</p>
        BEGIN OF ty_SFLIGHT,
          CARRID      TYPE SFLIGHT-CARRID,
          CONNID      TYPE SFLIGHT-CONNID,
          FLDATE      TYPE SFLIGHT-FLDATE,
          PRICE      TYPE SFLIGHT-PRICE,
          CURRENCY      TYPE SFLIGHT-CURRENCY,
          PLANETYPE      TYPE SFLIGHT-PLANETYPE,
          count      TYPE i,
        END OF ty_SFLIGHT,
        tab_sorted TYPE sorted TABLE OF ty_SFLIGHT WITH DEFAULT KEY.
      
      BREAK-POINT.
      
      
      SELECT CARRID, CONNID, FLDATE, PRICE, CURRENCY, PLANETYPE
        FROM SFLIGHT
        up to 999 rows 
        into table @data(lt_data).
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
      
      
      
      DATA(lv_lines) = REDUCE i( 
        INIT count = 0
        FOR ls_data IN lt_data
          ( count = count + 1 ) ).
      *  data(lt_soted) =
      
      