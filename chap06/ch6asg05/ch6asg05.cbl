       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           SCREEN-VISUAL-TEST.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-REPLY                    PIC X.

       SCREEN SECTION.

       01  ATTRIBUTE-SCREEN.
           05  BLANK SCREEN
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 0.

           05  LINE 1 COLUMN 20
               VALUE "GNUCOBOL SCREEN ATTRIBUTE TEST"
               HIGHLIGHT.

           05  LINE 2 COLUMN 15
               VALUE "Compare every line with NORMAL output".

           05  LINE 4 COLUMN 5
               VALUE "NORMAL:".
           05  LINE 4 COLUMN 30
               VALUE "TESTING 1, 2, 3".

           05  LINE 5 COLUMN 5
               VALUE "BLINK:".
           05  LINE 5 COLUMN 30
               VALUE "TESTING 1, 2, 3"
               BLINK.

           05  LINE 6 COLUMN 5
               VALUE "UNDERLINE:".
           05  LINE 6 COLUMN 30
               VALUE "TESTING 1, 2, 3"
               UNDERLINE.

           05  LINE 7 COLUMN 5
               VALUE "OVERLINE:".
           05  LINE 7 COLUMN 30
               VALUE "TESTING 1, 2, 3"
               OVERLINE.

           05  LINE 8 COLUMN 5
               VALUE "LEFTLINE:".
           05  LINE 8 COLUMN 30
               VALUE "TESTING 1, 2, 3"
               LEFTLINE.

           05  LINE 9 COLUMN 5
               VALUE "HIGHLIGHT:".
           05  LINE 9 COLUMN 30
               VALUE "TESTING 1, 2, 3"
               HIGHLIGHT.

           05  LINE 10 COLUMN 5
               VALUE "LOWLIGHT:".
           05  LINE 10 COLUMN 30
               VALUE "TESTING 1, 2, 3"
               LOWLIGHT.

           05  LINE 11 COLUMN 5
               VALUE "REVERSE-VIDEO:".
           05  LINE 11 COLUMN 30
               VALUE "TESTING 1, 2, 3"
               REVERSE-VIDEO.

           05  LINE 13 COLUMN 5
               VALUE "COMBINED ATTRIBUTES"
               HIGHLIGHT
               UNDERLINE.

           05  LINE 14 COLUMN 5
               VALUE "HIGHLIGHT + UNDERLINE:".
           05  LINE 14 COLUMN 34
               VALUE "TESTING 1, 2, 3"
               HIGHLIGHT
               UNDERLINE.

           05  LINE 15 COLUMN 5
               VALUE "REVERSE + HIGHLIGHT:".
           05  LINE 15 COLUMN 34
               VALUE "TESTING 1, 2, 3"
               REVERSE-VIDEO
               HIGHLIGHT.

           05  LINE 16 COLUMN 5
               VALUE "BLINK + REVERSE:".
           05  LINE 16 COLUMN 34
               VALUE "TESTING 1, 2, 3"
               BLINK
               REVERSE-VIDEO.

           05  LINE 18 COLUMN 5
               VALUE "PRESS ENTER FOR STANDARD COLORS..."
               HIGHLIGHT.

           05  LINE 18 COLUMN 45
               PIC X
               TO WS-REPLY
               AUTO.

       01  FOREGROUND-SCREEN.
           05  BLANK SCREEN
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 0.

           05  LINE 1 COLUMN 20
               VALUE "STANDARD FOREGROUND COLORS"
               HIGHLIGHT.

           05  LINE 3 COLUMN 5
               VALUE "COLOR 0 - BLACK"
               FOREGROUND-COLOR 0
               BACKGROUND-COLOR 7.

           05  LINE 4 COLUMN 5
               VALUE "COLOR 1 - BLUE"
               FOREGROUND-COLOR 1.

           05  LINE 5 COLUMN 5
               VALUE "COLOR 2 - GREEN"
               FOREGROUND-COLOR 2.

           05  LINE 6 COLUMN 5
               VALUE "COLOR 3 - CYAN"
               FOREGROUND-COLOR 3.

           05  LINE 7 COLUMN 5
               VALUE "COLOR 4 - RED"
               FOREGROUND-COLOR 4.

           05  LINE 8 COLUMN 5
               VALUE "COLOR 5 - MAGENTA"
               FOREGROUND-COLOR 5.

           05  LINE 9 COLUMN 5
               VALUE "COLOR 6 - YELLOW/BROWN"
               FOREGROUND-COLOR 6.

           05  LINE 10 COLUMN 5
               VALUE "COLOR 7 - WHITE/GRAY"
               FOREGROUND-COLOR 7.

           05  LINE 12 COLUMN 5
               VALUE "BRIGHT COLORS USING HIGHLIGHT"
               HIGHLIGHT
               UNDERLINE.

           05  LINE 14 COLUMN 5
               VALUE "BRIGHT BLUE"
               FOREGROUND-COLOR 1
               HIGHLIGHT.

           05  LINE 15 COLUMN 5
               VALUE "BRIGHT GREEN"
               FOREGROUND-COLOR 2
               HIGHLIGHT.

           05  LINE 16 COLUMN 5
               VALUE "BRIGHT CYAN"
               FOREGROUND-COLOR 3
               HIGHLIGHT.

           05  LINE 17 COLUMN 5
               VALUE "BRIGHT RED"
               FOREGROUND-COLOR 4
               HIGHLIGHT.

           05  LINE 18 COLUMN 5
               VALUE "BRIGHT MAGENTA"
               FOREGROUND-COLOR 5
               HIGHLIGHT.

           05  LINE 19 COLUMN 5
               VALUE "BRIGHT YELLOW"
               FOREGROUND-COLOR 6
               HIGHLIGHT.

           05  LINE 20 COLUMN 5
               VALUE "BRIGHT WHITE"
               FOREGROUND-COLOR 7
               HIGHLIGHT.

           05  LINE 22 COLUMN 5
               VALUE "PRESS ENTER FOR BACKGROUND COLORS..."
               HIGHLIGHT.

           05  LINE 22 COLUMN 47
               PIC X
               TO WS-REPLY
               AUTO.

       01  BACKGROUND-SCREEN.
           05  BLANK SCREEN
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 0.

           05  LINE 1 COLUMN 20
               VALUE "STANDARD BACKGROUND COLORS"
               HIGHLIGHT.

           05  LINE 3 COLUMN 5
               VALUE " BACKGROUND 0 - BLACK "
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 0.

           05  LINE 5 COLUMN 5
               VALUE " BACKGROUND 1 - BLUE "
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 1.

           05  LINE 7 COLUMN 5
               VALUE " BACKGROUND 2 - GREEN "
               FOREGROUND-COLOR 0
               BACKGROUND-COLOR 2.

           05  LINE 9 COLUMN 5
               VALUE " BACKGROUND 3 - CYAN "
               FOREGROUND-COLOR 0
               BACKGROUND-COLOR 3.

           05  LINE 11 COLUMN 5
               VALUE " BACKGROUND 4 - RED "
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 4.

           05  LINE 13 COLUMN 5
               VALUE " BACKGROUND 5 - MAGENTA "
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 5.

           05  LINE 15 COLUMN 5
               VALUE " BACKGROUND 6 - YELLOW/BROWN "
               FOREGROUND-COLOR 0
               BACKGROUND-COLOR 6.

           05  LINE 17 COLUMN 5
               VALUE " BACKGROUND 7 - WHITE/GRAY "
               FOREGROUND-COLOR 0
               BACKGROUND-COLOR 7.

           05  LINE 20 COLUMN 5
               VALUE "PRESS ENTER TO END..."
               HIGHLIGHT.

           05  LINE 20 COLUMN 30
               PIC X
               TO WS-REPLY
               AUTO.

       PROCEDURE DIVISION.
       100-MAIN.
           DISPLAY ATTRIBUTE-SCREEN
           ACCEPT ATTRIBUTE-SCREEN

           DISPLAY FOREGROUND-SCREEN
           ACCEPT FOREGROUND-SCREEN

           DISPLAY BACKGROUND-SCREEN
           ACCEPT BACKGROUND-SCREEN

           STOP RUN
           .
