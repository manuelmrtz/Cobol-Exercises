       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASGN08.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ENROLLMENT-FILE
               ASSIGN TO 'enrollment.dat'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TUITION-FILE
               ASSIGN TO 'tuition.dat'
               ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD  ENROLLMENT-FILE.
       01  ENROLLMENT-REC.
           05  STUDENT-NAME-IN  PIC X(20).
           05  CREDITS-IN       PIC 9(2).
           05  FILLER           PIC X(58).

       FD  TUITION-FILE.
       01  TUITION-REC.
           05  STUDENT-NAME-OUT PIC X(20).
           05  FILLER           PIC X(20).
           05  CREDITS-OUT      PIC 9(2).
           05  FILLER           PIC X(24).
           05  TUITION-OUT      PIC 9(4).
           
       
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
           OPEN INPUT ENROLLMENT-FILE
               OUTPUT TUITION-FILE
           
           PERFORM UNTIL ARE-THERE-MORE-RECORDS = 'NO '
               READ ENROLLMENT-FILE
                   AT END
                       MOVE 'NO ' TO ARE-THERE-MORE-RECORDS
                   NOT AT END
                       MOVE SPACES TO TUITION-REC
                       MOVE STUDENT-NAME-IN 
                           TO STUDENT-NAME-OUT
                       MOVE CREDITS-IN
                           TO CREDITS-OUT
                       IF CREDITS-IN LESS THAN 13
                           MULTIPLY CREDITS-IN BY 525
                               GIVING TUITION-OUT
                       ELSE
                           MOVE 6300 TO TUITION-OUT
                       END-IF 
                       WRITE TUITION-REC
               END-READ
           END-PERFORM
           
           CLOSE ENROLLMENT-FILE
                 TUITION-FILE
           STOP RUN
           .
