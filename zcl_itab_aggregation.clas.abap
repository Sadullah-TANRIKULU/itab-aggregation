CLASS zcl_itab_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_numbers_type,
             group  TYPE group,
             number TYPE i,
           END OF initial_numbers_type,
           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.

    TYPES: BEGIN OF aggregated_data_type,
             group   TYPE group,
             count   TYPE i,
             sum     TYPE i,
             min     TYPE i,
             max     TYPE i,
             average TYPE f,
           END OF aggregated_data_type,
           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.

    METHODS perform_aggregation
      IMPORTING
        initial_numbers        TYPE initial_numbers
      RETURNING
        VALUE(aggregated_data) TYPE aggregated_data.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_itab_aggregation IMPLEMENTATION.
  METHOD perform_aggregation.
    " add solution here
      data wa_in type initial_numbers_type.
      data wa_ad type aggregated_data_type.

loop at initial_numbers into wa_in.

      read table aggregated_data with key group = wa_in-group into wa_ad.
      data(indx) = sy-tabix.
  if sy-subrc <> 0.
      wa_ad-group = wa_in-group.
      wa_ad-count = 1.
      wa_ad-sum = wa_in-number.
      wa_ad-max = wa_in-number.
      wa_ad-min = wa_in-number.
      wa_ad-average = wa_in-number.
    append wa_ad to aggregated_data.
  
  else.
      wa_ad-group = wa_in-group.
      wa_ad-count = wa_ad-count + 1.
      wa_ad-sum = wa_ad-sum + wa_in-number.
    if wa_in-number > wa_ad-max.
      wa_ad-max = wa_in-number.
    ENDIF.
    if wa_in-number < wa_ad-min.
      wa_ad-min = wa_in-number.
    endif.
    wa_ad-average = wa_ad-sum / wa_ad-count.
    modify aggregated_data INDEX indx FROM wa_ad.  
    
  endif.

ENDLOOP.   

  ENDMETHOD.

ENDCLASS.
