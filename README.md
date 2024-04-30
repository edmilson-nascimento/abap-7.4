# ABAP 7.4 / inline #
![Static Badge](https://img.shields.io/badge/development-abap-blue)
![GitHub commit activity (branch)](https://img.shields.io/github/commit-activity/t/edmilson-nascimento/abap-7.4)


The are annotations about new features and 'new' ways to do something better. ~~I hope it.~~

Eu ainda não decidi ao certo se vou colocar isso em ingles ou português ~~e por enquanto estai indo de acordo com meu humor do dia~~.

## Dica
Bem, depois de algum tempo, antes de avançar com qualquer ajuste, achei importante deixar um ponto de atenção para se pensar.

```mermaid
flowchart TD
    
    Start((start)) --> DadosTeste[(Cenários de testes)]
    
    DadosTeste --> Debug(Debug e avaliação de cenários)
    Debug --> CheckAcao{Haverá impacto?} 

    CheckAcao --> sim((Sim))
    sim --> DadosTeste
    
    CheckAcao --> nao((não))
    
    nao --> Fix(Aplicar correção)

    Fix --> Finish([Finish])
```


## Itens listados para processamento ##

- [Groups](#usando-collect-mas-com-reduce)
- [Collect / Reduce](#usando-collect-mas-com-reduce)
- [Date](#date)
- [Groups](#Groups)
- [Let](#Let)
- [Loop](#Loop)
- [Range](#Range)
- [Reduce](#Reduce)
- [Reduce string](#reduce-string)
- [Timestamp](#Timestamp)
- [Diferença entre duas tabelas](#Diferenca-entre-duas-tabelas)
- [Mapping](#Mapping)


### Agrupamento e atribuição com `groups`
Penso que esse seja o comando que eu mais gosto e provavelmente o mais desafiante usar da maneira correta. Detalhes no [file](/files/01-groups.abap) e uma previa abaixo.

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

Segue codigo de como isso foi feito logo abaixo e [aqui](/files/02-collect.abap) é possivel ver todo o codigo com as duas versões.

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
A conversão de dados tem como exemplo no [file](/files/03-date.abap). Exitem maneiras diferentes de se fazer isso para obter diferentes formatos.


### Let
 [file](/files/04-let.abap)

### Loop
 [file](/files/05-loop.abap)

### Range
 [file](/files/06-range.abap)

### Reduce
 [file](/files/07-reduce.abap)

### Reduce string
 [file](/files/08-reduce_string.abap)

### Timestamp
 [file](/files/09-timestamp.abap)

### Diferenca-entre-duas-tabelas
 [file](/files/10-diff-sorted.abap)

### Mapping
Mapeamento para quando as tabelas tem campos diferentes. [file](/files/11-mapping.abap)
