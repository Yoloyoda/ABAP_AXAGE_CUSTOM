CLASS zcl_axage_room_c DEFINITION INHERITING FROM zcl_axage_thing
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA north TYPE REF TO zcl_axage_room_c.
    DATA east TYPE REF TO zcl_axage_room_c.
    DATA south TYPE REF TO zcl_axage_room_c.
    DATA west TYPE REF TO zcl_axage_room_c.
    DATA things TYPE REF TO zcl_axage_thing_list_c.
    CLASS-DATA no_exit TYPE REF TO zcl_axage_room_c.
    CLASS-METHODS class_constructor.
    METHODS constructor
      IMPORTING
        name  TYPE clike
        descr TYPE clike.
    METHODS set_exits
      IMPORTING
        n TYPE REF TO zcl_axage_room_c OPTIONAL
        e TYPE REF TO zcl_axage_room_c OPTIONAL
        s TYPE REF TO zcl_axage_room_c OPTIONAL
        w TYPE REF TO zcl_axage_room_c OPTIONAL.
  PROTECTED SECTION.
    METHODS set_exit
      IMPORTING
        room        TYPE REF TO zcl_axage_room_c
      RETURNING
        VALUE(exit) TYPE REF TO zcl_axage_room_c.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AXAGE_ROOM_C IMPLEMENTATION.


  METHOD class_constructor.
    no_exit = NEW zcl_axage_room_c( name = 'No Exit' descr = 'There is no exit in this direction...' ).
  ENDMETHOD.


  METHOD constructor.
    super->constructor( name = name descr = descr ).
    things = NEW #( ).
  ENDMETHOD.


  METHOD set_exit.
    IF room IS BOUND.
      exit = room.
    ELSE.
      exit = no_exit.
    ENDIF.
  ENDMETHOD.


  METHOD set_exits.
    north = set_exit( n ).
    east  = set_exit( e ).
    south = set_exit( s ).
    west  = set_exit( w ).
  ENDMETHOD.
ENDCLASS.
