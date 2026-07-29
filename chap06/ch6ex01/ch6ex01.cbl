       IDENTIFICATION DIVISION.
       PROGRAM-ID. CH6EX01.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  DOB-IN              PIC X(10).
       01  DOB-WS.
           05  YR-WS           PIC 9(4).
           05  MO-WS           PIC 9(2).
           05  DAY-WS          PIC 9(2).
       01  TODAY.
           05  TODAY-YR        PIC 9(4).
           05  TODAY-MO        PIC 9(2).
           05  TODAY-DAY       PIC 9(2).    

       01  CUTOFF-DATE.
           05  CUTOFF-YR       PIC 9(4).
           05  CUTOFF-MO       PIC 9(2).
           05  CUTOFF-DAY      PIC 9(2).        

       01  CUTOFF-DOB          PIC 9(8).
       PROCEDURE DIVISION.
       100-MAIN.
           DISPLAY "Enter date of birth (mm/dd/yyyy):"
               WITH NO ADVANCING
           ACCEPT DOB-IN
           PERFORM 200-PROCESS-DOB
           PERFORM 300-CHECK-AGE
           STOP RUN
           .
       200-PROCESS-DOB.
           UNSTRING DOB-IN DELIMITED BY "/" OR "-"
               INTO MO-WS
                    DAY-WS
                    YR-WS
           .
       300-CHECK-AGE.
           MOVE FUNCTION CURRENT-DATE TO TODAY
           SUBTRACT 21 FROM TODAY-YR GIVING CUTOFF-YR
           MOVE TODAY-MO TO CUTOFF-MO
           MOVE TODAY-DAY TO CUTOFF-DAY
           MOVE CUTOFF-DATE TO CUTOFF-DOB
           IF DOB-WS <= CUTOFF-DOB
               DISPLAY "Person is at least 21 years old."
           ELSE
               DISPLAY "Person is under 21 years old."
           END-IF
           .    
