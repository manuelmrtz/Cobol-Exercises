       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CH6EX05.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  COLOR-CODES.
           05  BLACK          PIC 9(1) VALUE 0.
           05  BLUE           PIC 9(1) VALUE 1.
           05  GREEN          PIC 9(1) VALUE 2.
           05  CYAN           PIC 9(1) VALUE 3.
           05  RED            PIC 9(1) VALUE 4.
           05  MAGENTA        PIC 9(1) VALUE 5.
           05  BROWN          PIC 9(1) VALUE 6.
           05  WHITE          PIC 9(1) VALUE 7.

       01  U-OR-G-IN          PIC X(1).
           88  UNDERGRAD               VALUE "u", "U".
           88  GRAD                    VALUE "g", "G".
           88  VALID-U-OR-G-CODE       VALUE "u", "U", "G", "g".

       01  RES-IN             PIC X(1) VALUE SPACE.
           88  RESIDENT                VALUE "1".
           88  RECIPROCITY             VALUE "2".
           88  NON-RESIDENT            VALUE "3".
           88  VALID-RES-CODE          VALUE "1" THRU "3".
       
       01  CREDITS-IN         PIC 9(2)V9(1).
       01  PER-CREDIT         PIC 9(4)V9(2).
       01  DUMMY              PIC X(1).
       01  TUITION-WS         PIC 9(4)V9(2).
       01  DO-AGAIN           PIC X(1) VALUE "Y".

       SCREEN SECTION.
       01  TITLE-SCREEN.
           05  BLANK SCREEN
                   FOREGROUND-COLOR BLACK
                   BACKGROUND-COLOR WHITE.
           05  LINE 4 COLUMN 15
                   VALUE "TUITION CALENDER".  
       01  UGRAD-GRAD-SCREEN.
           05  UGRAD-GRAD-CHOICES.
               10  LINE 7 COLUMN 10
                   VALUE "ARE YOU AN UNDERGRAD OR GRAD STUDENT?".
               10  LINE 9 COLUMN 15
                   VALUE "U) UNDERGRAD".
               10  LINE 11 COLUMN 15
                   VALUE "G) GRAD".
           05  UGRAD-GRAD-ANSWER.
               10  LINE 14 COLUMN 10
                   VALUE "ENTER CHOICE ".
               10  FOREGROUND-COLOR BLUE
                       HIGHLIGHT
                   VALUE "(U OR G) ".
               10  FOREGROUND-COLOR BLACK
                   VALUE "? ".
               10  PIC X(1) TO U-OR-G-IN
                   AUTO.

       01  ERROR-SCREEN.
           05  LINE 20 COLUMN 15
                   BEEP
                   FOREGROUND-COLOR RED
                   VALUE "NOT A VALID CHOICE - TRY AGAIN".
       01  RESIDENT-SCREEN.
           05  RES-CHOICES.
               10  LINE 7 COLUMN 10
                       VALUE "WHERE DO YOU LIVE?".
               10  LINE 9 COLUMN 15
                       VALUE "1) THIS STATE (RESIDENT) ?".
               10  LINE 11 COLUMN 15
                       VALUE "2) NEIGHBOR STATE (RECIPROCITY) ?".
               10  LINE 13 COLUMN 15
                       VALUE "3) SOMEWHERE ELSE (NON-RESIDENT) ?".
           05  RES-ANSWERS.
               10  LINE 16 COLUMN 10
                       VALUE "ENTER CHOICE ".
               10  FOREGROUND-COLOR BLUE
                       HIGHLIGHT
                       VALUE "(1, 2, or 3)".
               10  FOREGROUND-COLOR BLACK
                       VALUE "? ".
               10  PIC X(1) TO RES-IN
                       AUTO.
       01  CREDITS-SCREEN.
           05  CREDITS-PROMPT.
               10  LINE 7 COLUMN 10
                       VALUE "HOW MANY CREDITS ARE YOU TAKING? ".
               10  LINE 9 COLUMN 10
                       VALUE "ENTER NUMBER: ".                    
           05  CREDITS-ANSWER.
               10  PIC Z9.9 TO CREDITS-IN
                   AUTO.
       01  PART-TIME-WARNING.
           05  LINE 13 COLUMN 10
                   BEEP
                   FOREGROUND-COLOR WHITE
                       HIGHLIGHT
                   BACKGROUND-COLOR RED
                   VALUE "PART-TIME STUDENT - CHECK ON FINANCIAL AID RUL
      -                      "ES".
           05  LINE 15 COLUMN 10
                   FOREGROUND-COLOR BLUE
                       HIGHLIGHT
                   VALUE "HIT 'ENTER' TO CONTINUE".
           05  PIC X(1) TO DUMMY
               AUTO.
       01  OVERLOAD-WARNING.
           05  LINE 13 COLUMN 10
                   BEEP
                   FOREGROUND-COLOR WHITE
                       HIGHLIGHT
                   BACKGROUND-COLOR RED
                   VALUE "OVERLOAD - GET ADVISOR'S APPROVAL BEFORE REGIS
      -                "TERING".
           05  LINE 15 COLUMN 10
                   FOREGROUND-COLOR BLUE
                       HIGHLIGHT
                   VALUE "HIT 'ENTER' TO CONTINUE".    
           05  PIC X(1) TO DUMMY
               AUTO.
       01  TUITION-SCREEN.
           05  LINE 7 COLUMN 10
               VALUE "YOUR TUITION IS "
               FOREGROUND-COLOR BLACK.
           05  LINE 7 COLUMN 26
               PIC $Z,ZZ9.99
               FROM TUITION-WS
               FOREGROUND-COLOR RED
               HIGHLIGHT.

       01  REPEAT-SCREEN.
           05  LINE 17 COLUMN 10
                   VALUE "DO ANOTHER CALCULATION".
           05  FOREGROUND-COLOR BLUE
                   HIGHLIGHT
                   VALUE "(Y OR N)".                    
           05  FOREGROUND-COLOR BLACK
               VALUE "? ".
           05  PIC X(1) TO DO-AGAIN
               AUTO.

       PROCEDURE DIVISION.
       000-MAIN.
           PERFORM UNTIL DO-AGAIN = "N" OR "n"
               DISPLAY TITLE-SCREEN
               DISPLAY UGRAD-GRAD-SCREEN
                   PERFORM UNTIL VALID-U-OR-G-CODE
                       ACCEPT UGRAD-GRAD-SCREEN
                       IF NOT VALID-U-OR-G-CODE
                           DISPLAY ERROR-SCREEN
                       END-IF
                   END-PERFORM
               DISPLAY TITLE-SCREEN
               DISPLAY RESIDENT-SCREEN
                   PERFORM 
                       ACCEPT RESIDENT-SCREEN
                       IF NOT VALID-RES-CODE
                           DISPLAY ERROR-SCREEN
                       END-IF
                   END-PERFORM
               DISPLAY TITLE-SCREEN
               DISPLAY CREDITS-SCREEN
               ACCEPT CREDITS-SCREEN  
               PERFORM 200-CALCULATE-TUITION
               MOVE SPACE TO U-OR-G-IN
               MOVE SPACE TO RES-IN
               DISPLAY REPEAT-SCREEN
               ACCEPT REPEAT-SCREEN      
           END-PERFORM
           STOP RUN
           .
       200-CALCULATE-TUITION.
           IF UNDERGRAD AND CREDITS-IN < 12
               EVALUATE    TRUE
                   WHEN RESIDENT     MOVE 137.40 TO PER-CREDIT
                   WHEN RECIPROCITY  MOVE 140.40 TO PER-CREDIT
                   WHEN NON-RESIDENT MOVE 451.40 TO PER-CREDIT
               END-EVALUATE    
               COMPUTE TUITION-WS ROUNDED = PER-CREDIT * CREDITS-IN
                   + 1.35
               DISPLAY TITLE-SCREEN
               DISPLAY TUITION-SCREEN
               DISPLAY PART-TIME-WARNING
               ACCEPT PART-TIME-WARNING    
           END-IF
           IF UNDERGRAD AND CREDITS-IN >= 12
               EVALUATE    TRUE
                   WHEN    RESIDENT
                           MOVE 1644.15 TO TUITION-WS
                           IF CREDITS-IN > 18
                               COMPUTE TUITION-WS ROUNDED = TUITION-WS
                                 + (CREDITS-IN - 18) * 114.00
                           END-IF 
                   WHEN    RECIPROCITY
                           MOVE 1684.15 TO TUITION-WS
                           IF CREDITS-IN > 18
                               COMPUTE TUITION-WS ROUNDED = TUITION-WS
                                 + (CREDITS-IN - 18) * 117.00
                           END-IF
                   WHEN    NON-RESIDENT
                           MOVE 5412.15 TO TUITION-WS
                           IF CREDITS-IN > 18
                               COMPUTE TUITION-WS ROUNDED = TUITION-WS
                                 + (CREDITS-IN - 18) * 428.00
                           END-IF                
               END-EVALUATE
                   DISPLAY TITLE-SCREEN
                   DISPLAY TUITION-SCREEN
                   IF CREDITS-IN > 18
                       DISPLAY OVERLOAD-WARNING
                       ACCEPT OVERLOAD-WARNING
                   END-IF
           END-IF
           IF GRAD AND CREDITS-IN < 9.0
               EVALUATE        TRUE
                   WHEN        RESIDENT     MOVE 249.71 TO PER-CREDIT
                   WHEN        RECIPROCITY  MOVE 249.71 TO PER-CREDIT
                   WHEN        NON-RESIDENT MOVE 745.71 TO PER-CREDIT
               END-EVALUATE
             COMPUTE TUITION-WS ROUNDED = PER-CREDIT * CREDITS-IN + 1.35
               DISPLAY TITLE-SCREEN
               DISPLAY TUITION-SCREEN
           END-IF
           IF GRAD AND CREDITS-IN >= 9.0
               EVALUATE        TRUE
                   WHEN        RESIDENT     MOVE 2240.71 TO TUITION-WS
                   WHEN        RECIPROCITY  MOVE 2240.71 TO TUITION-WS
                   WHEN        NON-RESIDENT MOVE 6712.71 TO TUITION-WS 
               END-EVALUATE
               DISPLAY TITLE-SCREEN
               DISPLAY TUITION-SCREEN
           END-IF
           .
