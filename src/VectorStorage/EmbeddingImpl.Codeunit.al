codeunit 80100 "GPT Embedding Impl."
{

    procedure DeleteEmbeddingVector(Id: integer)
    var
        EmbeddingVector: Record "GPT Embedding Vector";
    begin
        EmbeddingVector.SetRange(Id, Id);
        EmbeddingVector.DeleteAll();
    end;

    procedure GenerateItemEmbeddings()
    var
        Item: Record Item;
        Embedding: Record "GPT Embedding";
        i: Integer;
    begin
        if Item.FindSet() then
            repeat
                i += 1;
                Embedding.Init();
                Embedding.Id := i;
                Embedding.Payload := Item.Description;
                Embedding.RecordId := Item.RecordId;
                Embedding.Insert(true);
                InsertToEmbeddingVector(Embedding.Id, GetAzureOpenAIEmbeddings(Embedding.Payload));
            until Item.Next() = 0;
    end;


    procedure GetAzureOpenAIEmbeddings(Input: Text) Vector: List of [Decimal]
    var
        RestClient: Codeunit "Rest Client";
        Payload: JsonObject;
        Response: Codeunit "Http Response Message";
    begin
        Payload.Add('input', Input);

        RestClient.SetDefaultRequestHeader('api-key', GetSecret());

        Vector := ProcessEmbeddingResponse(RestClient.PostAsJson(GetEndpoint(), Payload).AsObject())
    end;

    local procedure ProcessEmbeddingResponse(Response: JsonObject) Result: List of [Decimal]
    var
        DataTokenArray: JsonToken;
        DataToken: JsonToken;
        EmbeddingToken: JsonToken;
        EmbeddingArray: JsonArray;
        EmbeddingValue: JsonToken;
        i: Integer;
    begin
        if not Response.SelectToken('data', DataTokenArray) then
            exit(Result);

        DataTokenArray.AsArray().Get(0, DataToken);

        if not DataToken.SelectToken('embedding', EmbeddingToken) then
            exit(Result);

        EmbeddingArray := EmbeddingToken.AsArray();

        for i := 0 to EmbeddingArray.Count() - 1 do begin
            EmbeddingArray.Get(i, EmbeddingValue);
            Result.Add(EmbeddingValue.AsValue().AsDecimal());
        end;
    end;

    procedure InsertToEmbeddingVector(Id: integer; Vector: List of [Decimal])
    var
        i: integer;
        Value: Decimal;
        EmbeddingVector: Record "GPT Embedding Vector";
    begin
        foreach Value in vector do begin
            i += 1;
            EmbeddingVector.Init();
            EmbeddingVector.Id := Id;
            EmbeddingVector.VectorId := i;
            EmbeddingVector.VectorValue := Value;
            EmbeddingVector.Insert();
        end;
    end;


    local procedure GetEndpoint(): Text
    var
        SemanticSearchSetup: Record "GPT Semantic Search Setup";
    begin
        exit(SemanticSearchSetup.GetEndpoint())
    end;


    [NonDebuggable]
    local procedure GetSecret(): Text
    var
        SemanticSearchSetup: Record "GPT Semantic Search Setup";
    begin
        SemanticSearchSetup.Get();
        exit(SemanticSearchSetup.GetSecretKeyFromIsolatedStorage())
    end;
}