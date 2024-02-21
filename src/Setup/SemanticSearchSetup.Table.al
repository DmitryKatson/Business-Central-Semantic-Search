
table 80102 "GPT Semantic Search Setup"
{
    Description = 'Semantic Search Setup';

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';

        }

        field(2; "AOAI Embedding Endpoint"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Endpoint';
        }
        field(3; "AOAI Embedding Deployment"; Text[250])
        {
            Caption = 'Deployment';
        }

        field(4; "Secret Key"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Secret';
        }

        field(10; "AOAI Chat Endpoint"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Endpoint';
        }
        field(11; "AOAI Chat Deployment"; Text[250])
        {
            Caption = 'Deployment';
        }
        field(12; "SQL Database Connection"; Text[1024])
        {
            Caption = 'SQL Database Connection String';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    procedure GetEmbeddingEndpoint() Endpoint: Text[250]
    var
        Rec: Record "GPT Semantic Search Setup";
    begin
        Rec.Get();
        exit(Rec."AOAI Embedding Endpoint");
    end;

    procedure GetEmbeddingDeployment() Deployment: Text[250]
    var
        Rec: Record "GPT Semantic Search Setup";
    begin
        Rec.Get();
        exit(Rec."AOAI Embedding Deployment");
    end;

    procedure GetChatEndpoint() Endpoint: Text[250]
    var
        Rec: Record "GPT Semantic Search Setup";
    begin
        Rec.Get();
        exit(Rec."AOAI Chat Endpoint");
    end;

    procedure GetChatDeployment() Deployment: Text[250]
    var
        Rec: Record "GPT Semantic Search Setup";
    begin
        Rec.Get();
        exit(Rec."AOAI Chat Deployment");
    end;


    [NonDebuggable]
    procedure GetSecretKeyFromIsolatedStorage() SecretKey: Text
    begin
        if not IsNullGuid(Rec."Secret Key") then
            if not IsolatedStorage.Get(Rec."Secret Key", DataScope::Module, SecretKey) then;

        exit(SecretKey);
    end;

    [NonDebuggable]
    procedure SetSecretKeyToIsolatedStorage(SecretKey: Text)
    var
        NewSecretGuid: Guid;
    begin
        if not IsNullGuid(Rec."Secret Key") then
            if not IsolatedStorage.Delete(Rec."Secret Key", DataScope::Module) then;

        NewSecretGuid := CreateGuid();

        IsolatedStorage.Set(NewSecretGuid, SecretKey, DataScope::Module);

        Rec."Secret Key" := NewSecretGuid;
    end;
}