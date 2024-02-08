page 80102 "GPT Embedding Vectors"
{

    ApplicationArea = All;
    Caption = 'Embedding Vectors';
    PageType = List;
    SourceTable = "GPT Embedding Vector";
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
                field(VectorId; Rec.VectorId)
                {
                    ApplicationArea = All;
                }
                field(VectorValue; Rec.VectorValue)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 5 : 5;
                }
            }
        }
    }
}
