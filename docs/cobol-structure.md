# COBOL program structure

A COBOL program is traditionally organized into divisions.

## Main divisions

### IDENTIFICATION DIVISION
Defines the program identity.

### ENVIRONMENT DIVISION
Describes the environment, devices, files, and runtime-related context.

### DATA DIVISION
Defines variables, records, and data layouts.

### PROCEDURE DIVISION
Contains executable logic.

## Mental model

A useful way to think about COBOL is:

- first define the program
- then define the environment
- then define the data
- then describe the processing steps

This is more explicit than many modern languages, and that is part of the design philosophy of COBOL.
