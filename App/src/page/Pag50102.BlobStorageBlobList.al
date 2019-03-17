page 50102 "MME BlobStorage Blob List"
{
    PageType = List;
    SourceTable = "MME BlobStorage Blob";
    Caption = 'Blob Storage Blob List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Container"; "Container")
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field("Name"; "Name")
                {
                    ApplicationArea = All;
                }
                field("Content Length"; "Content Length")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part("MME Blob Content Preview"; "MME Blob Content Preview")
            {
                ApplicationArea = All;
                SubPageLink = Container = field (Container), Name = field (Name);
                UpdatePropagation = SubPart;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Download File")
            {
                ApplicationArea = All;
                Image = MoveDown;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Download File';

                trigger OnAction()
                begin
                    DownloadFile()
                end;
            }

            action("Upload File")
            {
                ApplicationArea = All;
                Image = MoveUp;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Upload File';

                trigger OnAction()
                begin
                    UploadFile()
                end;
            }
        }
    }
    var
        mContainer: Text;

    trigger OnOpenPage()
    begin
        if mContainer <> '' then
            ReloadBlobs();
    end;

    procedure SetContainer(container: Text)
    begin
        rec.DeleteAll();
        mContainer := container;
        if mContainer <> '' then
            ReloadBlobs();
    end;

    local procedure ReloadBlobs()
    var
        blobServiceApi: Codeunit "MME Blob Service API";
    begin
        Rec.DeleteAll();
        blobServiceApi.ListBlobs(mContainer, Rec);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage."MME Blob Content Preview".Page.SetBlob(Rec);
    end;

    local procedure UploadFile()
    var
        fileName: Text;
        stream: InStream;
        blogServiceAPI: Codeunit "MME Blob Service API";
    begin
        if UploadIntoStream('Upload File', '', '', fileName, stream) then
            if blogServiceAPI.PutBlob(Container, fileName, stream) then
                ReloadBlobs();
    end;

    local procedure DownloadFile()
    var
        fileName: Text;
        stream: InStream;
        blogServiceAPI: Codeunit "MME Blob Service API";
    begin
        fileName := Name.Replace('/', '_');
        if blogServiceAPI.GetBlob(Container, Name, stream) then
            DownloadFromStream(stream, 'Download File', '', '', fileName);
    end;
}
