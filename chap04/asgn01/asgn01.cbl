       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHAP04A01.
       
      *****************************************************************
      * PROGRAM NAME : Chapter 04 Assignment 01                       *
      * PROGRAM ID   : CHAP04A01                                      *
      *                                                               *
      * AUTHOR       : Manuel A. Martinez                             *
      * DATE WRITTEN : 2026-07-20                                     *
      * DATE COMPILED:                                                *
      *                                                               *
      * INSTALLATION : Manuel Martinez Development Lab                *
      * ENVIRONMENT  : Linux ARM64 GnuCOBOL 3.2                       *
      *                                                               *
      * PROGRAM TYPE : Batch                                          *
      *                                                               *
      *===============================================================*
      *                                                               *
      * DESCRIPTION :                                                 *
      *   [Brief description of what the program does - 2-3 lines]    *
      *                                                               *
      *===============================================================*
      *                                                               *
      * BUSINESS PURPOSE :                                            *
      *   Educational                                                 *
      *                                                               *
      *===============================================================*
      *                                                               *
      * INPUT FILES :                                                 *
      *   -------------------- -------------------------------------- *
      *   | File Name       | Description                           | *
      *   -------------------- -------------------------------------- *
      *   | asgn01-i.dat    | Customer master data                  | *
      *   -------------------- -------------------------------------- *
      *                                                               *
      * OUTPUT FILES :                                                *
      *   -------------------- -------------------------------------- *
      *   | File Name       | Description                           | *
      *   -------------------- -------------------------------------- *
      *   | asgn01-o1.dat   | Vertical labels (stacked)             | *
      *   | asgn01-o2.dat   | Horizontal labels (side-by-side)      | *
      *   -------------------- -------------------------------------- *
      *                                                               *
      *===============================================================*
      *                                                               *
      * ERROR HANDLING :                                              *
      *   Overall, the program handles open, read, end-of-file, write,*
      *       string overflow, close, and abnormal cleanup conditions.*
      *                                                               *
      *===============================================================*
      *                                                               *
      * REVISION HISTORY :                                            *
      *   2026-07-DD  MAM  Initial version                            *
      *                                                               *
      *****************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE
               ASSIGN TO "asgn01-i.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-CUSTOMER-STATUS.
           SELECT STACKED-LABEL
               ASSIGN TO "asgn01-o1.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-STACKED-STATUS.
           SELECT SIDE-LABEL
               ASSIGN TO "asgn01-o2.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-SIDE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  CUSTOMER-FILE.
       01  CUSTOMER-REC.
           05  IN-CUSTOMER-NAME          PIC X(20).
           05  IN-STREET-ADDRESS         PIC X(20).
           05  IN-CITY                   PIC X(10).
           05  IN-STATE                  PIC X(2).
           05  IN-ZIPCODE                PIC X(5).

       FD  STACKED-LABEL.
       01  STACKED-REC.
           05  LABEL-LINE-STACK           PIC X(20).
           
       FD  SIDE-LABEL.
       01  SIDE-REC.
           05  LABEL-LINE-SIDE            PIC X(60).

       WORKING-STORAGE SECTION.
       01  WS-WORKING-AREA.
           05  WS-END-OF-FILE      PIC X VALUE "N".
               88  END-OF-FILE           VALUE "Y".
               
       01  WS-SIDE-LABEL.
           05  LEFT-SIDE-LABEL           PIC X(20).
           05  FILLER                    PIC X(20).
           05  RIGHT-SIDE-LABEL          PIC X(20).
       01  WS-FILE-STATUS.
           05  WS-CUSTOMER-STATUS        PIC XX.
           05  WS-STACKED-STATUS         PIC XX.
           05  WS-SIDE-STATUS            PIC XX.
       01  WS-FILE-OPEN-SWITCHES.
           05  WS-CUSTOMER-OPEN          PIC X VALUE "N".
               88  CUSTOMER-IS-OPEN            VALUE "Y".
           05  WS-STACKED-OPEN           PIC X VALUE "N".
               88  STACKED-IS-OPEN             VALUE "Y".
           05  WS-SIDE-OPEN              PIC X VALUE "N".
               88  SIDE-IS-OPEN                VALUE "Y".
       
       PROCEDURE DIVISION.
       100-MAIN-MODULE.
      ******************************************************************  
      *    This makes sure that the record written to a file retains 
      *    trailing spaces.
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ******************************************************************     
           OPEN INPUT CUSTOMER-FILE

           IF WS-CUSTOMER-STATUS = "00"
               SET CUSTOMER-IS-OPEN TO TRUE
           ELSE
               DISPLAY "ERROR OPENING CUSTOMER FILE: " 
                   WS-CUSTOMER-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF

           OPEN OUTPUT STACKED-LABEL
                       
           IF WS-STACKED-STATUS = "00"
               SET STACKED-IS-OPEN TO TRUE
           ELSE
               DISPLAY "ERROR OPENING STACKED LABEL FILE: " 
                   WS-STACKED-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF

           OPEN OUTPUT SIDE-LABEL

           IF WS-SIDE-STATUS = "00"
               SET SIDE-IS-OPEN TO TRUE
           ELSE
               DISPLAY "ERROR OPENING SIDE LABEL FILE: " 
                   WS-SIDE-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF

           PERFORM 150-READ-CUSTOMER
           PERFORM UNTIL END-OF-FILE
               PERFORM 200-STACKED-LABEL
               PERFORM 300-SIDE-LABEL
               PERFORM 150-READ-CUSTOMER
           END-PERFORM
           PERFORM 600-END-PROGRAM
           .
       150-READ-CUSTOMER.
           READ CUSTOMER-FILE

           EVALUATE WS-CUSTOMER-STATUS
               WHEN "00"
                   CONTINUE
               WHEN "10"
                   SET END-OF-FILE TO TRUE
               WHEN OTHER
                   DISPLAY "ERROR READING CUSTOMER FILE: "
                       WS-CUSTOMER-STATUS
                   PERFORM 700-ABEND-PROGRAM
           END-EVALUATE
           .
       200-STACKED-LABEL.
           PERFORM 2 TIMES
               MOVE ALL "-" TO LABEL-LINE-STACK
               PERFORM 400-WRITE-STACKED
               MOVE IN-CUSTOMER-NAME TO LABEL-LINE-STACK
               PERFORM 400-WRITE-STACKED
               MOVE IN-STREET-ADDRESS TO LABEL-LINE-STACK
               PERFORM 400-WRITE-STACKED

               MOVE SPACES TO LABEL-LINE-STACK
           
               STRING
                   FUNCTION TRIM(IN-CITY)
                       DELIMITED BY SIZE
                   ", "
                       DELIMITED BY SIZE
                   FUNCTION TRIM(IN-STATE)
                       DELIMITED BY SIZE
                   " "
                       DELIMITED BY SIZE
                   FUNCTION TRIM(IN-ZIPCODE)
                       DELIMITED BY SIZE
                   INTO LABEL-LINE-STACK
                   ON OVERFLOW
                       DISPLAY "LABEL OVERFLOW FOR CUSTOMER: "
                           IN-CUSTOMER-NAME
                       PERFORM 700-ABEND-PROGRAM
               END-STRING
               PERFORM 400-WRITE-STACKED
           END-PERFORM
           .
       300-SIDE-LABEL.
           MOVE ALL "-" TO LABEL-LINE-SIDE
           PERFORM 500-WRITE-SIDE
           
      *    Line 1: Name
           MOVE SPACES TO WS-SIDE-LABEL
           MOVE IN-CUSTOMER-NAME 
               TO LEFT-SIDE-LABEL
                  RIGHT-SIDE-LABEL
           MOVE WS-SIDE-LABEL TO LABEL-LINE-SIDE
           PERFORM 500-WRITE-SIDE

      *    Line 2: Address    
           MOVE SPACES TO WS-SIDE-LABEL
           MOVE IN-STREET-ADDRESS 
               TO LEFT-SIDE-LABEL
                  RIGHT-SIDE-LABEL
           MOVE WS-SIDE-LABEL TO LABEL-LINE-SIDE
           PERFORM 500-WRITE-SIDE

      *    Line 3: City State ZIP
           MOVE SPACES TO WS-SIDE-LABEL
           STRING
               FUNCTION TRIM(IN-CITY)
                   DELIMITED BY SIZE
               ", "
                   DELIMITED BY SIZE
               FUNCTION TRIM(IN-STATE)
                   DELIMITED BY SIZE
               " "
                   DELIMITED BY SIZE
               FUNCTION TRIM(IN-ZIPCODE)
                   DELIMITED BY SIZE
               INTO LEFT-SIDE-LABEL
                   ON OVERFLOW
                       DISPLAY "LABEL OVERFLOW FOR CUSTOMER: "
                           IN-CUSTOMER-NAME
                       PERFORM 700-ABEND-PROGRAM
               END-STRING
               MOVE LEFT-SIDE-LABEL TO RIGHT-SIDE-LABEL
               MOVE WS-SIDE-LABEL TO LABEL-LINE-SIDE
               PERFORM 500-WRITE-SIDE
           .

       400-WRITE-STACKED.
           WRITE STACKED-REC

           IF WS-STACKED-STATUS NOT = "00"
               DISPLAY "ERROR WRITING STACKED LABEL FILE: "
                   WS-STACKED-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF
           .

       500-WRITE-SIDE.
           WRITE SIDE-REC

           IF WS-SIDE-STATUS NOT = "00"
               DISPLAY "ERROR WRITING SIDE LABEL FILE: "
                   WS-SIDE-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF
           .
       600-END-PROGRAM.
           CLOSE CUSTOMER-FILE
                 
           IF WS-CUSTOMER-STATUS NOT = "00"
               DISPLAY "ERROR CLOSING CUSTOMER FILE: "
                   WS-CUSTOMER-STATUS
           END-IF

           MOVE "N" TO WS-CUSTOMER-OPEN

           CLOSE STACKED-LABEL
           IF WS-STACKED-STATUS NOT = "00"
               DISPLAY "ERROR CLOSING STACKED LABEL FILE: "
                   WS-STACKED-STATUS
           END-IF

           MOVE "N" TO WS-STACKED-OPEN

           CLOSE SIDE-LABEL
           IF WS-SIDE-STATUS NOT = "00"
               DISPLAY "ERROR CLOSING SIDE LABEL FILE: "
                   WS-SIDE-STATUS
           END-IF

           MOVE "N" TO WS-SIDE-OPEN

           STOP RUN
           .
       700-ABEND-PROGRAM.
           DISPLAY "PROGRAM TERMINATED DUE TO A FILE ERROR"
           IF CUSTOMER-IS-OPEN
               CLOSE CUSTOMER-FILE
               MOVE "N" TO WS-CUSTOMER-OPEN
           END-IF

           IF STACKED-IS-OPEN
               CLOSE STACKED-LABEL
               MOVE "N" TO WS-STACKED-OPEN
           END-IF

           IF SIDE-IS-OPEN
               CLOSE SIDE-LABEL
               MOVE "N" TO WS-SIDE-OPEN
           END-IF
           STOP RUN
           .
