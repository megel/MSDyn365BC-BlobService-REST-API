page 50100 "MME Storage Account Card"
{
    PageType = Card;
    SourceTable = "MME BlobStorage Account";
    Caption = 'Storage Account Setup';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Account Url"; "Account Url")
                {
                    ApplicationArea = All;
                }
                field("SaS Token"; "SaS Token")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
