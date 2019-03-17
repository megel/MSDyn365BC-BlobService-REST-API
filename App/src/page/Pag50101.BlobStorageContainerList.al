page 50101 "MME BlobStorage Container List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MME BlobStorage Container";
    SourceTableTemporary = true;
    Caption = 'Blob Storage Container List';
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {

            repeater(Containers)
            {
                field(Name; Name)
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        p: Page "MME BlobStorage Blob List";
                    begin
                        p.SetContainer(Name);
                        p.Run();
                    end;
                }
                field("Last Modified"; "Last Modified") { ApplicationArea = All; }
                field("Lease State"; "Lease State") { ApplicationArea = All; }
                field("Lease Status"; "Lease Status") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("GetContainers")
            {
                ApplicationArea = All;
                Caption = 'Refresh Containers';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Refresh;

                trigger OnAction()
                begin
                    ReloadContainers();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ReloadContainers();
    end;

    local procedure ReloadContainers()
    var
        blobServiceApi: Codeunit "MME Blob Service API";
    begin
        Rec.DeleteAll();
        blobServiceApi.ListContainers(Rec);
    end;
}