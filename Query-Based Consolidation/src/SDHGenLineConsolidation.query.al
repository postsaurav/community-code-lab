query 50000 "SDH Gen. Line Consolidation"
{
    Caption = 'Gen. Line Consolidation';
    QueryType = Normal;
    OrderBy = ascending(PostingDate, AccountNo, DimensionSetID);

    elements
    {
        dataitem(GenJournalLine; "Gen. Journal Line")
        {
            filter(Journal_Template_Name; "Journal Template Name") { }
            filter(Journal_Batch_Name; "Journal Batch Name") { }
            column(PostingDate; "Posting Date") { }
            column(AccountNo; "Account No.") { }
            column(DimensionSetID; "Dimension Set ID") { }
            column(Amount; Amount) { Method = Sum; }
            column(DebitAmount; "Debit Amount") { Method = Sum; }
            column(CreditAmount; "Credit Amount") { Method = Sum; }
        }
    }
}