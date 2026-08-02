       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CH6ASG03.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT NAME-AND-ADDRESS-MASTER
               ASSIGN TO "master-file.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT MAILING-LIST
               ASSIGN TO "mailing-list.txt"
               ORGANIZATION IS LINE SEQUENTIAL.    
       DATA DIVISION.
       FILE SECTION.
       FD NAME-AND-ADDRESS-MASTER.
       01  MASTER-REC.
           05  CUSTOMER-NAME-IN       PIC X(20).
           05  ADDRESS-IN.
               10  STREET-IN          PIC X(20).
               10  CITY-STATE-ZIP-IN  PIC X(20).
       FD  MAILING-LIST.
       01  PRINT-REC                  PIC X(80).        
       WORKING-STORAGE SECTION.
       01  WS-WORKING-AREA.
           05  END-OF-FILE            PIC X VALUE "N".
           05  PAGE-NO-IN             PIC 9(2) VALUE 0.
           05  LABEL-NO-CONTROL       PIC 9(2) VALUE 0.

           05  DATE-IN.
               10  YEAR-IN            PIC X(4).
               10  MONTH-IN           PIC X(2).
               10  DAY-IN             PIC X(2).

       01  REPORT-LAYOUT.
           05 HEADING1.
               10                     PIC X(40) VALUE SPACES.
               10                     PIC X(12) VALUE "MAILING LIST".
               10                     PIC X(8)  VALUE SPACES.
               10                     PIC X(5)  VALUE "PAGE ".
               10  PAGE-NO-OUT        PIC 9(2).
               10                     PIC X(3)  VALUE SPACES.
               10  MONTH-OUT          PIC X(2).
               10                     PIC X(1) VALUE "/".
               10  DAY-OUT            PIC X(2).
               10                     PIC X(1) VALUE "/".
               10  YEAR-OUT           PIC X(4).
           05 DETAIL1.
               10                     PIC X(40) VALUE SPACES.
               10  DETAIL-LINE        PIC X(20).
               10                     PIC X(20) VALUE SPACES.
               
       PROCEDURE DIVISION.
       100-MAIN.
      ******************************************************************
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ******************************************************************
           OPEN INPUT NAME-AND-ADDRESS-MASTER
               OUTPUT MAILING-LIST  
           DISPLAY "Working..."
           READ NAME-AND-ADDRESS-MASTER
               AT END
                   DISPLAY "No Records to Process"
               NOT AT END
                   MOVE FUNCTION CURRENT-DATE TO DATE-IN
                   MOVE MONTH-IN TO MONTH-OUT
                   MOVE DAY-IN TO DAY-OUT
                   MOVE YEAR-IN TO YEAR-OUT
                   
                   PERFORM 200-HEADER
                   PERFORM 300-DETAIL
                   PERFORM UNTIL END-OF-FILE = "Y"
                       READ NAME-AND-ADDRESS-MASTER
                           AT END
                               MOVE "Y" TO END-OF-FILE
                           NOT AT END
                               PERFORM 300-DETAIL    
                       END-READ
                   END-PERFORM
           END-READ
           CLOSE NAME-AND-ADDRESS-MASTER
                 MAILING-LIST
           STOP RUN
           .
       200-HEADER.
           MOVE 0 TO LABEL-NO-CONTROL
           MOVE SPACES TO PRINT-REC
           IF PAGE-NO-IN = 0
               WRITE PRINT-REC
           ELSE
               WRITE PRINT-REC AFTER ADVANCING PAGE
           END-IF
           PERFORM 4 TIMES
               WRITE PRINT-REC
           END-PERFORM
           ADD 1 TO PAGE-NO-IN
           MOVE PAGE-NO-IN TO PAGE-NO-OUT
           MOVE HEADING1 TO PRINT-REC
           WRITE PRINT-REC
           MOVE SPACES TO PRINT-REC
           PERFORM 2 TIMES
               WRITE PRINT-REC
           END-PERFORM
           .
       300-DETAIL.
           IF LABEL-NO-CONTROL >= 14
               PERFORM 200-HEADER
           END-IF
           MOVE CUSTOMER-NAME-IN TO DETAIL-LINE
           MOVE DETAIL1 TO PRINT-REC
           WRITE PRINT-REC

           MOVE STREET-IN TO DETAIL-LINE
           MOVE DETAIL1 TO PRINT-REC
           WRITE PRINT-REC
           
           MOVE CITY-STATE-ZIP-IN TO DETAIL-LINE
           MOVE DETAIL1 TO PRINT-REC
           WRITE PRINT-REC

           MOVE SPACES TO PRINT-REC
           WRITE PRINT-REC
           ADD 1 TO LABEL-NO-CONTROL
           .

