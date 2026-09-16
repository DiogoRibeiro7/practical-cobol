# Notes - Relative Files

## The key is a record number

A relative file addresses records by a numeric relative record number rather than by a business key stored inside the record.

The `RELATIVE KEY` data item is maintained by the program and identifies the slot used for a random read or write.

## Sparse storage

A relative file does not require every slot between the first and last used record to contain data. Applications can therefore encounter an unused relative record number even when larger record numbers exist.

That is why this lesson writes slots 1, 3, and 5 and reads slot 2 explicitly.

## Relative files vs indexed files

Use the distinction conceptually:

- **indexed file**: lookup is by one or more data keys, usually meaningful business fields
- **relative file**: lookup is by numeric record position

Both support direct access, but they expose different abstractions to the application.

## Engineering implication

Relative access creates tighter coupling between application logic and physical record numbering. If record numbers leak broadly across a system, reorganizing the data can become harder because consumers may depend on those positions.

Indexed access usually provides a cleaner boundary for business entities because consumers ask for a stable key rather than a storage position.
