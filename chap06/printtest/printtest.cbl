       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRINT80.
      ******************************************************************
      * PURPOSE: CREATE AN 80-RECORD REPORT, QUERY AVAILABLE CUPS      *
      *          PRINTERS, LET THE USER SELECT ONE, AND PRINT.         *
      ******************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT PRINT-FILE
               ASSIGN TO "print-80-records.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PRINT-STATUS.

           SELECT PRINTER-LIST-FILE
               ASSIGN TO "cups-printers.tmp"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-LIST-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  PRINT-FILE.
       01  PRINT-RECORD                    PIC X(80).

       FD  PRINTER-LIST-FILE.
       01  PRINTER-LIST-RECORD             PIC X(128).

       WORKING-STORAGE SECTION.

       01  WS-PRINT-STATUS                 PIC XX VALUE SPACES.
       01  WS-LIST-STATUS                  PIC XX VALUE SPACES.

       01  WS-RETURN-CODE                  PIC S9(9) COMP-5
                                                   VALUE ZERO.

       01  WS-RECORD-NUMBER                PIC 99 VALUE ZERO.
       01  WS-DISPLAY-NUMBER               PIC Z9.

       01  WS-PAGE-NUMBER                  PIC 99 VALUE ZERO.
       01  WS-DISPLAY-PAGE                 PIC Z9.

       01  WS-LINE-COUNT                   PIC 99 VALUE ZERO.
       01  WS-MAX-LINES                    PIC 99 VALUE 60.

       01  WS-PRINTER-COUNT                PIC 99 VALUE ZERO.
       01  WS-PRINTER-INDEX                PIC 99 VALUE ZERO.
       01  WS-PRINTER-SELECTION            PIC 99 VALUE ZERO.
       01  WS-MENU-NUMBER                  PIC Z9.

       01  WS-END-OF-PRINTER-LIST          PIC X VALUE "N".
           88  END-OF-PRINTER-LIST         VALUE "Y".
           88  MORE-PRINTERS               VALUE "N".

       01  WS-SELECTED-PRINTER             PIC X(128)
                                                   VALUE SPACES.

       01  WS-PRINT-COMMAND                PIC X(500)
                                                   VALUE SPACES.

       01  WS-QUERY-COMMAND                PIC X(200)
           VALUE
           "lpstat -a | awk '{print $1}' > cups-printers.tmp".

       01  WS-FORM-FEED-COMMAND            PIC X(200)
           VALUE
           "printf '\014' >> print-80-records.txt".

       01  WS-DELETE-TEMP-COMMAND          PIC X(100)
           VALUE "rm -f cups-printers.tmp print-80-records.txt".

       01  WS-PRINTER-TABLE.
           05  WS-PRINTER-ENTRY OCCURS 20 TIMES.
               10  WS-PRINTER-NAME         PIC X(128).

       PROCEDURE DIVISION.

       100-MAIN.

           PERFORM 120-QUERY-PRINTERS

           PERFORM 150-SELECT-PRINTER

           PERFORM 200-OPEN-NEW-REPORT

           PERFORM 300-START-NEW-PAGE

           PERFORM VARYING WS-RECORD-NUMBER
               FROM 1 BY 1
               UNTIL WS-RECORD-NUMBER > 80

               IF WS-LINE-COUNT >= WS-MAX-LINES
                   PERFORM 500-INSERT-FORM-FEED
                   PERFORM 300-START-NEW-PAGE
               END-IF

               PERFORM 400-WRITE-DETAIL-RECORD
           END-PERFORM

           PERFORM 600-CLOSE-REPORT

           PERFORM 700-SEND-TO-PRINTER

           PERFORM 800-DELETE-TEMP-FILE

           STOP RUN.

       120-QUERY-PRINTERS.

           CALL "SYSTEM"
               USING WS-QUERY-COMMAND
               RETURNING WS-RETURN-CODE
           END-CALL

           IF WS-RETURN-CODE NOT = ZERO
               DISPLAY "ERROR QUERYING CUPS PRINTERS"
               DISPLAY "RETURN CODE: " WS-RETURN-CODE
               STOP RUN
           END-IF

           OPEN INPUT PRINTER-LIST-FILE

           IF WS-LIST-STATUS NOT = "00"
               DISPLAY "ERROR OPENING PRINTER LIST"
               DISPLAY "FILE STATUS: " WS-LIST-STATUS
               STOP RUN
           END-IF

           MOVE ZERO TO WS-PRINTER-COUNT
           SET MORE-PRINTERS TO TRUE

           PERFORM UNTIL END-OF-PRINTER-LIST
               READ PRINTER-LIST-FILE
                   AT END
                       SET END-OF-PRINTER-LIST TO TRUE

                   NOT AT END
                       IF PRINTER-LIST-RECORD NOT = SPACES
                           IF WS-PRINTER-COUNT < 20
                               ADD 1 TO WS-PRINTER-COUNT

                               MOVE PRINTER-LIST-RECORD
                                   TO WS-PRINTER-NAME
                                      (WS-PRINTER-COUNT)
                           END-IF
                       END-IF
               END-READ
           END-PERFORM

           CLOSE PRINTER-LIST-FILE

           IF WS-LIST-STATUS NOT = "00"
               DISPLAY "ERROR CLOSING PRINTER LIST"
               DISPLAY "FILE STATUS: " WS-LIST-STATUS
               STOP RUN
           END-IF

           IF WS-PRINTER-COUNT = ZERO
               DISPLAY "NO CUPS PRINTERS ARE AVAILABLE"
               DISPLAY "CHECK WITH: lpstat -a"
               STOP RUN
           END-IF.

       150-SELECT-PRINTER.

           DISPLAY SPACE
           DISPLAY "AVAILABLE CUPS PRINTERS"
           DISPLAY "-----------------------"

           PERFORM VARYING WS-PRINTER-INDEX
               FROM 1 BY 1
               UNTIL WS-PRINTER-INDEX > WS-PRINTER-COUNT

               MOVE WS-PRINTER-INDEX TO WS-MENU-NUMBER

               DISPLAY WS-MENU-NUMBER
                   " - "
                   FUNCTION TRIM
                       (WS-PRINTER-NAME(WS-PRINTER-INDEX))
           END-PERFORM

           DISPLAY SPACE
           DISPLAY "ENTER PRINTER NUMBER: "
               WITH NO ADVANCING

           ACCEPT WS-PRINTER-SELECTION

           IF WS-PRINTER-SELECTION < 1
               DISPLAY "INVALID SELECTION"
               PERFORM 150-SELECT-PRINTER
           ELSE
               IF WS-PRINTER-SELECTION > WS-PRINTER-COUNT
                   DISPLAY "INVALID SELECTION"
                   PERFORM 150-SELECT-PRINTER
               ELSE
                   MOVE WS-PRINTER-NAME
                       (WS-PRINTER-SELECTION)
                       TO WS-SELECTED-PRINTER
               END-IF
           END-IF

           PERFORM 170-BUILD-PRINT-COMMAND.

       170-BUILD-PRINT-COMMAND.

           MOVE SPACES TO WS-PRINT-COMMAND

           STRING
               "lp -d "
                   DELIMITED BY SIZE

               FUNCTION TRIM(WS-SELECTED-PRINTER)
                   DELIMITED BY SIZE

               " -o cpi=10"
                   DELIMITED BY SIZE

               " -o lpi=6"
                   DELIMITED BY SIZE

               " print-80-records.txt"
                   DELIMITED BY SIZE

               INTO WS-PRINT-COMMAND
           END-STRING.

       200-OPEN-NEW-REPORT.

           OPEN OUTPUT PRINT-FILE

           IF WS-PRINT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING REPORT FILE"
               DISPLAY "FILE STATUS: " WS-PRINT-STATUS
               STOP RUN
           END-IF.

       300-START-NEW-PAGE.

           ADD 1 TO WS-PAGE-NUMBER
           MOVE WS-PAGE-NUMBER TO WS-DISPLAY-PAGE
           MOVE ZERO TO WS-LINE-COUNT

           MOVE SPACES TO PRINT-RECORD

           STRING
               "  "
               "GNUCOBOL 80-RECORD PRINTING TEST"
               "                                      "
               "PAGE "
               WS-DISPLAY-PAGE
               DELIMITED BY SIZE
               INTO PRINT-RECORD
           END-STRING

           PERFORM 350-WRITE-REPORT-LINE

           MOVE SPACES TO PRINT-RECORD
           MOVE ALL "=" TO PRINT-RECORD(3:78)
           PERFORM 350-WRITE-REPORT-LINE

           MOVE SPACES TO PRINT-RECORD

           STRING
               "  "
               "NO."
               "   "
               "DESCRIPTION"
               "                                            "
               "STATUS"
               DELIMITED BY SIZE
               INTO PRINT-RECORD
           END-STRING

           PERFORM 350-WRITE-REPORT-LINE

           MOVE SPACES TO PRINT-RECORD
           MOVE ALL "-" TO PRINT-RECORD(3:78)
           PERFORM 350-WRITE-REPORT-LINE.

       350-WRITE-REPORT-LINE.

           WRITE PRINT-RECORD

           IF WS-PRINT-STATUS NOT = "00"
               DISPLAY "ERROR WRITING REPORT FILE"
               DISPLAY "FILE STATUS: " WS-PRINT-STATUS
               CLOSE PRINT-FILE
               STOP RUN
           END-IF

           ADD 1 TO WS-LINE-COUNT.

       400-WRITE-DETAIL-RECORD.

           MOVE WS-RECORD-NUMBER TO WS-DISPLAY-NUMBER
           MOVE SPACES TO PRINT-RECORD

           STRING
               "  "
               WS-DISPLAY-NUMBER
               "    "
               "THIS IS GNUCOBOL TEST RECORD NUMBER "
               WS-DISPLAY-NUMBER
               "                    "
               "OK"
               DELIMITED BY SIZE
               INTO PRINT-RECORD
           END-STRING

           PERFORM 350-WRITE-REPORT-LINE.

       500-INSERT-FORM-FEED.

           CLOSE PRINT-FILE

           IF WS-PRINT-STATUS NOT = "00"
               DISPLAY "ERROR CLOSING REPORT BEFORE FORM FEED"
               DISPLAY "FILE STATUS: " WS-PRINT-STATUS
               STOP RUN
           END-IF

           CALL "SYSTEM"
               USING WS-FORM-FEED-COMMAND
               RETURNING WS-RETURN-CODE
           END-CALL

           IF WS-RETURN-CODE NOT = ZERO
               DISPLAY "ERROR INSERTING FORM FEED"
               DISPLAY "RETURN CODE: " WS-RETURN-CODE
               STOP RUN
           END-IF

           OPEN EXTEND PRINT-FILE

           IF WS-PRINT-STATUS NOT = "00"
               DISPLAY "ERROR REOPENING REPORT FILE"
               DISPLAY "FILE STATUS: " WS-PRINT-STATUS
               STOP RUN
           END-IF.

       600-CLOSE-REPORT.

           CLOSE PRINT-FILE

           IF WS-PRINT-STATUS NOT = "00"
               DISPLAY "ERROR CLOSING REPORT FILE"
               DISPLAY "FILE STATUS: " WS-PRINT-STATUS
               STOP RUN
           END-IF.

       700-SEND-TO-PRINTER.

           DISPLAY SPACE
           DISPLAY "SELECTED PRINTER: "
               FUNCTION TRIM(WS-SELECTED-PRINTER)

           DISPLAY "SENDING REPORT..."

           CALL "SYSTEM"
               USING WS-PRINT-COMMAND
               RETURNING WS-RETURN-CODE
           END-CALL

           IF WS-RETURN-CODE = ZERO
               DISPLAY "REPORT SENT SUCCESSFULLY"
               DISPLAY "DETAIL RECORDS: 80"
               DISPLAY "REPORT FILE: print-80-records.txt"
           ELSE
               DISPLAY "ERROR SENDING REPORT"
               DISPLAY "RETURN CODE: " WS-RETURN-CODE
               DISPLAY "COMMAND: "
                   FUNCTION TRIM(WS-PRINT-COMMAND)
           END-IF.

       800-DELETE-TEMP-FILE.

           CALL "SYSTEM"
               USING WS-DELETE-TEMP-COMMAND
               RETURNING WS-RETURN-CODE
           END-CALL.
