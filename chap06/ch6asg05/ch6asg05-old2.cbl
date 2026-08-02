       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           VISUAL-ATTRIBUTE-TEST.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-ESC                  PIC X VALUE X"1B".
       01  WS-REPLY                PIC X.
       01  WS-COLOR                PIC 9(3) VALUE 0.
       01  WS-COLOR-DISPLAY        PIC ZZ9.
       01  WS-ROW-COUNT            PIC 99 VALUE 0.

       PROCEDURE DIVISION.
       100-MAIN.
           PERFORM 200-ATTRIBUTE-PAGE
           PERFORM 300-FOREGROUND-PAGE
           PERFORM 400-BACKGROUND-PAGE
           PERFORM 500-RESET-AND-EXIT
           STOP RUN
           .

       200-ATTRIBUTE-PAGE.
           PERFORM 900-CLEAR-SCREEN

           DISPLAY WS-ESC "[1;1H"
                   WS-ESC "[1m"
                   "GNUCOBOL / ANSI VISUAL ATTRIBUTE TEST"
                   WS-ESC "[0m"

           DISPLAY " "
           DISPLAY "NORMAL              : TESTING 1, 2, 3"

           DISPLAY WS-ESC "[1m"
                   "HIGHLIGHT / BOLD    : TESTING 1, 2, 3"
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[2m"
                   "LOWLIGHT / DIM      : TESTING 1, 2, 3"
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[3m"
                   "ITALIC              : TESTING 1, 2, 3"
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[4m"
                   "UNDERLINE           : TESTING 1, 2, 3"
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[5m"
                   "BLINK               : TESTING 1, 2, 3"
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[7m"
                   "REVERSE VIDEO       : TESTING 1, 2, 3"
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[8m"
                   "CONCEALED           : TESTING 1, 2, 3"
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[9m"
                   "STRIKETHROUGH       : TESTING 1, 2, 3"
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[21m"
                   "DOUBLE UNDERLINE    : TESTING 1, 2, 3"
                   WS-ESC "[0m"
           DISPLAY " " 
           DISPLAY WS-ESC "[53m"
                   "OVERLINE            : TESTING 1, 2, 3"
                   WS-ESC "[55m"

           DISPLAY WS-ESC "[1;4;7m"
                   "BOLD+UNDER+REVERSE  : TESTING 1, 2, 3"
                   WS-ESC "[0m"

           DISPLAY " "
           DISPLAY WS-ESC "[1m"
                   "STANDARD AND BRIGHT FOREGROUND COLORS"
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[30m" " 30 BLACK "
                   WS-ESC "[31m" " 31 RED "
                   WS-ESC "[32m" " 32 GREEN "
                   WS-ESC "[33m" " 33 YELLOW "
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[34m" " 34 BLUE "
                   WS-ESC "[35m" " 35 MAGENTA "
                   WS-ESC "[36m" " 36 CYAN "
                   WS-ESC "[37m" " 37 WHITE "
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[90m" " 90 BR BLACK "
                   WS-ESC "[91m" " 91 BR RED "
                   WS-ESC "[92m" " 92 BR GREEN "
                   WS-ESC "[93m" " 93 BR YELLOW "
                   WS-ESC "[0m"

           DISPLAY WS-ESC "[94m" " 94 BR BLUE "
                   WS-ESC "[95m" " 95 BR MAGENTA "
                   WS-ESC "[96m" " 96 BR CYAN "
                   WS-ESC "[97m" " 97 BR WHITE "
                   WS-ESC "[0m"

           DISPLAY " "
           DISPLAY "Press ENTER for the 256 foreground colors..."
           ACCEPT WS-REPLY
           .

       300-FOREGROUND-PAGE.
           PERFORM 900-CLEAR-SCREEN

           DISPLAY WS-ESC "[1m"
                   "256-COLOR FOREGROUND PALETTE (0-255)"
                   WS-ESC "[0m"
           DISPLAY "Each number is displayed using its own color."
           DISPLAY " "

           MOVE 0 TO WS-COLOR
           MOVE 0 TO WS-ROW-COUNT

           PERFORM UNTIL WS-COLOR > 255
               MOVE WS-COLOR TO WS-COLOR-DISPLAY

               DISPLAY WS-ESC
                       "[38;5;"
                       FUNCTION TRIM(WS-COLOR-DISPLAY)
                       "m"
                       WS-COLOR-DISPLAY
                       " "
                       WS-ESC
                       "[0m"
                       WITH NO ADVANCING

               ADD 1 TO WS-COLOR
               ADD 1 TO WS-ROW-COUNT

               IF WS-ROW-COUNT = 16
                   DISPLAY " "
                   MOVE 0 TO WS-ROW-COUNT
               END-IF
           END-PERFORM

           DISPLAY " "
           DISPLAY "Press ENTER for the 256 background colors..."
           ACCEPT WS-REPLY
           .

       400-BACKGROUND-PAGE.
           PERFORM 900-CLEAR-SCREEN

           DISPLAY WS-ESC "[1m"
                   "256-COLOR BACKGROUND PALETTE (0-255)"
                   WS-ESC "[0m"
           DISPLAY "Each block uses one extended background color."
           DISPLAY " "

           MOVE 0 TO WS-COLOR
           MOVE 0 TO WS-ROW-COUNT

           PERFORM UNTIL WS-COLOR > 255
               MOVE WS-COLOR TO WS-COLOR-DISPLAY

               IF WS-COLOR < 16
                   DISPLAY WS-ESC "[97m" WITH NO ADVANCING
               ELSE
                   IF WS-COLOR < 232
                       DISPLAY WS-ESC "[30m" WITH NO ADVANCING
                   ELSE
                       IF WS-COLOR < 244
                           DISPLAY WS-ESC "[97m" WITH NO ADVANCING
                       ELSE
                           DISPLAY WS-ESC "[30m" WITH NO ADVANCING
                       END-IF
                   END-IF
               END-IF

               DISPLAY WS-ESC
                       "[48;5;"
                       FUNCTION TRIM(WS-COLOR-DISPLAY)
                       "m"
                       WS-COLOR-DISPLAY
                       WS-ESC
                       "[0m"
                       " "
                       WITH NO ADVANCING

               ADD 1 TO WS-COLOR
               ADD 1 TO WS-ROW-COUNT

               IF WS-ROW-COUNT = 16
                   DISPLAY " "
                   MOVE 0 TO WS-ROW-COUNT
               END-IF
           END-PERFORM

           DISPLAY " "
           DISPLAY "Press ENTER to finish..."
           ACCEPT WS-REPLY
           .

       500-RESET-AND-EXIT.
           DISPLAY WS-ESC "[0m" WITH NO ADVANCING
           PERFORM 900-CLEAR-SCREEN
           DISPLAY "Visual attribute and color test completed."
           .

       900-CLEAR-SCREEN.
           DISPLAY WS-ESC "[0m"
                   WS-ESC "[2J"
                   WS-ESC "[H"
                   WITH NO ADVANCING
           .
