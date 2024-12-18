*&---------------------------------------------------------------------*
*& Include          ZBRMM0040_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND INPUT.
  CASE OK_CODE.
    WHEN 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_110 INPUT.
  CASE OK_CODE.
    WHEN 'CANCEL'.
      MESSAGE S212. " 송장검증이 취소되었습니다.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
      PERFORM SAVE_INVO.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0110 INPUT.

ENDMODULE.
