page 80105 "GPT API - Sales Order"
{
    PageType = API;
    APIPublisher = 'Katson';
    APIGroup = 'Copilot';
    APIVersion = 'v1.0';
    EntityName = 'salesOrder';
    EntitySetName = 'salesOrders';
    SourceTable = "Sales Order Entity Buffer";
    DelayedInsert = true;
    ODataKeyFields = Id;
    Extensible = false;

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
            }
        }
    }

    var
        LinesDescription: Text;
        FieldIsRequiredLbl: Label '%1 is required';

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SalesCopilot: Codeunit "GPT Sales Copilot Impl.";
        SalesHeaderGenerated: Record "Sales Header" temporary;
        SalesLineGenerated: Record "Sales Line" temporary;
    begin
        CheckFieldsSpecified();
        SalesCopilot.GenerateSalesOrder(Rec."Sell-to E-Mail", LinesDescription, SalesHeaderGenerated, SalesLineGenerated);
        Rec.Id := SalesCopilot.SaveGeneratedSalesOrder(SalesHeaderGenerated, SalesLineGenerated);
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