CLASS zcl_package DEFINITION
  INHERITING FROM zcl_base_example
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      manage_package,
      process_package.

  PRIVATE SECTION.
    DATA: lt_package_data TYPE TABLE OF string.

ENDCLASS.

CLASS zcl_package IMPLEMENTATION.

  METHOD manage_package.
    " Manage package data
    APPEND 'Package Data 1' TO lt_package_data.
    APPEND 'Package Data 2' TO lt_package_data.
  ENDMETHOD.

  METHOD process_package.
    " Process the package data
    LOOP AT lt_package_data INTO DATA(lv_data).
      " Example processing logic
      WRITE: / 'Processing:', lv_data.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.