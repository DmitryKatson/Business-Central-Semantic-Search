page 80104 "GPT Semantic Search Results"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "GPT Semantic Search Result";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Payload; Rec.Payload)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure Load(var SemanticSearchResult: Record "GPT Semantic Search Result")
    begin
        SemanticSearchResult.Reset();
        if SemanticSearchResult.FindSet() then
            repeat
                Rec := SemanticSearchResult;
                Rec.Insert();
            until SemanticSearchResult.Next() = 0;

        CurrPage.Update();
    end;
}