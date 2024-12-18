*&---------------------------------------------------------------------*
*& Include          ZBRMM0040_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_BPCO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_BPCO .
  SELECT A~BPCODE, BPNAME
    FROM ZTBSD1050 AS A
    JOIN ZTBSD1051 AS B
      ON A~BPCODE EQ B~BPCODE
   WHERE BPTCODE EQ 'V'
    INTO TABLE @DATA(LT_BPCO).

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'BPCODE'
      DYNPPROG        = SY-REPID
      DYNPNR          = SY-DYNNR
      DYNPROFIELD     = 'PA_BPCO'
      WINDOW_TITLE    = '거래처 선택'
      VALUE_ORG       = 'S'
    TABLES
      VALUE_TAB       = LT_BPCO[]
    EXCEPTIONS
      PARAMETER_ERROR = 1
      NO_VALUES_FOUND = 2
      OTHERS          = 3.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_INIT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_INIT .
  DATA: LV_DATE TYPE SY-DATUM.

  " LV_DATE에 오늘날짜의 한달전 날짜 할당
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      DATE      = SY-DATUM
      DAYS      = 0
      MONTHS    = 3
      SIGNUM    = '-'
      YEARS     = 0
    IMPORTING
      CALC_DATE = LV_DATE.

  SO_IBDT-SIGN = 'I'.
  SO_IBDT-OPTION = 'BT'.
  SO_IBDT-LOW = LV_DATE.   "한달 전
  SO_IBDT-HIGH = SY-DATUM. " 오늘

  APPEND SO_IBDT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_OUTPUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_OUTPUT .
  " SO_DAT-HIGH 필드 아웃풋 처리
  LOOP AT SCREEN.
    IF SCREEN-NAME CS 'SO_IBDT-HIGH'.
      SCREEN-INPUT = '0'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT .
  CREATE OBJECT GO_CUST1
    EXPORTING
      CONTAINER_NAME              = 'CUST1'
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.
  IF SY-SUBRC <> 0.
  ENDIF.

  CREATE OBJECT GO_ESPLIT
    EXPORTING
      PARENT        = GO_CUST1
      ORIENTATION   = 0
      SASH_POSITION = 50.

  GO_CONT1 = GO_ESPLIT->TOP_LEFT_CONTAINER.
  GO_CONT2 = GO_ESPLIT->BOTTOM_RIGHT_CONTAINER.

  " container
  CREATE OBJECT GO_GRID1
    EXPORTING
      I_PARENT = GO_CONT1.

  CREATE OBJECT GO_GRID2
    EXPORTING
      I_PARENT = GO_CONT2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT_ALV1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_LAYOUT_ALV1 .
  CLEAR GS_LAYO1.

  GS_LAYO1-GRID_TITLE = '구매오더 리스트'.
  GS_LAYO1-ZEBRA = 'X'.
  GS_LAYO1-CWIDTH_OPT = 'A'.
  GS_LAYO1-EXCP_FNAME = 'EXCP'.
  GS_LAYO1-EXCP_LED = 'X'.
*  GS_LAYO1-TOTALS_BEF = 'X'.
  GS_LAYO1-NO_TOTLINE = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT_ALV1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_FCAT_ALV1 .
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'EXCP'.
  GS_FCAT1-JUST = 'C'.
  GS_FCAT1-COLTEXT = '상태'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'PONUM'.
  GS_FCAT1-JUST = 'C'.
  GS_FCAT1-KEY = 'X'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'BPCODE'.
  GS_FCAT1-JUST = 'C'.
  GS_FCAT1-COLTEXT = '거래처코드'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'BPNAME'.
  GS_FCAT1-JUST = 'C'.
  GS_FCAT1-COLTEXT = '거래처 명'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'PLTCODE'.
  GS_FCAT1-JUST = 'C'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'PLTNAME'.
  GS_FCAT1-JUST = 'C'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'WHCODE'.
  GS_FCAT1-JUST = 'C'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'WHNAME'.
  GS_FCAT1-JUST = 'C'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'PODATE'.
  GS_FCAT1-JUST = 'C'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'EINDT'.
  GS_FCAT1-JUST = 'C'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'INBODATE'.
  GS_FCAT1-JUST = 'C'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'EMPID'.
  GS_FCAT1-JUST = 'C'.
  GS_FCAT1-COLTEXT = '구매오더 생성자'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'STATUS'.
  GS_FCAT1-JUST = 'C'.
  GS_FCAT1-NO_OUT = 'X'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'MATCODE'.
  GS_FCAT1-JUST = 'C'.
  GS_FCAT1-KEY = 'X'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'MATNAME'.
  GS_FCAT1-JUST = 'C'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'POQUANT'.
  GS_FCAT1-JUST = 'R'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'UNITCODE'.
  GS_FCAT1-JUST = 'L'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'POPRICE'.
  GS_FCAT1-JUST = 'R'.
  GS_FCAT1-DO_SUM = 'X'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.

  GS_FCAT1-FIELDNAME = 'CURRENCY'.
  GS_FCAT1-JUST = 'L'.
  APPEND GS_FCAT1 TO GT_FCAT1.
  CLEAR GS_FCAT1.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EVENT_ALV1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_EVENT_ALV1 .
  SET HANDLER LCL_EVENT=>ON_TOOLBAR1 FOR GO_GRID1.
  SET HANDLER LCL_EVENT=>ON_USER_COMMAND1 FOR GO_GRID1.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_ALV1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM INIT_ALV1 .
  DATA: LS_EXCLUD TYPE UI_FUNC,
        LT_EXCLUD TYPE UI_FUNCTIONS.

  LS_EXCLUD = CL_GUI_ALV_GRID=>MC_FC_EXCL_ALL.
  APPEND LS_EXCLUD TO LT_EXCLUD.

  GS_VARIANT-REPORT = SY-CPROG.
