CLASS zcl_abapaxage_custom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA:gv_command TYPE string,
         gv_results TYPE string,
         gv_help    TYPE string,
         gv_map     TYPE string.

    METHODS:set_battle
      IMPORTING
        im_t_mchoices TYPE string_table
        im_v_answer   TYPE string
        im_v_question TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: gv_initialized   TYPE abap_boolean,
          engine           TYPE REF TO zcl_axage_engine_c,
          bill_developer   TYPE REF TO zcl_axage_actor_c,
          mark_consultant  TYPE REF TO zcl_axage_actor_c,
          abapaxage_custom TYPE REF TO zcl_abapaxage_custom,
          gv_battle        TYPE abap_boolean,
          gt_mchoices      TYPE string_table,
          gv_answer        TYPE string,
          gv_question      TYPE string.

    METHODS: init_game,
      initialization,
      event_handler
        IMPORTING im_o_client TYPE REF TO z2ui5_if_client,
      process_battle
        IMPORTING
          im_o_client TYPE REF TO z2ui5_if_client
        CHANGING
          ch_o_page   TYPE REF TO z2ui5_cl_xml_view.
ENDCLASS.



CLASS zcl_abapaxage_custom IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    initialization( ).
    event_handler( EXPORTING im_o_client = client ).

    "Create UI
    DATA(lo_view) = z2ui5_cl_xml_view=>factory( )->shell( ).

    DATA(lo_page) = lo_view->page( title = 'abap - Axeage'
                 navbuttonpress = client->_event( 'BACK' )
            ).

    "Fixed UI components
    lo_page->simple_form( title = 'Axeage game' editable = abap_true
               )->title( 'Input'
                   )->label( 'Command'
                   )->input( value = client->_bind( gv_command )
                   )->vertical_layout( width = '50%'
                   )->button( text  = 'Execute Command' press = client->_event( 'BUTTON_COMMAND' )
                   )->horizontal_layout( width = '50%'
                   )->button( icon  = 'sap-icon://arrow-left' press = client->_event( 'WEST' )
                   )->button( icon  = 'sap-icon://arrow-top'  press = client->_event( 'NORTH' )
                   )->button( icon  = 'sap-icon://arrow-bottom'  press = client->_event( 'SOUTH' )
                   )->button( icon  = 'sap-icon://arrow-right' press = client->_event( 'EAST' ) ).

    "Fixed UI components
    lo_page->simple_form( title = 'Game Console' editable = abap_true )->content( 'form'
        )->horizontal_layout( width = '100%'
        )->code_editor( value = client->_bind( gv_results ) editable = 'false' type = `plain_text` height = '300px' width = '400px'
        )->label( '　'  "Dummy space
        )->text_area( value = client->_bind( gv_help ) editable = 'false' height = '300px' width = '400px'
        )->label( '　'  "Dummy space
        )->code_editor( value = client->_bind( gv_map ) editable = 'false' type = `plain_text` height = '300px' width = '400px'
        ).

    process_battle( EXPORTING im_o_client = client
                    CHANGING  ch_o_page   = lo_page ).

    "view rendering
    client->set_next( VALUE #( xml_main = lo_page->get_root( )->xml_get( ) ) ).

  ENDMETHOD.

  METHOD init_game.
    abapaxage_custom = NEW #( ).
    engine = NEW #( ).
    DATA(entrance)   = NEW zcl_axage_room_c( name = 'Entrance' descr = 'You are in the entrance area. Welcome.' ).
    DATA(developer)  = NEW zcl_axage_room_c( name = 'Developers office' descr = 'The developers area. be quiet!' ).
    DATA(consulting) = NEW zcl_axage_room_c( name = 'Consulting Department' descr = 'This is the area where the consultants work. Bring coffee!' ).

    engine->map->add_room( entrance ).
    engine->map->add_room( developer ).
    engine->map->add_room( consulting ).
    engine->map->set_floor_plan( VALUE #(
      ( `+--------------------+ +--------------------+` )
      ( `|                    | |                    |` )
      ( `|                    | |                    |` )
      ( `|                    +-+                    |` )
      ( `|     ENTRANCE              DEVELOPERS      |` )
      ( `|                    +-+                    |` )
      ( `|                    | |        Bill        |` )
      ( `|                    | |                    |` )
      ( `+--------+  +--------+ +--------------------+` )
      ( `         |  |` )
      ( `+--------+  +--------+` )
      ( `|                    |` )
      ( `|                    |` )
      ( `|                    |` )
      ( `|   CONSULTANTS      |` )
      ( `|                    |` )
      ( `|           Mark     |` )
      ( `|                    |` )
      ( `+--------------------+` ) ) ).

    entrance->set_exits(
      e = developer
      s = consulting ).
    developer->set_exits(
      w = entrance ).
    consulting->set_exits(
      n = entrance ).
    DATA(cutter_knife) = NEW zcl_axage_thing_c( name = 'KNIFE' descr = 'a very sharp cutter knife' ).
    developer->things->add( cutter_knife ).
    DATA(needed_to_open_box) = NEW zcl_axage_thing_list_c(  ).
    needed_to_open_box->add( cutter_knife ).
    DATA(content_of_box) = NEW zcl_axage_thing_list_c( ).
    content_of_box->add( NEW zcl_axage_thing_c( name = 'RFC' descr = 'The request for change.' ) ).
    DATA(card_box) = NEW zcl_axage_openable_thing_c(
      name    = 'BOX'
      descr   = 'a little card box'
      content = content_of_box
      needed  = needed_to_open_box ).
    consulting->things->add( card_box ).

    engine->player->set_location( entrance ).

    bill_developer = NEW #( name = 'Bill' descr = 'An ABAP developer' ).
    bill_developer->set_location( developer ).
    bill_developer->add_sentences( VALUE #(
      ( |Hey, I am Bill, an experienced ABAP developer.| )
      ( |I challenge you to a riddle. If you choose wrong answer, you'll have to start over.| )
      ( |...here we go| )
      ) ).
    bill_developer->set_mchoice( VALUE #(
      ( |Kyma Environment | )
      ( |SAP Successfactors| )
      ( |SteamPunk| )
      ( |SAP GUI| )
      ) ).
    bill_developer->set_question( |I live inside S4 HANA and Businesss Technology Platform. I have my own language version and help with developing upgrade-stable extensions. What am I?| ).
    bill_developer->set_answer( |SteamPunk| ).

    mark_consultant = NEW #( name = 'Mark' descr = 'An SAP consultant' ).
    mark_consultant->set_location( consulting ).
    mark_consultant->add_sentences( VALUE #(
      ( |Hello, My name is Mark and I am an SAP consultant| )
      ( |I challenge you to a quiz. If you choose wrong answer, it's game over.| )
      ( |...here we go| )
      ) ).
    mark_consultant->set_mchoice( VALUE #(
      ( |SAP ID for Me | )
      ( |SAP ID for Life| )
      ( |SAP Universal Number| )
      ( |SAP Universal ID| )
      ) ).
    mark_consultant->set_question( |What is the name of new SAP account management which provides a unified account across multipleSAP sites, such as S-users and P-users?| ).
    mark_consultant->set_answer( |SAP Universal ID| ).

    engine->actors->add( bill_developer ).
    engine->actors->add( mark_consultant ).
  ENDMETHOD.

  METHOD initialization.
    IF gv_initialized = abap_false.
      gv_initialized = abap_true.
      gv_command = 'MAP'.
      init_game(  ).
      gv_help = engine->interprete( 'HELP' )->get( ).
      gv_map  = engine->interprete( 'MAP' )->get( ).
    ENDIF.
  ENDMETHOD.


  METHOD event_handler.

    gv_command = SWITCH #( im_o_client->get( )-event
                                  WHEN 'WEST' THEN 'W'
                                  WHEN 'NORTH' THEN 'N'
                                  WHEN 'SOUTH' THEN 'S'
                                  WHEN 'EAST' THEN 'E'
                                  ELSE gv_command
                              ).

    "event handling
    CASE im_o_client->get( )-event.
      WHEN 'BUTTON_COMMAND'
        OR 'WEST' OR 'NORTH' OR 'SOUTH' OR 'EAST'.

        im_o_client->popup_message_toast( |{ gv_command } - send to the server| ).
        DATA(result) = engine->interprete( EXPORTING command = gv_command
                                           CHANGING ch_o_abapaxage_custom = abapaxage_custom ).

        IF engine->player->location->things->exists( 'RFC' ).
          engine->mission_completed = abap_true.
          result->add( 'Congratulations! You delivered the RFC to the developers!' ).
        ENDIF.
        gv_results = |{ result->get(  ) } \n | &&  gv_results.

      WHEN 'BACK'.
        im_o_client->nav_app_leave( im_o_client->get_app( im_o_client->get( )-id_prev_app_stack  ) ).
    ENDCASE.

  ENDMETHOD.



  METHOD process_battle.

    IF abapaxage_custom->gv_battle IS INITIAL.
      RETURN.
    ENDIF.


