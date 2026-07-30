       IDENTIFICATION DIVISION.
       PROGRAM-ID. MENUDEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       78  COLOR-BLACK         VALUE 0.
       78  COLOR-BLUE          VALUE 1.
       78  COLOR-CYAN          VALUE 3.
       78  COLOR-BRIGHT-WHITE  VALUE 15.

       01  WS-SELECTION        PIC X.

       SCREEN SECTION.

       01  MAIN-SCREEN.
           05  BLANK SCREEN
               BACKGROUND-COLOR COLOR-BLUE.

           05  VALUE " File "
               LINE 1 COLUMN 2
               FOREGROUND-COLOR COLOR-BLACK
               BACKGROUND-COLOR COLOR-CYAN.

           05  VALUE " Edit "
               LINE 1 COLUMN 10
               FOREGROUND-COLOR COLOR-BRIGHT-WHITE
               BACKGROUND-COLOR COLOR-BLUE.

           05  VALUE " Reports "
               LINE 1 COLUMN 18
               FOREGROUND-COLOR COLOR-BRIGHT-WHITE
               BACKGROUND-COLOR COLOR-BLUE.

           05  VALUE " Help "
               LINE 1 COLUMN 29
               FOREGROUND-COLOR COLOR-BRIGHT-WHITE
               BACKGROUND-COLOR COLOR-BLUE.

       01  FILE-MENU.
           05  VALUE "+------------------+"
               LINE 2 COLUMN 2
               FOREGROUND-COLOR COLOR-BLACK
               BACKGROUND-COLOR COLOR-CYAN.

           05  VALUE "| 1. New           |"
               LINE 3 COLUMN 2
               FOREGROUND-COLOR COLOR-BLACK
               BACKGROUND-COLOR COLOR-CYAN.

           05  VALUE "| 2. Open          |"
               LINE 4 COLUMN 2
               FOREGROUND-COLOR COLOR-BLACK
               BACKGROUND-COLOR COLOR-CYAN.

           05  VALUE "| 3. Save          |"
               LINE 5 COLUMN 2
               FOREGROUND-COLOR COLOR-BLACK
               BACKGROUND-COLOR COLOR-CYAN.

           05  VALUE "| 4. Exit          |"
               LINE 6 COLUMN 2
               FOREGROUND-COLOR COLOR-BLACK
               BACKGROUND-COLOR COLOR-CYAN.

           05  VALUE "+------------------+"
               LINE 7 COLUMN 2
               FOREGROUND-COLOR COLOR-BLACK
               BACKGROUND-COLOR COLOR-CYAN.

           05  FILE-CHOICE
               LINE 8 COLUMN 2
               PIC X
               TO WS-SELECTION
               FOREGROUND-COLOR COLOR-BRIGHT-WHITE
               BACKGROUND-COLOR COLOR-BLUE.

       PROCEDURE DIVISION.

       100-MAIN.
           DISPLAY MAIN-SCREEN
           DISPLAY FILE-MENU
           ACCEPT FILE-CHOICE

           EVALUATE WS-SELECTION
               WHEN "1"
                   DISPLAY "NEW SELECTED"
                       LINE 10 COLUMN 2
               WHEN "2"
                   DISPLAY "OPEN SELECTED"
                       LINE 10 COLUMN 2
               WHEN "3"
                   DISPLAY "SAVE SELECTED"
                       LINE 10 COLUMN 2
               WHEN "4"
                   CONTINUE
               WHEN OTHER
                   DISPLAY "INVALID SELECTION"
                       LINE 10 COLUMN 2
           END-EVALUATE

           STOP RUN.
           