page 80107 "GPT Sales Order Lines Proposal"
{
    SourceTable = "Sales Line";
    SourceTableTemporary = true;
    PageType = ListPart;
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Repeater)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure Load(var SalesLine: Record "Sales Line")
    begin
        Rec.Reset();
        Rec.DeleteAll();

        SalesLine.Reset();
        if SalesLine.FindSet() then
            repeat
                Rec := SalesLine;
                Rec.Insert();
            until SalesLine.Next = 0;
    end;

    procedure GetTempRecord(var SalesLinesGenerated: Record "Sales Line" temporary)
    begin
        SalesLinesGenerated.DeleteAll();

        Rec.Reset();
        if Rec.FindSet() then
            repeat
                SalesLinesGenerated := Rec;
                SalesLinesGenerated.Insert();
            until Rec.Next = 0;
    end;

}