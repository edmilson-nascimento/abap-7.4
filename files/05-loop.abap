types:
  begin of ty_header,
    id   type i,
    type type char10,
  end of ty_header,
  tab_headers type standard table of ty_header
               with default key,

  begin of ty_item,
    id   type i,
    item type i,
    desc type char10,
  end of ty_item,
  tab_items type standard table of ty_item
               with default key,

  begin of ty_out,
    id   type i,
    type type char10,
    item type i,
    desc type char10,
  end of ty_out,
  tab_out type standard table of ty_out
               with default key .

data:
  lt_out type tab_out,
  ls_out type ty_out.

data(lt_headers) =
  value tab_headers(
     ( id  = 1
       type = 'Car' )
     ( id  = 2
       type = 'Motorbike' )
   ) .


data(lt_items) =
  value tab_items(
    ( id   = 1
      item = 10
      desc = 'Audi' )
    ( id   = 1
      item = 20
      desc = 'Mercedes Benz' )

    ( id   = 2
      item = 10
      desc = 'Triumph' )
    ( id   = 2
      item = 20
      desc = 'Velocette' )
  ) .


lt_out = 
  value #(
    for l in lt_header (
      id   = l-id
      type = l-type
    )
  ).

* To be improve
loop at lt_headers into data(ls_header) .

  loop at lt_items into data(ls_item)
    where id eq ls_header-id .

    ls_out =
      value ty_out(
        id   = ls_header-id
        type = ls_header-type
        item = ls_item-item
        desc = ls_item-desc
    ).
    append ls_out to lt_out .

  endloop .
  
* Gilberto's improviments
DATA(lt_final) =
  VALUE tab_out(
    FOR ls_item IN lt_items
      FOR ls_header IN lt_headers FROM line_index( lt_headers[ id = ls_item-id ] )
        WHERE ( id = ls_item-id )

      LET ls_final =
        VALUE ty_out( id   = ls_header-id
                      type = ls_header-type
                      item = ls_item-item
                      desc = ls_item-desc )

      IN ( CORRESPONDING #( BASE ( ls_final ) ls_item ) ) ) .

endloop .

* Append quando a tabela ja tem dados

    data(lines_body) = lines_header .
    
    result = value soli_tab(
      for l in lines_header ( line = l-tdline ) ) .
      
loop at ....
[14:23] Renato Lara
* no seu caso aí se você que conservar as linhas que já estavam no 
* "result" você tem que por um BASE result entre o ( e o FOR

[14:24] Renato Lara
result = value soli_tab( base result for l in line_itens..............

  append lines of lines_items to lines_body .
  result = value soli_tab(
    base result for l in lines_items ( line = l-tdline ) ) .
endloop.

method set .

  if ( lines( me->gt_produto_acabado ) eq 0 ) or
     ( lines( me->gt_componentes )     eq 0 ) .
    return .
  endif .

  me->gt_out =
    value #(
      for c in me->gt_componentes
        for p in me->gt_produto_acabado
          from line_index(
            me->gt_produto_acabado[ aufnr = c-aufnr ] )
          where ( aufnr = c-aufnr )
        " Dados do Produto Acabado
        let ls_out =
          value zpps_0009(
            matnr = p-matnr
            maktx = p-maktx
            gmein = p-gmein
            gamng = p-gamng
            igmng = p-igmng
            lmnga = p-lmnga
            aufnr = p-aufnr
            auart = p-auart
            werks = p-werks
            lgort = p-lgort
            gltri = p-gltri

            lt_alternativa = p-lt_alternativa
            versao         = p-versao )

        in ( corresponding #( base ( ls_out ) c ) ) ) .

