       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASIGN06.
        
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL. 
           SELECT PAYROLL-IN ASSIGN TO "asgn06-i.dat"
                   ORGANIZATION IS LINE SEQUENTIAL.

           SELECT PAYROLL-OUT ASSIGN TO "asgn06-o.dat"
                   ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  PAYROLL-IN.
       01  PAYREC-REC.
           05  EMPLOYEE-NUMBER-IN     PICTURE 9(5).
           05  EMPLOYEE-NAME-IN       PICTURE X(20).
           05  AMOUNT-OF-SALES-IN     PICTURE 9999.
           05  ANNUAL-SALARY-IN       PICTURE 9(6).
           
       FD  PAYROLL-OUT.
       01  RECORD-OUT.
           05  EMPLOYEE-NUMBER-OUT    PICTURE 9(5).
           05  EMPLOYEE-NAME-OUT      PICTURE X(20).
           05  ANNUAL-SALARY-OUT      PICTURE 9(6).
      
       WORKING-STORAGE SECTION.
       01 ARE-THERE-MORE-RECORDS      PIC X(3) VALUE 'YES'.

       PROCEDURE DIVISION.
       100-MAIN-MODULE.
           OPEN INPUT PAYROLL-IN
               OUTPUT PAYROLL-OUT
           PERFORM UNTIL ARE-THERE-MORE-RECORDS = 'NO '
               READ PAYROLL-IN
                   AT END
                       MOVE 'NO ' TO ARE-THERE-MORE-RECORDS
                   NOT AT END
                       PERFORM 200-WAGE-ROUTINE
               END-READ
           END-PERFORM
           CLOSE PAYROLL-IN
                 PAYROLL-OUT
           STOP RUN
           .

       200-WAGE-ROUTINE.
           MOVE EMPLOYEE-NUMBER-IN TO EMPLOYEE-NUMBER-OUT
           MOVE EMPLOYEE-NAME-IN TO EMPLOYEE-NAME-OUT
           ADD 1000, ANNUAL-SALARY-IN
               GIVING ANNUAL-SALARY-OUT
           WRITE RECORD-OUT
           .
           
