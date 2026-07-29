       IDENTIFICATION DIVISION.
       PROGRAM-ID. CH6EX02.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  DOB-IN                  PIC X(10).

       01  DOB-WS.
           05  MO-WS               PIC 9(2).
           05  DAY-WS              PIC 9(2).
           05  YR-WS               PIC 9(4).

       01  TODAY.
           05  TODAY-YR            PIC 9(4).
           05  TODAY-MO            PIC 9(2).
           05  TODAY-DAY           PIC 9(2).

       01  CURRENT-DATE-WS         PIC X(21).

       01  CUTOFF-DATE.
           05  CUTOFF-YR           PIC 9(4).
           05  CUTOFF-MO           PIC 9(2).
           05  CUTOFF-DAY          PIC 9(2).

       01  DOB-COMPARE.
           05  DOB-YR-COMPARE      PIC 9(4).
           05  DOB-MO-COMPARE      PIC 9(2).
           05  DOB-DAY-COMPARE     PIC 9(2).

       PROCEDURE DIVISION.

       100-MAIN.
           display "                Test Program                "
               AT LINE 1
               COLUMN 2
               WITH BLANK SCREEN
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 1
           DISPLAY "============================================"
               AT LINE 2
               COLUMN 2
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 1

           DISPLAY
               "Enter date of birth (mm/dd/yyyy):"
               AT LINE 3
               COLUMN 2
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 1

           ACCEPT DOB-IN
               AT LINE 3
               COLUMN 35
               WITH REVERSE-VIDEO

           PERFORM 200-PROCESS-DOB
           PERFORM 300-CHECK-AGE

           ACCEPT OMITTED
           STOP RUN.

       200-PROCESS-DOB.
           UNSTRING DOB-IN
               DELIMITED BY "/"
               INTO MO-WS
                    DAY-WS
                    YR-WS

           MOVE YR-WS  TO DOB-YR-COMPARE
           MOVE MO-WS  TO DOB-MO-COMPARE
           MOVE DAY-WS TO DOB-DAY-COMPARE.

       300-CHECK-AGE.
           MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-WS

           MOVE CURRENT-DATE-WS(1:4) TO TODAY-YR
           MOVE CURRENT-DATE-WS(5:2) TO TODAY-MO
           MOVE CURRENT-DATE-WS(7:2) TO TODAY-DAY

           SUBTRACT 21 FROM TODAY-YR
               GIVING CUTOFF-YR

           MOVE TODAY-MO  TO CUTOFF-MO
           MOVE TODAY-DAY TO CUTOFF-DAY

           IF DOB-COMPARE <= CUTOFF-DATE
               DISPLAY
                   "Person is at least 21 years old."
                   AT LINE 4
                   COLUMN 2
                   FOREGROUND-COLOR 2
                   BACKGROUND-COLOR 1
           ELSE
               DISPLAY
                   "Person is under 21 years old."
                   AT LINE 4
                   COLUMN 2
                   WITH BEEP
                   FOREGROUND-COLOR 7
                   BACKGROUND-COLOR 4
           END-IF
           .
