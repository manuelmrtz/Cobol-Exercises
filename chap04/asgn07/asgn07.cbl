       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASGN07.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-TRANS
               ASSIGN TO 'account-trans.dat'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ACCOUNT-MASTER
               ASSIGN TO 'account-master.dat'
               ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNT-TRANS.
       01  TRANS-REC.
           05  ACCT-NO-IN       PIC X(5).
           05  CUST-NAME-IN     PIC X(20).
           05  AMT1-IN          PIC 999V99.
           05  AMT2-IN          PIC 999V99.
           05  DISCOUNT-AMT-IN  PIC 999V99.

       FD  ACCOUNT-MASTER.
       01  MASTER-REC.
           05  ACCT-NO-OUT      PIC X(5).
           05  CUST-NAME-OUT    PIC X(20).
           05  TOTAL-OUT        PIC 9999V99.
           05  AMT-DUE-OUT      PIC 9999V99.
           05  FILLER           PIC X(3).
       
       WORKING-STORAGE SECTION.
       01  WS-WORKING-AREA.
           05  ARE-THERE-MORE-RECORDS PIC XXX VALUE 'YES'.

       PROCEDURE DIVISION.
       100-MAIN-MODULE.
      ******************************************************************
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ******************************************************************     
           OPEN INPUT ACCOUNT-TRANS
               OUTPUT ACCOUNT-MASTER
           
           PERFORM UNTIL ARE-THERE-MORE-RECORDS = 'NO '
               READ ACCOUNT-TRANS
                   AT END
                       MOVE 'NO ' TO ARE-THERE-MORE-RECORDS
                   NOT AT END
                       MOVE SPACES TO MASTER-REC
                       MOVE ACCT-NO-IN 
                           TO ACCT-NO-OUT
                       MOVE CUST-NAME-IN
                           TO CUST-NAME-OUT
                       ADD AMT1-IN TO AMT2-IN
                           GIVING TOTAL-OUT
                       SUBTRACT DISCOUNT-AMT-IN FROM TOTAL-OUT
                           GIVING AMT-DUE-OUT
                       WRITE MASTER-REC
               END-READ
           END-PERFORM
           
           CLOSE ACCOUNT-TRANS
                 ACCOUNT-MASTER
           STOP RUN
           .
