page 80106 "GPT Sales Copilot"
{
    PageType = PromptDialog;
    Caption = 'Sales Copilot';
    PromptMode = Prompt;
    Extensible = false;
    SourceTable = "Sales Header";
    SourceTableTemporary = true;

    layout
    {
        area(Prompt)
        {
            field(Contact; CustomerEmail)
            {
                ApplicationArea = All;
                Caption = 'Customer Email';
                trigger OnLookup(var Text: Text): Boolean
                var
                    Contact: Record Contact;
                begin
                    Contact.SetRange("Contact Business Relation", "Contact Business Relation"::Customer);
                    if Page.RunModal(0, Contact) = Action::LookupOK then
                        CustomerEmail := Contact."E-Mail";
                end;

                trigger OnValidate()
                begin
                end;
            }
            field(InputText; InputText)
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
            field(SalesOrderNo; Rec."No.")
            {
                ApplicationArea = All;
                Caption = 'No.';
                Editable = false;
            }
            field(SalesOrderSellToCustomerNo; Rec."Sell-to Customer Name")
            {
                ApplicationArea = All;
                Caption = 'Sell-to Customer Name';
                Editable = false;
            }
            part(SalesOrderLines; "GPT Sales Order Lines Proposal")
            {
                ApplicationArea = All;
                Caption = 'Sales Order Lines';
                Editable = false;
                ShowFilter = false;
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Create Order';
                trigger OnAction()
                begin
                    CreateSalesOrder();
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    begin
        if CloseAction = CloseAction::OK then
            ApplyProposedSalesOrder();
    end;

    local procedure ApplyProposedSalesOrder()
    var
        SalesCopilotImpl: Codeunit "GPT Sales Copilot Impl.";
        SalesLinesGenerated: Record "Sales Line" temporary;
    begin
        CurrPage.SalesOrderLines.Page.GetTempRecord(SalesLinesGenerated);
        SalesCopilotImpl.SaveGeneratedSalesOrder(Rec, SalesLinesGenerated);
    end;

    local procedure CreateSalesOrder()
    var
        SalesCopilotImpl: Codeunit "GPT Sales Copilot Impl.";
        SalesLinesGenerated: Record "Sales Line" temporary;
    begin
        RemovePreviousGenerations();
        SalesCopilotImpl.GenerateSalesOrder(CustomerEmail, InputText, Rec, SalesLinesGenerated);
        CurrPage.SalesOrderLines.Page.Load(SalesLinesGenerated);
    end;

    local procedure RemovePreviousGenerations()
    begin
        Rec.Reset();
        Rec.DeleteAll();
    end;

    var
        InputText: Text;
        CustomerEmail: Text[80];

}