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