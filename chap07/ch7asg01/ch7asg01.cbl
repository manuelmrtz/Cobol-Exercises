       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CH7ASG01.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IN-EMPLOYEE-FILE ASSIGN TO "employee.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUT-SALARY-FILE ASSIGN TO "salary.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD  IN-EMPLOYEE-FILE.
       01  EMPLOYEE-REC.
           05  IN-EMPLOYEE-NAME      PIC X(15).
           05  IN-HOURS-WORKED       PIC 999.
           05  IN-RATE               PIC 9V99.

       FD  OUT-SALARY-FILE.
       01  SALARY-REC.
           05  OUT-EMPLOYEE-NAME     PIC X(15).
           05  OUT-GROSS-PAY         PIC 9(4)V99.
           05  OUT-FICA              PIC 9(3)V99.
           05  OUT-NET-PAY           PIC 9(4)V99.
       WORKING-STORAGE SECTION.
       01  WS-AREA.
           05 END-OF-FILE            PIC XXX VALUE "NO ".
       PROCEDURE DIVISION.
       100-MAIN-MODULE.
      ******************************************************************
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ****************************************************************** 
           DISPLAY "WORKING..."
           DISPLAY "DONE..."
           OPEN INPUT IN-EMPLOYEE-FILE
               OUTPUT OUT-SALARY-FILE

           
           PERFORM UNTIL END-OF-FILE = "YES"
               READ IN-EMPLOYEE-FILE
                   AT END
                       MOVE "YES" TO END-OF-FILE
                   NOT AT END
                       PERFORM 200-PAYCALC-RTN
               END-READ
           END-PERFORM
           CLOSE IN-EMPLOYEE-FILE
                 OUT-SALARY-FILE
           STOP RUN
           .
       200-PAYCALC-RTN.
           MOVE IN-EMPLOYEE-NAME TO OUT-EMPLOYEE-NAME
           MULTIPLY IN-HOURS-WORKED BY IN-RATE GIVING OUT-GROSS-PAY
           MULTIPLY OUT-GROSS-PAY BY 0.0765 GIVING OUT-FICA ROUNDED
           SUBTRACT OUT-FICA FROM OUT-GROSS-PAY GIVING OUT-NET-PAY
           WRITE SALARY-REC
           .
