       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           ch6asg01.
 
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUST-FILE
               ASSIGN TO "cust-file.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PRINT-FILE
               ASSIGN TO "print-file.txt"
               ORGANIZATION IS LINE SEQUENTIAL.    
    
       DATA DIVISION.
       FILE SECTION.
       
       FD  CUST-FILE.
       01  CUST-REC.
           05  INITIAL1-IN    PIC X(1).
           05  INITIAL2-IN    PIC X(1).
           05  LAST-NAME-IN   PIC X(10).
           05  TRAN-MONTH-IN  PIC X(2).
           05  TRAN-YEAR-IN   PIC X(4).
           05  TRAN-AMT-IN    PIC 9(6).

       FD  PRINT-FILE.
       01  PRINT-REC            PIC X(80).    

       WORKING-STORAGE SECTION.
       01  WS-WORKING-AREA.
           05  END-OF-FILE      PIC X(1) VALUE "N".
           05  PRINT-LINE-COUNT PIC 99   VALUE ZEROS.
           05  PRINT-FIRST-PAGE PIC X(1) VALUE "Y".
           
       01  REPORT-SECTION.
           05  RPT-HEADING.
               10               PIC X(5)  VALUE SPACES.
               10               PIC X(4)  VALUE "NAME".
               10               PIC X(5)  VALUE SPACES.
               10               PIC X(19) VALUE "DATE OF TRANSACTION".
               10               PIC X(3)  VALUE SPACES.
               10               PIC X(21) VALUE "AMOUNT OF TRANSACTION".
               10               PIC X(23).
           05  RPT-DETAIL.
               10  INITIAL1-OUT    PIC X(1).
               10                  PIC X(1) VALUE ".".
               10  INITIAL2-OUT    PIC X(1).
               10                  PIC X(1) VALUE ".".
               10  LAST-NAME-OUT   PIC X(10).
               10                  PIC X(6) VALUE SPACES.
               10  TRAN-MONTH-OUT  PIC X(2).
               10  FILLER          PIC X(1) VALUE "/".
               10  TRAN-YEAR-OUT   PIC X(4).
               10                  PIC X(11) VALUE SPACES.
               10  TRAN-AMT-OUT    PIC $ZZZ,ZZ9.
               10                  PIC X(34) VALUE SPACES.
               
       PROCEDURE DIVISION.
       100-MAIN.
      ******************************************************************
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ******************************************************************

           DISPLAY "Working..."
           OPEN INPUT  CUST-FILE
                OUTPUT PRINT-FILE
           READ CUST-FILE
               AT END
                   DISPLAY "NO RECORDS TO PRINT"
               NOT AT END
                   PERFORM 200-PRINT-HEADING
                   PERFORM UNTIL END-OF-FILE = "Y"
                       PERFORM 300-PRINT-DETAIL
                       READ CUST-FILE
                           AT END
                               MOVE "Y" TO END-OF-FILE
                       END-READ
                   END-PERFORM    
           END-READ    
           
           CLOSE CUST-FILE
                 PRINT-FILE
           STOP RUN
           .
       200-PRINT-HEADING.
           MOVE 0 TO PRINT-LINE-COUNT

           MOVE SPACES TO PRINT-REC
           IF PRINT-FIRST-PAGE = "Y"
               WRITE PRINT-REC
               MOVE "N" TO PRINT-FIRST-PAGE
           ELSE
               WRITE PRINT-REC AFTER ADVANCING PAGE
           END-IF
           
           WRITE PRINT-REC 
           MOVE RPT-HEADING TO PRINT-REC
           WRITE PRINT-REC
           MOVE SPACES TO PRINT-REC
           WRITE PRINT-REC
           .
       300-PRINT-DETAIL.
           IF PRINT-LINE-COUNT >= 54
              PERFORM 200-PRINT-HEADING
           END-IF

           MOVE INITIAL1-IN TO INITIAL1-OUT
           MOVE INITIAL2-IN TO INITIAL2-OUT
           MOVE LAST-NAME-IN TO LAST-NAME-OUT
           MOVE TRAN-MONTH-IN TO TRAN-MONTH-OUT
           MOVE TRAN-YEAR-IN TO TRAN-YEAR-OUT
           MOVE TRAN-AMT-IN TO TRAN-AMT-OUT
           
           MOVE RPT-DETAIL TO PRINT-REC
           WRITE PRINT-REC
           
           ADD 1 TO PRINT-LINE-COUNT
           .
