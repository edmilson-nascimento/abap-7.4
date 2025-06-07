# ABAP 7.4 / Modern ABAP Development #
![ABAP](https://img.shields.io/badge/ABAP-7.4-blue?style=flat&logo=sap)
![SAP](https://img.shields.io/badge/SAP-ECC%206.0-blue?style=flat&logo=sap)
![S/4HANA](https://img.shields.io/badge/S%2F4HANA-2023-blue?style=flat&logo=sap)
![SAP](https://img.shields.io/badge/SAP-On%20Premise-blue?style=flat&logo=sap)
![ABAP OO](https://img.shields.io/badge/ABAP-Object%20Oriented-orange?style=flat&logo=sap)
![Development](https://img.shields.io/badge/Development-ABAP-brightgreen?style=flat&logo=sap)

![GitHub](https://img.shields.io/badge/GitHub-Repository-black?style=flat&logo=github)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/edmilson-nascimento/abap-7.4?style=flat)
![GitHub last commit](https://img.shields.io/github/last-commit/edmilson-nascimento/abap-7.4?style=flat)
![GitHub issues](https://img.shields.io/github/issues/edmilson-nascimento/abap-7.4?style=flat)
![GitHub stars](https://img.shields.io/github/stars/edmilson-nascimento/abap-7.4?style=flat)
![License](https://img.shields.io/github/license/edmilson-nascimento/abap-7.4?style=flat)

This repository contains examples and best practices for modern ABAP development using ABAP 7.4+ features. The goal is to demonstrate more efficient and cleaner ways to write ABAP code.

> Note: The examples are provided in both English and Portuguese to reach a wider audience.

## Development Guidelines
Before implementing any changes in your ABAP system, it's important to follow these testing guidelines:

```mermaid
flowchart TD
    Start((start)) --> DadosTeste[(Cenários de testes)]
    
    DadosTeste  --> Debug(Debug e avaliação de cenários)
    Debug       --> CheckAcao{Haverá impacto?} 

    CheckAcao --> sim((Sim))
    sim       --> DadosTeste
    
    CheckAcao --> nao((não))
    
    nao       --> Fix(Aplicar correção)

    Fix       --> Finish([Finish])
```

## Features and Examples
This repository covers the following ABAP 7.4+ features:

### Groups in ABAP
One of the most powerful features in modern ABAP is the `GROUPS` functionality, enabling efficient data grouping and aggregation. [See examples](/files/01-groups.abap)

```abap
DATA(lt_filter) = VALUE tt_prps(
  FOR GROUPS DP OF ls_data IN lt_pstab
  WHERE ( psphi IS NOT INITIAL )
  GROUP BY ls_data-psphi ASCENDING
  ( psphi = DP ) ).
```

### COLLECT and REDUCE Operations
Modern alternatives to traditional COLLECT using REDUCE. [See examples](/files/02-collect.abap)

### Date Formatting
Modern date conversion and formatting techniques:
```abap
ls_out-date_creation = |{ ls_att-crdat DATE = USER }|.
ls_out-time_creation = |{ ls_att-crtim TIME = ISO }|.
```
[See more examples](/files/03-date.abap)

### LET Expressions 
Using LET for improved code readability. [See examples](/files/04-let.abap)

### Loop Constructs
Modern loop patterns and best practices. [See examples](/files/05-loop.abap)

### Range Operations
Simplified range handling. [See examples](/files/06-range.abap)

### REDUCE Operations
Data aggregation using REDUCE. [See examples](/files/07-reduce.abap)

### String Operations
Text processing with modern ABAP. [See examples](/files/08-reduce_string.abap)

### Timestamp Operations
Modern timestamp handling. [See examples](/files/09-timestamp.abap)

### Sorted Table Operations
Working with sorted tables efficiently. [See examples](/files/10-diff-sorted.abap)

### Field Mapping
Advanced field mapping techniques. [See examples](/files/11-mapping.abap)

### Counting Operations
Efficient counting in tables. [See examples](/files/12-count.abap)

### Index Operations
Working with table indices. [See examples](/files/13-index.abap)

### Split Operations
Modern string and table splitting. [See examples](/files/14-split.abap)

### Package Processing
Handling large data sets in packages. [See examples](/files/15-package.abap)

### Base Table Operations
Working with base tables and modifications. [See examples](/files/16-base.abap)
