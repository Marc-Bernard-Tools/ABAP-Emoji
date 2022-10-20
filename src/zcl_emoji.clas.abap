CLASS zcl_emoji DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    TYPES:
      ty_results TYPE SORTED TABLE OF string WITH UNIQUE DEFAULT KEY .

    CONSTANTS c_version TYPE string VALUE '1.2.0' ##NO_TEXT.

    CLASS-METHODS create
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_emoji .
    METHODS find_emoji
      IMPORTING
        !iv_regex        TYPE string
      RETURNING
        VALUE(rt_result) TYPE ty_results .
    METHODS format_emoji
      IMPORTING
        !iv_line         TYPE string
      RETURNING
        VALUE(rv_result) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA go_emoji TYPE REF TO zcl_emoji.

    DATA mt_emoji TYPE HASHED TABLE OF string WITH UNIQUE KEY table_line.

    METHODS init_emoji.

ENDCLASS.



CLASS zcl_emoji IMPLEMENTATION.


  METHOD create.
    IF go_emoji IS INITIAL.
      CREATE OBJECT go_emoji.
      go_emoji->init_emoji( ).
    ENDIF.
    ro_result = go_emoji.
  ENDMETHOD.


  METHOD find_emoji.

    FIELD-SYMBOLS <lv_emoji> LIKE LINE OF mt_emoji.

    LOOP AT mt_emoji ASSIGNING <lv_emoji>.
      IF find(
           val   = <lv_emoji>
           regex = iv_regex
           case  = abap_false ) >= 0.
        INSERT <lv_emoji> INTO TABLE rt_result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD format_emoji.

    DATA:
      lv_emoji TYPE string,
      lv_html  TYPE string.

    FIELD-SYMBOLS <lv_emoji> LIKE LINE OF mt_emoji.

    rv_result = iv_line.

    LOOP AT mt_emoji ASSIGNING <lv_emoji>.
      lv_emoji = |:{ <lv_emoji> }:|.
      lv_html = |<i class="twa twa-{ <lv_emoji> }"></i>|.
      REPLACE ALL OCCURRENCES OF lv_emoji IN rv_result WITH lv_html.
    ENDLOOP.

  ENDMETHOD.


  METHOD init_emoji.

    DATA:
      lv_descr   TYPE string,
      lv_class   TYPE seoclsname,
      lv_program TYPE program,
      lt_emoji   TYPE STANDARD TABLE OF string.

    FIELD-SYMBOLS <lv_emoji> LIKE LINE OF mt_emoji.

    lv_descr = cl_abap_classdescr=>get_class_name( me ).
    lv_class = lv_descr+7(*).
    lv_program = cl_oo_classname_service=>get_ccimp_name( lv_class ).

    READ REPORT lv_program INTO lt_emoji STATE 'A'.
    ASSERT sy-subrc = 0.

    LOOP AT lt_emoji ASSIGNING <lv_emoji> WHERE table_line CP '" *'.
      INSERT <lv_emoji>+2(*) INTO TABLE mt_emoji.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
