
## Development test flow ##
Legend
- PO - Process Order
- Press F4 - Button to "NEXT" on the screen
- Qty - Confirmed Qty
- Sort Entries - Sort the entries by Flag Completed ascending and Batches ascending
- Post F4 - Button to "POST" on the screen that will be the creation of an Inbound Delivery (by `BAPI_GOODSMVT_CREATE` bapi)

```mermaid
flowchart TD
    
    Start((start)) --> Operator(Operator scan PO number)
    
    Operator --> ButtonF4(press F4)
    ButtonF4 --> CheckOrder{Check Order Type}   
    CheckOrder --> |Type different ZMP| OldTcode(Process by ZLM99)
    OldTcode --> Finish([Finish])

    CheckOrder --> |Type equals ZMP| NewTcode(Process by ZLM99M)

    Continue(Continue ZLM99M) --> CopyQty(Copy qty from ZML99)
    CopyQty --> ListBatchies[(List Batchies from PO)]
    ListBatchies[(List Batchies from PO)] --> Sort(Sort Entries) 
    Sort --> CheckComple[(Check complete data)] 
    CheckComple --> HandleScreen(Handle Screen) 
    HandleScreen --> CreateMoviment(Create Moviment) 
    CreateMoviment --> FinishNew(Finish)

```