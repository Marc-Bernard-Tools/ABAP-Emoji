CLASS zcl_emoji DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

********************************************************************************
* ABAP Emoji
*
* https://github.com/Marc-Bernard-Tools/ABAP-Emoji
*
* Copyright 2022 Marc Bernard <https://marcbernardtools.com/>
* SPDX-License-Identifier: MIT
********************************************************************************

  PUBLIC SECTION.

    CONSTANTS c_version TYPE string VALUE '1.1.0' ##NEEDED.

    TYPES ty_results TYPE SORTED TABLE OF string WITH UNIQUE DEFAULT KEY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS find_emoji
      IMPORTING
        !iv_regex        TYPE string
      RETURNING
        VALUE(rt_result) TYPE ty_results.

    CLASS-METHODS format_emoji
      IMPORTING
        !iv_line         TYPE string
      RETURNING
        VALUE(rv_result) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS c_emoji_list TYPE progname VALUE 'ZEMOJI_LIST'.

    CLASS-DATA gt_emoji TYPE HASHED TABLE OF string WITH UNIQUE KEY table_line.

    CLASS-METHODS init_emoji.
ENDCLASS.



CLASS zcl_emoji IMPLEMENTATION.


  METHOD class_constructor.
    init_emoji( ).
  ENDMETHOD.


  METHOD find_emoji.

    FIELD-SYMBOLS <lv_emoji> LIKE LINE OF gt_emoji.

    LOOP AT gt_emoji ASSIGNING <lv_emoji>.
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

    FIELD-SYMBOLS <lv_emoji> LIKE LINE OF gt_emoji.

    rv_result = iv_line.

    LOOP AT gt_emoji ASSIGNING <lv_emoji>.
      lv_emoji = |:{ <lv_emoji> }:|.
      lv_html = |<i class="twa twa-{ <lv_emoji> }"></i>|.
      REPLACE ALL OCCURRENCES OF lv_emoji IN rv_result WITH lv_html.
    ENDLOOP.

  ENDMETHOD.


  METHOD init_emoji.

    DATA lt_emoji TYPE STANDARD TABLE OF string.

    FIELD-SYMBOLS <lv_emoji> LIKE LINE OF gt_emoji.

    READ REPORT c_emoji_list INTO lt_emoji.
    ASSERT sy-subrc = 0.

    LOOP AT lt_emoji ASSIGNING <lv_emoji> WHERE table_line CP '" *'.
      INSERT <lv_emoji>+2(*) INTO TABLE gt_emoji.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
