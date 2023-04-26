
    DATA:
      date            TYPE sy-datum VALUE '20230119',
      salary_time_tab TYPE STANDARD TABLE OF zsalary_time.

    CONVERT DATE date
       INTO TIME STAMP DATA(start_date)
       TIME ZONE space .

    CONVERT DATE date
       INTO TIME STAMP DATA(end_date)
       TIME ZONE space .

*

]