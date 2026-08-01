       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           ch6asg02.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PAYROLL-MASTER
               ASSIGN TO "payroll-master.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PAYROLL-LIST
               ASSIGN TO "payroll-list.txt"
            ORGANIZATION IS LINE SEQUENTIAL.    

       DATA DIVISION.
       FILE SECTION.
       FD  PAYROLL-MASTER.
       01  MASTER-REC.
           05  EMPLOYEE-NO-IN       PIC X(5).
           05  EMPLOYEE-NAME-IN     PIC X(20).
           05  TERRITORY-NO-IN      PIC X(2).
           05  OFFICE-NO-IN         PIC X(2).
           05  ANNUAL-SALARY-IN     PIC X(6).
           05  SOC-SEC-IN           PIC X(9).
           05                       PIC X(36).
       FD  PAYROLL-LIST.
       01  REPORT-REC               PIC X(80).  
       WORKING-STORAGE SECTION.
       01  WS-WORKING-AREA.
           05  END-OF-FILE          PIC X(1) VALUE "N".
           05  PAGE-NO-CONTROL      PIC 99 VALUE 0.
           05  PRINT-LINE-CONTROL   PIC 99 VALUE 0.
           05  DATE-IN.
               10  YEAR-IN          PIC X(4).
               10  MONTH-IN         PIC X(2).
               10  DAY-IN           PIC X(2).
           05  DATE-OUT.
               10  MONTH-OUT        PIC X(2).
               10                   PIC X(1) VALUE "/".
               10  DAY-OUT          PIC X(2).
               10                   PIC X(1) VALUE "/".
               10  YEAR-OUT         PIC X(4).

       01  REPORT-DATA.
           05  RPT-HEADING1.
               10                   PIC X(30) VALUE SPACES.
               10                   PIC X(15) VALUE "PAYROLL LISTING".    
               10                   PIC X(15) VALUE SPACES.
               10                   PIC X(5)  VALUE "PAGE ".
               10  PAGE-NO-OUT      PIC Z9.
               10                   PIC X(3)  VALUE SPACES.
               10  RPT-DATE-OUT     PIC X(10).
           05  RPT-HEADING2.
               10              PIC X(10) VALUE "EMP.NO  ".    
               10              PIC X(22) VALUE "EMPLOYEE NAME         ".
               10              PIC X(10) VALUE "TERR NO.  ".
               10              PIC X(12) VALUE "OFFICE NO.  ".
               10              PIC X(15) VALUE "ANNUAL SALARY  ".
               10              PIC X(11) VALUE "SOC SEC NO.".
           05  RPT-DETAIL.
               10              PIC X(1) VALUE SPACE. 
               10  EMPLOYEE-NO-OUT    PIC X(5).
               10                     PIC X(4) VALUE SPACES.
               10  EMPLOYEE-NAME-OUT  PIC X(20).
               10                     PIC X(5) VALUE SPACES.
               10  TERRITORY-NO-OUT   PIC X(2).
               10                     PIC X(8) VALUE SPACES.
               10  OFFICE-NO-OUT      PIC X(2).
               10                     PIC X(10) VALUE SPACES.
               10  ANNUAL-SALARY-OUT  PIC $ZZZZZZ.
               10                     PIC X(5) VALUE SPACES.
               10  SOC-SEC-OUT.
                   15    PART1        PIC X(3).
                   15                 PIC X(1) VALUE "-".
                   15    PART2        PIC X(2).
                   15                 PIC X(1) VALUE "-".
                   15    PART3        PIC X(4).

       PROCEDURE DIVISION.
       100-MAIN.
      ******************************************************************
      *    This makes sure that the record written to a file retains   *
      *    trailing spaces.                                            *
      ******************************************************************
           DISPLAY "COB_LS_FIXED" UPON ENVIRONMENT-NAME
           DISPLAY "TRUE"         UPON ENVIRONMENT-VALUE
      ******************************************************************     

           OPEN INPUT PAYROLL-MASTER
               OUTPUT PAYROLL-LIST
     
           READ PAYROLL-MASTER
               AT END
                   DISPLAY "NO RECORDS TO PROCESS"
               NOT AT END
                  MOVE FUNCTION CURRENT-DATE TO DATE-IN

                  MOVE YEAR-IN  TO YEAR-OUT
                  MOVE MONTH-IN TO MONTH-OUT
                  MOVE DAY-IN   TO DAY-OUT

                  PERFORM 200-PRINT-HEADER
                  PERFORM 300-PRINT-DETAIL
                  PERFORM UNTIL END-OF-FILE = "Y"
                      READ PAYROLL-MASTER
                          AT END
                              MOVE "Y" TO END-OF-FILE
                          NOT AT END 
                              PERFORM 300-PRINT-DETAIL                              
                      END-READ
                  END-PERFORM
           END-READ

           CLOSE PAYROLL-MASTER
                 PAYROLL-LIST    
           DISPLAY "Program Completed..."                 
           STOP RUN
           .
       200-PRINT-HEADER.
           MOVE 0 TO PRINT-LINE-CONTROL
           MOVE SPACES TO REPORT-REC
           
           IF PAGE-NO-CONTROL > 0
               WRITE REPORT-REC AFTER ADVANCING PAGE
           ELSE
               WRITE REPORT-REC
           END-IF
           
           PERFORM 4 TIMES
               WRITE REPORT-REC
           END-PERFORM
           ADD 1 TO PAGE-NO-CONTROL
           MOVE DATE-OUT TO RPT-DATE-OUT
           MOVE PAGE-NO-CONTROL TO PAGE-NO-OUT
           MOVE RPT-HEADING1 TO REPORT-REC
           WRITE REPORT-REC
           MOVE SPACES TO REPORT-REC
           WRITE REPORT-REC
           MOVE RPT-HEADING2 TO REPORT-REC
           WRITE REPORT-REC
           MOVE SPACES TO REPORT-REC
           WRITE REPORT-REC
           .
       300-PRINT-DETAIL.
           IF PRINT-LINE-CONTROL >= 54
               PERFORM 200-PRINT-HEADER    
           END-IF
           MOVE EMPLOYEE-NO-IN TO EMPLOYEE-NO-OUT
           MOVE EMPLOYEE-NAME-IN TO EMPLOYEE-NAME-OUT
           MOVE TERRITORY-NO-IN TO TERRITORY-NO-OUT
           MOVE OFFICE-NO-IN TO OFFICE-NO-OUT
           MOVE ANNUAL-SALARY-IN TO ANNUAL-SALARY-OUT
           MOVE SOC-SEC-IN(1:3) TO PART1
           MOVE SOC-SEC-IN(4:2) TO PART2
           MOVE SOC-SEC-IN(6:4) TO PART3
           MOVE RPT-DETAIL TO REPORT-REC
           WRITE REPORT-REC
           ADD 1 TO PRINT-LINE-CONTROL
           .
