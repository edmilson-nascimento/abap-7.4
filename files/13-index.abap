*Define structure
TYPES:
  BEGIN OF ty_struct1,
    field1 TYPE i,
    field2 TYPE string,
  END OF ty_struct1,
  BEGIN OF ty_struct2,
    field1 TYPE i,
    field2 TYPE string,
    field3 TYPE i,
  END OF ty_struct2.

*Define table types
TYPES:  gtt_struct1 TYPE STANDARD TABLE OF ty_struct1 WITH DEFAULT KEY,
        gtt_struct2 TYPE STANDARD TABLE OF ty_struct2 WITH DEFAULT KEY.

        * Initialize source table with some random values
DATA(lt_source) = VALUE gtt_struct1(
    ( field1 = 1 field2 = 'A' )
    ( field1 = 2 field2 = 'B' ) ).

    *Populate sy-tabix in the additional fields within the for loop
DATA(lt_target2) = VALUE gtt_struct2( FOR lwa_source IN lt_source
                            INDEX INTO index
                            LET base = VALUE ty_struct2( field3 = index )
                            IN ( CORRESPONDING #( BASE ( base ) lwa_source ) ) ).

cl_demo_output=>display( lt_target2 ).