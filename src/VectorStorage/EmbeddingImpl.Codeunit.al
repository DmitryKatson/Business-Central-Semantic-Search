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
        VectorJArray: JsonArray;
        VectorText: Text;
    begin
        Embedding.DeleteAll(true);

        if Item.FindSet() then
            repeat
                VectorJArray := GetAzureOpenAIEmbeddings(Item.Description);
                VectorJArray.WriteTo(VectorText);

                i += 1;
                Embedding.Init();
                Embedding.Id := i;
                Embedding.Payload := Item.Description;
                Embedding.RecordId := Item.RecordId;
                Embedding.Vector := CopyStr(VectorText, 1, MaxStrLen(Embedding.Vector));
                Embedding.Insert(true);

                InsertToEmbeddingVector(Embedding.Id, VectorJArray);
            until Item.Next() = 0;
    end;


    procedure GetAzureOpenAIEmbeddings(Input: Text) Vector: JsonArray
    var
        RestClient: Codeunit "Rest Client";
        Payload: JsonObject;
        Response: JsonObject;
    begin
        Payload.Add('input', Input);

        RestClient.SetDefaultRequestHeader('api-key', GetSecret());

        Response := RestClient.PostAsJson(GetEndpoint(), Payload).AsObject();

        exit(GetEmbedding(Response))
    end;

    local procedure GetEmbedding(Response: JsonObject) Result: JsonArray
    var
        DataTokenArray: JsonToken;
        DataToken: JsonToken;
        EmbeddingToken: JsonToken;
    begin
        if not Response.SelectToken('data', DataTokenArray) then
            exit(Result);

        DataTokenArray.AsArray().Get(0, DataToken);

        if not DataToken.SelectToken('embedding', EmbeddingToken) then
            exit(Result);

        Result := EmbeddingToken.AsArray();
    end;


    local procedure ConvertJsonArrayToListOfDecimals(EmbeddingArray: JsonArray) Result: List of [Decimal]
    var
        i: Integer;
        EmbeddingValue: JsonToken;
    begin
        for i := 0 to EmbeddingArray.Count() - 1 do begin
            EmbeddingArray.Get(i, EmbeddingValue);
            Result.Add(EmbeddingValue.AsValue().AsDecimal());
        end;
    end;

    procedure InsertToEmbeddingVector(Id: integer; VectorJArray: JsonArray)
    var
        i: integer;
        Value: Decimal;
        Vector: List of [Decimal];
        EmbeddingVector: Record "GPT Embedding Vector";
    begin
        Vector := ConvertJsonArrayToListOfDecimals(VectorJArray);

        foreach Value in Vector do begin
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