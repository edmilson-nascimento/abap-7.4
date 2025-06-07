DATA: the_date TYPE d VALUE '19891130'.

WRITE: / |{ the_date }|,          " Internal format
       / |{ the_date DATE = ISO }|, " Output in ISO format
       / |{ the_date DATE = USER }|. " User format

ls_out-date_creation = |{ ls_att-crdat DATE = USER }|.
ls_out-time_creation = |{ ls_att-crtim TIME = ISO }|.