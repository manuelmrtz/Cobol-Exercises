       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASGN02.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PAYROLL-MASTER
               ASSIGN TO "pmaster.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-MASTER-STATUS.

           SELECT PAYROLL-LIST
               ASSIGN TO "plist.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-LIST-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  PAYROLL-MASTER.
       01  PAYROLL-REC.
           05  IN-EMPLOYEE-NO               PIC X(5).
           05  IN-EMPLOYEE-NAME             PIC X(20).
           05  IN-LOCATION-CODE.
               10  IN-TERRITORY-NO          PIC X(2).
               10  IN-OFFICE-NUMBER         PIC X(2).
           05  IN-ANNUAL-SALARY             PIC X(6).
           05  IN-SOCIAL-SECURITY-NUMBER    PIC X(9).
           05  IN-NUMBER-OF-DEPENDANTS      PIC X(2).
           05  IN-JOB-CLASS-CODE            PIC X(2).
           05  FILLER                       PIC X(32).

       FD  PAYROLL-LIST.
       01  LIST-REC.
           05  FILLER                       PIC X(5).
           05  OUT-EMPLOYEE-NO              PIC X(5).
           05  FILLER                       PIC X(2).
           05  OUT-EMPLOYEE-NAME            PIC X(20).
           05  FILLER                       PIC X(1).
           05  OUT-TERRITORY-NO             PIC X(2).
           05  FILLER                       PIC X(3).
           05  OUT-OFFICE-NUMBER            PIC X(2).
           05  FILLER                       PIC X(2).
           05  OUT-ANNUAL-SALARY            PIC X(6).
           05  FILLER                       PIC X(2).
           05  OUT-SOCIAL-SECURITY-NUMBER   PIC X(9).
           05  FILLER                       PIC X(2).
           05  OUT-NUMBER-OF-DEPENDANTS     PIC X(2).
           05  FILLER                       PIC X(2).
           05  OUT-JOB-CLASS-CODE           PIC X(2).
           05  FILLER                       PIC X(13). 
       
       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           05  WS-MASTER-STATUS             PIC XX.
           05  WS-LIST-STATUS               PIC XX.

       01  WS-WORKING-AREA.
           05  WS-END-OF-FILE      PIC X VALUE "N".
               88  END-OF-FILE           VALUE "Y".

       01  WS-FILE-OPEN-SWITCHES.
           05  WS-MASTER-OPEN             PIC X VALUE "N".
               88  MASTER-IS-OPEN               VALUE "Y".
               88  MASTER-IS-CLOSED             VALUE "N".

           05  WS-LIST-OPEN               PIC X VALUE "N".
               88  LIST-IS-OPEN                 VALUE "Y".
               88  LIST-IS-CLOSED               VALUE "N".        

       PROCEDURE DIVISION.
       100-MAIN-MODULE.
      ******************************************************************  
      *    This makes sure that the record written to a file retains 
      *    trailing spaces.
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ******************************************************************
           OPEN INPUT PAYROLL-MASTER

           IF WS-MASTER-STATUS = "00"
               SET MASTER-IS-OPEN TO TRUE
           ELSE
               DISPLAY "ERROR OPENING MASTER FILE: "
                   WS-MASTER-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF    

           OPEN OUTPUT PAYROLL-LIST

           IF WS-LIST-STATUS = "00"
               SET LIST-IS-OPEN TO TRUE
           ELSE
               DISPLAY "ERROR OPENING LIST FILE: "
                   WS-LIST-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF

           PERFORM 150-READ-MASTER
           PERFORM UNTIL END-OF-FILE
               PERFORM 200-WRITE-LIST
               PERFORM 150-READ-MASTER
           END-PERFORM
           
           PERFORM 600-END-PROGRAM
           .

       150-READ-MASTER.
           READ PAYROLL-MASTER
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

       200-WRITE-LIST.
           MOVE SPACES TO LIST-REC
           MOVE IN-EMPLOYEE-NO 
               TO OUT-EMPLOYEE-NO
           MOVE IN-EMPLOYEE-NAME 
               TO OUT-EMPLOYEE-NAME
           MOVE IN-TERRITORY-NO 
               TO OUT-TERRITORY-NO
           MOVE IN-OFFICE-NUMBER 
               TO OUT-OFFICE-NUMBER
           MOVE IN-ANNUAL-SALARY 
               TO OUT-ANNUAL-SALARY
           MOVE IN-SOCIAL-SECURITY-NUMBER 
               TO OUT-SOCIAL-SECURITY-NUMBER
           MOVE IN-NUMBER-OF-DEPENDANTS 
               TO OUT-NUMBER-OF-DEPENDANTS
           MOVE IN-JOB-CLASS-CODE 
               TO OUT-JOB-CLASS-CODE
           WRITE LIST-REC

           IF WS-LIST-STATUS NOT = "00"
               DISPLAY "ERROR WRITING LIST FILE: "
                   WS-LIST-STATUS
               PERFORM 700-ABEND-PROGRAM
           END-IF
           .    

       600-END-PROGRAM.
           IF MASTER-IS-OPEN
               CLOSE PAYROLL-MASTER

               IF WS-MASTER-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING MASTER FILE: "
                       WS-MASTER-STATUS
                   MOVE 1 TO RETURN-CODE 
               END-IF

               SET MASTER-IS-CLOSED TO TRUE
           END-IF

           IF LIST-IS-OPEN
               CLOSE PAYROLL-LIST

               IF WS-LIST-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING LIST FILE: "
                       WS-LIST-STATUS
                   MOVE 1 TO RETURN-CODE    
               END-IF

               SET LIST-IS-CLOSED TO TRUE
           END-IF
           
           STOP RUN
           .

       700-ABEND-PROGRAM.
           DISPLAY
               "PROGRAM TERMINATED DUE TO A FILE ERROR."

           IF MASTER-IS-OPEN
               CLOSE PAYROLL-MASTER

               IF WS-MASTER-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING MASTER FILE: "
                       WS-MASTER-STATUS
               END-IF

               SET MASTER-IS-CLOSED TO TRUE
           END-IF

           IF LIST-IS-OPEN
               CLOSE PAYROLL-LIST

               IF WS-LIST-STATUS NOT = "00"
                   DISPLAY "ERROR CLOSING LIST FILE: "
                       WS-LIST-STATUS
               END-IF
               SET LIST-IS-CLOSED TO TRUE
           END-IF
           MOVE 1 TO RETURN-CODE
           STOP RUN
           .
