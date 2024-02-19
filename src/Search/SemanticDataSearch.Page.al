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
            }
        }
    }

    var
        SearchText: Text;
        SimilarityLevel: Option Close,Middle,Far;

    local procedure DoSemanticSearch()
    var
        SemanticSearchImpl: Codeunit "GPT Semantic Search Impl.";
        SemanticSearchResult: Record "GPT Semantic Search Result";
    begin
        SemanticSearchImpl.SemanticSearch(SemanticSearchResult, SearchText, Format(Database::Item), GetSimilarityLevel());
        CurrPage.SemanticSearchResults.Page.Load(SemanticSearchResult);
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