*  GS_VARIANT-VARIANT = '/ALV100'.

  CALL METHOD GO_GRID1->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'ZSBMM0060_ALV1'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = 'A'
*     I_DEFAULT                     =
      IS_LAYOUT                     = GS_LAYO1
*     IT_TOOLBAR_EXCLUDING          = LT_EXCLUD
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY1
      IT_FIELDCATALOG               = GT_FCAT1
      IT_SORT                       = GT_SORT1
*     IT_FILTER                     =
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    MESSAGE S205 DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV1 .
* ALV1 DATA 바뀔 시 최적화 및 REFRESH.
  DATA: LS_STABLE TYPE LVC_S_STBL.

  CALL METHOD GO_GRID1->GET_FRONTEND_LAYOUT
    IMPORTING
      ES_LAYOUT = GS_LAYO1.

  GS_LAYO1-CWIDTH_OPT = ABAP_ON.

  CALL METHOD GO_GRID1->SET_FRONTEND_LAYOUT
    EXPORTING
      IS_LAYOUT = GS_LAYO1.

  CALL METHOD GO_GRID1->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT_ALV2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_LAYOUT_ALV2 .
  CLEAR GS_LAYO2.

  GS_LAYO2-GRID_TITLE = '거래처송장 리스트'.
  GS_LAYO2-ZEBRA = 'X'.
  GS_LAYO2-CWIDTH_OPT = 'A'.
  GS_LAYO2-EXCP_FNAME = 'EXCP'.
  GS_LAYO2-EXCP_LED = 'X'.
  GS_LAYO2-NO_TOTLINE = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT_ALV2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_FCAT_ALV2 .
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'EXCP'.
  GS_FCAT2-JUST = 'C'.
  GS_FCAT2-COLTEXT = '상태'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'INVONUM'.
  GS_FCAT2-JUST = 'C'.
  GS_FCAT2-KEY = 'X'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'PONUM'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'BPCODE'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'BPNAME'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'INBODATE'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'EMPID'.
  GS_FCAT2-JUST = 'C'.
  GS_FCAT2-COLTEXT = '송장등록 담당자'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'MATCODE'.
  GS_FCAT2-JUST = 'C'.
  GS_FCAT2-KEY = 'X'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'MATNAME'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'INBOQUANT'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'UNITCODE'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'INVOPRICE'.
  GS_FCAT2-JUST = 'C'.
  GS_FCAT2-DO_SUM = 'X'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'CURRENCY'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'EMPID2'.
  GS_FCAT2-JUST = 'C'.
  GS_FCAT2-COLTEXT = '송장검증 담당자'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'INVOPDATE'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'INVTEXT'.
  GS_FCAT2-JUST = 'C'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.

  GS_FCAT2-FIELDNAME = 'STATUS'.
  GS_FCAT2-JUST = 'C'.
  GS_FCAT2-NO_OUT = 'X'.
  APPEND GS_FCAT2 TO GT_FCAT2.
  CLEAR GS_FCAT2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EVENT_ALV2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_EVENT_ALV2 .
  SET HANDLER LCL_EVENT=>ON_TOOLBAR2 FOR GO_GRID2.
  SET HANDLER LCL_EVENT=>ON_USER_COMMAND2 FOR GO_GRID2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_ALV2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM INIT_ALV2 .
  DATA: LS_EXCLUD TYPE UI_FUNC,
        LT_EXCLUD TYPE UI_FUNCTIONS.

  LS_EXCLUD = CL_GUI_ALV_GRID=>MC_FC_EXCL_ALL.
  APPEND LS_EXCLUD TO LT_EXCLUD.

  GS_VARIANT-REPORT = SY-CPROG.
*  GS_VARIANT-VARIANT = '/ALV100'.

  CALL METHOD GO_GRID2->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'ZSBMM0060_ALV2'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = 'A'
*     I_DEFAULT                     =
      IS_LAYOUT                     = GS_LAYO2
*     IT_TOOLBAR_EXCLUDING          = LT_EXCLUD
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY2
      IT_FIELDCATALOG               = GT_FCAT2
      IT_SORT                       = GT_SORT2
