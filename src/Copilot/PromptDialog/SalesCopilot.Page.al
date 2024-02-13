page 80106 "GPT Sales Copilot"
{
    PageType = PromptDialog;
    Caption = 'Sales Copilot';
    PromptMode = Prompt;
    Extensible = false;

    layout
    {
        area(Prompt)
        {
            field(CustomerEmail; CustomerEmail)
            {
                ApplicationArea = All;
                Caption = 'Customer Email';
                Editable = true;
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
            field(SalesOrderNo; SalesHeader."No.")
            {
                ApplicationArea = All;
                Caption = 'No.';
                Editable = false;
            }
            field(SalesOrderSellToCustomerNo; SalesHeader."Sell-to Customer Name")
            {
                ApplicationArea = All;
                Caption = 'Sell-to Customer Name';
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
                Caption = 'Create Order';
                trigger OnAction()
                begin
                    CreateSalesOrder();
                end;
            }
        }
    }

    local procedure CreateSalesOrder()
    var
        SalesCopilot: Codeunit "GPT Sales Copilot Impl.";
        SalesOrderSystemId: Guid;
    begin
        SalesOrderSystemId := SalesCopilot.CreateSalesOrder(CustomerEmail, InputText);
        SalesHeader.GetBySystemId(SalesOrderSystemId);
    end;

    var
        InputText: Text;
        CustomerEmail: Text[80];
        SalesHeader: Record "Sales Header";

}