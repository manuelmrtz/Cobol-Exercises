       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASGN03.
      ******************************************************************
      * The Light-Em-Up Utility Company has a master disk record, each *
      * of which will be used to create an electrill bill record to be *
      * stored on an ELEC-BILL-FILE and a gas bill record to be stored *
      * on a GAS-BILL-FILE. Note that for each input record, the       *
      * program will create two disk records, one on the               *
      * ELEC-BILL-FILE and on on the GAS-BILL-FILE.                    *
      ******************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-MASTER
               ASSIGN TO 'account-master.dat'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-MASTER-STATUS.
           SELECT ELEC-BILL-FILE
               ASSIGN TO 'elec-bill.dat'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-ELEC-STATUS.
           SELECT GAS-BILL-FILE
               ASSIGN TO 'gas-bill.dat'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-GAS-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNT-MASTER.
       01  MASTER-REC.
           05  IN-ACCOUNT-NO          PIC X(5).
           05  IN-NAME-OF-CUSTOMER    PIC X(20).
           05  IN-ADDRESS             PIC X(20).
           05  IN-KWH-USED            PIC X(5).
           05  IN-GAS-USED            PIC X(5).
           05  IN-ELEC-BILL           PIC X(5).
           05  IN-GAS-BILL            PIC X(5). 

       FD  ELEC-BILL-FILE.
       01  ELEC-REC.
           05  ELEC-ACCOUNT-NO        PIC X(5).
           05  ELEC-CUSTOMER-NAME     PIC X(20).
           05  ELEC-ADDRESS           PIC X(20).
           05  ELEC-USED              PIC X(5).
           05  ELEC-BILL              PIC X(5).
       
       FD  GAS-BILL-FILE.
       01  GAS-REC.
           05  GAS-ACCOUNT-NO         PIC X(5).
           05  GAS-CUSTOMER-NAME      PIC X(20).
           05  GAS-ADDRESS            PIC X(20).
           05  GAS-USED               PIC X(5).
           05  GAS-BILL               PIC X(5).
       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           05  WS-MASTER-STATUS   PIC XX VALUE SPACES.
           05  WS-ELEC-STATUS     PIC XX VALUE SPACES.
           05  WS-GAS-STATUS      PIC XX VALUE SPACES.

       01  WS-WORKING-AREA.
           05  WS-END-OF-FILE     PIC X    VALUE "N".
               88  END-OF-FILE             VALUE "Y".

       01  WS-FILE-OPEN-SWITCHES.
           05  WS-MASTER-OPEN             PIC X VALUE "N".
               88  MASTER-IS-OPEN               VALUE "Y".
               88  MASTER-IS-CLOSED             VALUE "N".

           05  WS-ELEC-OPEN               PIC X VALUE "N".
               88  ELEC-IS-OPEN                 VALUE "Y".
               88  ELEC-IS-CLOSED               VALUE "N".       

           05  WS-GAS-OPEN               PIC X VALUE "N".
               88  GAS-IS-OPEN                 VALUE "Y".
               88  GAS-IS-CLOSED               VALUE "N".       
    
       PROCEDURE DIVISION.
       100-MAIN-MODULE.
      ******************************************************************  
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ******************************************************************
           OPEN INPUT ACCOUNT-MASTER
           IF WS-MASTER-STATUS = "00"
               SET MASTER-IS-OPEN TO TRUE
           ELSE
               DISPLAY "ERROR OPENING MASTER FILE: "
                   WS-MASTER-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF

           OPEN OUTPUT ELEC-BILL-FILE
           IF WS-ELEC-STATUS = "00"
               SET ELEC-IS-OPEN TO TRUE
           ELSE
               DISPLAY "ERROR OPENING ELEC-BILL FILE: "
                   WS-ELEC-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF

           OPEN OUTPUT GAS-BILL-FILE
           IF WS-GAS-STATUS = "00"
               SET GAS-IS-OPEN TO TRUE
           ELSE
               DISPLAY "ERROR OPENING GAS-BILL FILE: "
                   WS-GAS-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF            

           PERFORM 150-READ-MASTER
           PERFORM UNTIL END-OF-FILE
               PERFORM 200-WRITE-ELEC
               PERFORM 210-WRITE-GAS
               PERFORM 150-READ-MASTER
           END-PERFORM
           PERFORM 600-END-PROGRAM
           .

       150-READ-MASTER.
           READ ACCOUNT-MASTER
           EVALUATE WS-MASTER-STATUS
               WHEN "00"
                   CONTINUE
               WHEN "10"
                   SET END-OF-FILE TO TRUE
               WHEN OTHER
                   DISPLAY "ERROR READING MASTER FILE: "
                       WS-MASTER-STATUS
                   PERFORM 700-ABEND-PROGRAM     
           END-EVALUATE
           .

       200-WRITE-ELEC.
           MOVE SPACES TO ELEC-REC
           MOVE IN-ACCOUNT-NO       TO ELEC-ACCOUNT-NO
           MOVE IN-NAME-OF-CUSTOMER TO ELEC-CUSTOMER-NAME    
           MOVE IN-ADDRESS          TO ELEC-ADDRESS             
           MOVE IN-KWH-USED         TO ELEC-USED            
           MOVE IN-ELEC-BILL        TO ELEC-BILL              
           WRITE ELEC-REC

           IF WS-ELEC-STATUS NOT = "00"
               DISPLAY "ERROR WRITING ELEC-BILL FILE: "
                   WS-ELEC-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF
           .

       210-WRITE-GAS.
           MOVE SPACES TO GAS-REC
           MOVE IN-ACCOUNT-NO       TO GAS-ACCOUNT-NO
           MOVE IN-NAME-OF-CUSTOMER TO GAS-CUSTOMER-NAME    
           MOVE IN-ADDRESS          TO GAS-ADDRESS             
           MOVE IN-GAS-USED         TO GAS-USED            
           MOVE IN-GAS-BILL         TO GAS-BILL              
           WRITE GAS-REC

           IF WS-GAS-STATUS NOT = "00"
               DISPLAY "ERROR WRITING GAS-BILL FILE: "
                   WS-GAS-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF
           .
                  
       600-END-PROGRAM.
           IF MASTER-IS-OPEN
               CLOSE ACCOUNT-MASTER
               IF WS-MASTER-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING MASTER FILE: "
                       WS-MASTER-STATUS
                   MOVE 1 TO RETURN-CODE 
               END-IF
               SET MASTER-IS-CLOSED TO TRUE
           END-IF

           IF ELEC-IS-OPEN
               CLOSE ELEC-BILL-FILE
               IF WS-ELEC-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING ELEC-BILL FILE: "
                       WS-ELEC-STATUS
                   MOVE 1 TO RETURN-CODE    
               END-IF
               SET ELEC-IS-CLOSED TO TRUE
           END-IF    

           IF GAS-IS-OPEN
               CLOSE GAS-BILL-FILE
               IF WS-GAS-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING GAS-BILL FILE: "
                       WS-GAS-STATUS
                   MOVE 1 TO RETURN-CODE
               END-IF
               SET GAS-IS-CLOSED TO TRUE
           END-IF            

           STOP RUN 
           .

       700-ABEND-PROGRAM.
           DISPLAY 
               "PROGRAM TERMINATED DUE TO A FILE ERROR."
           
           IF MASTER-IS-OPEN
               CLOSE ACCOUNT-MASTER
               IF WS-MASTER-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING MASTER FILE: "
                       WS-MASTER-STATUS
               END-IF
               SET MASTER-IS-CLOSED TO TRUE
           END-IF

           IF ELEC-IS-OPEN
               CLOSE ELEC-BILL-FILE
               IF WS-ELEC-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING ELEC-BILL FILE: "
                       WS-ELEC-STATUS
               END-IF
               SET ELEC-IS-CLOSED TO TRUE
           END-IF   

           IF GAS-IS-OPEN
               CLOSE GAS-BILL-FILE
               IF WS-GAS-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING GAS-BILL FILE: "
                       WS-GAS-STATUS
               END-IF
               SET GAS-IS-CLOSED TO TRUE
           END-IF

           MOVE 1 TO RETURN-CODE
           STOP RUN    
           . 
           