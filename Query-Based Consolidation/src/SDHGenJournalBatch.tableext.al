tableextension 50000 "SDH Gen. Journal Batch" extends "Gen. Journal Batch"
{
    fields
    {
        field(50000; "SDH Consolidation Batch"; Boolean)
        {
            Caption = 'Consolidation Batch';
            DataClassification = CustomerContent;
        }
    }
}