*     IT_FILTER                     =
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    MESSAGE S205 DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV2 .
* ALV1 DATA 바뀔 시 최적화 및 REFRESH.
  DATA: LS_STABLE TYPE LVC_S_STBL.

  CALL METHOD GO_GRID2->GET_FRONTEND_LAYOUT
    IMPORTING
      ES_LAYOUT = GS_LAYO1.

  GS_LAYO2-CWIDTH_OPT = ABAP_ON.

  CALL METHOD GO_GRID2->SET_FRONTEND_LAYOUT
    EXPORTING
      IS_LAYOUT = GS_LAYO2.

  CALL METHOD GO_GRID2->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA_ALV1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA_ALV1 .
  SELECT *
    FROM ZTBMM0020 AS A  " 구매오더 헤더
LEFT JOIN ZTBMM0021 AS B " 구매오더 아이템
    ON A~PONUM EQ B~PONUM " 구매오더 번호
    JOIN ZTBSD1051 AS C " 거래처 명 Text table
    ON A~BPCODE EQ C~BPCODE " 거래처 코드
    JOIN ZTBMM1020 AS D " 플랜트 마스터
    ON A~PLTCODE EQ D~PLTCODE " 플랜트 코드
    JOIN ZTBMM1030 AS E " 창고 마스터
    ON A~WHCODE EQ E~WHCODE " 창고 코드
    JOIN ZTBMM1011 AS F " 자재 명 Text table
    ON B~MATCODE EQ F~MATCODE " 자재 코드
   WHERE A~BPCODE EQ @PA_BPCO " 거래처 코드
    AND A~INBODATE IN @SO_IBDT " 입고등록일
    AND A~EMPID IN @SO_EMID " 사원 ID
    AND A~PONUM IN @SO_PONU " 구매오더 번호
    AND A~STATUS NE @SPACE " STATUS = SPACE : 구매요청 결재 대기
    AND A~STATUS NE 'A' " STATUS = A : 입고 대기
    ORDER BY A~PONUM ASCENDING " 구매오더 번호 기준 오름차순 정렬
    INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY1.

  LOOP AT GT_DISPLAY1 INTO GS_DISPLAY1.
    CASE GS_DISPLAY1-STATUS.
      WHEN 'B'.
        GS_DISPLAY1-EXCP = '2'. " 송장 검증 전이면 노란불
      WHEN 'C'.
        GS_DISPLAY1-EXCP = '3'. " 송장 검증 완료면 초록불
    ENDCASE.
    MODIFY GT_DISPLAY1 FROM GS_DISPLAY1 INDEX SY-TABIX TRANSPORTING EXCP.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR1  USING  PV_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET.
  DATA LS_BUTTON LIKE LINE OF PV_OBJECT->MT_TOOLBAR.

* 구분자 추가.
  CLEAR LS_BUTTON.
  LS_BUTTON-BUTN_TYPE = 3.
  APPEND LS_BUTTON TO PV_OBJECT->MT_TOOLBAR.
  CLEAR LS_BUTTON.

* 버튼 '송장조회' 추가.
  LS_BUTTON-BUTN_TYPE = 0. " 일반 버튼(NORMAL BUTTON)
  LS_BUTTON-TEXT      = ' 송장조회 '.
  LS_BUTTON-FUNCTION  = 'DIS'.
  LS_BUTTON-ICON = ICON_COPY_OBJECT.
  APPEND LS_BUTTON TO PV_OBJECT->MT_TOOLBAR.
  CLEAR LS_BUTTON.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND1  USING PV_UCOMM.
  CASE PV_UCOMM.
    WHEN 'DIS'.
      PERFORM GET_DATA_ALV2.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA_ALV3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA_ALV2 .
  DATA: LV_ANSWER.

  CLEAR: GT_ROW1, GS_ROW1, GS_DISPLAY1.

* SELECT ROW METHOD 호출.
  CALL METHOD GO_GRID1->GET_SELECTED_ROWS
    IMPORTING
      ET_ROW_NO = GT_ROW1.

* 선택한 행 정보 GS_DISPLAY1 할당.
  READ TABLE GT_ROW1 INTO GS_ROW1 INDEX 1.
  READ TABLE GT_DISPLAY1 INTO GS_DISPLAY1 INDEX GS_ROW1-ROW_ID.

* ALV1 행 선택 유무로 CONFIRM POPUP 생성.
  IF GS_DISPLAY1 IS INITIAL. " ALV1에서 행 선택을 하지 않고 '송장조회' 버튼 눌렀을 때.
    MESSAGE S217 DISPLAY LIKE 'E'. " 구매오더 데이터를 선택해주세요.

  ELSE. " ALV1에서 행 선택을 하고 '송장조회' 버튼 눌렀을 때.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        TITLEBAR              = TEXT-T03 " 송장조회 확인.
        TEXT_QUESTION         = TEXT-Q01 " 선택한 구매오더의 송장을 조회하시겠습니까?
        TEXT_BUTTON_1         = 'YES'
        ICON_BUTTON_1         = 'ICON_OKAY'
        TEXT_BUTTON_2         = 'NO'
        ICON_BUTTON_2         = 'ICON_CANCEL'
        DEFAULT_BUTTON        = '1'
        DISPLAY_CANCEL_BUTTON = ''
      IMPORTING
        ANSWER                = LV_ANSWER.

    IF LV_ANSWER = '1'. " 컨펌팝업 YES

