       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CH7EX02.
      ******************************************************************
      * This program accepts four student exam scores and prints       *
      * detail lines with each student's average                       *
      ******************************************************************     
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT GRADE-REPORT ASSIGN TO 'ch7ppi.rpt'
               ORGANIZATION IS LINE SEQUENTIAL.    
       DATA DIVISION.
       FILE SECTION.
       FD  GRADE-REPORT.
       01  REPORT-REC               PIC X(80).
       WORKING-STORAGE SECTION.
       01  LINE-CT                  PIC 99        VALUE 0.
       01  ARE-THERE-MORE-RECORDS   PIC XXX       VALUE 'YES'.
       01  WS-TOTAL                 PIC 9(4).
       01  WS-DATE.
           05  WS-YEAR              PIC 9999.
           05  WS-MONTH             PIC 99.
           05  WS-DAY               PIC 99.
      
       01  STUDENT-INFO.
           05  ID-NO-IN             PIC X(5).
           05  STUDENT-NAME-IN      PIC X(20).
           05  EXAM1                PIC 999.
           05  EXAM2                PIC 999.
           05  EXAM3                PIC 999.
           05  EXAM4                PIC 999.
       
       01  DETAIL-LINE.
           05                       PIC X(4)      VALUE SPACES.
           05  ID-NO-OUT            PIC X(5).
           05                       PIC X(5)      VALUE SPACES.
           05  STUDENT-NAME-OUT     PIC X(20).
           05                       PIC X(4)      VALUE SPACES.
           05  AVERAGE              PIC 999.
           05                       PIC X(39)     VALUE SPACES.
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
           05                       PIC X(12)     VALUE SPACES.
       01  HDR-2.
           05                       PIC X(2)      VALUE SPACES.
           05                       PIC X(20)     VALUE 'I.D. NO.'.
           05                       PIC X(58)   
                                   VALUE     "NAME          AVERAGE".
       01  COLORS.
           05  BLUE                 PIC 9(1)      VALUE 1.
           05  WHITE                PIC 9(1)      VALUE 7.
       SCREEN SECTION.
       01  DATA-SCREEN.
           05  HIGHLIGHT
               FOREGROUND-COLOR BLUE
               BACKGROUND-COLOR WHITE.
               10  BLANK SCREEN.
               10  LINE 1 COLUMN 1 VALUE 'ID-NO: '.
               10  PIC X(5) USING ID-NO-IN.
               10  LINE 2 COLUMN 1 VALUE 'STUDENT NAME: '.
               10  PIC X(20) USING STUDENT-NAME-IN.
               10  LINE 4 COLUMN 1 VALUE 'EXAM 1: '.
               10  PIC 9(3) USING EXAM1.
               10  LINE 5 COLUMN 1 VALUE 'EXAM 2: '.
               10  PIC 9(3) USING EXAM2.
               10  LINE 6 COLUMN 1 VALUE 'EXAM 3: '.
               10  PIC 9(3) USING EXAM3.
               10  LINE 7 COLUMN 1 VALUE 'EXAM 4: '.
               10  PIC 9(3) USING EXAM4.
       01  AGAIN-SCREEN.
           05  HIGHLIGHT.
               10  LINE 10 COLUMN 1
                   VALUE 'Another student (YES OR NO)? '.
               10  PIC X(3) USING  ARE-THERE-MORE-RECORDS.            

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
           OPEN OUTPUT GRADE-REPORT
           MOVE FUNCTION CURRENT-DATE TO WS-DATE
           MOVE WS-MONTH TO MONTH-OUT
           MOVE WS-DAY TO DAY-OUT
           MOVE WS-YEAR TO YEAR-OUT
           PERFORM 200-HEADING-RTN
           PERFORM UNTIL ARE-THERE-MORE-RECORDS = 'NO '
               INITIALIZE STUDENT-INFO

      *        DISPLAY DATA-SCREEN
               ACCEPT  DATA-SCREEN
      *             WITH NO UPDATE
               PERFORM 300-AVERAGE-RTN
      *        DISPLAY AGAIN-SCREEN
               ACCEPT AGAIN-SCREEN
               MOVE FUNCTION UPPER-CASE(ARE-THERE-MORE-RECORDS)
                   TO ARE-THERE-MORE-RECORDS
           END-PERFORM    
           CLOSE GRADE-REPORT
           STOP RUN
           .
      ******************************************************************     
      *       Headings are printed from 200-HEADING-RTN                *
      ****************************************************************** 
       200-HEADING-RTN.
           ADD 1 TO PAGE-NO

           MOVE SPACES TO REPORT-REC
           IF PAGE-NO > 1
               WRITE REPORT-REC
                   AFTER ADVANCING PAGE
           ELSE
               WRITE REPORT-REC
           END-IF

           WRITE REPORT-REC FROM HDR-1

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
               GIVING WS-TOTAL
           DIVIDE WS-TOTAL BY 4 GIVING AVERAGE ROUNDED
           WRITE REPORT-REC FROM DETAIL-LINE
               AFTER ADVANCING 2 LINES    
           ADD 1 TO LINE-CT
           .
           