CLASS zcl_axage_actor_c DEFINITION INHERITING FROM zcl_axage_thing_c
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA location TYPE REF TO zcl_axage_room_c.
    DATA things TYPE REF TO zcl_axage_thing_list_c.
    METHODS constructor
      IMPORTING
        name  TYPE clike
        descr TYPE clike.
    METHODS set_location
      IMPORTING
        room TYPE REF TO zcl_axage_room_c.
    METHODS get_location
      RETURNING
        VALUE(room) TYPE REF TO zcl_axage_room_c.
    METHODS speak
      RETURNING
        VALUE(sentences) TYPE string_table.
    METHODS set_mchoice
      IMPORTING
        mchoice TYPE string_table.
    METHODS set_question
      IMPORTING
        question TYPE string.
    METHODS set_answer
      IMPORTING
        answer TYPE string.
    METHODS set_image
      IMPORTING
        image TYPE string.
    METHODS get_mchoice
      RETURNING
        VALUE(mchoice) TYPE string_table.
    METHODS get_question
      RETURNING
        VALUE(question) TYPE string.
    METHODS get_answer
      RETURNING
        VALUE(answer) TYPE string.
    METHODS get_image
      RETURNING
        VALUE(image) TYPE string.
    METHODS add_sentences
      IMPORTING
        sentences TYPE string_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA my_sentences TYPE string_table.
    DATA my_mchoices  TYPE string_table.
    DATA my_answer    TYPE string.
    DATA my_question  TYPE string.
    DATA my_image  TYPE string.
ENDCLASS.



CLASS zcl_axage_actor_c IMPLEMENTATION.


  METHOD add_sentences.
    my_sentences = sentences.
  ENDMETHOD.


  METHOD constructor.
    super->constructor( name = name descr = descr ).
    things = NEW #( ).
  ENDMETHOD.


  METHOD get_location.
    room = location.
  ENDMETHOD.


  METHOD set_location.
    location = room.
  ENDMETHOD.


  METHOD speak.
    sentences = my_sentences.
  ENDMETHOD.

  METHOD set_mchoice.
    my_mchoices = mchoice.
  ENDMETHOD.

  METHOD set_answer.
    my_answer = answer.
  ENDMETHOD.

  METHOD set_question.
    my_question = question.
  ENDMETHOD.

  METHOD set_image.
    my_image = image.
  ENDMETHOD.

  METHOD get_mchoice.
    mchoice = my_mchoices.
  ENDMETHOD.

  METHOD get_answer.
    answer = my_answer.
  ENDMETHOD.

  METHOD get_question.
    question = my_question.
  ENDMETHOD.

  METHOD get_image.
    image = my_image.
  ENDMETHOD.

ENDCLASS.
