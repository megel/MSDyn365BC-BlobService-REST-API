page 50103 "MME Blob Content Preview"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MME BlobStorage Blob";
    SourceTableTemporary = true;
    Caption = 'Blob Information';

    layout
    {
        area(Content)
        {
            group(Details)
            {
                Caption = 'Details';

                field("Creation Time"; "Creation Time")
                {
                    ApplicationArea = All;
                }
                field("Last Modified"; "Last Modified")
                {
                    ApplicationArea = All;
                }
                field("Lease Status"; "Lease Status")
                {
                    ApplicationArea = All;
                }
                field("Lease State"; "Lease State")
                {
                    ApplicationArea = All;
                }
                field("Content Type"; "Content Type")
                {
                    ApplicationArea = All;
                }

                field("BlobType"; "Blob Type")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
            }
            group(Preview)
            {
                Caption = 'Preview';
                usercontrol(BlobPreviewControl; BlobPreviewControl)
                {
                    ApplicationArea = All;
                }
            }
        }


    }

    procedure SetBlob(var blob: Record "MME BlobStorage Blob" temporary)
    var
        blobServiceApi: Codeunit "MME Blob Service API";
        content: Text;
    begin
        Rec.DeleteAll();
        Rec.Copy(blob);
        Rec.Insert();
        if ("Content Type" = 'text/plain') or (Name.EndsWith('.md') or Name.EndsWith('.txt') or Name.EndsWith('.json')) then begin
            if blobServiceApi.GetBlob(Container, Name, content) then
                CurrPage.BlobPreviewControl.SetText(content)
            else
                CurrPage.BlobPreviewControl.Reset();
        end else
            if ("Content Type" = 'image/jpeg') or (Name.EndsWith('.png') or Name.EndsWith('.jpg') or Name.EndsWith('.jpeg')) then
                CurrPage.BlobPreviewControl.SetImageUri(blobServiceApi.GetBlobUrl(Container, Name))
            else
                CurrPage.BlobPreviewControl.Reset();

        CurrPage.Update(false);
    end;



}