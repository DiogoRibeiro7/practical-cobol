# Notes - Indexed Files

## Sequential versus indexed access

Sequential files are natural for batch workloads where every record will be processed. Indexed files are useful when a program must retrieve or update individual records by a stable business key.

The trade-off is that indexed storage adds a maintained access structure and more failure modes: duplicate keys, missing keys, and implementation-specific file handling.

## Primary keys

`RECORD KEY IS CUSTOMER-ID` declares the unique primary key for the indexed file. Writes must preserve uniqueness.

## Dynamic access

`ACCESS MODE IS DYNAMIC` allows both direct keyed access and sequential traversal. That makes it useful for systems that need both point lookups and reporting passes.

## FILE STATUS discipline

Production COBOL commonly treats file status as an explicit interface contract with the runtime. Checking it makes I/O failures observable and allows business logic to distinguish conditions such as success, missing keys, duplicates, and other file errors.

## Portfolio relevance

This lesson is intentionally a customer-master example rather than a generic address book. The goal is to expose the data-access pattern behind long-lived business applications: stable keys, durable records, explicit I/O state, and deterministic handling of lookup failure.
