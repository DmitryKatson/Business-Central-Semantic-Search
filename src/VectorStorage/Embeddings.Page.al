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
                field("Table No."; Rec."Table No.")
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
                field(Vector; VectorText)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(ClassicSearch_Promoted; ClassicSearch) { }
            actionref(Search_Promoted; Search) { }
            actionref(Generate_Promoted; Generate) { }
            actionref(Vectors_Promoted; Vectors) { }
            actionref(Setup_Promoted; Setup) { }
        }
        area(Processing)
        {
            action(ClassicSearch)
            {
                ApplicationArea = All;
                Image = Find;
                Caption = 'Classic Search';

                RunObject = page "Data Search";
            }
            action(Search)
            {
                ApplicationArea = All;
                Image = Sparkle;
                Caption = 'Semantic Search';

                RunObject = page "GPT Semantic Search";
            }
            action(Generate)
            {
                ApplicationArea = All;
                Image = SuggestNumber;

                trigger OnAction()
                var
                    EmbeddingsImpl: Codeunit "GPT Embedding Impl.";
                begin
                    EmbeddingsImpl.GenerateEmbeddings();
                end;
            }
            action("Clear")
            {
                ApplicationArea = All;
                Image = Delete;
                Caption = 'Clear';

                trigger OnAction()
                var
                    EmbeddingsImpl: Codeunit "GPT Embedding Impl.";
                begin
                    EmbeddingsImpl.ClearEmbeddings();
                end;

            }
        }
        area(Navigation)
        {
            action(Vectors)
            {
                Image = NumberGroup;
                RunObject = page "GPT Embedding Vectors";
                RunPageLink = Id = field(Id);
                ApplicationArea = All;
            }
            action(Setup)
            {
                Image = NumberSetup;
                RunObject = page "GPT Semantic Search Setup";
                ApplicationArea = All;
            }
        }
    }

    var
        VectorText: Text;

    trigger OnAfterGetRecord()
    begin
        VectorText := Rec.LoadVectorText();
    end;
}
