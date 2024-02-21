report 80100 "GPT Demo Data Removal"
{
    ApplicationArea = All;
    Caption = 'GPT Demo Data Removal';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Integer; Integer)
        {
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                DeleteDemoData();
                Message('Demo data has been removed.');
            end;
        }
    }


    local procedure DeleteDemoData()
    var
        Customer: Record Customer;
        Item: Record Item;
    begin
        Item.SetRange("GPT Demo Data", true);
        if Item.FindSet() then
            repeat
                Item.Delete(true);  // Delete the item and all its related records, which includes attributes
            until Item.Next = 0;

        Customer.SetRange("GPT Demo Data", true);
        if Customer.FindSet() then
            repeat
                Customer.Delete(true);
            until Customer.Next = 0;

    end;
}
