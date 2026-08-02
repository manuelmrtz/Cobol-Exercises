       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           VISUAL-ATTRIBUTE-TEST.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-REPLY                 PIC X.

       SCREEN SECTION.
       01  ATTRIBUTE-TEST-SCREEN.
           05  BLANK SCREEN
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 0.

      *---------------------------------------------------------------*
      * TITLE                                                         *
      *---------------------------------------------------------------*
           05  LINE 1 COLUMN 20
               VALUE "GNUCOBOL VISUAL ATTRIBUTE TEST"
               HIGHLIGHT.

           05  LINE 2 COLUMN 15
               VALUE "Compare each line with the NORMAL display".

      *---------------------------------------------------------------*
      * INDIVIDUAL ATTRIBUTES                                         *
      *---------------------------------------------------------------*
           05  LINE 4 COLUMN 5
               VALUE "NORMAL:".
           05  LINE 4 COLUMN 28
               VALUE "TESTING 1, 2, 3".

           05  LINE 5 COLUMN 5
               VALUE "BLINK:".
           05  LINE 5 COLUMN 28
               VALUE "TESTING 1, 2, 3"
               BLINK.

           05  LINE 6 COLUMN 5
               VALUE "UNDERLINE:".
           05  LINE 6 COLUMN 28
               VALUE "TESTING 1, 2, 3"
               UNDERLINE.

           05  LINE 7 COLUMN 5
               VALUE "OVERLINE:".
           05  LINE 7 COLUMN 28
               VALUE "TESTING 1, 2, 3"
               OVERLINE.

           05  LINE 8 COLUMN 5
               VALUE "LEFTLINE:".
           05  LINE 8 COLUMN 28
               VALUE "TESTING 1, 2, 3"
               LEFTLINE.

           05  LINE 9 COLUMN 5
               VALUE "HIGHLIGHT:".
           05  LINE 9 COLUMN 28
               VALUE "TESTING 1, 2, 3"
               HIGHLIGHT.

           05  LINE 10 COLUMN 5
               VALUE "LOWLIGHT:".
           05  LINE 10 COLUMN 28
               VALUE "TESTING 1, 2, 3"
               LOWLIGHT.

           05  LINE 11 COLUMN 5
               VALUE "REVERSE-VIDEO:".
           05  LINE 11 COLUMN 28
               VALUE "TESTING 1, 2, 3"
               REVERSE-VIDEO.

      *---------------------------------------------------------------*
      * COMBINED ATTRIBUTES                                           *
      *---------------------------------------------------------------*
           05  LINE 13 COLUMN 5
               VALUE "COMBINED ATTRIBUTES"
               UNDERLINE
               HIGHLIGHT.

           05  LINE 14 COLUMN 5
               VALUE "HIGHLIGHT + UNDERLINE:".
           05  LINE 14 COLUMN 32
               VALUE "TESTING 1, 2, 3"
               HIGHLIGHT
               UNDERLINE.

           05  LINE 15 COLUMN 5
               VALUE "REVERSE + HIGHLIGHT:".
           05  LINE 15 COLUMN 32
               VALUE "TESTING 1, 2, 3"
               REVERSE-VIDEO
               HIGHLIGHT.

           05  LINE 16 COLUMN 5
               VALUE "BLINK + REVERSE:".
           05  LINE 16 COLUMN 32
               VALUE "TESTING 1, 2, 3"
               BLINK
               REVERSE-VIDEO.

           05  LINE 17 COLUMN 5
               VALUE "OVER + UNDER + LEFT:".
           05  LINE 17 COLUMN 32
               VALUE "TESTING 1, 2, 3"
               OVERLINE
               UNDERLINE
               LEFTLINE.

      *---------------------------------------------------------------*
      * FOREGROUND COLORS                                             *
      *---------------------------------------------------------------*
           05  LINE 19 COLUMN 5
               VALUE "FOREGROUND COLORS"
               UNDERLINE
               HIGHLIGHT.

           05  LINE 20 COLUMN 5
               VALUE "0 BLACK"
               FOREGROUND-COLOR 0
               BACKGROUND-COLOR 7.

           05  LINE 20 COLUMN 15
               VALUE "1 BLUE"
               FOREGROUND-COLOR 1.

           05  LINE 20 COLUMN 25
               VALUE "2 GREEN"
               FOREGROUND-COLOR 2.

           05  LINE 20 COLUMN 36
               VALUE "3 CYAN"
               FOREGROUND-COLOR 3.

           05  LINE 20 COLUMN 46
               VALUE "4 RED"
               FOREGROUND-COLOR 4.

           05  LINE 20 COLUMN 55
               VALUE "5 MAGENTA"
               FOREGROUND-COLOR 5.

           05  LINE 20 COLUMN 67
               VALUE "6 YELLOW"
               FOREGROUND-COLOR 14.

           05  LINE 21 COLUMN 5
               VALUE "7 WHITE"
               FOREGROUND-COLOR 7.

      *---------------------------------------------------------------*
      * BACKGROUND COLORS                                             *
      *---------------------------------------------------------------*
           05  LINE 22 COLUMN 5
               VALUE "BACKGROUND:"
               HIGHLIGHT.

           05  LINE 22 COLUMN 18
               VALUE " BLUE "
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 1.

           05  LINE 22 COLUMN 26
               VALUE " GREEN "
               FOREGROUND-COLOR 0
               BACKGROUND-COLOR 2.

           05  LINE 22 COLUMN 35
               VALUE " CYAN "
               FOREGROUND-COLOR 0
               BACKGROUND-COLOR 3.

           05  LINE 22 COLUMN 43
               VALUE " RED "
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 4.

           05  LINE 22 COLUMN 50
               VALUE " MAGENTA "
               FOREGROUND-COLOR 7
               BACKGROUND-COLOR 5.

           05  LINE 22 COLUMN 61
               VALUE " YELLOW "
               FOREGROUND-COLOR 0
               BACKGROUND-COLOR 6.

           05  LINE 24 COLUMN 20
               VALUE "Press ENTER to end the test:"
               HIGHLIGHT.

           05  LINE 24 COLUMN 50
               PIC X
               TO WS-REPLY
               AUTO.

       PROCEDURE DIVISION.
       100-MAIN.
           DISPLAY ATTRIBUTE-TEST-SCREEN

           ACCEPT ATTRIBUTE-TEST-SCREEN

           STOP RUN
           .

