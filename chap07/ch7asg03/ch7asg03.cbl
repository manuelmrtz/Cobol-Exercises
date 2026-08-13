       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CH7ASG03.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  SCREEN-DATA.
           05  IN-CUSTOMER-NAME        PIC X(20).
           05  IN-AMT-LOAN             PIC 9(5).
           05  IN-INTEREST-RATE        PIC 99V99.
           05  IN-LENGTH-LOAN          PIC 99.

       01  CALCULATION-DATA.
           05  MONTHLY-RATE            PIC 9V9(8).
           05  NO-OF-PAYMENTS          PIC 9(3).
           05  MONTHLY-PAYMENT         PIC 9(5)V99.

       01  OUTPUT-DATA.
           05  OUT-MONTHLY-PAYMENT     PIC $ZZ,ZZ9.99.

       SCREEN SECTION.

       01  ENTRY-SCREEN.
           05  BLANK SCREEN.

           05  LINE 04 COLUMN 22
               VALUE "CUSTOMER NAME: ".

           05  LINE 05 COLUMN 12
               VALUE "AMT OF LOAN (PRINCIPAL): ".

           05  LINE 06 COLUMN 15
               VALUE "YEARLY INTEREST RATE: ".

           05  LINE 07 COLUMN 10
               VALUE "LENGTH OF LOAN (IN YEARS): ".

           05  LINE 04 COLUMN 37
               PIC X(20)
               USING IN-CUSTOMER-NAME.

           05  LINE 05 COLUMN 37
               PIC 9(5)
               USING IN-AMT-LOAN.

           05  LINE 06 COLUMN 37
               PIC 99.99
               USING IN-INTEREST-RATE.

           05  LINE 07 COLUMN 37
               PIC 99
               USING IN-LENGTH-LOAN.
       01  TOTAL-SCREEN.
           05  BLANK SCREEN.
           05  LINE 10 COLUMN 17 
                   PIC X(9) 
                   VALUE "CUSTOMER:" .
           05  LINE 10 COLUMN 30 
                   PIC X(20)
                   USING IN-CUSTOMER-NAME.
           05  LINE 11 COLUMN 10 
                   PIC X(16) 
                   VALUE "MONTHLY PAYMENT:".
           05  LINE 11 COLUMN 30 
                   PIC $$$,$$9.99
                   USING OUT-MONTHLY-PAYMENT.

       01  CLEAR-SCREEN.
           05  BLANK SCREEN.

       PROCEDURE DIVISION.

       100-MAIN.

           ACCEPT ENTRY-SCREEN
           COMPUTE MONTHLY-RATE =
               IN-INTEREST-RATE / 100 / 12
           
           COMPUTE NO-OF-PAYMENTS =
               IN-LENGTH-LOAN * 12

           COMPUTE MONTHLY-PAYMENT ROUNDED =
               IN-AMT-LOAN * MONTHLY-RATE /
               (1 - (1 + MONTHLY-RATE) ** (-NO-OF-PAYMENTS))

           MOVE MONTHLY-PAYMENT
               TO OUT-MONTHLY-PAYMENT

           DISPLAY TOTAL-SCREEN

           

           STOP RUN
           .
