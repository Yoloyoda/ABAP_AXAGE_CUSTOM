CLASS zcl_axage_thing_list_c DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    TYPES _things TYPE STANDARD TABLE OF REF TO zcl_axage_thing_c WITH EMPTY KEY.
    METHODS constructor
      IMPORTING
        things TYPE _things OPTIONAL.
    METHODS get_list
      RETURNING VALUE(things) TYPE _things.
    METHODS get
      IMPORTING
        name         TYPE clike
      RETURNING
        VALUE(thing) TYPE REF TO zcl_axage_thing_c.
    METHODS show
      RETURNING
        VALUE(result) TYPE string_table.
    METHODS add
      IMPORTING
        thing         TYPE REF TO zcl_axage_thing_c
      RETURNING
        VALUE(result) TYPE REF TO zcl_axage_result_c.
    METHODS delete
      IMPORTING
        name TYPE clike.
    METHODS exists
      IMPORTING
        name          TYPE clike
      RETURNING
        VALUE(exists) TYPE abap_bool.
  PROTECTED SECTION.
    DATA things TYPE _things.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AXAGE_THING_LIST_C IMPLEMENTATION.


  METHOD add.
    APPEND thing TO things.
  ENDMETHOD.


  METHOD constructor.
    me->things = things.
  ENDMETHOD.


  METHOD delete.
    DELETE things WHERE table_line->name = name.
  ENDMETHOD.


  METHOD exists.
    exists =  xsdbool( line_exists( me->things[ table_line->name = name ]  ) ).
  ENDMETHOD.


  METHOD get.
    READ TABLE me->things INTO thing WITH KEY table_line->name  = name.
  ENDMETHOD.


  METHOD get_list.
    things = me->things.
  ENDMETHOD.


  METHOD show.
    LOOP AT things into DATA(currentThing).
      APPEND |a { currentThing->name } - { currentThing->description }| TO result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
