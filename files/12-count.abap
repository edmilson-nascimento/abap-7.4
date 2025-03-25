
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
  tab_sorted TYPE SORTED TABLE OF ty_SFLIGHT WITH NON-UNIQUE KEY currency.

SELECT carrid, connid, fldate, price, currency, planetype
  FROM sflight
  UP TO 999 ROWS
  INTO TABLE @DATA(lt_data).
IF sy-subrc <> 0.
  RETURN.
ENDIF.


DATA(lt_group) = VALUE tab_sorted( FOR GROUPS currency_group OF <line> IN lt_data
                                   GROUP BY <line>-currency ASCENDING
                                   ( currency = currency_group
                                     count    = REDUCE #(
                                        INIT int TYPE i FOR <group> IN lt_group
                                        NEXT int = int + 1 ) ) ).