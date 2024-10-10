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
          carrid    TYPE sflight-carrid,
          connid    TYPE sflight-connid,
          fldate    TYPE sflight-fldate,
          price     TYPE sflight-price,
          currency  TYPE sflight-currency,
          planetype TYPE sflight-planetype,
          count     TYPE i,
        END OF ty_SFLIGHT,
        tab_sorted TYPE SORTED TABLE OF ty_SFLIGHT WITH NON-UNIQUE KEY CURRENCY.
      
      BREAK-POINT.
      
      
      SELECT CARRID, CONNID, FLDATE, PRICE, CURRENCY, PLANETYPE
        FROM SFLIGHT
        up to 999 rows
        into table @data(lt_data).
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
      
      
      data(lt_group) = value tab_sorted(
        for GROUPS currency_group of <line> in lt_data
      group by <line>-currency ASCENDING
        ( currency = currency_group )
      
       ).
      
      
      