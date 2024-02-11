page 80102 "GPT Embedding Vectors"
{

    Caption = 'Embedding Vectors';
    PageType = List;
    SourceTable = "GPT Embedding Vector";
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
