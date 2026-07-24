       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASGN11.
       DATA DIVISION.
           
       WORKING-STORAGE SECTION.
       01  WS-WORKING-AREA.
           05  IS-THERE-MORE-DATA PIC XXX VALUE 'Y'.
           05  NAME-IN             PIC X(20).
           05  CREDITS-IN          PIC 99.
           05  TUITION             PIC 9999.


       PROCEDURE DIVISION.
       100-MAIN-MODULE.
           
           PERFORM UNTIL IS-THERE-MORE-DATA = 'N'
               DISPLAY "ENTER STUDENT NAME: "
                   WITH NO ADVANCING
               ACCEPT NAME-IN

               DISPLAY "ENTER TOTAL CREDITS: "
                   WITH NO ADVANCING
               ACCEPT CREDITS-IN

               IF CREDITS-IN IS GREATER THAN 12
                   MOVE 6300 TO TUITION
               ELSE
                   MULTIPLY 525 BY CREDITS-IN GIVING TUITION
               END-IF
               DISPLAY " "
               MOVE FUNCTION UPPER-CASE(NAME-IN)
                   TO NAME-IN
               
               DISPLAY "STUDENT NAME: "
                   NAME-IN

               DISPLAY "CREDITS: "
                   CREDITS-IN
               DISPLAY "TOTAL TUITION: "
                   TUITION

               DISPLAY "IS THERE MORE DATA? (Y/N): "
                   WITH NO ADVANCING

               ACCEPT IS-THERE-MORE-DATA

               MOVE FUNCTION UPPER-CASE(IS-THERE-MORE-DATA)
                   TO IS-THERE-MORE-DATA
             
           END-PERFORM

           STOP RUN
           .
