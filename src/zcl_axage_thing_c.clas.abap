CLASS zcl_axage_thing_c DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    DATA name TYPE string.
    DATA description TYPE string.

    METHODS constructor
      IMPORTING
        name  TYPE clike
        descr TYPE clike.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AXAGE_THING_C IMPLEMENTATION.


  METHOD constructor.
    me->name = name.
    me->description = descr.
  ENDMETHOD.
ENDCLASS.
