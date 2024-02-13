page 80100 "GPT Semantic Search Setup"
{

    Caption = 'Semantic Search Setup';
    PageType = Card;
    SourceTable = "GPT Semantic Search Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = All;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group(Embedding)
            {
                field("Embedding Endpoint"; Rec."AOAI Embedding Endpoint")
                {
                    ApplicationArea = All;
                }
                field("Embedding Deployment"; Rec."AOAI Embedding Deployment")
                {
                    ApplicationArea = All;
                }
            }
            group(Chat)
            {
                field("AOAI Endpoint"; Rec."AOAI Chat Endpoint")
                {
                    ApplicationArea = All;
                }
                field("AOAI Deployment"; Rec."AOAI Chat Deployment")
                {
                    ApplicationArea = All;
                }
            }
            group(Secret)
            {
                field(SecretKey; SecretKey)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Secret Key';
                    NotBlank = true;
                    ShowMandatory = true;
                    ExtendedDatatype = Masked;
                    trigger OnValidate()
                    begin
                        Rec.SetSecretKeyToIsolatedStorage(SecretKey);
                    end;
                }
            }
        }
    }

    var
        [NonDebuggable]
        SecretKey: Text;


    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Insert();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SecretKey := Rec.GetSecretKeyFromIsolatedStorage();
    end;

}