* "Fixed UI components
*    lo_page->simple_form( title = 'Axeage game' editable = abap_true
*               )->title( 'Input'
*                   )->label( 'Command'
*                   )->input( value = client->_bind( gv_command )
*                   )->vertical_layout( width = '50%'
*                   )->button( text  = 'Execute Command' press = client->_event( 'BUTTON_COMMAND' )
*                   )->horizontal_layout( width = '50%'
*                   )->button( icon  = 'sap-icon://arrow-left' press = client->_event( 'WEST' )
*                   )->button( icon  = 'sap-icon://arrow-top'  press = client->_event( 'NORTH' )
*                   )->button( icon  = 'sap-icon://arrow-bottom'  press = client->_event( 'SOUTH' )
*                   )->button( icon  = 'sap-icon://arrow-right' press = client->_event( 'EAST' ) ).
*
*    "Fixed UI components
*    lo_page->simple_form( title = 'Game Console' editable = abap_true )->content( 'form'
*        )->horizontal_layout( width = '100%'
*        )->code_editor( value = client->_bind( gv_results ) editable = 'false' type = `plain_text` height = '300px' width = '400px'
*        )->text_area( value = client->_bind( gv_help ) editable = 'false' height = '300px' width = '400px'
*        )->code_editor( value = client->_bind( gv_map ) editable = 'false' type = `plain_text` height = '300px' width = '400px'
*        ).

    READ TABLE abapaxage_custom->gt_mchoices INTO DATA(lv_choice1) INDEX 1.
    READ TABLE abapaxage_custom->gt_mchoices INTO DATA(lv_choice2) INDEX 2.
    READ TABLE abapaxage_custom->gt_mchoices INTO DATA(lv_choice3) INDEX 3.
    READ TABLE abapaxage_custom->gt_mchoices INTO DATA(lv_choice4) INDEX 4.

    ch_o_page->simple_form( title = 'Battle Console' editable = abap_true )->content( 'form'
        )->horizontal_layout(
        )->label( 'Question'
        )->label( '　'  "Dummy space
        )->text_area( value = abapaxage_custom->gv_question editable = 'false' height = '100px' width = '400px'
        )->label( '　'  "Dummy space
        )->vertical_layout( width = '100%'
        )->button( icon  = 'sap-icon://feeder-arrow' text = lv_choice1 press = im_o_client->_event( 'CHOICE1' )
        )->button( icon  = 'sap-icon://feeder-arrow' text = lv_choice2 press = im_o_client->_event( 'CHOICE2' )
        )->button( icon  = 'sap-icon://feeder-arrow' text = lv_choice3 press = im_o_client->_event( 'CHOICE3' )
        )->button( icon  = 'sap-icon://feeder-arrow' text = lv_choice4 press = im_o_client->_event( 'CHOICE4' )
        ).

  ENDMETHOD.


  METHOD set_battle.
    gv_battle = ABAP_true.
    gt_mchoices = im_t_mchoices.
    gv_answer = im_v_answer.
    gv_question = im_v_question.

  ENDMETHOD.


ENDCLASS.