* ALV2 - 선택한 구매오더 송장 데이터 띄우기.
      SELECT *
        FROM ZTBMM0060 AS A " 송장 헤더
   LEFT JOIN ZTBMM0061 AS B " 송장 아이템
          ON A~INVONUM EQ B~INVONUM " 송장 번호
        JOIN ZTBSD1051 AS C " 거래처명 Text table
          ON A~BPCODE EQ C~BPCODE " 거래처 코드
        JOIN ZTBMM1011 AS D " 자재명 Text table
          ON B~MATCODE EQ D~MATCODE " 자재번호
       WHERE A~PONUM EQ @GS_DISPLAY1-PONUM " 구매오더 번호
        ORDER BY A~INVONUM ASCENDING " 송장번호 기준 오름차순 정렬
        INTO CORRESPONDING FIELDS OF TABLE @GT_DISPLAY2.

      IF SY-SUBRC = 0. " 선택한 구매오더 건에 대해 송장 데이터가 존재할 때.
        LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
          CASE GS_DISPLAY2-STATUS.
            WHEN 'A'.
              GS_DISPLAY2-EXCP = '2'. " 송장 검증 대기 노란색
            WHEN 'B'.
              GS_DISPLAY2-EXCP = '3'. " 송장 검증 결과 정상처리 초록색
            WHEN 'X'.
              GS_DISPLAY2-EXCP = '1'. " 송장 검증 결과 예외처리 빨간색
          ENDCASE.
          MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 INDEX SY-TABIX TRANSPORTING EXCP.
        ENDLOOP.

        CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE " ALV2 REFRESH.
          EXPORTING
            NEW_CODE = 'ENTER'.

        MESSAGE S218. " 송장조회를 성공하였습니다.

      ELSE. " 선택한 구매오더 건에 대해 송장 데이터가 존재하지 않을 때.
        MESSAGE S216 DISPLAY LIKE 'E'. " 송장 데이터가 존재하지 않습니다.
      ENDIF.

    ELSE. " 컨펌팝업 NO
      MESSAGE S219. " 송장조회를 취소하였습니다.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&---------------------------------------------------------------------*
FORM HANDLE_TOOLBAR2  USING  PV_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET.
  DATA LS_BUTTON LIKE LINE OF PV_OBJECT->MT_TOOLBAR.

* 구분자 추가.
  CLEAR LS_BUTTON.
  LS_BUTTON-BUTN_TYPE = 3.
  APPEND LS_BUTTON TO PV_OBJECT->MT_TOOLBAR.
  CLEAR LS_BUTTON.

* 버튼 '송장검증' 추가.
  LS_BUTTON-BUTN_TYPE = 0. " 일반 버튼(NORMAL BUTTON)
  LS_BUTTON-TEXT      = ' 송장검증 '.
  LS_BUTTON-FUNCTION  = 'VER'.
  LS_BUTTON-ICON = ICON_INTENSIFY.
  APPEND LS_BUTTON TO PV_OBJECT->MT_TOOLBAR.
  CLEAR LS_BUTTON.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND2  USING PV_UCOMM.
  CASE PV_UCOMM.
    WHEN 'VER'.
      PERFORM GET_DATA_ALV3.
      CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE " 삭제 후 PAI-PBO 동작해서 ALV2 REFRESH.
        EXPORTING
          NEW_CODE = 'ENTER'.

      PERFORM UPDATE_GT_DISPLAY2.

      PERFORM REFRESH_ALV1.
      PERFORM REFRESH_ALV2.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA_ALV3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA_ALV3 .
  DATA: LV_ANSWER.

  CLEAR: GT_ROW2, GS_ROW2, GS_DISPLAY2.

* SELECT ROW METHOD 호출.
  CALL METHOD GO_GRID2->GET_SELECTED_ROWS
    IMPORTING
      ET_ROW_NO = GT_ROW2.

* 선택한 행 정보 GS_DISPLAY2 할당.
  READ TABLE GT_ROW2 INTO GS_ROW2 INDEX 1.
  READ TABLE GT_DISPLAY2 INTO GS_DISPLAY2 INDEX GS_ROW2-ROW_ID.

* ALV2 행 선택 유무로 CONFIRM POPUP 생성.
  IF GS_DISPLAY2 IS INITIAL. " ALV1에서 행 선택을 하지 않고 '송장조회' 버튼 눌렀을 때.
    MESSAGE S211 DISPLAY LIKE 'E'. " 송장 데이터를 선택해주세요.

  ELSE. " ALV2에서 행 선택을 하고 '송장조회' 버튼 눌렀을 때.
    IF GS_DISPLAY2-STATUS NE 'A'. " 이미 검증이 완료된 송장의 경우
      MESSAGE S220 DISPLAY LIKE 'E'. " 이미 검증이 완료된 송장입니다.

    ELSE. " 검증이 완료되지 않은 송장일 때.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          TITLEBAR              = TEXT-T04 " 송장검증 확인.
          TEXT_QUESTION         = TEXT-Q02 " 선택한 송장의 검증을 진행하시겠습니까?
          TEXT_BUTTON_1         = 'YES'
          ICON_BUTTON_1         = 'ICON_OKAY'
          TEXT_BUTTON_2         = 'NO'
          ICON_BUTTON_2         = 'ICON_CANCEL'
          DEFAULT_BUTTON        = '1'
          DISPLAY_CANCEL_BUTTON = ''
        IMPORTING
          ANSWER                = LV_ANSWER.

      IF LV_ANSWER = '1'. " 컨펌팝업 YES

