*  **PROPRIETARY_STATEMENT********************************************
* *01* PROPRIETARY STATEMENT=                                        *
*                                                                    *
*                                                                    *
*   LICENSED MATERIALS - PROPERTY OF IBM                             *
*   THIS MACRO IS "RESTRICTED MATERIALS OF IBM"                      *
*   5685-025 (C) COPYRIGHT IBM CORP. 1989,1992                       *
*   SEE COPYRIGHT INSTRUCTIONS                                       *
*                                                                    *
*   STATUS= HTE24D2                                                  *
*                                                                    *
*  **END_OF_PROPRIETARY_STATEMENT*************************************
         TITLE 'IKJEFF53 - IBM-SUPPLIED FIB INSTALLATION EXIT'
***********************************************************************
*
*   MODULE NAME = IKJEFF53
*      LOAD MODULE NAME = IKJEFF53
*
*   DESCRIPTIVE NAME = IBM-SUPPLIED VERSION OF FIB INSTALLATION EXIT
*                      FOR SYSTEMS USING JESJOBS AND JESSPOOL
*
*
*
*   FUNCTION =
*      VALIDITY CHECKS JOBNAME ENTERED ON A CANCEL, OUTPUT, OR
*      STATUS FIB (FOREGROUND INITIATED BACKGROUND) COMMAND.
*      THE TSO USER IS RESTRICTED FROM CANCELING OR ACCESSING
*      OUTPUT FROM A JOB THAT DOES NOT BELONG TO THE USER.  AN
*      INSTALLATION-SUPPLIED VERSION OF IKJEFF53 COULD DO OTHER
*      TYPES OF VALIDITY CHECKS.  SEE IKJEFFIE MACRO FOR DETAILS.
*
*      NOTE - FOR THE CANCEL COMMAND, IF THE RACF JESJOBS CLASS
*      IS ACTIVE, THEN NO CHECKING WILL BE DONE.  FOR THE OUTPUT
*      COMMAND, IF THE RACF JESSPOOL CLASS IS ACTIVE, THEN NO
*      CHECKING WILL BE DONE.
*
*   OPERATION =
*
*         IF THE COMMAND IS STATUS, RETURN CONTROL TO THE CALLER
*         OF THIS ROUTINE.  ANY JOBNAME IS ALLOWED.
*
*         IF THE COMMAND IS CANCEL OR OUTPUT, COMPARE THE USERID
*         WITH THE JOBNAME PASSED.  IF THE JOBNAME IS NOT THE
*         USERID PLUS AT LEAST ONE CHARACTER FOR CANCEL, OR DOES
*         NOT START WITH THE USERID FOR OUTPUT, THE JOBNAME IS
*         REJECTED.  ERROR MESSAGE TEXT AND RETURN CODE (INDICATING
*         TO ISSUE PUTLINE MESSAGE) ARE PASSED BACK TO THE CALLER.
*         THEN THIS EXIT IS CALLED AGAIN SO THAT IT MAY FREE THE
*         MESSAGE BUFFER AND RETURN THE CODE THAT REJECTS THE JOBNAME.
*
*         NOTE:
*         THE OUTPUT COMMAND ALLOWS THE JOBNAME TO BE THE USERID (THE
*         JOBNAME FOR THE USER'S LOGON SESSION) SO THE TSO USER
*         MAY ACCESS SYSOUT DATA SETS GENERATED DURING FOREGROUND
*         PROCESSING.
*
*   NOTES =
*
*      DEPENDENCIES =
*         CHARACTER CODE DEPENDENCIES = EBCDIC.
*
*      RESTRICTIONS = N/A
*
*      REGISTER CONVENTIONS = STANDARD
*
*   PATCH LABEL = PATCH (UNUSED AND INITIALIZED TO 'ZAP'S)
*
*   MODULE TYPE = PROCEDURE
*
*      PROCESSOR = IBM HIGH LEVEL ASSEMBLER/MVS               @P50068A
*
*      MODULE SIZE = SEE ASSEMBLER LISTING.
*
*   ATTRIBUTES = RES:PROB.PGM.REGION, REFRESHABLE,
*                KEY 8, AUTHORIZED
*
*   ENTRY POINT = IKJEFF53 (ONLY ENTRY POINT)
*
*      PURPOSE = SEE FUNCTION
*
*      LINKAGE =
*         From IKJEFF51 (CANCEL OR STATUS COMMAND) VIA CALL.
*         From IKJCT469 (OUTPUT COMMAND) VIA CALL.
*
*      INPUT = REGISTER 1 POINTS TO THE PARAMETER LIST
*              FOR A DESCRIPTION OF THE PARM LIST, SEE IKJEFFIE MACRO
*
*      REGISTERS SAVED = 0 - 12 AND 14 - 15
*      REGISTERS USED =  All
*      REGISTERS RESTORED = 0 - 14
*
*   EXIT - NORMAL = AT END OF PROGRAM, TO CALLER VIA BR 14
*      CONDITIONS = SEE OPERATION
*      OUTPUT = NONE
*      RETURN CODE = ZERO
*
*   EXIT - ERROR =  AT END OF PROGRAM, TO CALLER VIA BR 14
*      CONDITIONS = SEE OPERATION
*      OUTPUT = MESSAGEP set in the input parameter list
*      RETURN CODE = (POSSIBLE RETURN CODES)
*          4 - ISSUE PROMPT MESSAGE AND RETURN REPLY
*          8 - ISSUE PUTLINE MESSAGE AND RETURN
*         12 - REJECT THIS JOB AND CONTINUE PROCESSING
*         16 - TERMINATE THE COMMAND
*         (THIS VERSION OF IKJEFF53 USES CODES 8 AND 12)
*
*   EXTERNAL REFERENCES =
*
*      ROUTINES = NONE
*
*      DATA AREAS = NONE
*
*      CONTROL BLOCKS = NONE
*
*      TABLES = NONE
*
*   MACROS = MODID, GETMAIN, FREEMAIN, RACROUTE               @YA64055
*      SERIALIZATION = NONE
*
*   MESSAGES =
*      NO MESSAGES ARE ISSUED BY THIS MODULE.
*
*      HOWEVER THE FOLLOWING MESSAGE TEXTS ARE PASSED TO THE CALLER,
*      WHICH ISSUES PUTLINE MESSAGE IKJ56208I (IF CANCEL) OR MESSAGE
*      IKJ56328I (IF OUTPUT) -
*
*         JOB <JOBNAME> REJECTED - JOBNAME MUST BE YOUR USERID
*         PLUS AT LEAST ONE CHARACTER                    (FOR CANCEL)
*
*         JOB <JOBNAME> REJECTED - JOBNAME MUST BE YOUR USERID OR
*         MUST START WITH YOUR USERID                    (FOR OUTPUT)
*
*      THIS MODULE COULD ALSO PASS THE CALLER TEXT TO BE INSERTED
*      INTO PUTGET MESSAGE IKJ56208A OR IKJ56328A.
*
*   ABEND CODES = NONE
*
*   CHANGE ACTIVITY =
*     @E21X2B1 - TSO/E VERSION 2 RELEASE 1.1                  @E21X2B1
*     @PMH0156 - CHANGE RACSTAT MACRO TO RACROUTE             @PMH0156
*                (SUG APAR OY55619)                           @PMH0156
*     @OY64055 - COPY THE STATIC RACROUTE PARAMETER LIST      @YA64055
*                INTO THE DYNAMIC STORAGE PARAMETER LIST      @YA64055
* $P5=PTM,HTE25D2,,KLZ: PROCESSOR INFORMATION UPDATE          @P50068A
***********************************************************************
         EJECT
IKJEFF53 CSECT ,
         USING *,R15
         MODID
         DROP  R15
         STM   R14,R12,12(R13)      SAVE THE REGISTERS
         LR    R12,R15              SET THE BASE REGISTER
         USING IKJEFF53,R12
         L     R00,DYNSIZE          SIZE FOR GETMAIN
         GETMAIN  R,LV=(0)          GET DYNAMIC AREA
         LR    R11,R01              SET THE DATA REGISTER
         USING DYNAREA,R11
         ST    R13,SAVEAREA+4       SAVE BACKWARD POINTER
         LM    R00,R01,20(R13)      RESTORE REGS USED BY GETMAIN
         ST    R11,8(,R13)          SAVE FORWARD POINTER
         LR    R13,R11              SET SAVEAREA POINTER
*
INITIALIZE EQU *
*                                                             @YA64055
* COPY THE STATIC RACROUTE PARAMETER LIST INTO THE DYNAMIC    @YA64055
* STORAGE PARAMETER LIST                                      @YA64055
*                                                             @YA64055
         LA    R04,STATWAD          LOAD THE ADDRESS OF THE   @YA64055
*                                   DYNAMIC STORAGE PARAMATER @YA64055
*                                   LIST                      @YA64055
         LA    R06,STATWAS          LOAD THE ADDRESS OF THE   @YA64055
*                                   STATIC STORAGE PARAMETER  @YA64055
*                                   LIST                      @YA64055
         L     R05,STATWAL          LOAD THE LENGTH OF THE    @YA64055
*                                   PARAMETER LIST            @YA64055
         LR    R07,R05              COPY THE LENGTH INTO R07  @YA64055
*                                   FOR THE MVCL              @YA64055
         MVCL  R04,R06              COPY THE STATIC PARAMETER @YA64055
*                                   INTO THE DYNAMICALLY      @YA64055
*                                   ALLOCATED STORAGE         @YA64055
         LR    IEPTR,R01            INPUT PARAMETER POINTER
         SLR   RETCODE,RETCODE      INITIALIZE RETURN CODE TO "OK"
*
* ONLY DO PROCESSING IF CALLER IS CANCEL OR OUTPUT COMMAND
*
         L     R10,CODEP(,IEPTR)
         CLI   CMNDCODE(R10),CANCEL COMMAND IS CANCEL
         BE    CANCEL_OR_OUTPUT     YES
         CLI   CMNDCODE(R10),OUTPUT COMMAND IS OUTPUT
         BNE   RETURN_TO_CALLER     NO
CANCEL_OR_OUTPUT EQU *
         CLI   CMNDCODE(R10),CANCEL COMMAND IS CANCEL
         BE    ISCANCEL             YES
*
* FOR THE OUTPUT COMMAND, CHECK TO SEE IF THE JESSPOOL CLASS IS ACTIVE.
* IF IT IS, NO JOBNAME CHECKING WILL BE DONE.  THIS WILL BE TO ENSURE
* THAT THE FEATURE OF JESSPOOL OUTPUT "OWNERSHIP" IS NOT RESTRICTED BY
* THIS EXIT TO JOBNAMES THAT BEGIN WITH USERID.
*
         RACROUTE REQUEST=STAT,     REQUEST STATUS            @PMH0156 +
               CLASS=SPOOL,         CHECK JESSPOOL CLASS      @PMH0156 +
               RELEASE=1.9,         USE PROPER RELEASE        @PMH0156 +
               WORKA=SAFWA,         SUPPLY A WORK AREA        @PMH0156 +
               MF=(E,STATWAD)       SPECIFY STATUS WORK AREA  @YA64055
         LTR   R15,R15              CHECK FOR REQUEST DONE    @PMH0156
         BNZ   CHECK_JOBNAME        REQUEST NOT DONE, WE MUST @PMH0156
*                                   DO THE CHECKING           @PMH0156
         LA    R10,STATWAD          GET SAF PARAMETER AREA    @YA64055
         USING SAFP,R10             ESTABLISH ADDRESSABILITY  @PMH0156
         L     R09,SAFPRRET         GET STAT RETURN CODE      @PMH0156
         LTR   R09,R09              CHECK FOR CLASS ACTIVE    @PMH0156
         BZ    RETURN_TO_CALLER     CLASS IS ACTIVE, NOTHING TO DO
         B     CHECK_JOBNAME        CLASS IS NOT ACTIVE, DO CHECKING
ISCANCEL EQU   *                    COMMAND IS CANCEL
*
* FOR THE CANCEL COMMAND, CHECK TO SEE IF THE JESJOBS CLASS IS ACTIVE.
* IF IT IS, NO JOBNAME CHECKING WILL BE DONE.  THIS WILL BE TO ENSURE
* THAT THE FEATURE OF JESJOBS JOB "OWNERSHIP" IS NOT RESTRICTED BY
* THIS EXIT TO JOBNAMES THAT BEGIN WITH USERID.
*
         RACROUTE REQUEST=STAT,     Request status            @PMH0156 +
               CLASS=JOBS,          Check JESJOBS class       @PMH0156 +
               RELEASE=1.9,         Use proper release        @PMH0156 +
               WORKA=SAFWA,         Supply a work area        @PMH0156 +
               MF=(E,STATWAD)       Specify status work area  @YA64055
         LTR   R15,R15              Check for request done    @PMH0156
         BNZ   CHECK_JOBNAME        Request not done, we must @PMH0156
*                                   do the checking           @PMH0156
         LA    R10,STATWAD          Get SAF parameter area    @YA64055
         USING SAFP,R10             Establish addressability  @PMH0156
         L     R09,SAFPRRET         Get STAT return code      @PMH0156
         LTR   R09,R09              Check for class active    @PMH0156
         BZ    RETURN_TO_CALLER     Class is active, nothing to do
CHECK_JOBNAME EQU *
*
* IF NO MESSAGE ISSUED FOR LAST ENTRY
*
         L     R10,MESSAGEP(,IEPTR)
         LTR   R10,R10              IS MESSAGE BUFFER EMPTY
         BNZ   REJECT_COMMAND       MESSAGE WAS ISSUED
*
* CHECK WHETHER JOBNAME IS VALID
*
         L     R10,IDLENPTR(,IEPTR)
         CLI   IDLENGTH(R10),0      CHECK USERID LENGTH
         BE    JOBNAME_INVALID      IF ZERO, COMMAND IS INVALID
         L     R01,CODEP(,IEPTR)
         CLI   CMNDCODE(R01),CANCEL COMMAND IS CANCEL
         BNE   CHECK_OUTPUT_JOBNAME
         L     R01,NAMELENP(,IEPTR)
         SLR   R02,R02
         IC    R02,IDLENGTH(,R10)   GET USERID LENGTH
*--*     CH    R02,JOBNAMEL(,R01)   COMPARE WITH JOBNAME LENGTH
*--*     BNL   JOBNAME_INVALID      INVALID IF USERID < JOBNAME LENGTH
         L     R10,USERIDP(,IEPTR)
         L     R01,JOBNAMEP(,IEPTR) GET JOBNAME LENGTH
         BCTR  R02,0                SUBTRACT FOR "EXECUTE"
*--*     EX    R02,COMPARE_USERID_AND_JOBNAME COMPARE
*--*     BNE   JOBNAME_INVALID      INVALID IF NOT EQUAL
         B     RETURN_TO_CALLER     ELSE RETURN
CHECK_OUTPUT_JOBNAME EQU *
         L     R10,NAMELENP(,IEPTR)
         L     R01,IDLENPTR(,IEPTR)
         SLR   R02,R02
         IC    R02,IDLENGTH(,R01)   GET USERID LENGTH
*--*     CH    R02,JOBNAMEL(,R10)   COMPARE WITH JOBNAME LENGTH
*--*     BH    JOBNAME_INVALID      INVALID IF USERID > JOBNAME LENGTH
         L     R10,USERIDP(,IEPTR)
         L     R01,JOBNAMEP(,IEPTR) GET JOBNAME LENGTH
         BCTR  R02,0                SUBTRACT FOR "EXECUTE"
*--*     EX    R02,COMPARE_USERID_AND_JOBNAME COMPARE
*--*     BE    RETURN_TO_CALLER     VALID IF EQUAL
         B     RETURN_TO_CALLER     BRANCH TO RETURN_TO_CALLER
JOBNAME_INVALID EQU *
*
* JOBNAME IS INVALID.  BUILD MESSAGE SAYING JOBNAME IS REJECTED
*
         L     R00,GETMINFO         SUBPOOL AND LENGTH OF MESSAGE AREA
         GETMAIN R,LV=(0)               GET MESSAGE BUFFER
         ST    R01,MESSAGEP(,IEPTR) Move msg buff ptr to parm list
         L     R10,MESSAGEP(,IEPTR)
         MVI   REJMSG(R10),C' '     Move in one blank
         MVC   REJMSG+1(83,R10),REJMSG(R10) Init buffer with blanks
         MVC   REJMLEN(2,R10),MSGLENTH Maximum length
         MVI   REJJOB+3(R10),C' '   Move in one blank
         MVC   REJJOB(3,R10),JOBCONST Put in "JOB"
         L     R01,NAMELENP(,IEPTR)
         LH    R02,JOBNAMEL(,R01)   Get JOBNAME length
         LR    R03,R02              Make a copy
         BCTR  R03,0                Subtract for "execute"
         L     R01,JOBNAMEP(,IEPTR)
         EX    R03,MOVE_JOBNAME     Insert the bad JOBNAME
         AL    R02,TWO              Get offset of blank after JOBNAME
         LR    TEMPOFST,R02         Index past blank after JOBNAME
         L     R01,CODEP(,IEPTR)
         CLI   CMNDCODE(R01),CANCEL Command is CANCEL
         BNE   DO_OUTPT             MUST BE OUTPUT
         ALR   R10,TEMPOFST
         MVC   REJSLOT-1(66,R10),REJTEXT1 Move in reason for rejection
         B     SET_RC
DO_OUTPT L     R10,MESSAGEP(,IEPTR)
         ALR   R10,TEMPOFST
         MVC   REJSLOT-1(69,R10),REJTEXT2 MOVE IN REASON FOR REJECTION
SET_RC   LA    RETCODE,8            SET RETURN CODE
         B     RETURN_TO_CALLER
REJECT_COMMAND EQU *
*
* SECOND TIME ENTRY (FREE MESSAGE BUFFER AND REJECT JOBNAME)
*
         LA    RETCODE,12           SET RETURN CODE
         L     R01,MESSAGEP(,IEPTR) GET MESSAGE BUFFER
         L     R00,GETMINFO         SUBPOOL AND LENGTH OF MESSAGE AREA
         FREEMAIN  R,LV=(0),A=(1)   FREE MESSAGE BUFFER
         SLR   R10,R10
         ST    R10,MESSAGEP(,IEPTR) RESET MESSAGE BUFFER
RETURN_TO_CALLER EQU *
*
* RETURN TO CALLER (STATUS, CANCEL, OR OUTPUT COMMAND)
*
         L     R13,4(,R13)          Get previous savearea
         L     R00,DYNSIZE          Size for FREEMAIN
         LR    R01,R11              Address for FREEMAIN
         FREEMAIN R,LV=(0),A=(1)
         LR    R15,RETCODE          Set Return Code
         L     R14,12(,R13)         Restore Retreg
         LM    R00,R12,20(R13)      Restore rest of regs
         BR    R14                  Return
*
* DYNAMIC AREA OF MODULE DATA
*
DYNAREA  DSECT
SAVEAREA DS    18F
INPPARMS DS    1F
SAFWA    DS    CL512                   SAF WORK AREA          @PMH0156
STATWAD  RACROUTE REQUEST=STAT,     REQUEST STATUS            @YA64055 +
               CLASS='JESSPOOL',    CHECK JESSPOOL CLASS      @PMH0156 +
               RELEASE=1.9,         USE PROPER RELEASE        @PMH0156 +
               WORKA=*-*,           SUPPLY A WORK AREA        @YA64055 +
               MF=L                 SPECIFY LIST FORM         @PMH0156
         DS    0D
         ORG   *+1-(*-DYNAREA)/(*-DYNAREA) INSURE DSECT DATA
ENDDYN   EQU   *
         ICHSAFP                    SAF PARAMETER MAPPING     @PMH0156
*
* STATIC AREA OF MODULE CONSTANTS
*
IKJEFF53 CSECT
STATAREA DS    0H
STATWAS  RACROUTE REQUEST=STAT,     REQUEST STATUS            @YA64055 +
               CLASS='JESSPOOL',    CHECK JESSPOOL CLASS      @YA64055 +
               RELEASE=1.9,         USE PROPER RELEASE        @YA64055 +
               WORKA=*-*,           SUPPLY A WORK AREA        @YA64055 +
               MF=L                 SPECIFY LIST FORM         @YA64055
STATWAL  DC    A(*-STATWAS)                                   @YA64055
MSGLENTH DC    H'84'
COMPARE_USERID_AND_JOBNAME CLC USERID(0,R10),IEJOBNM(R01)
MOVE_JOBNAME MVC REJSLOT(0,R10),IEJOBNM(R01)
TWO      DC    F'2'
         DS    0F
DYNSIZE  DC    AL1(0)
         DC    AL3(((ENDDYN-DYNAREA+7)/8)*8)
         DS    0D
JOBCONST DC    C'JOB'
REJTEXT1 DC    CL66'REJECTED - JOBNAME MUST BE YOUR USERID PLUS AT LEASC
               T ONE CHARACTER'
REJTEXT2 DC    CL69'REJECTED - JOBNAME MUST BE YOUR USERID OR MUST STARC
               T WITH YOUR USERID'
         DS    CL2
GETMINFO DS    CL4
         ORG   GETMINFO
GETMSP   DC    AL1(0)
GETMLEN  DC    AL3(84)
         ORG   GETMINFO+4
PATCH    DS    CL21
         ORG   PATCH
PTCHINIT DC    7CL3'ZAP'
         ORG   PATCH+21
SPOOL    DC    CL8'JESSPOOL'           CLASS IS JESSPOOL      @PMH0156
JOBS     DC    CL8'JESJOBS '           CLASS IS JESJOBS       @PMH0156
R00      EQU   00                      EQUATES FOR REGISTERS 0-15
R01      EQU   01
R02      EQU   02
R03      EQU   03
R04      EQU   04
R05      EQU   05
R06      EQU   06
R07      EQU   07
R08      EQU   08
R09      EQU   09
R10      EQU   10
R11      EQU   11
R12      EQU   12
R13      EQU   13
R14      EQU   14
R15      EQU   15
TEMPOFST EQU   R05
RETCODE  EQU   R05
IEPTR    EQU   R04
CANCEL   EQU   4
OUTPUT   EQU   8
REJMSG   EQU   0
REJMLEN  EQU   REJMSG
REJJOB   EQU   REJMSG+2
REJSLOT  EQU   REJMSG+6
PARMLIST EQU   0
JOBNAMEP EQU   PARMLIST
NAMELENP EQU   PARMLIST+4
USERIDP  EQU   PARMLIST+8
IDLENPTR EQU   PARMLIST+12
MESSAGEP EQU   PARMLIST+16
REPLYP   EQU   PARMLIST+20
CODEP    EQU   PARMLIST+24
JOBIDP   EQU   PARMLIST+28
JIDLENP  EQU   PARMLIST+32
IEOUTPLP EQU   PARMLIST+36
IEJOBNM  EQU   0
JOBNAMEL EQU   0
USERID   EQU   0
IDLENGTH EQU   0
CMNDCODE EQU   0
MESSAGE  EQU   0
IEREPLY  EQU   0
IEOUTPL  EQU   0
IESYNTAX EQU   IEOUTPL+16
IEJOBID  EQU   0
JIDLEN   EQU   0
PARM     EQU   0
         DS    0D
ENDSTAT  EQU   *
         END   IKJEFF53
