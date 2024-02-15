codeunit 80106 "GPT Embeddings Handler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Global Triggers", OnGlobalDelete, '', false, false)]
    local procedure DeleteEmbeddingsVector(RecRef: RecordRef)
    var
        Embedding: Record "GPT Embedding";
    begin
        Embedding.SetRange("Table No.", RecRef.Number);
        Embedding.SetRange(RecordId, RecRef.RecordId);
        if Embedding.IsEmpty then
            exit;

        Embedding.DeleteAll(true);
    end;
}