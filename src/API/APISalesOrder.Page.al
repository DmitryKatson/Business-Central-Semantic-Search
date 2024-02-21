page 80105 "GPT API - Sales Order"
{
    APIGroup = 'Copilot';
    APIPublisher = 'Katson';
    APIVersion = 'v1.0';
    DelayedInsert = true;
    EntityName = 'salesOrder';
    EntitySetName = 'salesOrders';
    Extensible = false;
    ODataKeyFields = Id;
    PageType = API;
    SourceTable = "Sales Order Entity Buffer";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Id; Rec.Id)
                {
                    Editable = false;
                }
                field(email; Rec."Sell-to E-Mail")
                {

                }
                field(linesDescription; LinesDescription)
                {

                }
                field(salesOrderNo; Rec."No.")
                {

                }
            }
        }
    }

    var
        FieldIsRequiredLbl: Label '%1 is required';
        LinesDescription: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SalesHeaderGenerated: Record "Sales Header" temporary;
        SalesLineGenerated: Record "Sales Line" temporary;
        SalesCopilot: Codeunit "GPT Sales Copilot Impl.";
    begin
        CheckFieldsSpecified();
        SalesCopilot.GenerateSalesOrder(Rec."Sell-to E-Mail", LinesDescription, SalesHeaderGenerated, SalesLineGenerated);
        Rec.Id := SalesCopilot.SaveGeneratedSalesOrder(SalesHeaderGenerated, SalesLineGenerated);
        Rec."No." := SalesHeaderGenerated."No.";
        exit(false);
    end;

    procedure CheckFieldsSpecified()
    begin
        if (Rec."Sell-to E-Mail" = '') then
            Error(StrSubstNo(FieldIsRequiredLbl, 'email'));
        if (LinesDescription = '') then
            Error(StrSubstNo(FieldIsRequiredLbl, 'linesDescription'));
    end;
}