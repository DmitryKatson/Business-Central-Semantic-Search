codeunit 80107 "GPT SQL Similarity"
{
    procedure PerformSQLSemanticSearch(Vector: Text; MinimumScore: Decimal; NumberOfRecords: Integer): Text
    var
        SQLSemanticSearch: DotNet SQLSemanticSearch;
        SearchResult: Text;
    begin
        SearchResult := SQLSemanticSearch.PerformSemanticSearch(GetSqlConnectionString(), Vector, MinimumScore, NumberOfRecords);
        exit(SearchResult);
    end;

    local procedure GetSqlConnectionString(): Text
    var
        GPTSemanticSearchSetup: Record "GPT Semantic Search Setup";
    begin
        GPTSemanticSearchSetup.Get();
        exit(GPTSemanticSearchSetup."SQL Database Connection");
    end;
}