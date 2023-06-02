CLASS zcl_axage_map_c DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    METHODS add_room
      IMPORTING
        room TYPE REF TO zcl_axage_room_c.
    METHODS get_room
      IMPORTING
        name        TYPE clike
      RETURNING
        VALUE(room) TYPE REF TO zcl_axage_room_c.
    METHODS set_floor_plan
      IMPORTING
        input TYPE string_table.
    METHODS show
      RETURNING
        VALUE(result) TYPE string_table.
  PROTECTED SECTION.
    TYPES _map TYPE STANDARD TABLE OF REF TO zcl_axage_room_c.
    DATA map TYPE _map.
    DATA floor_plan TYPE string_table.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AXAGE_MAP_C IMPLEMENTATION.


  METHOD add_room.
    APPEND room TO map.
  ENDMETHOD.


  METHOD get_room.
    READ TABLE map WITH KEY table_line->name = name INTO room.
    IF room IS INITIAL.
      room = zcl_axage_room_c=>no_exit.
    ENDIF.
  ENDMETHOD.


  METHOD set_floor_plan.
    me->floor_plan = input.
  ENDMETHOD.


  METHOD show.
    result = floor_plan.
  ENDMETHOD.
ENDCLASS.
