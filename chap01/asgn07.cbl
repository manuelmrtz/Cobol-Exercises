      ******************************************************************
      * PROGRAM:      ASGN07.CBL
      * PROGRAM-ID:   TEMPERATURES
      * AUTHOR:       MANUEL A. MARTINEZ
      * DATE:         2026-07-17
      * PURPOSE:      CONVERT KNOTS TO MILES.
      * COMPILER:     GNUCOBOL 3.2
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASGN07.
       
       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  KNOTS-IN  PICTURE 999V99.
       01  MILES-OUT PICTURE 999V99.
       01  MILES-DISPLAY PICTURE ZZ9.99.
       01  MORE-DATA PICTURE XXX VALUE "YES".


       PROCEDURE DIVISION.
       100-MAIN-MODULE.

           PERFORM UNTIL MORE-DATA = "NO "

               DISPLAY "ENTER SPEED IN KNOTS: "
                   WITH NO ADVANCING
               ACCEPT KNOTS-IN

               COMPUTE MILES-OUT ROUNDED = 
                   1.15078 * KNOTS-IN

               MOVE MILES-OUT TO MILES-DISPLAY

               DISPLAY "MILES PER HOUR: ", MILES-DISPLAY
               
               DISPLAY "ENTER MORE DATA? (YES/NO): "
                   WITH NO ADVANCING

               ACCEPT MORE-DATA

               MOVE FUNCTION UPPER-CASE(MORE-DATA)
                   TO MORE-DATA
               
               DISPLAY " "


           END-PERFORM

           STOP RUN
           .
           
