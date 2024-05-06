* by Sara Martins

DATA the_date TYPE d VALUE '19891130'.
|{ the_date }|  "=> '19891130', internal format
|{ the_date DATE = ISO }| '1989-11-30', output in ISO format
|{ the_date DATE = USER }| '11/30/1989', '30.11.1989',

ls_out-date_creation = |{ ls_att-crdat DATE = USER }|.
ls_out-time_creation = |{ ls_att-crtim TIME = ISO }|.

"RAW, ISO, USER, ENVIRONMENT...
