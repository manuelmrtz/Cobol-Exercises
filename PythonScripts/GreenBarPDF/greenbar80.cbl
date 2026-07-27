       IDENTIFICATION DIVISION.
       PROGRAM-ID. GREENBAR80.
      ******************************************************************
      * PROGRAM: GREENBAR80                                            *
      * PURPOSE: CREATE AN 80-RECORD TEXT REPORT AND CONVERT IT TO     *
      *          A GREENBAR-STYLE PDF USING GREENBAR_PDF.PY.           *
      * COMPILER: GNUCOBOL                                             *
      ******************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT REPORT-FILE
               ASSIGN TO "print-80-records.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-REPORT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  REPORT-FILE.
       01  REPORT-RECORD                   PIC X(80).

       WORKING-STORAGE SECTION.

      ******************************************************************
      * FILE STATUS                                                    *
      ******************************************************************

       01  WS-REPORT-STATUS                PIC XX VALUE SPACES.

      ******************************************************************
      * REPORT CONTROL                                                  *
      ******************************************************************

       01  WS-RECORD-NUMBER                PIC 999 VALUE ZERO.
       01  WS-RECORD-NUMBER-OUT            PIC ZZ9.

       01  WS-PAGE-NUMBER                  PIC 99 VALUE ZERO.
       01  WS-PAGE-NUMBER-OUT              PIC Z9.

       01  WS-LINE-COUNT                   PIC 999 VALUE ZERO.
       01  WS-MAX-LINES                    PIC 999 VALUE 60.

      ******************************************************************
      * SYSTEM COMMANDS                                                 *
      ******************************************************************

       01  WS-SYSTEM-RETURN-CODE           PIC S9(9) COMP-5
                                                   VALUE ZERO.

       01  WS-FORM-FEED-COMMAND            PIC X(200)
           VALUE
           "printf '\014' >> print-80-records.txt".

       01  WS-PDF-COMMAND                  PIC X(500) VALUE SPACES.

       01  WS-OPEN-COMMAND                 PIC X(200)
           VALUE "xdg-open print-80-records.pdf".

       01  WS-OPEN-ANSWER                  PIC X VALUE SPACE.

      ******************************************************************
      * REPORT LINES                                                    *
      ******************************************************************

       01  HEADING-LINE.
           05  FILLER                      PIC X(2) VALUE SPACES.
           05  FILLER                      PIC X(34)
               VALUE "GNUCOBOL GREENBAR PRINTING TEST".
           05  FILLER                      PIC X(35) VALUE SPACES.
           05  FILLER                      PIC X(5) VALUE "PAGE ".
           05  HEADING-PAGE                PIC Z9.
           05  FILLER                      PIC X(2) VALUE SPACES.

       01  COLUMN-HEADING.
           05  FILLER                      PIC X(2) VALUE SPACES.
           05  FILLER                      PIC X(3) VALUE "NO.".
           05  FILLER                      PIC X(4) VALUE SPACES.
           05  FILLER                      PIC X(45)
               VALUE "DESCRIPTION".
           05  FILLER                      PIC X(18) VALUE SPACES.
           05  FILLER                      PIC X(6) VALUE "STATUS".
           05  FILLER                      PIC X(2) VALUE SPACES.

       01  DETAIL-LINE.
           05  FILLER                      PIC X(1) VALUE SPACES.
           05  DETAIL-NUMBER               PIC ZZ9.
           05  FILLER                      PIC X(5) VALUE SPACES.
           05  FILLER                      PIC X(38)
               VALUE "THIS IS GNUCOBOL TEST RECORD NUMBER".
           05  FILLER                      PIC X VALUE SPACE.
           05  DETAIL-NUMBER-TEXT          PIC ZZ9.
           05  FILLER                      PIC X(22) VALUE SPACES.
           05  FILLER                      PIC X(2) VALUE "OK".
           05  FILLER                      PIC X(6) VALUE SPACES.

       PROCEDURE DIVISION.

       100-MAIN-MODULE.

           PERFORM 150-BUILD-PDF-COMMAND

           PERFORM 200-OPEN-REPORT

           PERFORM 300-START-NEW-PAGE

           PERFORM VARYING WS-RECORD-NUMBER
               FROM 1 BY 1
               UNTIL WS-RECORD-NUMBER > 998

               IF WS-LINE-COUNT >= WS-MAX-LINES
                   PERFORM 500-INSERT-FORM-FEED
                   PERFORM 300-START-NEW-PAGE
               END-IF

               PERFORM 400-WRITE-DETAIL
           END-PERFORM

           PERFORM 600-CLOSE-REPORT

           PERFORM 700-CREATE-GREENBAR-PDF

           IF WS-SYSTEM-RETURN-CODE = ZERO
               PERFORM 800-ASK-TO-OPEN-PDF
           END-IF

           STOP RUN.

      ******************************************************************
      * BUILD THE PYTHON COMMAND                                        *
      ******************************************************************

       150-BUILD-PDF-COMMAND.

           MOVE SPACES TO WS-PDF-COMMAND

           STRING
               "python3 greenbar_pdf.py"
                   DELIMITED BY SIZE
               " "
                   DELIMITED BY SIZE
               "print-80-records.txt"
                   DELIMITED BY SIZE
               " "
                   DELIMITED BY SIZE
               "print-80-records.pdf"
                   DELIMITED BY SIZE
               " "
                   DELIMITED BY SIZE
               "--orientation portrait"
                   DELIMITED BY SIZE
               " "
                   DELIMITED BY SIZE
               "--columns 80"
                   DELIMITED BY SIZE
               " "
                   DELIMITED BY SIZE
               "--lines 60"
                   DELIMITED BY SIZE
               " "
                   DELIMITED BY SIZE
               "--band-lines 3"
                   DELIMITED BY SIZE
               INTO WS-PDF-COMMAND
           END-STRING.

      ******************************************************************
      * OPEN THE TEXT REPORT                                            *
      ******************************************************************

       200-OPEN-REPORT.

           OPEN OUTPUT REPORT-FILE

           IF WS-REPORT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING REPORT FILE"
               DISPLAY "FILE STATUS: " WS-REPORT-STATUS
               STOP RUN
           END-IF.

      ******************************************************************
      * START A NEW REPORT PAGE                                         *
      ******************************************************************

       300-START-NEW-PAGE.

           ADD 1 TO WS-PAGE-NUMBER
           MOVE WS-PAGE-NUMBER TO WS-PAGE-NUMBER-OUT
           MOVE WS-PAGE-NUMBER TO HEADING-PAGE
           MOVE ZERO TO WS-LINE-COUNT

           MOVE HEADING-LINE TO REPORT-RECORD
           PERFORM 350-WRITE-REPORT-LINE

           MOVE SPACES TO REPORT-RECORD
           MOVE ALL "=" TO REPORT-RECORD(3:78)
           PERFORM 350-WRITE-REPORT-LINE

           MOVE COLUMN-HEADING TO REPORT-RECORD
           PERFORM 350-WRITE-REPORT-LINE

           MOVE SPACES TO REPORT-RECORD
           MOVE ALL "-" TO REPORT-RECORD(3:78)
           PERFORM 350-WRITE-REPORT-LINE.

      ******************************************************************
      * WRITE ONE REPORT LINE                                           *
      ******************************************************************

       350-WRITE-REPORT-LINE.

           WRITE REPORT-RECORD

           IF WS-REPORT-STATUS NOT = "00"
               DISPLAY "ERROR WRITING REPORT FILE"
               DISPLAY "FILE STATUS: " WS-REPORT-STATUS
               CLOSE REPORT-FILE
               STOP RUN
           END-IF

           ADD 1 TO WS-LINE-COUNT.

      ******************************************************************
      * WRITE ONE DETAIL RECORD                                         *
      ******************************************************************

       400-WRITE-DETAIL.

           MOVE WS-RECORD-NUMBER TO WS-RECORD-NUMBER-OUT
           MOVE WS-RECORD-NUMBER TO DETAIL-NUMBER
           MOVE WS-RECORD-NUMBER TO DETAIL-NUMBER-TEXT

           MOVE DETAIL-LINE TO REPORT-RECORD

           PERFORM 350-WRITE-REPORT-LINE.

      ******************************************************************
      * INSERT A FORM FEED                                              *
      *                                                                 *
      * LINE SEQUENTIAL FILES MAY REJECT X"0C", SO THE FILE IS CLOSED, *
      * THE FORM FEED IS APPENDED WITH LINUX PRINTF, AND THE FILE IS    *
      * THEN REOPENED IN EXTEND MODE.                                   *
      ******************************************************************

       500-INSERT-FORM-FEED.

           CLOSE REPORT-FILE

           IF WS-REPORT-STATUS NOT = "00"
               DISPLAY "ERROR CLOSING REPORT BEFORE FORM FEED"
               DISPLAY "FILE STATUS: " WS-REPORT-STATUS
               STOP RUN
           END-IF

           CALL "SYSTEM"
               USING WS-FORM-FEED-COMMAND
               RETURNING WS-SYSTEM-RETURN-CODE
           END-CALL

           IF WS-SYSTEM-RETURN-CODE NOT = ZERO
               DISPLAY "ERROR INSERTING FORM FEED"
               DISPLAY "RETURN CODE: "
                   WS-SYSTEM-RETURN-CODE
               STOP RUN
           END-IF

           OPEN EXTEND REPORT-FILE

           IF WS-REPORT-STATUS NOT = "00"
               DISPLAY "ERROR REOPENING REPORT FILE"
               DISPLAY "FILE STATUS: " WS-REPORT-STATUS
               STOP RUN
           END-IF.

      ******************************************************************
      * CLOSE THE TEXT REPORT                                           *
      ******************************************************************

       600-CLOSE-REPORT.

           CLOSE REPORT-FILE

           IF WS-REPORT-STATUS NOT = "00"
               DISPLAY "ERROR CLOSING REPORT FILE"
               DISPLAY "FILE STATUS: " WS-REPORT-STATUS
               STOP RUN
           END-IF.

      ******************************************************************
      * CONVERT THE TEXT REPORT TO A GREENBAR PDF                       *
      ******************************************************************

       700-CREATE-GREENBAR-PDF.

           DISPLAY SPACE
           DISPLAY "CREATING GREENBAR PDF..."

           CALL "SYSTEM"
               USING WS-PDF-COMMAND
               RETURNING WS-SYSTEM-RETURN-CODE
           END-CALL

           IF WS-SYSTEM-RETURN-CODE = ZERO
               DISPLAY "GREENBAR PDF CREATED SUCCESSFULLY"
               DISPLAY "TEXT FILE: print-80-records.txt"
               DISPLAY "PDF FILE:  print-80-records.pdf"
           ELSE
               DISPLAY "ERROR CREATING GREENBAR PDF"
               DISPLAY "RETURN CODE: "
                   WS-SYSTEM-RETURN-CODE
               DISPLAY "COMMAND: "
                   FUNCTION TRIM(WS-PDF-COMMAND)
           END-IF.

      ******************************************************************
      * ASK WHETHER TO OPEN THE PDF                                     *
      ******************************************************************

       800-ASK-TO-OPEN-PDF.

           DISPLAY SPACE
           DISPLAY "OPEN THE PDF NOW? Y/N: "
               WITH NO ADVANCING

           ACCEPT WS-OPEN-ANSWER

           MOVE FUNCTION UPPER-CASE(WS-OPEN-ANSWER)
               TO WS-OPEN-ANSWER

           IF WS-OPEN-ANSWER = "Y"
               CALL "SYSTEM"
                   USING WS-OPEN-COMMAND
                   RETURNING WS-SYSTEM-RETURN-CODE
               END-CALL

               IF WS-SYSTEM-RETURN-CODE NOT = ZERO
                   DISPLAY "ERROR OPENING PDF"
                   DISPLAY "RETURN CODE: "
                       WS-SYSTEM-RETURN-CODE
               END-IF
           END-IF.
