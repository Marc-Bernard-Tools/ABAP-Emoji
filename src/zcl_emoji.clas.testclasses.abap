********************************************************************************
* ABAP Emoji
*
* Copyright 2022 Marc Bernard <https://marcbernardtools.com/>
* SPDX-License-Identifier: MIT
********************************************************************************
CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test_find FOR TESTING.
    METHODS test_format FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test_find.
    DATA lt_emoji TYPE TABLE OF string.

    lt_emoji = zcl_emoji=>find_emoji( 'sparkles' ).

    cl_aunit_assert=>assert_equals(
      act = lines( lt_emoji )
      exp = 1 ).
  ENDMETHOD.

  METHOD test_format.
    DATA lv_html TYPE string.

    lv_html = zcl_emoji=>format_emoji( 'Here are some :sparkles:' ).

    cl_aunit_assert=>assert_equals(
      act = lv_html
      exp = 'Here are some <i class="twa twa-sparkles"></i>' ).
  ENDMETHOD.

ENDCLASS.