* 선택한 송장의 검증 결과 팝업창 띄우기.
        MESSAGE S213. " 송장검증 결과를 확인해주세요.
        CALL SCREEN 110
          STARTING AT 30 8.


      ELSE. " 컨펌팝업 NO
        MESSAGE S212. " 송장검증이 취소되었습니다.
      ENDIF.
    ENDIF. " 송장 검증 완료 여부.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_DATA_ALV3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_DATA_ALV3 .
  DATA: LV_ANSWER.

  DATA: LS_ZTBMM0021 TYPE ZTBMM0021, " 구매오더 아이템.
        LT_ZTBMM0021 LIKE TABLE OF LS_ZTBMM0021,
        LS_ZTBMM0061 TYPE ZTBMM0061, " 거래청송장 아이템.
        LT_ZTBMM0061 LIKE TABLE OF LS_ZTBMM0061.

  CLEAR: GT_DISPLAY3, GS_DISPLAY3.

  MOVE-CORRESPONDING GS_DISPLAY2 TO ZSBMM0060_ALV3.

* 선택한 송장에 해당하는 구매오더 아이템 데이터와 송장 아이템 데이터 비교.

  SELECT * " 구매오더 아이템 데이터.
    FROM ZTBMM0021
   WHERE PONUM EQ @ZSBMM0060_ALV3-PONUM
    ORDER BY MATCODE ASCENDING
    INTO CORRESPONDING FIELDS OF TABLE @LT_ZTBMM0021.

  SELECT * " 송장 아이템 데이터.
    FROM ZTBMM0061
   WHERE INVONUM EQ @ZSBMM0060_ALV3-INVONUM
    ORDER BY MATCODE ASCENDING
    INTO CORRESPONDING FIELDS OF TABLE @LT_ZTBMM0061.

* 송장 아이템 ALV3에 띄우기.
  MOVE-CORRESPONDING LT_ZTBMM0061 TO GT_DISPLAY3.

* 구매오더 데이터와 송장 데이터 비교.
  LOOP AT LT_ZTBMM0021 INTO LS_ZTBMM0021.
    READ TABLE LT_ZTBMM0061 INTO LS_ZTBMM0061 INDEX SY-TABIX.
    READ TABLE GT_DISPLAY3 INTO GS_DISPLAY3 INDEX SY-TABIX.

    SELECT SINGLE MATNAME
      FROM ZTBMM1011
     WHERE MATCODE EQ @GS_DISPLAY3-MATCODE
      INTO @GS_DISPLAY3-MATNAME.

    IF LS_ZTBMM0021-POPRICE = LS_ZTBMM0061-INVOPRICE " 가격 같을 경우.
      AND LS_ZTBMM0021-POQUANT = LS_ZTBMM0061-INBOQUANT " 수량 같을 경우.
      AND LS_ZTBMM0021-UNITCODE = LS_ZTBMM0061-UNITCODE " UNITCODE 같을 경우.
      AND LS_ZTBMM0021-MATCODE = LS_ZTBMM0061-MATCODE. " MATCODE 같을 경우.
      GS_DISPLAY3-EXCP = '3'.
      ZSBMM0060_ALV3-RESULT = '일치'.

    ELSE. " 4개 중에 하나라도 다를 경우.
      GS_DISPLAY3-EXCP = '1'.
      ZSBMM0060_ALV3-RESULT = '불일치'.
    ENDIF.
    MODIFY GT_DISPLAY3 FROM GS_DISPLAY3 INDEX SY-TABIX TRANSPORTING EXCP MATNAME.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT3 .
  CREATE OBJECT GO_CUST2
    EXPORTING
      CONTAINER_NAME              = 'CUST2'
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.
  IF SY-SUBRC <> 0.
  ENDIF.

  CREATE OBJECT GO_GRID3
    EXPORTING
      I_PARENT          = GO_CUST2
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1
      ERROR_CNTL_INIT   = 2
      ERROR_CNTL_LINK   = 3
      ERROR_DP_CREATE   = 4
      OTHERS            = 5.
  IF SY-SUBRC <> 0.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT_ALV3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_LAYOUT_ALV3 .
  CLEAR GS_LAYO3.

  GS_LAYO3-GRID_TITLE = '송증검증 자재 리스트'.
  GS_LAYO3-ZEBRA = 'X'.
  GS_LAYO3-CWIDTH_OPT = 'A'.
  GS_LAYO3-EXCP_FNAME = 'EXCP'.
  GS_LAYO3-EXCP_LED = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT_ALV3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_FCAT_ALV3 .
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'EXCP'.
  GS_FCAT3-JUST = 'C'.
  GS_FCAT3-COLTEXT = '상태'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'INVONUM'.
  GS_FCAT3-JUST = 'C'.
  GS_FCAT3-NO_OUT = 'X'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'PONUM'.
  GS_FCAT3-JUST = 'C'.
  GS_FCAT3-NO_OUT = 'X'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'MATCODE'.
  GS_FCAT3-JUST = 'C'.
  GS_FCAT3-KEY = 'X'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'MATNAME'.
  GS_FCAT3-JUST = 'C'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'INBOQUANT'.
  GS_FCAT3-JUST = 'R'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'UNITCODE'.
  GS_FCAT3-JUST = 'L'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'INVOPRICE'.
  GS_FCAT3-JUST = 'R'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'CURRENCY'.
  GS_FCAT3-JUST = 'L'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'INVTEXT'.
  GS_FCAT3-JUST = 'C'.
  GS_FCAT3-NO_OUT = 'X'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'STATUS'.
  GS_FCAT3-JUST = 'C'.
  GS_FCAT3-NO_OUT = 'X'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.

  GS_FCAT3-FIELDNAME = 'RESULT'.
  GS_FCAT3-JUST = 'C'.
  GS_FCAT3-NO_OUT = 'X'.
  APPEND GS_FCAT3 TO GT_FCAT3.
  CLEAR GS_FCAT3.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EVENT_ALV3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_EVENT_ALV3 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_ALV3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM INIT_ALV3 .
  DATA: LS_EXCLUD TYPE UI_FUNC,
        LT_EXCLUD TYPE UI_FUNCTIONS.

  LS_EXCLUD = CL_GUI_ALV_GRID=>MC_FC_EXCL_ALL.
  APPEND LS_EXCLUD TO LT_EXCLUD.

  GS_VARIANT-REPORT = SY-CPROG.
