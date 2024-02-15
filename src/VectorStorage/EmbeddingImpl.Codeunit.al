codeunit 80100 "GPT Embedding Impl."
{
    var
        ConfirmGenerateEmbeddingsQtn: Label 'Do you want to generate embeddings?';

    procedure DeleteEmbeddingVector(Id: integer)
    var
        EmbeddingVector: Record "GPT Embedding Vector";
    begin
        EmbeddingVector.SetRange(Id, Id);
        EmbeddingVector.DeleteAll();
    end;

    procedure GenerateEmbeddings()
    var
        DataSearchSetupTable: Record "Data Search Setup (Table)";
        RoleCenterID: Integer;
        Payload: text;
        i: Integer;
        VectorJArray: JsonArray;
        VectorText: Text;
        ConfirmMgtCodeunit: Codeunit "Confirm Management";
    begin
        if not ConfirmMgtCodeunit.GetResponse(ConfirmGenerateEmbeddingsQtn, false) then
            exit;

        RoleCenterID := DataSearchSetupTable.GetRoleCenterID(); //TODO: implement without role center dependency
        DataSearchSetupTable.Setrange("Role Center ID", RoleCenterID);

        if DataSearchSetupTable.FindSet() then
            repeat
                EmbedTable(DataSearchSetupTable);
            until DataSearchSetupTable.Next() = 0;
    end;

    local procedure EmbedTable(DataSearchSetupTable: Record "Data Search Setup (Table)")
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        RecRef.Open(DataSearchSetupTable."Table No.");
        if RecRef.FindSet() then
            repeat
                GeneratePayloadAndEmbedRecord(DataSearchSetupTable, RecRef);
            until RecRef.Next() = 0;
    end;

    local procedure GenerateRecordPayload(var Payload: TextBuilder; RecRef: RecordRef)
    var
        DataSearchSetupField: Record "Data Search Setup (Field)";
        FldRef: FieldRef;
    begin
        DataSearchSetupField.SetRange("Table No.", RecRef.Number);
        if DataSearchSetupField.FindSet() then
            repeat
                if RecRef.FieldExist(DataSearchSetupField."Field No.") then begin
                    DataSearchSetupField.CalcFields("Field Caption");
                    FldRef := RecRef.Field(DataSearchSetupField."Field No.");
                    if Format(FldRef.Value) <> '' then begin
                        Payload.AppendLine();
                        Payload.Append(StrSubstNo('%1: %2', DataSearchSetupField."Field Caption", FldRef.Value));
                    end;
                end;
            until DataSearchSetupField.Next() = 0;
    end;

    local procedure EmbedRecord(Payload: Text; RecRef: RecordRef; DataSearchSetupTable: Record "Data Search Setup (Table)")
    var
        Embedding: Record "GPT Embedding";
        VectorJArray: JsonArray;
        VectorText: Text;
    begin
        VectorJArray := GetAzureOpenAIEmbeddings(Payload);
        VectorJArray.WriteTo(VectorText);

        InsertEmbedding(Payload, RecRef, DataSearchSetupTable, Embedding, VectorText);
        InsertEmbeddingVectors(Embedding.Id, VectorJArray);
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

    local procedure InsertEmbedding(var Payload: Text; var RecRef: RecordRef; var DataSearchSetupTable: Record "Data Search Setup (Table)"; var Embedding: Record "GPT Embedding"; var VectorText: Text)
    begin
        Embedding.Init();
        Embedding."Table No." := DataSearchSetupTable."Table No.";
        Embedding."Table Subtype" := DataSearchSetupTable."Table Subtype";
        Embedding."Table/Type ID" := DataSearchSetupTable."Table/Type ID";
        Embedding.Payload := Payload;
        Embedding.RecordId := RecRef.RecordId;
        Embedding.Insert(true);
        Embedding.SaveVectorText(VectorText);
    end;

    procedure InsertEmbeddingVectors(Id: integer; VectorJArray: JsonArray)
    var
        Value: Decimal;
        Vector: List of [Decimal];
        i: Integer;
    begin
        Vector := ConvertJsonArrayToListOfDecimals(VectorJArray);

        foreach Value in Vector do begin
            i += 1;
            InsertEmbeddingVector(Id, i, Value);
        end;
    end;

    local procedure InsertEmbeddingVector(Id: integer; VectorId: Integer; Value: Decimal)
    var
        EmbeddingVector: Record "GPT Embedding Vector";
    begin
        EmbeddingVector.Init();
        EmbeddingVector.Id := Id;
        EmbeddingVector.VectorId := VectorId;
        EmbeddingVector.VectorValue := Value;
        EmbeddingVector.Insert(true);
    end;

    procedure ConvertJsonArrayToListOfDecimals(EmbeddingArray: JsonArray) Result: List of [Decimal]
    var
        i: Integer;
        EmbeddingValue: JsonToken;
    begin
        for i := 0 to EmbeddingArray.Count() - 1 do begin
            EmbeddingArray.Get(i, EmbeddingValue);
            Result.Add(EmbeddingValue.AsValue().AsDecimal());
        end;
    end;


    local procedure GetEndpoint(): Text
    var
        SemanticSearchSetup: Record "GPT Semantic Search Setup";
        Url: Text;
    begin
        Url := SemanticSearchSetup.GetEmbeddingEndpoint();
        if CopyStr(Url, StrLen(Url), 1) = '/' then
            Url := CopyStr(Url, 1, StrLen(Url) - 1);

        Url := Url + '/openai/deployments/' + SemanticSearchSetup.GetEmbeddingDeployment() + '/embeddings?api-version=2023-03-15-preview';

        exit(Url)
    end;


    [NonDebuggable]
    local procedure GetSecret(): Text
    var
        SemanticSearchSetup: Record "GPT Semantic Search Setup";
    begin
        SemanticSearchSetup.Get();
        exit(SemanticSearchSetup.GetSecretKeyFromIsolatedStorage())
    end;

    local procedure GeneratePayloadAndEmbedRecord(var DataSearchSetupTable: Record "Data Search Setup (Table)"; var RecRef: RecordRef)
    var
        Payload: TextBuilder;
    begin
        if CheckIfRecordExistAndWasNotChangedSinceLastEmbedding(RecRef) then
            exit;

        DataSearchSetupTable.CalcFields("Table Caption");
        Payload.Append(DataSearchSetupTable."Table Caption");
        Payload.AppendLine();
        GenerateRecordPayload(Payload, RecRef);
        EmbedRecord(Payload.ToText(), RecRef, DataSearchSetupTable);
    end;

    local procedure CheckIfRecordExistAndWasNotChangedSinceLastEmbedding(RecRef: RecordRef) Result: Boolean
    var
        Embedding: Record "GPT Embedding";
        ModifiedAt: DateTime;
    begin
        Embedding.SetRange("Table No.", RecRef.Number);
        Embedding.SetRange(RecordId, RecRef.RecordId);
        if Embedding.IsEmpty() then
            exit(false);

        Embedding.FindFirst();
        ModifiedAt := RecRef.Field(RecRef.SystemModifiedAtNo).Value;
        if ModifiedAt <= Embedding.SystemCreatedAt then
            exit(true);

        exit(false);
    end;

    internal procedure ClearEmbeddings()
    var
        Embedding: Record "GPT Embedding";
        EmbeddingVector: Record "GPT Embedding Vector";
        ConfirmMgtCodeunit: Codeunit "Confirm Management";
    begin
        if not ConfirmMgtCodeunit.GetResponse('Do you want to clear all embeddings?', false) then
            exit;

        Embedding.DeleteAll();
        EmbeddingVector.DeleteAll();
    end;
}