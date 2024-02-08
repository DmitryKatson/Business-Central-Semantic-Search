page 80101 "GPT Embeddings"
{

    ApplicationArea = All;
    Caption = 'Embeddings';
    PageType = List;
    SourceTable = "GPT Embedding";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                }
                field("RecordId"; Rec."RecordId")
                {
                    ApplicationArea = All;
                }
                field(Payload; Rec.Payload)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Generate)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    EmbeddingsImpl: Codeunit "GPT Embedding Impl.";
                begin
                    EmbeddingsImpl.GenerateItemEmbeddings();
                end;
            }
        }
        area(Navigation)
        {
            action(Vectors)
            {
                RunObject = page "GPT Embedding Vectors";
                RunPageLink = Id = field(Id);
                ApplicationArea = All;
            }
            action(Setup)
            {
                RunObject = page "GPT Semantic Search Setup";
                ApplicationArea = All;
            }
        }
    }
}