*  GS_VARIANT-VARIANT = '/ALV100'.

  CALL METHOD GO_GRID3->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'ZSBMM0060_ALV3'
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = 'A'
*     I_DEFAULT                     =
      IS_LAYOUT                     = GS_LAYO3
*     IT_TOOLBAR_EXCLUDING          = LT_EXCLUD
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY3
      IT_FIELDCATALOG               = GT_FCAT3
*     IT_SORT                       =
*     IT_FILTER                     =
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    MESSAGE S205 DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_ALV3 .
* ALV3 DATA 바뀔 시 최적화 및 REFRESH.
  DATA: LS_STABLE TYPE LVC_S_STBL.

  CALL METHOD GO_GRID3->GET_FRONTEND_LAYOUT
    IMPORTING
      ES_LAYOUT = GS_LAYO3.

  GS_LAYO3-CWIDTH_OPT = ABAP_ON.

  CALL METHOD GO_GRID3->SET_FRONTEND_LAYOUT
    EXPORTING
      IS_LAYOUT = GS_LAYO3.

  CALL METHOD GO_GRID3->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = LS_STABLE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_INVO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SAVE_INVO .
  DATA: LV_ANSWER,
        LV_NR     TYPE NUM10,
        LV_PRICE  TYPE ZTBFI0031-WRBTR.

  DATA: LS_ZTBMM0060 TYPE ZTBMM0060,
        LS_ZTBMM0020 TYPE ZTBMM0020.

  DATA: LS_ZTBFI0030 TYPE ZTBFI0030,
        LS_ZTBFI0031 TYPE ZTBFI0031.

  SELECT SINGLE EMPID
    FROM ZTBSD1030
   WHERE LOGID EQ @SY-UNAME
    INTO @DATA(LV_EMPID).

  IF ZSBMM0060_ALV3-INVTEXT IS INITIAL. " 송장헤더텍스트 입력안했을 때.
    MESSAGE I215 DISPLAY LIKE 'E'. " 송장헤더텍스트를 입력해주세요.

  ELSE. " 송장헤더텍스트 입력했을 때.
    CASE ZSBMM0060_ALV3-RESULT.
      WHEN '일치'.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            TITLEBAR              = TEXT-T05 " 송장검증 결과 저장확인
            TEXT_QUESTION         = TEXT-Q03 " 송장검증 완료 및 매입전표를 생성하시겠습니까?
            TEXT_BUTTON_1         = 'YES'
            ICON_BUTTON_1         = 'ICON_OKAY'
            TEXT_BUTTON_2         = 'NO'
            ICON_BUTTON_2         = 'ICON_CANCEL'
            DEFAULT_BUTTON        = '1'
            DISPLAY_CANCEL_BUTTON = ''
          IMPORTING
            ANSWER                = LV_ANSWER.

        IF LV_ANSWER = '1'. " 컨펌팝업 YES

* ALV2 UPDATE & 송장 TP TABLE UPDATE.
          LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2 WHERE INVONUM = ZSBMM0060_ALV3-INVONUM.
            GS_DISPLAY2-STATUS = 'B'. " 해당 송장 검증완료 처리.
            GS_DISPLAY2-EMPID2 = LV_EMPID. " 송장검증 담당자.
            GS_DISPLAY2-INVOPDATE = SY-DATUM. " 송장검증일.
            GS_DISPLAY2-INVTEXT = ZSBMM0060_ALV3-INVTEXT. " 송장헤더텍스트.

            MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 INDEX SY-TABIX
            TRANSPORTING STATUS EMPID2 INVOPDATE INVTEXT.

            MOVE-CORRESPONDING GS_DISPLAY2 TO LS_ZTBMM0060.

            UPDATE ZTBMM0060
            SET EMPID2 = LV_EMPID
                INVOPDATE = SY-DATUM
                STATUS = 'B'
                INVTEXT = ZSBMM0060_ALV3-INVTEXT
          WHERE INVONUM EQ GS_DISPLAY2-INVONUM.
          ENDLOOP.

