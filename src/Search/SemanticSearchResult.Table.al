table 80103 "GPT Semantic Search Result"
{
    TableType = Temporary;

    fields
    {
        field(1; Id; Integer) { }
        field(2; "Cosine Similarity"; Decimal) { }
        field(9; "Table No."; Integer) { }
        field(10; "RecordId"; RecordId) { }
        field(11; Payload; Text[2048]) { }
        field(20; "Table Subtype"; Integer) { }
        field(21; "Table/Type ID"; Integer) { }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
        key(SK; "Cosine Similarity")
        {

        }
    }
}