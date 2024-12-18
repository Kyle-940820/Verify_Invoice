*&---------------------------------------------------------------------*
*& Include          ZBRMM0040_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK BLK1 WITH FRAME TITLE TEXT-T01.
  PARAMETERS: PA_BPCO TYPE ZSBMM0060-BPCODE OBLIGATORY. " BPCODE
  SELECT-OPTIONS: SO_IBDT FOR ZSBMM0060-INBODATE OBLIGATORY. " 입고완료일
SELECTION-SCREEN END OF BLOCK BLK1.

SELECTION-SCREEN BEGIN OF BLOCK BLK2 WITH FRAME TITLE TEXT-T02.
  SELECT-OPTIONS: SO_PONU FOR ZSBMM0060-PONUM. " 구매오더번호
  SELECT-OPTIONS: SO_EMID FOR ZSBMM0060-EMPID. " 구매오더 생성자
SELECTION-SCREEN END OF BLOCK BLK2.