* ALV1 UPDATE & 구매오더 TP TABLE UPDATE.
          LOOP AT GT_DISPLAY1 INTO GS_DISPLAY1 WHERE PONUM = ZSBMM0060_ALV3-PONUM.
            GS_DISPLAY1-STATUS = 'C'. " 구매오더 송장검증완료 상태 처리.
            MODIFY GT_DISPLAY1 FROM GS_DISPLAY1 INDEX SY-TABIX TRANSPORTING STATUS.

            MOVE-CORRESPONDING GS_DISPLAY1 TO LS_ZTBMM0020.

            UPDATE ZTBMM0020
            SET STATUS = 'C'
            WHERE PONUM = LS_ZTBMM0020-PONUM.
          ENDLOOP.

* 매입전표 생성 및 전표 헤더 TP TABLE DATA CREATE.
          CALL FUNCTION 'NUMBER_GET_NEXT' " 전표 NUMBER RANGE 호출.
            EXPORTING
              NR_RANGE_NR             = '01'
              OBJECT                  = 'ZBBFI0030'
            IMPORTING
              NUMBER                  = LV_NR
            EXCEPTIONS
              INTERVAL_NOT_FOUND      = 1
              NUMBER_RANGE_NOT_INTERN = 2
              OBJECT_NOT_FOUND        = 3
              QUANTITY_IS_0           = 4
              QUANTITY_IS_NOT_1       = 5
              INTERVAL_OVERFLOW       = 6
              BUFFER_OVERFLOW         = 7
              OTHERS                  = 8.
          IF SY-SUBRC <> 0.
          ENDIF.

          LS_ZTBFI0030-BELNR = LV_NR.
          LS_ZTBFI0030-COMCODE = '1000'.
          LS_ZTBFI0030-GJAHR = SY-DATUM+0(4).
          LS_ZTBFI0030-BLART = 'KR'.
          LS_ZTBFI0030-BUDAT = SY-DATUM.

          CONCATENATE SY-DATUM+4(2) '월 ' GS_DISPLAY2-BPNAME ' 외상매입 ' INTO LS_ZTBFI0030-BKTXT.

          LS_ZTBFI0030-BLDAT = GS_DISPLAY2-INBODATE.
          LS_ZTBFI0030-XBLNR = GS_DISPLAY2-INVONUM.
          LS_ZTBFI0030-REVRS = SPACE.
          LS_ZTBFI0030-USNAM = LV_EMPID.
**********타임스탬프*****************************************************
          LS_ZTBFI0030-STAMP_DATE_F = SY-DATUM.
          LS_ZTBFI0030-STAMP_TIME_F = SY-UZEIT.
          LS_ZTBFI0030-STAMP_USER_F = LS_ZTBFI0030-USNAM.
**********************************************************************

          INSERT ZTBFI0030 FROM LS_ZTBFI0030.

* 매입전표 생성 및 전표 아이템 TP TABLE DATA CREATE.
          LOOP AT GT_DISPLAY3 INTO GS_DISPLAY3.
            LV_PRICE = LV_PRICE + GS_DISPLAY3-INVOPRICE.
          ENDLOOP.

          SELECT SINGLE ZTERM
            FROM ZTBSD1050
           WHERE BPCODE EQ @GS_DISPLAY2-BPCODE
            INTO @DATA(LV_ZTERM).


          LS_ZTBFI0031-BELNR = LV_NR.
          LS_ZTBFI0031-BUZEI = '1'.
          LS_ZTBFI0031-SHKZG = 'S'.
          LS_ZTBFI0031-ACODE = '20001'.
          LS_ZTBFI0031-ANAME = 'GR/IR 임시'.
          LS_ZTBFI0031-WRBTR = LV_PRICE.
          LS_ZTBFI0031-CURRENCY = 'KRW'.
          LS_ZTBFI0031-ITTXT = LS_ZTBFI0030-BKTXT.
          LS_ZTBFI0031-BPCODE = GS_DISPLAY2-BPCODE.
          LS_ZTBFI0031-ZTERM = LV_ZTERM.
          LS_ZTBFI0031-HWRBTR = LV_PRICE.
          LS_ZTBFI0031-CURRENCY_F = 'KRW'.
**********타임스탬프*****************************************************
          LS_ZTBFI0031-STAMP_DATE_F = SY-DATUM.
          LS_ZTBFI0031-STAMP_TIME_F = SY-UZEIT.
          LS_ZTBFI0031-STAMP_USER_F = LS_ZTBFI0030-USNAM.
