*&---------------------------------------------------------------------*
*& Include          ZBRMM0040_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module GET_BPINFO OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE GET_BPINFO OUTPUT.
  SELECT SINGLE *
    FROM ZTBSD1050 AS A
    JOIN ZTBSD1051 AS B
      ON A~BPCODE EQ B~BPCODE
    JOIN ZTBFI0040 AS C
      ON A~ZTERM EQ C~ZTERM
    JOIN ZTBFI0060 AS D
      ON A~BANKCODE EQ D~BANKCODE
   WHERE A~BPCODE EQ @PA_BPCO
    INTO CORRESPONDING FIELDS OF @ZSBMM0060.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CREATE_OBJECT OUTPUT.
  IF GO_CUST1 IS INITIAL.
    PERFORM CREATE_OBJECT.

* ALV1 SUBROUTINES.
    PERFORM SET_LAYOUT_ALV1.
    PERFORM SET_FCAT_ALV1.
    PERFORM SET_SORT_ALV1.
    PERFORM SET_EVENT_ALV1.
    PERFORM INIT_ALV1.

* ALV2 SUBROUTINES.
    PERFORM SET_LAYOUT_ALV2.
    PERFORM SET_FCAT_ALV2.
    PERFORM SET_SORT_ALV2.
    PERFORM SET_EVENT_ALV2.
    PERFORM INIT_ALV2.

  ELSE.
    PERFORM REFRESH_ALV1.
    PERFORM REFRESH_ALV2.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module GET_DATA_ALV1 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE GET_DATA_ALV1 OUTPUT.
  PERFORM GET_DATA_ALV1.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0110 OUTPUT.
 SET PF-STATUS 'S110'.
 SET TITLEBAR 'T110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module GET_DATA_ALV3 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE GET_DATA_ALV3 OUTPUT.
  PERFORM SET_DATA_ALV3.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_OBJECT3 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CREATE_OBJECT3 OUTPUT.
  IF GO_CUST2 IS INITIAL.
    PERFORM CREATE_OBJECT3.

* ALV3 SUBROUTINES.
    PERFORM SET_LAYOUT_ALV3.
    PERFORM SET_FCAT_ALV3.
    PERFORM SET_EVENT_ALV3.
    PERFORM INIT_ALV3.

  ELSE.
    PERFORM REFRESH_ALV3.
  ENDIF.
ENDMODULE.
