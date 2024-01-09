# ABAP 7.4 / inline #
![Static Badge](https://img.shields.io/badge/development-abap-blue)
![GitHub commit activity (branch)](https://img.shields.io/github/commit-activity/t/edmilson-nascimento/abap-7.4)


The are annotations about new features and 'new' ways to do something better. ~~I hope it.~~

Eu ainda não decidi ao certo se vou colocar isso em ingles ou português ~~e por enquanto estai indo de acordo com meu humor do dia~~.


## Itens listados para processamento ##

- [Groups](#usando-collect-mas-com-reduce)
- [Collect / Reduce](#usando-collect-mas-com-reduce)
- [Date](#agrupamento-e-atribuição-com-groups)
- [Groups](#agrupamento-e-atribuição-com-groups)
- [Let](#agrupamento-e-atribuição-com-groups)
- [Loop](#agrupamento-e-atribuição-com-groups)
- [Range](#agrupamento-e-atribuição-com-groups)
- [Reduce](#agrupamento-e-atribuição-com-groups)
- [Reduce string](#agrupamento-e-atribuição-com-groups)
- [Timestap](#agrupamento-e-atribuição-com-groups)


### Agrupamento e atribuição com `groups`
Penso que esse seja o comando que eu mais gosto e provavelmente o mais desafiante usar da maneira correta. Detalhes no [file](/files/groups.abap) e uma previa abaixo.

```abap
data(lt_filter) =
  " Atribuição do tipo TT_PRPS
  value tt_prps(
  " Agrupa a Definição do Projeto na variavel DP
  for groups DP of ls_data in lt_pstab
  " Condicao para não retornar valores vazios
  where ( psphi is not initial )
  " Campo que sera agrupado 
  group by ls_data-psphi ascending
  " Atribuir a variavel
    ( psphi = DP ) ) .
```

### Usando `collect`, mas com `reduce` 
O Consultor SAP ABAP/PO Murilo Borges empre me diz que eu não gosto de usar o comando `collect`. E sim, devido as minhas experiências ruins que eu tive no começo do meu aprendizado com `ABAP` por não saber usar corretamente ~~ou porque alguns lugares usavam isso para finalizadade diferente do que foi criado~~.

Aqui um exemplo de como eu não uso ele e aplico outro codigo para mesma finalidade. No caso, a finalidade é:
1. Buscar dados dem uma tabela usando um campo como filtro (com mais de um valor proposto/pretendido)
2. Retornar todos os dados encontrados
3. Verificar, de acordo com os três valores informados, quais deles que possuem **todos os campos** usados no filtro.

> Na verdade, o intuito inicial é encontrar uma tabela/estrutura que tem todos os três campos que eu usei como filtro e não apenas um deles. Mas é assunto para outro podcast

Segue codigo de como isso foi feito logo abaixo e [aqui](/files/collect.abap) é possivel ver todo o codigo com as duas versões.

```abap
  lt_reduce = VALUE #(
    FOR GROUPS table OF <line> IN lt_data
    GROUP BY <line>-tabname
    ( tabname = table
      valor   = REDUCE i( INIT i TYPE i
                           FOR ls_field IN GROUP table
                          NEXT i = i + 1 ) )
  ).
```


### Date
.

### Groups
.

### Let
.

### Loop
.

### Range
.

### Reduce
.

### Reduce string
.

### Timestap
.



:)