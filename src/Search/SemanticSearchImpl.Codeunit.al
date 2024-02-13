codeunit 80101 "GPT Semantic Search Impl."
{
    procedure SemanticSearch(var SemanticSearchResult: Record "GPT Semantic Search Result"; SearchText: Text; TableNoFilter: Text)
    var
        SearchTextVector: List of [Decimal];
        EmbeddingImpl: Codeunit "GPT Embedding Impl.";
    begin
        SearchTextVector := EmbeddingImpl.ConvertJsonArrayToListOfDecimals(EmbeddingImpl.GetAzureOpenAIEmbeddings(SearchText));
        CalculateCosineSimilarityForEmbeddings(SemanticSearchResult, SearchTextVector, TableNoFilter);
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


}