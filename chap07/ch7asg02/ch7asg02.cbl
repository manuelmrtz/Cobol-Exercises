       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CH7ASG02.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PAYROLL-MASTER ASSIGN TO "master.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PAYROLL-REPORT 
               ASSIGN TO LINE ADVANCING "report.txt".
           SELECT PRINTER-LIST
               ASSIGN TO "printer-list.txt"
               ORGANIZATION IS LINE SEQUENTIAL.    
       
       DATA DIVISION.
       FILE SECTION.
       FD  PAYROLL-MASTER.
       01  MASTER-REC.
           05  IN-EMPLOYEE-NO       PIC X(5).
           05  IN-EMPLOYEE-NAME     PIC X(20).
           05                       PIC X(4).
           05  IN-ANNUAL-SALARY     PIC 9(6).
           05                       PIC X(13).
           05  IN-UNION-DUES        PIC 9(3)V99.
           05  IN-INSURANCE         PIC 9(3)V99.
           05                       PIC X(22).
       
       FD  PAYROLL-REPORT.
       01  REPORT-REC               PIC X(80).

       FD  PRINTER-LIST.
       01  PRINTER-REC    PIC X(40).
           

       WORKING-STORAGE SECTION.
       01  WS-AREA.
           05 END-OF-FILE           PIC XXX   VALUE "NO ".
           05 IN-DATE.
               10    IN-YEAR        PIC XXXX.
               10    IN-MONTH       PIC XX.
               10    IN-DAY         PIC XX.
           05  RECORD-COUNT         PIC 9(5) VALUE 0.    
           05 REPORT-CONTROL.
               10  PAGE-CONTROL     PIC 99999 VALUE 0.
               10  LINE-CONTROL     PIC 99    VALUE 0. 

       01  REPORT-SET-UP.
           05  HEADING1.
               10                   PIC X(31) VALUE SPACES.
               10                   PIC X(15) VALUE "PAYROLL  REPORT".
               10                   PIC X(21) VALUE SPACES.
               10  OUT-MONTH        PIC XX.
               10                   PIC X     VALUE "/".
               10  OUT-DAY          PIC XX.
               10                   PIC X     VALUE "/".
               10  OUT-YEAR         PIC XXXX.   
               10                   PIC X(3)  VALUE SPACES.
           05  COL-HEADING1.
               10                   PIC X(1)  VALUE SPACES.
               10                   PIC X(8)  VALUE "EMPLOYEE".
               10                   PIC X(9)  VALUE SPACES.    
               10                   PIC X(4)  VALUE "NAME".
               10                   PIC X(11) VALUE SPACES.    
               10                   PIC X(3)  VALUE "OLD".
               10                   PIC X(5)  VALUE SPACES.    
               10                   PIC X(3)  VALUE "NEW".
               10                   PIC X(5)  VALUE SPACES.    
               10                   PIC X(3)  VALUE "OLD".
               10                   PIC X(5)  VALUE SPACES.    
               10                   PIC X(3)  VALUE "NEW".
               10                   PIC X(5)  VALUE SPACES.    
               10                   PIC X(3)  VALUE "OLD".
               10                   PIC X(5)  VALUE SPACES.    
               10                   PIC X(3)  VALUE "NEW".
               10                   PIC X(4)  VALUE SPACES.    
           05  COL-HEADING2.
               10                   PIC X(4)  VALUE SPACES.
               10                   PIC X(3)  VALUE "NO.".
               10                   PIC X(25) VALUE SPACES.    
               10                   PIC X(6)  VALUE "SALARY".
               10                   PIC X(2)  VALUE SPACES.    
               10                   PIC X(6)  VALUE "SALARY".
               10                   PIC X(3)  VALUE SPACES.    
               10                   PIC X(4)  VALUE "DUES".
               10                   PIC X(4)  VALUE SPACES.    
               10                   PIC X(4)  VALUE "DUES".
               10                   PIC X(3)  VALUE SPACES.    
               10                   PIC X(6)  VALUE "INSUR.".
               10                   PIC X(2)  VALUE SPACES.    
               10                   PIC X(6)  VALUE "INSUR.".
               10                   PIC X(2)  VALUE SPACES.        
           05  DETAIL-LINE.
               10                   PIC X(3)  VALUE SPACES.
               10  OUT-EMPLOYEE-NO  PIC X(5).
               10                   PIC X(2)  VALUE SPACES.
               10  OUT-EMPLOYEE-NAME PIC X(20).
               10                    PIC X(2)  VALUE SPACES.
               10  OLD-SALARY        PIC ZZZZZ9.
               10                    PIC X(1)  VALUE SPACES.
               10  NEW-SALARY        PIC ZZZZZZ9.
               10                    PIC X(2)  VALUE SPACES.
               10  OLD-UNION-DUES    PIC ZZZ.99.
               10                    PIC X(1)  VALUE SPACES.
               10  NEW-UNION-DUES    PIC ZZZZ.99.
               10                    PIC X(2)  VALUE SPACES.
               10  OLD-INSURANCE     PIC ZZZ.99.
               10                    PIC X(1)  VALUE SPACES.
               10  NEW-INSURANCE     PIC ZZZZ.99.

       01  PRINTER-AREA.
           05  PRINTER-COUNT       PIC 99 VALUE 0.
           05  PRINTER-SUB         PIC 99 VALUE 0.
           05  PRINTER-SELECTION   PIC 99 VALUE 0.
           05  PRINTER-EOF         PIC X VALUE "N".
               88  PRINTER-EOF-YES       VALUE "Y".
               88  PRINTER-EOF-NO        VALUE "N".
           05  SELECTED-PRINTER    PIC X(40) VALUE SPACES.
           05  PRINT-COMMAND       PIC X(150) VALUE SPACES.
           05  SYSTEM-STATUS       PIC S9(9) COMP-5 VALUE 0.

       01  PRINTER-TABLE.
           05  PRINTER-ENTRY OCCURS 20 TIMES.
               10  TABLE-PRINTER-NAME    PIC X(40).     
               
       PROCEDURE DIVISION.
       100-MAIN-MODULE.
      ******************************************************************
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ******************************************************************
           OPEN INPUT PAYROLL-MASTER
               OUTPUT PAYROLL-REPORT

           DISPLAY "RUNNING..."
           MOVE FUNCTION CURRENT-DATE TO IN-DATE
           MOVE IN-YEAR TO OUT-YEAR
           MOVE IN-MONTH TO OUT-MONTH
           MOVE IN-DAY TO OUT-DAY
           READ PAYROLL-MASTER
               AT END
                   MOVE "YES" TO END-OF-FILE    
               NOT AT END
                   PERFORM 200-PRINT-HEADING    
           END-READ
           PERFORM UNTIL END-OF-FILE = "YES"
               PERFORM 300-PRINT-DETAIL
               READ PAYROLL-MASTER
                   AT END
                       MOVE "YES" TO END-OF-FILE
               END-READ
           END-PERFORM

           CLOSE PAYROLL-MASTER
                 PAYROLL-REPORT

           IF RECORD-COUNT > 0
               PERFORM 400-SELECT-PRINTER
           ELSE
               DISPLAY "NO REPORT PRINTED - NO DATA."
           END-IF

           STOP RUN
           .
       200-PRINT-HEADING.
           ADD 1 TO PAGE-CONTROL
           
           IF PAGE-CONTROL = 1
               WRITE REPORT-REC FROM HEADING1
                  AFTER ADVANCING 1 LINES
           ELSE
               MOVE SPACES TO REPORT-REC
               WRITE REPORT-REC  
                   AFTER ADVANCING PAGE
               WRITE REPORT-REC FROM HEADING1 
                   
           END-IF

           WRITE REPORT-REC FROM COL-HEADING1
               AFTER ADVANCING 2 LINES

           WRITE REPORT-REC FROM COL-HEADING2    
               AFTER ADVANCING 1 LINE

           MOVE SPACES TO REPORT-REC
               WRITE REPORT-REC
                   AFTER ADVANCING 1 LINE
           MOVE 0 TO LINE-CONTROL
           .
       300-PRINT-DETAIL.
           IF LINE-CONTROL >= 55
               PERFORM 200-PRINT-HEADING
           END-IF
           MOVE IN-EMPLOYEE-NO TO OUT-EMPLOYEE-NO
           MOVE IN-EMPLOYEE-NAME TO OUT-EMPLOYEE-NAME
           MOVE IN-ANNUAL-SALARY TO OLD-SALARY
           MULTIPLY IN-ANNUAL-SALARY BY 1.07 GIVING NEW-SALARY ROUNDED
           MOVE IN-UNION-DUES TO OLD-UNION-DUES
           MULTIPLY IN-UNION-DUES BY 1.04 GIVING NEW-UNION-DUES ROUNDED       
           MOVE IN-INSURANCE TO OLD-INSURANCE
           MULTIPLY IN-INSURANCE BY 1.03 GIVING NEW-INSURANCE ROUNDED
           MOVE DETAIL-LINE TO REPORT-REC
           WRITE REPORT-REC
           ADD 1 TO LINE-CONTROL
           ADD 1 TO RECORD-COUNT
           .
       400-SELECT-PRINTER.

           CALL "SYSTEM"
               USING
               "lpstat -p | awk '{print $2}' > printer-list.txt"
               RETURNING SYSTEM-STATUS

           IF SYSTEM-STATUS NOT = 0
               DISPLAY "ERROR GETTING PRINTER LIST."
               EXIT PARAGRAPH
           END-IF

           MOVE 0 TO PRINTER-COUNT
           SET PRINTER-EOF-NO TO TRUE

           OPEN INPUT PRINTER-LIST

           PERFORM UNTIL PRINTER-EOF-YES

               READ PRINTER-LIST
                   AT END
                       SET PRINTER-EOF-YES TO TRUE

                   NOT AT END
                       IF PRINTER-COUNT < 20
                           ADD 1 TO PRINTER-COUNT
                           MOVE PRINTER-REC
                               TO TABLE-PRINTER-NAME(PRINTER-COUNT)
                       END-IF
               END-READ

           END-PERFORM

           CLOSE PRINTER-LIST

           IF PRINTER-COUNT = 0
               DISPLAY "NO PRINTERS FOUND."
               EXIT PARAGRAPH
           END-IF

           DISPLAY SPACE
           DISPLAY "AVAILABLE PRINTERS"
           DISPLAY "------------------"
           DISPLAY SPACE

           PERFORM VARYING PRINTER-SUB FROM 1 BY 1
               UNTIL PRINTER-SUB > PRINTER-COUNT

               DISPLAY PRINTER-SUB ". "
                   TABLE-PRINTER-NAME(PRINTER-SUB)

           END-PERFORM

           DISPLAY SPACE

           MOVE 0 TO PRINTER-SELECTION

           PERFORM UNTIL
               PRINTER-SELECTION >= 1
               AND PRINTER-SELECTION <= PRINTER-COUNT

               DISPLAY "SELECT PRINTER: "
                   WITH NO ADVANCING

               ACCEPT PRINTER-SELECTION

               IF PRINTER-SELECTION < 1
                   OR PRINTER-SELECTION > PRINTER-COUNT
                       DISPLAY "INVALID PRINTER SELECTION."
               END-IF

           END-PERFORM

           MOVE TABLE-PRINTER-NAME(PRINTER-SELECTION)
               TO SELECTED-PRINTER

           PERFORM 500-PRINT-REPORT
           .
       500-PRINT-REPORT.
           MOVE SPACES TO PRINT-COMMAND

           STRING
               "lp -d "
                   DELIMITED BY SIZE

               SELECTED-PRINTER
                   DELIMITED BY SPACE

               " -o cpi=10 -o lpi=6 report.txt"
                   DELIMITED BY SIZE

               INTO PRINT-COMMAND
           END-STRING

           DISPLAY SPACE
           DISPLAY "PRINTING TO: " SELECTED-PRINTER

           CALL "SYSTEM"
               USING PRINT-COMMAND
               RETURNING SYSTEM-STATUS

           IF SYSTEM-STATUS = 0
               DISPLAY "REPORT SENT TO PRINTER."
           ELSE
               DISPLAY "ERROR PRINTING REPORT."
           END-IF
           .
