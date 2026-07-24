       IDENTIFICATION DIVISION.
       PROGRAM-ID. "ASGN05".
      ******************************************************************
      * The Video Trap has one input file containing data on video     *
      * tapes for rent and one input file containing data tapes for    *
      * sale. Create a master file where that contains a rental record *
      * follwed by a sales record.                                     *
      ******************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT RENTAL-FILE
               ASSIGN TO 'rental-file.dat'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT SALES-FILE
               ASSIGN TO 'sales-file.dat'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT MASTER-FILE
               ASSIGN TO 'master-file.dat'
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD  RENTAL-FILE.
       01  RENTAL-REC.
           05  RENTAL-ITEM                PIC X(3).      
           05  RENTAL-VIDEO-NAME          PIC X(17).
           05  RENTAL-TAPES-FOR-RENTAL    PIC X(3).

       FD  SALES-FILE.
       01  SALES-REC.
           05  SALES-ITEM                 PIC X(3).      
           05  SALES-VIDEO-NAME           PIC X(17).
           05  SALES-TAPES-FOR-SALES      PIC X(3).

       FD  MASTER-FILE.
       01  MASTER-REC.
           05  MASTER-ITEM                 PIC X(3).      
           05  MASTER-VIDEO-NAME           PIC X(17).
           05  MASTER-TAPES-FOR-RENTAL     PIC X(3).
           05  MASTER-TAPES-FOR-SALES      PIC X(3).

       WORKING-STORAGE SECTION.
       01  ARE-THERE-MORE-RECORD           PIC XXX VALUE 'YES'.

       PROCEDURE DIVISION.
       100-MAIN-MODULE.
      ******************************************************************
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ******************************************************************
           OPEN INPUT RENTAL-FILE
                      SALES-FILE
               OUTPUT MASTER-FILE

           PERFORM UNTIL ARE-THERE-MORE-RECORD = 'NO '
               READ RENTAL-FILE
                   AT END
                       MOVE 'NO ' TO ARE-THERE-MORE-RECORD
                   NOT AT END
                       MOVE SPACES 
                           TO MASTER-REC
                       MOVE RENTAL-ITEM 
                           TO MASTER-ITEM
                       MOVE RENTAL-VIDEO-NAME 
                           TO MASTER-VIDEO-NAME
                       MOVE RENTAL-TAPES-FOR-RENTAL
                           TO MASTER-TAPES-FOR-RENTAL
                       MOVE SPACES  
                           TO MASTER-TAPES-FOR-SALES 
                       WRITE MASTER-REC
               END-READ
           END-PERFORM
           MOVE 'YES' TO ARE-THERE-MORE-RECORD
           PERFORM UNTIL ARE-THERE-MORE-RECORD = 'NO '
               READ SALES-FILE
                   AT END
                       MOVE 'NO ' TO ARE-THERE-MORE-RECORD
                   NOT AT END
                       MOVE SPACES 
                           TO MASTER-REC
                       MOVE SALES-ITEM 
                           TO MASTER-ITEM
                       MOVE SALES-VIDEO-NAME 
                           TO MASTER-VIDEO-NAME
                       MOVE SPACES 
                           TO MASTER-TAPES-FOR-RENTAL
                       MOVE SALES-TAPES-FOR-SALES 
                           TO MASTER-TAPES-FOR-SALES 
                       WRITE MASTER-REC
               END-READ
           END-PERFORM 
           CLOSE RENTAL-FILE
                 SALES-FILE
                 MASTER-FILE
    
           STOP RUN
           .
