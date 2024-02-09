table 80100 "GPT Embedding"
{
    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
        }
        field(10; "RecordId"; RecordId)
        {

        }
        field(11; Payload; Text[2048])
        {

        }
        field(12; Vector; Text[100])
        {

        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }


    trigger OnDelete()
    begin
        DeleteVector();
    end;

    trigger OnModify()
    begin
        Error('Cannot modify GPT Record Embedding');
    end;

    local procedure DeleteVector()
    var
        EmbeddingImpl: Codeunit "GPT Embedding Impl.";
    begin
        EmbeddingImpl.DeleteEmbeddingVector(Rec.Id);
    end;

}