       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CH6EX03.
      ******************************************************************
      * This is an interactive version of the solution to             *
      * Programming Assignment 3 from Chapter 6                       *
      ******************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MAILING-LIST
               ASSIGN TO "ch6ex03.rpt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  MAILING-LIST.

       01  REPORT-OUT                    PIC X(80).

       WORKING-STORAGE SECTION.

       01  DO-IT-AGAIN                   PIC X     VALUE "Y".
       01  PAGE-CNT                      PIC 99    VALUE ZEROS.
       01  LINE-CNT                      PIC 99    VALUE 99.

       01  ACCEPTED-DATA.
           05  NAME-IN                   PIC X(20).
           05  ADDRESS-IN                PIC X(20).
           05  CITY-IN                   PIC X(13).
           05  STATE-IN                  PIC X(2).
           05  ZIP-CODE-IN               PIC X(5).

       01  HEADING-LINE.
           05                            PIC X(40) VALUE SPACES.
           05                            PIC X(12) VALUE
                                         "MAILING-LIST".
           05                            PIC X(8)  VALUE SPACES.
           05                            PIC X(5)  VALUE "PAGE ".
           05  PAGE-OUT                  PIC Z9    VALUE ZEROS.
           05                            PIC X(3)  VALUE SPACES.
           05  DATE-OUT                  PIC XX/XX/XXXX.
           05                            PIC X(2)  VALUE SPACES.

       01  MAILING-LINE-1.
           05                            PIC X(40) VALUE SPACES.
           05  NAME-1-OUT                PIC X(20) VALUE SPACES.
           05                            PIC X(20) VALUE SPACES.

       01  MAILING-LINE-2.
           05                            PIC X(40) VALUE SPACES.
           05  ADDRESS-1-OUT             PIC X(20) VALUE SPACES.
           05                            PIC X(20) VALUE SPACES.

       01  MAILING-LINE-3.
           05                            PIC X(40) VALUE SPACES.
           05  CITY-1-OUT                PIC X(13) VALUE SPACES.
           05                            PIC X     VALUE SPACES.
           05  STATE-1-OUT               PIC X(2)  VALUE SPACES.
           05                            PIC X     VALUE SPACES.
           05  ZIP-1-OUT                 PIC X(5)  VALUE SPACES.
           05                            PIC X(8)  VALUE SPACES.

       01  DATE-WS     PIC X(8).
       01  DATE-TEMP REDEFINES DATE-WS.
           05  MO-TEMP                   PIC X(2).
           05  DA-TEMP                   PIC X(2).
           05  YR-TEMP                   PIC X(4).

       01  DATE-IN.
           05  YR-IN                     PIC X(4).
           05  MO-IN                     PIC X(2).
           05  DA-IN                     PIC X(2).

      ***************************************************************
      * PC compilers with their SCREEN SECTIONs allow               *
      * the programmer to insert very functional user               *
      * interfaces                                                  *
      ***************************************************************

       SCREEN SECTION.

       01  SCREEN-1.
           05 BLANK SCREEN
              FOREGROUND-COLOR 15
              BACKGROUND-COLOR 1.
           05 LINE 1 COLUMN 1 VALUE 'NAME:'
              FOREGROUND-COLOR 15
              BACKGROUND-COLOR 1.
           05 COLUMN 17 PIC X(20) TO NAME-IN.
           05 LINE 2 COLUMN 1 VALUE 'STREET ADDRESS:'
              FOREGROUND-COLOR 15
              BACKGROUND-COLOR 1.
           05 COLUMN 17 PIC X(20) TO ADDRESS-IN.
           05 LINE 3 COLUMN 1 VALUE 'CITY:'
           FOREGROUND-COLOR 15
              BACKGROUND-COLOR 1.
           05 COLUMN 17 PIC X(13) TO CITY-IN.
           05 LINE 4 COLUMN 1 VALUE 'STATE:'
           FOREGROUND-COLOR 15
              BACKGROUND-COLOR 1.
           05 COLUMN 17 PIC X(2) TO STATE-IN AUTO.
           05 LINE 5 COLUMN 1 VALUE 'ZIP CODE:'
           FOREGROUND-COLOR 15
              BACKGROUND-COLOR 1.
           05 COLUMN 17 PIC X(5) TO ZIP-CODE-IN AUTO.

       01  SCREEN-2.
           05 BLANK SCREEN
              FOREGROUND-COLOR 4
              BACKGROUND-COLOR 7
              HIGHLIGHT.
           05 LINE 10 COLUMN 1 VALUE
              'IS THERE MORE DATA? ( ENTER Y OR N )'.
           05 LINE 10 COLUMN 37 PIC X(1) TO DO-IT-AGAIN.

       PROCEDURE DIVISION.

       000-MAIN-MODULE.
           PERFORM 100-INITIALIZATION-MODULE
           PERFORM 200-PROCESS-MODULE
               UNTIL DO-IT-AGAIN = "N" OR "n"
           PERFORM 900-TERMINATION-MODULE
           STOP RUN.

       100-INITIALIZATION-MODULE.
           OPEN OUTPUT MAILING-LIST
           MOVE FUNCTION CURRENT-DATE TO DATE-IN
           MOVE YR-IN TO YR-TEMP
           MOVE MO-IN TO MO-TEMP
           MOVE DA-IN TO DA-TEMP
           MOVE DATE-WS TO DATE-OUT.

       200-PROCESS-MODULE.
           DISPLAY SCREEN-1
           ACCEPT SCREEN-1

           IF LINE-CNT > 56
               PERFORM 300-HEADING-LINE
           END-IF

           MOVE NAME-IN TO NAME-1-OUT
           PERFORM 301-WRITE-LINE

           MOVE ADDRESS-IN TO ADDRESS-1-OUT
           PERFORM 302-WRITE-LINE

           MOVE CITY-IN TO CITY-1-OUT
           MOVE STATE-IN TO STATE-1-OUT
           MOVE ZIP-CODE-IN TO ZIP-1-OUT
           PERFORM 303-WRITE-LINE

           ADD 3 TO LINE-CNT

           DISPLAY SCREEN-2
           ACCEPT SCREEN-2.

              300-HEADING-LINE.
           ADD 1 TO PAGE-CNT
           MOVE PAGE-CNT TO PAGE-OUT
           MOVE ZEROS TO LINE-CNT

           WRITE REPORT-OUT FROM HEADING-LINE
               AFTER ADVANCING PAGE

           MOVE SPACES TO REPORT-OUT

           WRITE REPORT-OUT
               AFTER ADVANCING 1 LINES.

       301-WRITE-LINE.
           WRITE REPORT-OUT FROM MAILING-LINE-1
               AFTER ADVANCING 2 LINES.

       302-WRITE-LINE.
           WRITE REPORT-OUT FROM MAILING-LINE-2
               AFTER ADVANCING 1 LINES.

       303-WRITE-LINE.
           WRITE REPORT-OUT FROM MAILING-LINE-3
               AFTER ADVANCING 1 LINES.

       900-TERMINATION-MODULE.
           CLOSE MAILING-LIST
           .
