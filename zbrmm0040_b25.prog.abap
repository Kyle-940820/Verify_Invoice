*&---------------------------------------------------------------------*
*& Report ZBRMM0040
*&---------------------------------------------------------------------*
*&   [MM]
*&   개발자        : CL2 kdt-b-25 하정훈
*&   프로그램 개요   : 송장검증 프로그램
*&   개발 시작일    :'2024.11.13'
*&   개발 완료일    :'2024.11.13'
*&   개발상태      : 개발 완료
*&---------------------------------------------------------------------*
REPORT ZBRMM0040_B25 MESSAGE-ID ZCOMMON_MSG.

INCLUDE ZBRMM0040_B25_TOP.
INCLUDE ZBRMM0040_B25_C01.
INCLUDE ZBRMM0040_B25_S01.
INCLUDE ZBRMM0040_B25_O01.
INCLUDE ZBRMM0040_B25_I01.
INCLUDE ZBRMM0040_B25_F01.

INITIALIZATION.
  PERFORM SET_INIT. " Selection Screen 필드에 default 값 세팅.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR PA_BPCO.
  PERFORM GET_BPCO. " 거래처 코드 Search Help

AT SELECTION-SCREEN OUTPUT.
  PERFORM SET_OUTPUT. " 날짜 오른쪽필드 아웃풋 처리.

START-OF-SELECTION.
  CALL SCREEN 100.
