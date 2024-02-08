table 80101 "GPT Embedding Vector"
{

    fields
    {
        field(1; Id; Integer)
        {

        }
        field(2; VectorId; Integer)
        {

        }
        field(10; VectorValue; Decimal)
        {

        }
    }

    keys
    {
        key(PK; Id, VectorId)
        {
            Clustered = true;
        }
    }
}