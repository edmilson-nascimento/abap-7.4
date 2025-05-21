DO.
  " Seu código aqui
  " Preenchimento de lt_item_single
  
  " ...
  
  " Combinar tabelas usando VALUE com BASE
  lt_item = VALUE #( BASE lt_item
                    ( LINES OF lt_item_single ) ).
  
  " Limpar para próxima iteração
  REFRESH lt_item_single.
  