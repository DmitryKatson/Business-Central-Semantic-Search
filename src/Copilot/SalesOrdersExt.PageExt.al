pageextension 80100 "GPT Sales Orders Ext" extends "Sales Order List"
{
    actions
    {
        addlast(Promoted)
        {
            actionref("GPT SalesCopilot_Promoted"; "GPT SalesCopilot") { }
        }
        addlast(Processing)
        {
            action("GPT SalesCopilot")
            {
                ApplicationArea = All;
                Image = Sparkle;
                Caption = 'Sales Copilot';
                ToolTip = 'Sales Copilot';
                RunObject = Page "GPT Sales Copilot";
            }
        }
    }
}