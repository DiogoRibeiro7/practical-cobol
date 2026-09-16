      *> Shared fixed-width transaction record.
      *> Any program that consumes this file format can COPY this layout.
       01 TXN-RECORD.
           05 TXN-ID                PIC X(6).
           05 TXN-TYPE              PIC X.
           05 TXN-AMOUNT            PIC 9(5)V99.
           05 TXN-DESCRIPTION       PIC X(20).
