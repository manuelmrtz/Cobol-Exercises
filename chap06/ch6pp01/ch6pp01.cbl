       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CH6PP01.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PURCHASE-TRANS
               ASSIGN TO "purchases.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PURCHASE-REPORT
               ASSIGN TO "report.txt"
               ORGANIZATION IS LINE SEQUENTIAL.    

       DATA DIVISION.
       FILE SECTION.
       FD  PURCHASE-TRANS.
       01  PURCHASE-REC.
           05  CUSTOMER-NO-IN      PIC X(5).
           05  CUSTOMER-NAME-IN    PIC X(20).
           05  PURCHASE-AMT-IN     PIC 9(5)V99.        
       FD  PURCHASE-REPORT.
       01  PRINT-REC               PIC X(80).

       WORKING-STORAGE SECTION.
       01  WORKING-AREA.
           05  END-OF-FILE         PIC X VALUE "N".    
           05  DATE-IN.
               10  YEAR-IN         PIC X(4).
               10  MONTH-IN        PIC X(2).
               10  DAY-IN          PIC X(2).
           05  CURRENT-PAGE        PIC 9(2) VALUE 0.
           05  RECORDS-PRINTED     PIC 9(2) VALUE 0.
       01  WS-PURCHASE-REPORT.
           05  HDG1-OUT.
               10  FILLER          PIC X(40)
                   VALUE SPACES.
               10  FILLER          PIC X(15)
                   VALUE "PURCHASE REPORT".
               10  FILLER          PIC X(3).   
               10  DATE-OUT.
                   15  MONTH-OUT   PIC 99.
                   15              PIC X VALUE "/".
                   15  DAY-OUT     PIC 99.
                   15              PIC X VALUE "/".
                   15  YEAR-OUT    PIC 9999.
               10                  PIC X(3) VALUE SPACES.  
               10                  PIC X(5) VALUE "PAGE ".   
               10  PAGE-OUT        PIC Z9.
               10  FILLER          PIC X(2)
                   VALUE SPACES.  
           05 HDG2-OUT.
              10                   PIC X(10) VALUE SPACES.
              10                   PIC X(11) VALUE "CUSTOMER NO".
              10                   PIC X(3)  VALUE SPACES.
              10                   PIC X(13) VALUE "CUSTOMER NAME".
              10                   PIC X(13) VALUE SPACES.
              10                   PIC X(18) VALUE "AMOUNT OF PURCHASE".
              10                   PIC X(12) VALUE SPACES.         
           05 DETAIL-OUT.
               10                    PIC X(13) VALUE SPACES.
               10  CUSTOMER-NO-OUT   PIC X(5).
               10                    PIC X(6)  VALUE SPACES.
               10  CUSTOMER-NAME-OUT PIC X(20).
               10                    PIC X(10)  VALUE SPACES.
               10  PURCHASE-AMT-OUT  PIC ZZ,ZZZ.99. 
               10                    PIC X(17) VALUE SPACES.                  

       PROCEDURE DIVISION.
       100-MAIN-MODULE.
      ******************************************************************
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ****************************************************************** 
           MOVE FUNCTION CURRENT-DATE TO DATE-IN
           MOVE YEAR-IN  TO YEAR-OUT
           MOVE MONTH-IN TO MONTH-OUT
           MOVE DAY-IN  TO DAY-OUT
        
           OPEN INPUT PURCHASE-TRANS
                OUTPUT PURCHASE-REPORT  
           PERFORM 200-HDG-RTN      
           
           PERFORM UNTIL END-OF-FILE = "Y"
               READ PURCHASE-TRANS
                   AT END
                       MOVE "Y" TO END-OF-FILE
                   NOT AT END
                       PERFORM 300-REPORT-RTN
               END-READ
           END-PERFORM

           CLOSE PURCHASE-TRANS
                 PURCHASE-REPORT
           STOP RUN 
           .
       200-HDG-RTN.
           
           ADD 1 TO CURRENT-PAGE
           MOVE CURRENT-PAGE TO PAGE-OUT 
           
           
           MOVE SPACES TO PRINT-REC
           IF CURRENT-PAGE > 1  
               WRITE PRINT-REC AFTER ADVANCING PAGE
           ELSE
               WRITE PRINT-REC
           END-IF
           WRITE PRINT-REC
           MOVE HDG1-OUT TO PRINT-REC
           WRITE PRINT-REC

           MOVE SPACES TO PRINT-REC
           WRITE PRINT-REC

           MOVE HDG2-OUT TO PRINT-REC
           WRITE PRINT-REC

           MOVE SPACES TO PRINT-REC
           WRITE PRINT-REC
           .
       300-REPORT-RTN.
           IF RECORDS-PRINTED = 56
              MOVE 0 TO RECORDS-PRINTED
              PERFORM 200-HDG-RTN
           END-IF
           MOVE CUSTOMER-NO-IN TO CUSTOMER-NO-OUT
           MOVE CUSTOMER-NAME-IN TO CUSTOMER-NAME-OUT
           MOVE PURCHASE-AMT-IN TO PURCHASE-AMT-OUT
           MOVE DETAIL-OUT TO PRINT-REC
           WRITE PRINT-REC
           ADD 1 TO RECORDS-PRINTED 
           .
