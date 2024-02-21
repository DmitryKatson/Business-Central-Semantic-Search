codeunit 80101 "GPT Semantic Search Impl."
{
    procedure SemanticSearch(var SemanticSearchResult: Record "GPT Semantic Search Result"; SearchText: Text; TableNoFilter: Text; MinimumCosineSimilarity: Decimal)
    var
        SearchTextVector: List of [Decimal];
        EmbeddingImpl: Codeunit "GPT Embedding Impl.";
    begin
        SearchTextVector := EmbeddingImpl.ConvertJsonArrayToListOfDecimals(EmbeddingImpl.GetAzureOpenAIEmbeddings(SearchText));
        CalculateCosineSimilarityForEmbeddings(SemanticSearchResult, SearchTextVector, TableNoFilter);
        SemanticSearchResult.SetCurrentKey("Cosine Similarity");
        SemanticSearchResult.Ascending(false);
        SemanticSearchResult.SetFilter("Cosine Similarity", '>=' + Format(MinimumCosineSimilarity));
    end;

    procedure SemanticSearchSQL(var SemanticSearchResult: Record "GPT Semantic Search Result"; SearchText: Text; TableNoFilter: Text; MinimumCosineSimilarity: Decimal)
    var
        SearchTextVector: List of [Decimal];
        EmbeddingImpl: Codeunit "GPT Embedding Impl.";
        GPTSimilarity: Codeunit "GPT SQL Similarity";
        result, vectorText : Text;
    begin
        EmbeddingImpl.GetAzureOpenAIEmbeddings(SearchText).WriteTo(vectorText);
        result := GPTSimilarity.PerformSQLSemanticSearch(vectorText, MinimumCosineSimilarity, 50);   //Number of records is here fixed (we can pass it as a parameter from search)

        SaveSQLSemanticSearchResult(result, SemanticSearchResult);

        if TableNoFilter <> '' then
            SemanticSearchResult.SetFilter("Table No.", TableNoFilter);
        SemanticSearchResult.SetCurrentKey("Cosine Similarity");
        SemanticSearchResult.Ascending(false);
        SemanticSearchResult.SetFilter("Cosine Similarity", '>=' + Format(MinimumCosineSimilarity));
    end;

    procedure CalculateCosineSimilarityForEmbeddings(var SemanticSearchResult: Record "GPT Semantic Search Result"; SearchTextVector: List of [Decimal]; TableNoFilter: Text)
    var
        Embedding: Record "GPT Embedding";
        CosineSimilarity: Decimal;
    begin
        SemanticSearchResult.Reset();
        SemanticSearchResult.DeleteAll();

        if TableNoFilter <> '' then
            Embedding.SetFilter("Table No.", TableNoFilter);

        if Embedding.FindSet() then
            repeat
                CosineSimilarity := CalculateCosineSimilarity(Embedding, SearchTextVector);

                SemanticSearchResult.Init();
                SemanticSearchResult.TransferFields(Embedding);
                SemanticSearchResult."Cosine Similarity" := CosineSimilarity;
                SemanticSearchResult.Insert();

            until Embedding.Next = 0;
    end;

    procedure CalculateCosineSimilarity(var Embedding: Record "GPT Embedding"; SearchTextVector: List of [Decimal]) CosineSimilarity: Decimal
    var
        Vector: Record "GPT Embedding Vector";
        SearchTextVectorValue: Decimal;
    begin
        Vector.SetRange(Id, Embedding.Id);
        if Vector.FindSet() then
            repeat
                SearchTextVector.Get(Vector.VectorId, SearchTextVectorValue);
                CosineSimilarity += Vector.VectorValue * SearchTextVectorValue;
            until Vector.Next = 0;
    end;


    local procedure SaveSQLSemanticSearchResult(SimilarityResult: Text; var SemanticSearchResult: Record "GPT Semantic Search Result")
    var
        ResultArray: JsonArray;
        JsonManagement: Codeunit "JSON Management";
        i: Integer;
        result: Text;
        id, payload, tableno, cosinedistance : Text;
    begin
        SemanticSearchResult.Reset();
        SemanticSearchResult.DeleteAll();
        ResultArray.ReadFrom(SimilarityResult);

        JsonManagement.InitializeCollection(SimilarityResult);
        for i := 0 to JsonManagement.GetCollectionCount() - 1 do begin
            JsonManagement.GetObjectFromCollectionByIndex(result, i);
            JsonManagement.InitializeObject(result);
            JsonManagement.GetStringPropertyValueByName('Id', id);
            JsonManagement.GetStringPropertyValueByName('Payload', payload);
            JsonManagement.GetStringPropertyValueByName('TableNo', tableno);
            JsonManagement.GetStringPropertyValueByName('CosineDistance', cosinedistance);

            SemanticSearchResult.Init();
            Evaluate(SemanticSearchResult.Id, id);
            SemanticSearchResult.Payload := payload;
            Evaluate(SemanticSearchResult."Table No.", tableno);
            Evaluate(SemanticSearchResult."Cosine Similarity", cosinedistance);
            SemanticSearchResult.Insert();
        end;
    end;
}