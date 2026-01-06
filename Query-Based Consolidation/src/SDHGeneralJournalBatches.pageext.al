pageextension 50001 "SDH General Journal Batches" extends "General Journal Batches"
{
    layout
    {
        addlast(Control1)
        {
            field("SDH Consolidation Batch"; Rec."SDH Consolidation Batch")
            {
                ApplicationArea = All;
                Caption = 'Consolidation Batch';
            }
        }
    }
}
