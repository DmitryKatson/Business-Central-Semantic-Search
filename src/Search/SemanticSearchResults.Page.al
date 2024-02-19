page 80104 "GPT Semantic Search Results"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "GPT Semantic Search Result";
    SourceTableView = sorting("Cosine Similarity") order(descending);
    ShowFilter = false;
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
                field("Cosine Similarity"; Rec."Cosine Similarity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure Load(var SemanticSearchResult: Record "GPT Semantic Search Result")
    begin
        Rec.DeleteAll();

        if SemanticSearchResult.FindSet() then
            repeat
                Rec := SemanticSearchResult;
                Rec.Insert();
            until SemanticSearchResult.Next() = 0;


        CurrPage.Update(false);
    end;
}