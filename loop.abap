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

endloop .
