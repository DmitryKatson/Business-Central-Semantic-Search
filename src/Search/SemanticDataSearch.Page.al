page 80108 "GPT Semantic Data Search"
{
    PageType = ListPlus;
    Caption = 'Semantic search in company data [Preview]';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(SearchStringGroup)
            {
                ShowCaption = false;
                field(SearchString; SearchText)
                {
                    Caption = 'Search for ';
                    ApplicationArea = All;
                    Style = Subordinate;

                    trigger OnValidate()
                    begin
                        DoSemanticSearch();
                    end;
                }
                field(Level; SimilarityLevel)
                {
                    Caption = 'Similarity level';
                    ApplicationArea = All;
                }
            }
            part(SemanticSearchResults; "GPT Semantic Search Results")
            {
                ApplicationArea = All;
                Caption = 'Semantic Search Results';
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Search)
            {
                ApplicationArea = All;
                Caption = 'Start semantic search';
                ToolTip = 'Starts the semantic search.';
                Image = Find;
                Enabled = SearchText <> '';

                trigger OnAction()
                begin
                    DoSemanticSearch();
                end;
            }
            action(SearchSQL)
            {
                ApplicationArea = All;
                Caption = 'Start semantic search (SQL)';
                ToolTip = 'Starts the semantic search (SQL Similarity).';
                Image = Find;
                Enabled = SearchText <> '';

                trigger OnAction()
                begin
                    DoSemanticSearchSQL();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Semantic Search';

                actionref(Contact_Promoted;
                Search)
                {
                }
                actionref(SearchSQLRef; SearchSQL)
                {
                }
            }
        }
    }

    var
        SearchText: Text;
        SimilarityLevel: Option Close,Middle,Far;

    //Search only on Item table
    // local procedure DoSemanticSearch()
    // var
    //     SemanticSearchImpl: Codeunit "GPT Semantic Search Impl.";
    //     SemanticSearchResult: Record "GPT Semantic Search Result";
    // begin
    //     SemanticSearchImpl.SemanticSearch(SemanticSearchResult, SearchText, Format(Database::Item), GetSimilarityLevel());
    //     CurrPage.SemanticSearchResults.Page.Load(SemanticSearchResult);
    // end;

    // local procedure DoSemanticSearchSQL()
    // var
    //     SemanticSearchImpl: Codeunit "GPT Semantic Search Impl.";
    //     SemanticSearchResult: Record "GPT Semantic Search Result";
    // begin
    //     SemanticSearchImpl.SemanticSearchSQL(SemanticSearchResult, SearchText, Format(Database::Item), GetSimilarityLevel());
    //     CurrPage.SemanticSearchResults.Page.Load(SemanticSearchResult);
    // end;

    //Search on all tables
    local procedure DoSemanticSearch()
    var
        SemanticSearchImpl: Codeunit "GPT Semantic Search Impl.";
        SemanticSearchResult: Record "GPT Semantic Search Result";
        startTime, endTime : DateTime;
        elapsed: Duration;
    begin
        startTime := CurrentDateTime;
        SemanticSearchImpl.SemanticSearch(SemanticSearchResult, SearchText, '', GetSimilarityLevel());
        endTime := CurrentDateTime;
        elapsed := endtime - startTime;
        CurrPage.SemanticSearchResults.Page.Load(SemanticSearchResult);
        Message('Search time: ' + Format(elapsed));
    end;

    local procedure DoSemanticSearchSQL()
    var
        SemanticSearchImpl: Codeunit "GPT Semantic Search Impl.";
        SemanticSearchResult: Record "GPT Semantic Search Result";
        startTime, endTime : DateTime;
        elapsed: Duration;
    begin
        startTime := CurrentDateTime;
        SemanticSearchImpl.SemanticSearchSQL(SemanticSearchResult, SearchText, '', GetSimilarityLevel());
        endTime := CurrentDateTime;
        elapsed := endtime - startTime;
        CurrPage.SemanticSearchResults.Page.Load(SemanticSearchResult);
        Message('Search (SQL) time: ' + Format(elapsed));
    end;

    local procedure GetSimilarityLevel(): Decimal
    begin
        case SimilarityLevel of
            SimilarityLevel::Close:
                exit(0.8);
            SimilarityLevel::Middle:
                exit(0.7);
            SimilarityLevel::Far:
                exit(0.5);
        end;
    end;

}
