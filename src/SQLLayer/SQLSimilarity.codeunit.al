codeunit 80107 "GPT SQL Similarity"
{
    procedure PerformSQLSemanticSearch(Vector: Text; MinimumScore: Decimal; NumberOfRecords: Integer): Text
    var
        SQLSemanticSearch: DotNet SQLSemanticSearch;
        SearchResult: Text;
    begin
        SearchResult := SQLSemanticSearch.PerformSemanticSearch(Vector, MinimumScore, NumberOfRecords);
        exit(SearchResult);
    end;
}