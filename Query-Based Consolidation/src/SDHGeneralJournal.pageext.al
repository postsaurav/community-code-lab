pageextension 50000 "SDH General Journal" extends "General Journal"
{
    actions
    {
        addafter("Apply Entries")
        {
            action(ApplyConsolidation)
            {
                Caption = 'Apply Consolidation';
                Image = CompareContacts;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CheckBatchIsConsolidation();
                    ConsolidateBatchLines();
                end;
            }
        }
        addafter("Apply Entries_Promoted")
        {
            actionref(ApplyConsolidation_ref; ApplyConsolidation) { }
        }
    }

    local procedure CheckBatchIsConsolidation()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then
            if GenJournalBatch."SDH Consolidation Batch" then
                Error('This batch is for consolidation entries.');
    end;

    local procedure ConsolidateBatchLines()
    var
        SDHGenLineConsolidation: Query "SDH Gen. Line Consolidation";
        GenJournalBatch: Record "Gen. Journal Batch";
        TargetGenJournalLine: Record "Gen. Journal Line";
        LineNo, LinesCreated : Integer;
    begin
        GenJournalBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalBatch.SetRange("SDH Consolidation Batch", true);
        if not GenJournalBatch.FindFirst() then
            Error('No consolidation batch found.');

        LineNo := GetNextPossibleLineNo(GenJournalBatch."Journal Template Name", GenJournalBatch."Name");

        SDHGenLineConsolidation.SetFilter(Journal_Template_Name, Rec."Journal Template Name");
        SDHGenLineConsolidation.SetFilter(Journal_Batch_Name, Rec."Journal Batch Name");
        SDHGenLineConsolidation.Open();
        while SDHGenLineConsolidation.Read() do begin
            TargetGenJournalLine.Init();
            TargetGenJournalLine."Journal Template Name" := Rec."Journal Template Name";
            TargetGenJournalLine."Journal Batch Name" := GenJournalBatch."Name";
            TargetGenJournalLine."Line No." := LineNo;
            LineNo += 10000;
            TargetGenJournalLine.Validate("Posting Date", SDHGenLineConsolidation.PostingDate);
            TargetGenJournalLine.Validate("Account No.", SDHGenLineConsolidation.AccountNo);
            TargetGenJournalLine.Validate("Dimension Set ID", SDHGenLineConsolidation.DimensionSetID);
            TargetGenJournalLine.Validate("Amount", SDHGenLineConsolidation.Amount);
            TargetGenJournalLine.Validate("Debit Amount", SDHGenLineConsolidation.DebitAmount);
            TargetGenJournalLine.Validate("Credit Amount", SDHGenLineConsolidation.CreditAmount);
            TargetGenJournalLine.Insert(true);
            LinesCreated += 1;
        end;
        CleanSourceJournal(LinesCreated);
    end;

    local procedure CleanSourceJournal(TargetLinesCreated: Integer)
    begin
        If Confirm(StrSubstNo('%1 Consolidation Lines are Created. \\ Do you want to Remove Source Lines?', TargetLinesCreated), false) then begin
            Rec.DeleteAll(true);
            Message('Source lines removed from source journal.');
        end;
    end;

    local procedure GetNextPossibleLineNo(JournalTemplateName: Code[10]; JournalBatchName: Code[10]): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJournalLine.IsEmpty() then
            exit(10000)
        else if Confirm('There are Lines in Consolidation Batch. Do you want to Remove Lines?', false) then begin
            GenJournalLine.DeleteAll(true);
            exit(10000);
        end else begin
            GenJournalLine.FindLast();
            exit(GenJournalLine."Line No." + 10000)
        end;
    end;
}