**********************************************************************

          INSERT ZTBFI0031 FROM LS_ZTBFI0031.

          LS_ZTBFI0031-BUZEI = '2'.
          LS_ZTBFI0031-SHKZG = 'H'.
          LS_ZTBFI0031-ACODE = '20002'.
          LS_ZTBFI0031-ANAME = '외상매입금'.
**********타임스탬프*****************************************************
          LS_ZTBFI0031-STAMP_DATE_F = SY-DATUM.
          LS_ZTBFI0031-STAMP_TIME_F = SY-UZEIT.
          LS_ZTBFI0031-STAMP_USER_F = LS_ZTBFI0030-USNAM.
**********************************************************************

          INSERT ZTBFI0031 FROM LS_ZTBFI0031.

          MESSAGE S222 WITH LV_NR. " 송장검증결과 저장 및 전표 생성을 성공하였습니다.



          LEAVE TO SCREEN 0.
        ELSE. " 컨펌팝업 NO
          MESSAGE S214. " 송장검증결과 저장을 취소하였습니다.
        ENDIF.

      WHEN '불일치'.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            TITLEBAR              = TEXT-T05 " 송장검증 결과 저장확인
            TEXT_QUESTION         = TEXT-Q04 " 해당 송장을 예외처리 하시겠습니까?
            TEXT_BUTTON_1         = 'YES'
            ICON_BUTTON_1         = 'ICON_OKAY'
            TEXT_BUTTON_2         = 'NO'
            ICON_BUTTON_2         = 'ICON_CANCEL'
            DEFAULT_BUTTON        = '1'
            DISPLAY_CANCEL_BUTTON = ''
          IMPORTING
            ANSWER                = LV_ANSWER.

        IF LV_ANSWER = '1'. " 컨펌팝업 YES
          LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2 WHERE INVONUM = ZSBMM0060_ALV3-INVONUM.
            GS_DISPLAY2-STATUS = 'X'. " 해당 송장 예외처리.
            GS_DISPLAY2-EMPID2 = LV_EMPID. " 송장검증 담당자.
            GS_DISPLAY2-INVOPDATE = SY-DATUM. " 송장검증일.
            GS_DISPLAY2-INVTEXT = ZSBMM0060_ALV3-INVTEXT. " 송장헤더텍스트.

            MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 INDEX SY-TABIX
            TRANSPORTING STATUS EMPID2 INVOPDATE INVTEXT.

            MOVE-CORRESPONDING GS_DISPLAY2 TO LS_ZTBMM0060.

            UPDATE ZTBMM0060
            SET EMPID2 = LV_EMPID
                INVOPDATE = SY-DATUM
                STATUS = 'X'
                INVTEXT = ZSBMM0060_ALV3-INVTEXT
          WHERE INVONUM EQ GS_DISPLAY2-INVONUM.
          ENDLOOP.

          MESSAGE S223. " 송장검증결과를 저장하였습니다.

          CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE " 삭제 후 PAI-PBO 동작해서 ALV2 REFRESH.
            EXPORTING
              NEW_CODE = 'ENTER'.

          PERFORM REFRESH_ALV1.
          PERFORM REFRESH_ALV2.

          LEAVE TO SCREEN 0.
        ELSE. " 컨펌팝업 NO
          MESSAGE S214. " 송장검증결과 저장을 취소하였습니다.
        ENDIF.
    ENDCASE.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form UPDATE_GT_DISPLAY2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM UPDATE_GT_DISPLAY2 .
  LOOP AT GT_DISPLAY2 INTO GS_DISPLAY2.
    CASE GS_DISPLAY2-STATUS.
      WHEN 'A'.
        GS_DISPLAY2-EXCP = '2'.
      WHEN 'B'.
        GS_DISPLAY2-EXCP = '3'.
      WHEN 'X'.
        GS_DISPLAY2-EXCP = '1'.
    ENDCASE.
    MODIFY GT_DISPLAY2 FROM GS_DISPLAY2 INDEX SY-TABIX TRANSPORTING EXCP.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT_ALV1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_SORT_ALV1 .
  DATA: LS_SORT TYPE LVC_S_SORT.

  LS_SORT-FIELDNAME = 'PONUM'.
  LS_SORT-UP = 'X'.
  LS_SORT-SUBTOT = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'EXCP'.
  LS_SORT-UP = 'X'..
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'BPCODE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'BPNAME'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'PLTCODE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'PLTNAME'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'WHCODE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'WHNAME'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'PODATE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'EINDT'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'INBODATE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'EMPID'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'MATCODE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT1.
  CLEAR LS_SORT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT_ALV2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_SORT_ALV2 .
  DATA: LS_SORT TYPE LVC_S_SORT.

  LS_SORT-FIELDNAME = 'INVONUM'.
  LS_SORT-UP = 'X'.
  LS_SORT-SUBTOT = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'EXCP'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'PONUM'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'BPCODE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'BPNAME'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'INBODATE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'EMPID'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'MATCODE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'EMPID2'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'INVOPDATE'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

  LS_SORT-FIELDNAME = 'INVTEXT'.
  LS_SORT-UP = 'X'.
  APPEND LS_SORT TO GT_SORT2.
  CLEAR LS_SORT.

ENDFORM.
