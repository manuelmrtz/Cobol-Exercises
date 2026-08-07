       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CH7EX01.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT STUDENT-MASTER ASSIGN TO 'ch7pp.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT GRADE-REPORT ASSIGN TO 'ch7pp.rpt'
               ORGANIZATION IS LINE SEQUENTIAL.    
       DATA DIVISION.
       FILE SECTION.
       FD  STUDENT-MASTER.
       01  STUDENT-REC.
           05  ID-NO-IN             PIC X(5).
           05  STUDENT-NAME-IN      PIC X(20).
           05  EXAM1                PIC 999.
           05  EXAM2                PIC 999.
           05  EXAM3                PIC 999.
           05  EXAM4                PIC 999.
           05                       PIC X(43).
       FD  GRADE-REPORT.
       01  REPORT-REC               PIC X(80).
       WORKING-STORAGE SECTION.
       01  LINE-CT                  PIC 99        VALUE 0.
       01  ARE-THERE-MORE-RECORDS   PIC XXX       VALUE 'YES'.
       01  WS-DATE.
           05  WS-YEAR              PIC 9999.
           05  WS-MONTH             PIC 99.
           05  WS-DAY               PIC 99.
       01  DETAIL-LINE.
           05                       PIC X(4)      VALUE SPACES.
           05  ID-NO-OUT            PIC X(5).
           05                       PIC X(5)      VALUE SPACES.
           05  STUDENT-NAME-OUT     PIC X(20).
           05                       PIC X(4)      VALUE SPACES.
           05  AVERAGE              PIC 999.
       01  HDR-1.
           05                       PIC X(15)     VALUE SPACES.
           05                       PIC X(13)     VALUE "CLASS  GRADES".
           05                       PIC X(22)     VALUE SPACES.
           05  DATE-OUT.
               10  MONTH-OUT        PIC XX.
               10                   PIC X         VALUE "/".
               10  DAY-OUT          PIC XX.
               10                   PIC X         VALUE "/".
               10  YEAR-OUT         PIC XXXX.
           05                       PIC X(1).
           05                       PIC X(5)      VALUE 'PAGE '.
           05  PAGE-NO              PIC 99        VALUE ZERO.
       01  HDR-2.
           05                       PIC X(2)      VALUE SPACES.
           05                       PIC X(20)     VALUE 'I.D. NO.'.
           05                       PIC X(58)   
               VALUE     "NAME          AVERAGE".
       PROCEDURE DIVISION.
      ******************************************************************
      *     Program logic is controlled from the                       *
      *        main module                                             *
      ******************************************************************
       100-MAIN-MODULE.
      ******************************************************************
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ****************************************************************** 
           DISPLAY "Working..."
           OPEN INPUT STUDENT-MASTER
               OUTPUT GRADE-REPORT
           MOVE FUNCTION CURRENT-DATE TO WS-DATE
           MOVE WS-MONTH TO MONTH-OUT
           MOVE WS-DAY TO DAY-OUT
           MOVE WS-YEAR TO YEAR-OUT
           PERFORM 200-HEADING-RTN
           PERFORM UNTIL ARE-THERE-MORE-RECORDS = 'NO '
               READ STUDENT-MASTER
                   AT END
                       MOVE 'NO ' TO ARE-THERE-MORE-RECORDS
                   NOT AT END
                       PERFORM 300-AVERAGE-RTN
               END-READ
           END-PERFORM    
           CLOSE STUDENT-MASTER
                 GRADE-REPORT
           
           DISPLAY "Finished."
           STOP RUN
           .
      ******************************************************************     
      *       Headings are printed from 200-HEADING-RTN                *
      ****************************************************************** 
       200-HEADING-RTN.
           ADD 1 TO PAGE-NO
           MOVE SPACES TO REPORT-REC
           WRITE REPORT-REC
           IF PAGE-NO = 1
               WRITE REPORT-REC FROM HDR-1
           ELSE
               WRITE REPORT-REC FROM HDR-1
                   AFTER ADVANCING PAGE
           END-IF
           WRITE REPORT-REC FROM HDR-2
               AFTER ADVANCING 2 LINES
           MOVE 0 TO LINE-CT
           .
       300-AVERAGE-RTN.
           IF LINE-CT >= 25
               PERFORM 200-HEADING-RTN
           END-IF
           MOVE ID-NO-IN TO ID-NO-OUT
           MOVE STUDENT-NAME-IN TO STUDENT-NAME-OUT
           ADD EXAM1 EXAM2 EXAM3 EXAM4
               GIVING AVERAGE
           DIVIDE 4 INTO AVERAGE ROUNDED
           WRITE REPORT-REC FROM DETAIL-LINE
               AFTER ADVANCING 2 LINES    
           ADD 1 TO LINE-CT
           .
           