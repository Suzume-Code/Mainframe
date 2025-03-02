USSN     TITLE '-- ACF/VTAM USS TABLE FOR NONSNA DEVICES'
         SPACE
*/* ------------------------------------------------------------------
*/*
*/*  USS TABLE FOR NONSNA DEVICES ...
*/*
*/*  . CAN USE 3270 CONTROL CHARACTERS
*/*
*/* ------------------------------------------------------------------
         SPACE
USSN     USSTAB   FORMAT=DYNAMIC
         SPACE
LOGON    USSCMD   CMD=LOGON,REP=LOGON,FORMAT=BAL
         USSPARM  PARM=P1,REP=DATA,DEFAULT=' '
         USSPARM  PARM=LOGMODE
         USSPARM  PARM=APPLID,DEFAULT='TSO'
         SPACE
L        USSCMD   CMD=L,REP=LOGON,FORMAT=BAL
         USSPARM  PARM=P1,REP=APPLID,DEFAULT='TSO'
         USSPARM  PARM=LOGMODE
         SPACE
TSO      USSCMD   CMD=TSO,REP=LOGON,FORMAT=BAL
         USSPARM  PARM=P1,REP=DATA
         USSPARM  PARM=LOGMODE
         USSPARM  PARM=APPLID,DEFAULT='TSO'
         EJECT
*
* COLOR
*
&BLUE    SETC  'X''2902C0F842F1'''       SFE HI,SKIP,BLUE
&RED     SETC  'X''2902C0F842F2'''       SFE HI,SKIP,RED
&PINK    SETC  'X''2902C0F842F3'''       SFE HI,SKIP,PINK
&GREEN   SETC  'X''2902C0F842F4'''       SFE HI,SKIP,GREEN
&TURQ    SETC  'X''2902C0F842F5'''       SFE HI,SKIP,TURQ
&YELLOW  SETC  'X''2902C0F842F6'''       SFE HI,SKIP,YELLOW
&WHITE   SETC  'X''2902C0F842F7'''       SFE HI,SKIP,WHITE
&BLACK   SETC  'X''2902C0F842F8'''       SFE HI,SKIP,BLACK
&DBLUE   SETC  'X''2902C0F842F9'''       SFE HI,SKIP,DBLUE
&ORANGE  SETC  'X''2902C0F842FA'''       SFE HI,SKIP,ORANGE
&PURPLE  SETC  'X''2902C0F842FB'''       SFE HI,SKIP,PURPLE
&LGREEN  SETC  'X''2902C0F842FC'''       SFE HI,SKIP,LGREEN
&LTURQ   SETC  'X''2902C0F842FD'''       SFE HI,SKIP,LTURQ
&GREY    SETC  'X''2902C0F842FE'''       SFE HI,SKIP,GREY
&BWHITE  SETC  'X''2902C0F842FF'''       SFE HI,SKIP,BOLDWHITE
*
USSMSG10 USSMSG   MSG=10,BUFFER=(BUF010,SCAN)
BUF010   DS    0H
         DC    AL2(END010-BUF010)
*
         DC    X'F5C7'                                   COMMAND + WCC
         DC    X'11',AL2(((24-1)*80)+(80-1))                 R=24,C=80
         DC    X'1DC8'                           PROTECTED,INTENSIFIED
*
         DC    X'11',AL2(((01-1)*80)+(01-1))                 R=01,C=01
         DC    &WHITE
         DC    C'Z/OS Z110 LEVEL 0809                    '
         DC    C'                       DATE : @@@@DATE '
*                ----------++++++++++----------++++++++++
*
         DC    X'11',AL2(((02-1)*80)+(01-1))                 R=02,C=01
         DC    &WHITE
         DC    C'APPLICATION DEVELOPER SYSTEM            '
         DC    C'                       TIME : @@@@TIME '
*                ----------++++++++++----------++++++++++
*
         DC    X'11',AL2(((04-1)*80)+(01-1))                 R=04,C=01
         DC    C'                                        '
         DC    C'                                       '
*
         DC    X'11',AL2(((05-1)*80)+(01-1))                 R=05,C=01
         DC    C'                                        '
         DC    C'                                       '
*
         DC    X'11',AL2(((06-1)*80)+(01-1))                 R=06,C=01
         DC    &TURQ
         DC    C'          .-'') _       ,-.             .'
         DC    C'-'')                                    '
*                ----------++++++++++----------++++++++++
*
         DC    X'11',AL2(((07-1)*80)+(01-1))                 R=07,C=01
         DC    C'         (  OO) )      / /            ( '
         DC    C'OO ).                                  '
*
         DC    X'11',AL2(((08-1)*80)+(01-1))                 R=08,C=01
         DC    C'       ,(_)----.      / /.-''),-----. (_)'
         DC    C'---\_)                                 '
*
         DC    X'11',AL2(((09-1)*80)+(01-1))                 R=09,C=01
         DC    C'       |       |     / /( OO''  .-.  ''/  '
         DC    C'  _ |                                  '
*
         DC    X'11',AL2(((10-1)*80)+(01-1))                 R=10,C=01
         DC    C'       ''--.   /     / / /   |  | |  |\  '
         DC    C':` `.                                  '
*
         DC    X'11',AL2(((11-1)*80)+(01-1))                 R=11,C=01
         DC    C'       (_/   /     / /  \_) |  |\|  | ''.'
         DC    C'.`''''.)                                 '
*
         DC    X'11',AL2(((12-1)*80)+(01-1))                 R=12,C=01
         DC    C'        /   /___  / /     \ |  | |  |.-.'
         DC    C'_)   \                                 '
*
         DC    X'11',AL2(((13-1)*80)+(01-1))                 R=13,C=01
         DC    C'       |        |/ /       `''  ''-''  ''\  '
         DC    C'     /                                 '
*
         DC    X'11',AL2(((14-1)*80)+(01-1))                 R=14,C=01
         DC    C'       `--------''`-''         `-----''  `-'
         DC    C'----''                                  '
*
         DC    X'11',AL2(((16-1)*80)+(01-1))                 R=16,C=01
         DC    C'                                        '
         DC    C'                                       '
*
*--*     DC    X'11',AL2(((18-1)*80)+(01-1))                 R=18,C=01
*--*     DC    C'                                        '
*--*     DC    C'                                       '
*
*--*     DC    X'11',AL2(((19-1)*80)+(01-1))                 R=19,C=01
*--*     DC    C'                                        '
*--*     DC    C'                                       '
*
         DC    X'11',AL2(((18-1)*80)+(01-1))                 R=18,C=01
         DC    &YELLOW
         DC    C' ENTER "LOGON" FOLLOWED BY THE TSO USERI'
         DC    C'D. EXAMPLE "LOGON USERID" OR           '
*                ----------++++++++++----------++++++++++
*
         DC    X'11',AL2(((19-1)*80)+(01-1))                 R=19,C=01
         DC    &YELLOW
         DC    C' ENTER L FOLLOWED BY THE APPLID. EXAMPLE'
         DC    C'S: "L TSO", "L CICS", "L IMS3270"      '
*
         DC    X'11',AL2(((21-1)*80)+(80-1))                 R=21,C=80
         DC    &YELLOW
         DC    C' COMMAND ==>'
         DC    X'1D40'                                     UNPROTECTED
         DC    X'13'                                      INSERTCURSOR
*
*--*     DC    X'11',AL2(((22-1)*80)+(01-1))                 R=22,C=01
*--*     DC    &YELLOW
*--*     DC    C'                                        '
*--*     DC    C'                                       '
*--*             ----------++++++++++----------++++++++++
*
END010   EQU   *
         EJECT
END      USSEND
         END     ,            END OF ASSEMBLY
