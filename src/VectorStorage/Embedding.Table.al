table 80100 "GPT Embedding"
{
    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
        }
        field(9; "Table No."; Integer) { }
        field(10; "RecordId"; RecordId) { }
        field(11; Payload; Text[2048]) { }
        field(12; Vector; Blob)
        {
            Compressed = false;
        }
        field(20; "Table Subtype"; Integer) { }
        field(21; "Table/Type ID"; Integer) { }
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

    procedure SaveVectorText(VectorText: Text)
    var
        OutStream: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        ConvertedText: Text;
    begin
        ConvertedText := Base64Convert.ToBase64(VectorText);
        Clear(Rec.Vector);
        Rec.Vector.CreateOutStream(OutStream);
        OutStream.WriteText(ConvertedText);
        Rec.Modify();
    end;

    procedure LoadVectorText() VectorText: Text
    var
        InStream: InStream;
        Base64Convert: Codeunit "Base64 Convert";
        ConvertedText: Text;
    begin
        Rec.CalcFields(Vector);
        Rec.Vector.CreateInStream(InStream);
        InStream.ReadText(ConvertedText);
        VectorText := Base64Convert.FromBase64(ConvertedText);
    end;
}