page 80103 "GPT Semantic Search"
{
    PageType = PromptDialog;
    Caption = 'Semantic Search';
    PromptMode = Prompt;
    Extensible = false;

    layout
    {
        area(Prompt)
        {
            field(SearchText; SearchText)
            {
                ApplicationArea = All;
                MultiLine = true;
                ShowCaption = false;

                trigger OnValidate()
                begin

                end;
            }

        }
        area(Content)
        {
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
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Search';
                trigger OnAction()
                begin
                    DoSemanticSearch();
                end;
            }
        }
    }

    local procedure DoSemanticSearch()
    var
        SemanticSearchImpl: Codeunit "GPT Semantic Search Impl.";
        SemanticSearchResult: Record "GPT Semantic Search Result";
    begin
        SemanticSearchImpl.SemanticSearch(SemanticSearchResult, SearchText, '', 0);
        CurrPage.SemanticSearchResults.Page.Load(SemanticSearchResult);
    end;

    var
        SearchText: Text;

}